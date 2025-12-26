/**
 * GenCraft API - Rate Limiting and Cost Control Middleware
 *
 * Multi-tier rate limiting based on API key tier.
 * Cost circuit breaker to prevent runaway expenses.
 * Per-engine daily limits.
 *
 * @module middleware/rateLimiter
 */

import rateLimit from 'express-rate-limit';
import { getDatabase } from '../config/database.js';
import logger from '../config/logger.js';

// Rate limit configurations per tier
const RATE_LIMITS = {
  basic: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 3600000, // 1 hour
    max: parseInt(process.env.RATE_LIMIT_MAX_BASIC) || 100
  },
  pro: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 3600000,
    max: parseInt(process.env.RATE_LIMIT_MAX_PRO) || 1000
  },
  enterprise: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 3600000,
    max: 10000 // Effectively unlimited for enterprise
  }
};

// Engine daily limits
const ENGINE_LIMITS = {
  vibesdk: process.env.VIBESDK_DAILY_LIMIT || 'unlimited',
  'sindy-rl': parseInt(process.env.SINDY_RL_DAILY_LIMIT) || 500,
  document07: parseInt(process.env.DOCUMENT07_DAILY_LIMIT) || 100
};

/**
 * Create rate limiter based on API key tier
 *
 * Uses API key ID as identifier for rate limiting.
 */
export const createTieredRateLimiter = () => {
  return rateLimit({
    windowMs: 3600000, // 1 hour default
    max: async (req) => {
      const tier = req.apiKey?.tier || 'basic';
      return RATE_LIMITS[tier].max;
    },
    keyGenerator: (req) => {
      // Use API key ID for rate limiting
      return req.apiKey?.id || req.ip;
    },
    handler: (req, res) => {
      const tier = req.apiKey?.tier || 'basic';
      const limit = RATE_LIMITS[tier].max;

      logger.warn('Rate limit exceeded', {
        requestId: req.id,
        keyId: req.apiKey?.id,
        tier,
        limit
      });

      res.status(429).json({
        error: {
          code: 'RATE_LIMIT_EXCEEDED',
          message: `Rate limit exceeded for ${tier} tier`,
          technical: `Maximum ${limit} requests per hour allowed`,
          userFriendly: `You've made too many requests. Your ${tier} plan allows ${limit} requests per hour. Please wait before trying again.`,
          suggestion: tier === 'basic' ? 'Upgrade to Pro tier for 10x more requests' : 'Wait for rate limit to reset',
          retryAfter: Math.ceil((RATE_LIMITS[tier].windowMs) / 1000),
          learnMore: 'https://gencraft.dev/docs/rate-limits'
        }
      });
    },
    standardHeaders: true,
    legacyHeaders: false
  });
};

/**
 * Get today's usage for an API key
 *
 * @param {string} apiKeyId - API key identifier
 * @returns {Promise<object>} { totalCost: number, totalRequests: number, engineBreakdown: object }
 */
async function getTodayUsage(apiKeyId) {
  const db = await getDatabase();
  const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD

  const summary = await db.get(
    `SELECT total_requests, total_cost, engine_breakdown
     FROM daily_usage_summary
     WHERE api_key_id = ? AND date = ?`,
    [apiKeyId, today]
  );

  if (!summary) {
    return {
      totalCost: 0,
      totalRequests: 0,
      engineBreakdown: {}
    };
  }

  return {
    totalCost: summary.total_cost,
    totalRequests: summary.total_requests,
    engineBreakdown: summary.engine_breakdown ? JSON.parse(summary.engine_breakdown) : {}
  };
}

/**
 * Check if API key has exceeded daily cost limit (circuit breaker)
 *
 * Prevents runaway costs from malicious or buggy clients.
 */
export async function checkCostCircuitBreaker(req, res, next) {
  const requestLogger = logger.child({ requestId: req.id });

  try {
    const apiKeyId = req.apiKey.id;
    const dailyCostLimit = req.apiKey.dailyCostLimit;

    const usage = await getTodayUsage(apiKeyId);

    if (usage.totalCost >= dailyCostLimit) {
      requestLogger.warn('Daily cost limit exceeded - circuit breaker activated', {
        keyId: apiKeyId,
        currentCost: usage.totalCost,
        limit: dailyCostLimit
      });

      return res.status(429).json({
        error: {
          code: 'DAILY_COST_LIMIT_EXCEEDED',
          message: 'Daily cost limit exceeded',
          technical: `Current daily cost: $${usage.totalCost.toFixed(2)}, Limit: $${dailyCostLimit.toFixed(2)}`,
          userFriendly: `You've reached your daily spending limit of $${dailyCostLimit.toFixed(2)}. Your API key will reset tomorrow at midnight UTC.`,
          suggestion: 'Upgrade to a higher tier for increased daily limits',
          currentUsage: {
            totalCost: usage.totalCost,
            totalRequests: usage.totalRequests,
            limit: dailyCostLimit,
            resetAt: new Date(new Date().setUTCHours(24, 0, 0, 0)).toISOString()
          },
          learnMore: 'https://gencraft.dev/docs/cost-limits'
        }
      });
    }

    // Attach usage to request for logging/monitoring
    req.todayUsage = usage;

    next();
  } catch (error) {
    requestLogger.error('Cost circuit breaker check failed', { error: error.message });
    next(); // Continue on error (fail open to avoid blocking valid requests)
  }
}

