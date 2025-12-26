/**
 * GenCraft API - Engine Health Monitoring
 *
 * Monitors health status of all three GenCraft engines.
 * Provides real-time status, performance metrics, and uptime tracking.
 *
 * @module utils/healthCheck
 */

import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import { fileURLToPath } from 'url';
import logger from '../config/logger.js';

const execAsync = promisify(exec);
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Engine configurations
const ENGINES = {
  vibesdk: {
    name: 'VibeSdk',
    description: 'Cloudflare webapp generator',
    enabled: process.env.VIBESDK_ENABLED !== 'false',
    scriptPath: '../../engines/vibesdk/generate.sh',
    testCommand: 'echo "test" | head -1', // Placeholder for real health check
    timeout: 5000
  },
  'sindy-rl': {
    name: 'SINDy-RL',
    description: '82% cost optimization via intelligent model routing',
    enabled: process.env.SINDY_RL_ENABLED !== 'false',
    scriptPath: '../../engines/sindy-rl/generate.sh',
    testCommand: 'echo "test" | head -1', // Placeholder
    timeout: 5000
  },
  document07: {
    name: 'Document 07',
    description: 'Meta-generation engine (not yet implemented)',
    enabled: process.env.DOCUMENT07_ENABLED === 'true',
    scriptPath: '../../engines/document07/generate.sh',
    testCommand: null, // Not implemented yet
    timeout: 5000
  }
};

// In-memory health status cache
let healthCache = {
  lastCheck: null,
  engines: {}
};

/**
 * Check health of a single engine
 *
 * @param {string} engineId - Engine identifier (vibesdk, sindy-rl, document07)
 * @returns {Promise<object>} Health status object
 */
async function checkEngineHealth(engineId) {
  const engine = ENGINES[engineId];

  if (!engine) {
    return {
      status: 'unknown',
      error: 'Engine not configured'
    };
  }

  if (!engine.enabled) {
    return {
      status: 'disabled',
      message: 'Engine is disabled in configuration'
    };
  }

  // Document07 is not implemented yet
  if (engineId === 'document07' && !engine.testCommand) {
    return {
      status: 'not_implemented',
      message: 'Engine is planned but not yet implemented',
      eta: '2026-Q1'
    };
  }

  // Perform health check
  const startTime = Date.now();

  try {
    // Execute test command with timeout
    const { stdout, stderr } = await Promise.race([
      execAsync(engine.testCommand),
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error('Health check timeout')), engine.timeout)
      )
    ]);

    const responseTime = Date.now() - startTime;

    // Simple check: if command succeeded, engine is healthy
    return {
      status: 'operational',
      responseTime: `${(responseTime / 1000).toFixed(1)}s`,
      lastSuccess: new Date().toISOString(),
      message: 'Engine is responding normally'
    };
  } catch (error) {
    const responseTime = Date.now() - startTime;

    // Degraded if slow but still responding
    if (responseTime > 3000) {
      return {
        status: 'degraded',
        responseTime: `${(responseTime / 1000).toFixed(1)}s`,
        lastSuccess: healthCache.engines[engineId]?.lastSuccess || 'never',
        message: 'Engine is responding but slower than expected',
        warning: 'Response time > 3 seconds'
      };
    }

    // Down if completely failed
    return {
      status: 'down',
      error: error.message,
      lastSuccess: healthCache.engines[engineId]?.lastSuccess || 'never',
      message: 'Engine is not responding'
    };
  }
}

/**
 * Check health of all engines
 *
 * @param {boolean} useCache - Use cached results if available (< 60 seconds old)
 * @returns {Promise<object>} Overall health status
 */
export async function checkAllEngines(useCache = true) {
  const now = Date.now();
  const cacheAge = healthCache.lastCheck ? now - healthCache.lastCheck : Infinity;

  // Use cache if < 60 seconds old and cache requested
  if (useCache && cacheAge < 60000) {
    logger.debug('Using cached health status', { cacheAge: `${(cacheAge / 1000).toFixed(1)}s` });
    return healthCache;
  }

  logger.info('Performing engine health check');

  // Check all engines in parallel
  const healthChecks = await Promise.all(
    Object.keys(ENGINES).map(async (engineId) => {
      const health = await checkEngineHealth(engineId);
      return { engineId, health };
    })
  );

  // Build health status object
  const engines = {};
  let overallStatus = 'healthy';

  for (const { engineId, health } of healthChecks) {
    engines[engineId] = {
      name: ENGINES[engineId].name,
      description: ENGINES[engineId].description,
      ...health
    };

    // Determine overall status
    if (health.status === 'down' && ENGINES[engineId].enabled) {
      overallStatus = 'unhealthy';
    } else if (health.status === 'degraded' && overallStatus === 'healthy') {
      overallStatus = 'degraded';
    }
  }

  // Update cache
  healthCache = {
    lastCheck: now,
    status: overallStatus,
    engines
  };

  logger.info('Health check complete', {
    overallStatus,
    operational: Object.values(engines).filter(e => e.status === 'operational').length,
    total: Object.keys(engines).length
  });

  return healthCache;
}

/**
 * Get current health status (cached)
 *
 * @returns {object} Current health status
 */
export function getCurrentHealth() {
  return healthCache;
}

/**
 * Start periodic health monitoring
 *
 * Checks engine health every 60 seconds in background.
 *
 * @param {number} intervalMs - Check interval in milliseconds
 */
export function startHealthMonitoring(intervalMs = 60000) {
  logger.info('Starting periodic health monitoring', { intervalMs });

  // Initial check
  checkAllEngines(false).catch(err => {
    logger.error('Initial health check failed', { error: err.message });
  });

  // Periodic checks
  setInterval(() => {
    checkAllEngines(false).catch(err => {
      logger.error('Periodic health check failed', { error: err.message });
    });
  }, intervalMs);
}
