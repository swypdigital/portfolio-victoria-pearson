/**
 * GenCraft API - Generation Routes
 *
 * API endpoints for content generation, cost estimation, and health checks.
 *
 * @module routes/generateRoutes
 */

import express from 'express';
import { validateMiddleware, GenerationRequestSchema, CostEstimationSchema } from '../utils/validation.js';
import { generateContent, estimateCost, getHealth } from '../controllers/generateController.js';
import { authenticateApiKey, authorizeEngine } from '../middleware/auth.js';
import { checkCostCircuitBreaker, checkEngineDailyLimit } from '../middleware/rateLimiter.js';

const router = express.Router();

/**
 * POST /api/v1/generate
 *
 * Generate content using GenCraft engines
 *
 * Request body:
 *   {
 *     "type": "webapp" | "component" | "document",
 *     "description": "Natural language description",
 *     "options": { ... } // Optional engine-specific options
 *   }
 *
 * Response:
 *   {
 *     "id": "gen_123abc",
 *     "type": "webapp",
 *     "engine": "vibesdk",
 *     "status": "completed",
 *     "output": { ... },
 *     "metadata": { ... }
 *   }
 */
router.post(
  '/generate',
  authenticateApiKey,
  validateMiddleware(GenerationRequestSchema),
  authorizeEngine,
  checkCostCircuitBreaker,
  checkEngineDailyLimit,
  generateContent
);

/**
 * POST /api/v1/estimate-cost
 *
 * Estimate cost for a generation request without actually generating
 *
 * Request body:
 *   {
 *     "type": "webapp" | "component" | "document",
 *     "complexity": "simple" | "medium" | "complex"
 *   }
 *
 * Response:
 *   {
 *     "type": "webapp",
 *     "complexity": "medium",
 *     "estimatedCost": 0.15,
 *     "estimatedTime": "15-30s",
 *     "currency": "USD"
 *   }
 */
router.post(
  '/estimate-cost',
  authenticateApiKey,
  validateMiddleware(CostEstimationSchema),
  estimateCost
);

/**
 * GET /api/v1/health
 *
 * Get health status of all GenCraft engines
 *
 * Response:
 *   {
 *     "status": "healthy" | "degraded" | "unhealthy",
 *     "timestamp": "2025-12-26T10:30:00Z",
 *     "engines": {
 *       "vibesdk": { "status": "operational", ... },
 *       "sindy-rl": { "status": "operational", ... },
 *       "document07": { "status": "not_implemented", ... }
 *     }
 *   }
 */
router.get('/health', getHealth);

export default router;
