/**
 * GenCraft API - Authentication Middleware
 *
 * JWT-based authentication with API key validation.
 * Supports tiered access (basic, pro, enterprise) with different rate limits.
 *
 * @module middleware/auth
 */

import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';
import { getDatabase } from '../config/database.js';
import logger from '../config/logger.js';

const JWT_SECRET = process.env.JWT_SECRET || 'your-super-secret-jwt-key-change-this-in-production';

/**
 * Generate API key for a user
 *
 * @param {string} name - Name/description for the API key
 * @param {string} tier - Access tier (basic, pro, enterprise)
 * @param {number} dailyCostLimit - Daily cost limit in USD
 * @returns {Promise<object>} { apiKey: string, keyId: string }
 */
export async function generateApiKey(name, tier = 'basic', dailyCostLimit = 10.00) {
  const db = await getDatabase();
  const apiKey = `gk_${tier}_${uuidv4().replace(/-/g, '')}`;
  const keyHash = await bcrypt.hash(apiKey, 10);
  const keyId = uuidv4();

  const now = new Date().toISOString();

  await db.run(
    `INSERT INTO api_keys (id, key_hash, name, tier, created_at, is_active, daily_cost_limit)
     VALUES (?, ?, ?, ?, ?, 1, ?)`,
    [keyId, keyHash, name, tier, now, dailyCostLimit]
  );

  logger.info('API key generated', { keyId, name, tier, dailyCostLimit });

  return { apiKey, keyId };
}

/**
 * Validate API key and return associated metadata
 *
 * @param {string} apiKey - API key to validate
 * @returns {Promise<object|null>} API key metadata or null if invalid
 */
export async function validateApiKey(apiKey) {
  if (!apiKey || !apiKey.startsWith('gk_')) {
    return null;
  }

  const db = await getDatabase();
  const keys = await db.all('SELECT * FROM api_keys WHERE is_active = 1');

  for (const key of keys) {
    const isValid = await bcrypt.compare(apiKey, key.key_hash);

    if (isValid) {
      // Update last used timestamp
      await db.run(
        'UPDATE api_keys SET last_used_at = ? WHERE id = ?',
        [new Date().toISOString(), key.id]
      );

      return {
        id: key.id,
        name: key.name,
        tier: key.tier,
        dailyCostLimit: key.daily_cost_limit,
        createdAt: key.created_at,
        lastUsedAt: key.last_used_at
      };
    }
  }

  return null;
}

/**
 * Express middleware for API key authentication
 *
 * Validates API key from Authorization header and attaches key metadata to request.
 *
 * Usage:
 *   Authorization: Bearer gk_basic_abc123...
 */
export async function authenticateApiKey(req, res, next) {
  const requestLogger = logger.child({ requestId: req.id });

  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      requestLogger.warn('Missing or invalid authorization header');
      return res.status(401).json({
        error: {
          code: 'MISSING_API_KEY',
          message: 'API key is required',
          technical: 'Authorization header must be in format: Bearer gk_xxx',
          userFriendly: 'You need to provide an API key to use GenCraft. Get one at https://gencraft.dev/api-keys',
          learnMore: 'https://gencraft.dev/docs/authentication'
        }
      });
    }

    const apiKey = authHeader.substring(7); // Remove 'Bearer ' prefix
    const keyMetadata = await validateApiKey(apiKey);

    if (!keyMetadata) {
      requestLogger.warn('Invalid API key provided');
      return res.status(401).json({
        error: {
          code: 'INVALID_API_KEY',
          message: 'API key is invalid or has been revoked',
          technical: 'API key validation failed',
          userFriendly: 'The API key you provided is not valid. Please check your key or generate a new one.',
          learnMore: 'https://gencraft.dev/docs/authentication'
        }
      });
    }

    // Attach API key metadata to request for use in downstream middleware
    req.apiKey = keyMetadata;

    requestLogger.info('API key validated', {
      keyId: keyMetadata.id,
      tier: keyMetadata.tier
    });

    next();
  } catch (error) {
    requestLogger.error('Authentication error', { error: error.message });
    return res.status(500).json({
      error: {
        code: 'AUTH_ERROR',
        message: 'Authentication failed',
        technical: error.message
      }
    });
  }
}

/**
 * Check if API key has permission to access specific engine
 *
 * @param {string} tier - API key tier
 * @param {string} engine - Engine name (vibesdk, sindy-rl, document07)
 * @returns {boolean} True if authorized
 */
export function isAuthorizedForEngine(tier, engine) {
  const enginePermissions = {
    basic: ['vibesdk'],
    pro: ['vibesdk', 'sindy-rl'],
    enterprise: ['vibesdk', 'sindy-rl', 'document07']
  };

  return enginePermissions[tier]?.includes(engine) || false;
}

/**
 * Express middleware for engine authorization
 *
 * Checks if API key tier allows access to requested engine.
 */
export function authorizeEngine(req, res, next) {
  const requestLogger = logger.child({ requestId: req.id });
  const engine = req.body.engine || req.params.engine;

  if (!engine) {
    return next(); // No engine specified, let validation middleware handle it
  }

  if (!isAuthorizedForEngine(req.apiKey.tier, engine)) {
    requestLogger.warn('Engine access denied', {
      tier: req.apiKey.tier,
      engine,
      keyId: req.apiKey.id
    });

    return res.status(403).json({
      error: {
        code: 'ENGINE_ACCESS_DENIED',
        message: `Your ${req.apiKey.tier} tier does not have access to ${engine} engine`,
        technical: `Tier '${req.apiKey.tier}' is not authorized for engine '${engine}'`,
        userFriendly: `The ${engine} engine requires a higher tier plan. Upgrade your plan to access this feature.`,
        suggestion: 'Upgrade to Pro or Enterprise tier',
        learnMore: 'https://gencraft.dev/pricing'
      }
    });
  }

  next();
}
