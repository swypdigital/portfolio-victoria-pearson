/**
 * Authentication Middleware
 * Verifies JWT tokens and attaches user to request
 */

import { Request, Response, NextFunction } from 'express';
import { createAPIError } from './error-handler';
import { initializeDatabaseFromEnv } from '../../shared/database';

// Extend Express Request to include user data
declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string;
        role: string;
        tenant_id: string;
      };
    }
  }
}

/**
 * Authentication middleware - verifies Supabase JWT token
 */
export async function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    // Extract token from Authorization header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw createAPIError('Missing or invalid authorization header', 401, 'unauthorized');
    }

    const token = authHeader.substring(7); // Remove 'Bearer '

    // Verify token with Supabase
    const db = initializeDatabaseFromEnv();
    const { data: { user }, error } = await db.getClient().auth.getUser(token);

    if (error || !user) {
      throw createAPIError('Invalid or expired token', 401, 'unauthorized');
    }

    // Attach user data to request
    req.user = {
      id: user.id,
      email: user.email || '',
      role: user.user_metadata?.role || 'user',
      tenant_id: user.user_metadata?.tenant_id || '',
    };

    next();
  } catch (error) {
    next(error);
  }
}

/**
 * Optional auth middleware - doesn't fail if no token provided
 */
export async function optionalAuthMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next(); // Continue without user
    }

    const token = authHeader.substring(7);
    const db = initializeDatabaseFromEnv();
    const { data: { user }, error } = await db.getClient().auth.getUser(token);

    if (!error && user) {
      req.user = {
        id: user.id,
        email: user.email || '',
        role: user.user_metadata?.role || 'user',
        tenant_id: user.user_metadata?.tenant_id || '',
      };
    }

    next();
  } catch (error) {
    next(); // Continue without user on error
  }
}
