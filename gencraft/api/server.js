#!/usr/bin/env node
/**
 * GenCraft API Server
 *
 * Enterprise-grade REST API for GenCraft's three generator engines:
 *   1. VibeSdk - Cloudflare webapp generator
 *   2. SINDy-RL - 82% cost optimization via intelligent model routing
 *   3. Document 07 - Meta-generation engine (planned)
 *
 * Features:
 *   - JWT authentication with API keys
 *   - Tiered rate limiting (basic, pro, enterprise)
 *   - Cost circuit breaker to prevent runaway expenses
 *   - Per-engine daily limits
 *   - Structured logging with correlation IDs
 *   - Request validation with Zod
 *   - Error translation for newbie-friendly messages
 *   - Engine health monitoring
 *
 * @module server
 */

import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import path from 'path';

// Load environment variables
dotenv.config();

// Import middleware
import { attachRequestId } from './middleware/requestId.js';
import { createTieredRateLimiter } from './middleware/rateLimiter.js';

// Import routes
import generateRoutes from './routes/generateRoutes.js';

// Import utilities
import logger from './config/logger.js';
import { initializeDatabase } from './config/database.js';
import { startHealthMonitoring } from './utils/healthCheck.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Server configuration
const PORT = process.env.PORT || 3001;
const NODE_ENV = process.env.NODE_ENV || 'development';
const CORS_ORIGIN = process.env.CORS_ORIGIN || '*';

// Create Express app
const app = express();

/**
 * Security Middleware
 */
app.use(helmet()); // Security headers
app.use(cors({
  origin: CORS_ORIGIN,
  credentials: process.env.CORS_CREDENTIALS === 'true'
}));

/**
 * Request Processing Middleware
 */
app.use(express.json({ limit: '10mb' })); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded bodies
app.use(attachRequestId); // Attach correlation ID

/**
 * Rate Limiting
 */
const rateLimiter = createTieredRateLimiter();
app.use('/api/', rateLimiter);

/**
 * Request Logging
 */
app.use((req, res, next) => {
  const requestLogger = logger.child({ requestId: req.id });

  requestLogger.info('Incoming request', {
    method: req.method,
    path: req.path,
    ip: req.ip,
    userAgent: req.get('user-agent')
  });

  // Log response
  const originalSend = res.send;
  res.send = function (data) {
    requestLogger.info('Response sent', {
      statusCode: res.statusCode,
      contentLength: data?.length
    });
    originalSend.call(this, data);
  };

  next();
});

/**
 * API Routes
 */
app.use('/api/v1', generateRoutes);

/**
 * Root Endpoint
 */
app.get('/', (req, res) => {
  res.json({
    name: 'GenCraft API',
    version: '1.0.0',
    description: 'Enterprise REST API for GenCraft Three Generator Engines',
    documentation: 'https://gencraft.dev/docs/api',
    endpoints: {
      generate: 'POST /api/v1/generate',
      estimateCost: 'POST /api/v1/estimate-cost',
      health: 'GET /api/v1/health'
    },
    engines: {
      vibesdk: 'Cloudflare webapp generator',
      'sindy-rl': '82% cost optimization via intelligent model routing',
      document07: 'Meta-generation engine (planned for 2026-Q1)'
    },
    authentication: {
      type: 'Bearer token',
      header: 'Authorization: Bearer gk_xxx',
      getApiKey: 'https://gencraft.dev/api-keys'
    }
  });
});

/**
 * 404 Handler
 */
app.use((req, res) => {
  res.status(404).json({
    error: {
      code: 'NOT_FOUND',
      message: 'Endpoint not found',
      path: req.path,
      suggestion: 'Check the API documentation for valid endpoints',
      documentation: 'https://gencraft.dev/docs/api'
    }
  });
});

/**
 * Error Handler
 */
app.use((err, req, res, next) => {
  const requestLogger = logger.child({ requestId: req.id });

  requestLogger.error('Unhandled error', {
    error: err.message,
    stack: err.stack
  });

  res.status(500).json({
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: 'An unexpected error occurred',
      technical: NODE_ENV === 'development' ? err.message : undefined,
      userFriendly: 'Something went wrong on our end. Our team has been notified.',
      requestId: req.id
    }
  });
});

/**
 * Server Initialization
 */
async function startServer() {
  try {
    // Initialize database
    logger.info('Initializing database...');
    await initializeDatabase();

    // Start health monitoring
    logger.info('Starting engine health monitoring...');
    startHealthMonitoring();

    // Start HTTP server
    app.listen(PORT, () => {
      logger.info('GenCraft API Server started', {
        port: PORT,
        environment: NODE_ENV,
        processId: process.pid,
        nodeVersion: process.version
      });

      console.log(`
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║                    GenCraft API Server v1.0.0                    ║
║                                                                  ║
║  Status:      Running                                            ║
║  Port:        ${PORT}                                                ║
║  Environment: ${NODE_ENV}                                         ║
║  Docs:        https://gencraft.dev/docs/api                      ║
║                                                                  ║
║  Engines:                                                        ║
║    • VibeSdk       (Webapp generator)                            ║
║    • SINDy-RL      (Cost optimization)                           ║
║    • Document 07   (Planned - 2026 Q1)                           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
      `);
    });
  } catch (error) {
    logger.error('Failed to start server', {
      error: error.message,
      stack: error.stack
    });
    process.exit(1);
  }
}

/**
 * Graceful Shutdown
 */
process.on('SIGTERM', () => {
  logger.info('SIGTERM received, shutting down gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  logger.info('SIGINT received, shutting down gracefully...');
  process.exit(0);
});

// Start the server
startServer();