/**
 * Check if API key has exceeded per-engine daily limit
 */
export async function checkEngineDailyLimit(req, res, next) {
  const requestLogger = logger.child({ requestId: req.id });

  try {
    const engine = req.body.engine || req.params.engine;

    if (!engine) {
      return next(); // No engine specified, skip check
    }

    const engineLimit = ENGINE_LIMITS[engine];

    if (engineLimit === 'unlimited') {
      return next(); // No limit for this engine
    }

    const apiKeyId = req.apiKey.id;
    const usage = await getTodayUsage(apiKeyId);
    const engineUsage = usage.engineBreakdown[engine] || 0;

    if (engineUsage >= engineLimit) {
      requestLogger.warn('Engine daily limit exceeded', {
        keyId: apiKeyId,
        engine,
        currentUsage: engineUsage,
        limit: engineLimit
      });

      return res.status(429).json({
        error: {
          code: 'ENGINE_DAILY_LIMIT_EXCEEDED',
          message: `Daily limit exceeded for ${engine} engine`,
          technical: `Current usage: ${engineUsage}, Limit: ${engineLimit}`,
          userFriendly: `You've reached your daily limit of ${engineLimit} requests for the ${engine} engine. The limit will reset tomorrow at midnight UTC.`,
          suggestion: engine === 'sindy-rl' ? 'Try using the vibesdk engine (unlimited)' : 'Wait for limit reset',
          currentUsage: {
            engine,
            requests: engineUsage,
            limit: engineLimit,
            resetAt: new Date(new Date().setUTCHours(24, 0, 0, 0)).toISOString()
          },
          learnMore: 'https://gencraft.dev/docs/engine-limits'
        }
      });
    }

    next();
  } catch (error) {
    requestLogger.error('Engine limit check failed', { error: error.message });
    next(); // Fail open
  }
}

/**
 * Track usage after successful request
 *
 * Records request in database for cost and rate limit tracking.
 */
export async function trackUsage(apiKeyId, endpoint, engine, cost, responseTimeMs, statusCode, tokensUsed) {
  const db = await getDatabase();
  const now = new Date().toISOString();
  const today = now.split('T')[0];

  try {
    // Insert usage record
    await db.run(
      `INSERT INTO api_usage (api_key_id, endpoint, engine, request_timestamp, response_time_ms, status_code, cost, tokens_used)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [apiKeyId, endpoint, engine, now, responseTimeMs, statusCode, cost, tokensUsed]
    );

    // Update daily summary (upsert)
    const currentSummary = await db.get(
      'SELECT total_requests, total_cost, engine_breakdown FROM daily_usage_summary WHERE api_key_id = ? AND date = ?',
      [apiKeyId, today]
    );

    if (currentSummary) {
      const engineBreakdown = JSON.parse(currentSummary.engine_breakdown || '{}');
      engineBreakdown[engine] = (engineBreakdown[engine] || 0) + 1;

      await db.run(
        `UPDATE daily_usage_summary
         SET total_requests = total_requests + 1,
             total_cost = total_cost + ?,
             engine_breakdown = ?
         WHERE api_key_id = ? AND date = ?`,
        [cost, JSON.stringify(engineBreakdown), apiKeyId, today]
      );
    } else {
      const engineBreakdown = { [engine]: 1 };

      await db.run(
        `INSERT INTO daily_usage_summary (api_key_id, date, total_requests, total_cost, engine_breakdown)
         VALUES (?, ?, 1, ?, ?)`,
        [apiKeyId, today, cost, JSON.stringify(engineBreakdown)]
      );
    }

    logger.debug('Usage tracked', {
      apiKeyId,
      endpoint,
      engine,
      cost,
      responseTimeMs,
      statusCode
    });
  } catch (error) {
    logger.error('Failed to track usage', {
      error: error.message,
      apiKeyId,
      endpoint,
      engine
    });
  }
}
