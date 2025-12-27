/**
 * GenCraft v3.0 - Main API Server
 * Express.js REST API with AIEN enforcement
 */

import express, { Express, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { createServer } from 'http';
import { initializeDatabaseFromEnv } from '../shared/database';

// Routes
import authRoutes from './routes/auth';
import aienRoutes from './routes/aien';
import userRoutes from './routes/user';

// Middleware
import { errorHandler } from './middleware/error-handler';
import { requestLogger } from './middleware/logger';
import { rateLimiter } from './middleware/rate-limiter';

export class APIServer {
  private app: Express;
  private port: number;

  constructor(port: number = parseInt(process.env.PORT || '3000', 10)) {
    this.app = express();
    this.port = port;
    this.setupMiddleware();
    this.setupRoutes();
    this.setupErrorHandling();
  }

  /**
   * Configure middleware
   */
  private setupMiddleware(): void {
    // Security headers
    this.app.use(helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          scriptSrc: ["'self'"],
          imgSrc: ["'self'", 'data:', 'https:'],
        },
      },
    }));

    // CORS
    this.app.use(cors({
      origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3001'],
      credentials: true,
    }));

    // Body parsing
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));

    // Request logging
    this.app.use(requestLogger);

    // Rate limiting
    this.app.use(rateLimiter);
  }

  /**
   * Configure routes
   */
  private setupRoutes(): void {
    // Health check (no auth required)
    this.app.get('/health', async (req: Request, res: Response) => {
      const db = initializeDatabaseFromEnv();
      const dbHealthy = await db.healthCheck();

      res.json({
        status: dbHealthy ? 'healthy' : 'degraded',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        services: {
          database: dbHealthy ? 'healthy' : 'unhealthy',
          redis: 'not_implemented', // TODO: Redis health check
          aien: 'healthy',
        },
      });
    });

    // API routes
    this.app.use('/v1/auth', authRoutes);
    this.app.use('/v1/aien', aienRoutes);
    this.app.use('/v1', userRoutes); // /v1/me endpoints

    // 404 handler
    this.app.use((req: Request, res: Response) => {
      res.status(404).json({
        error: 'not_found',
        message: `Route ${req.method} ${req.path} not found`,
      });
    });
  }

  /**
   * Configure error handling
   */
  private setupErrorHandling(): void {
    this.app.use(errorHandler);
  }

  /**
   * Start the API server
   */
  async start(): Promise<void> {
    try {
      // Initialize database connection
      const db = initializeDatabaseFromEnv();
      const dbHealthy = await db.healthCheck();

      if (!dbHealthy) {
        console.error('❌ Database health check failed');
        throw new Error('Database connection failed');
      }

      console.log('✅ Database connection established');

      // Create HTTP server
      const server = createServer(this.app);

      // Start listening
      server.listen(this.port, () => {
        console.log(`
╔═══════════════════════════════════════╗
║   GenCraft v3.0 API Server Running   ║
╠═══════════════════════════════════════╣
║  Port: ${this.port.toString().padEnd(32)}  ║
║  Environment: ${(process.env.NODE_ENV || 'development').padEnd(23)}  ║
║  Base URL: http://localhost:${this.port}/v1   ║
╚═══════════════════════════════════════╝
        `);
      });

      // Graceful shutdown
      process.on('SIGTERM', () => {
        console.log('SIGTERM signal received: closing HTTP server');
        server.close(() => {
          console.log('HTTP server closed');
          process.exit(0);
        });
      });

    } catch (error) {
      console.error('❌ Failed to start API server:', error);
      process.exit(1);
    }
  }

  /**
   * Get Express app instance (for testing)
   */
  getApp(): Express {
    return this.app;
  }
}

// Start server if run directly
if (require.main === module) {
  const server = new APIServer();
  server.start();
}

export default APIServer;
