/**
 * Authentication Routes
 * Handles user login and token management
 */

import { Router, Request, Response } from 'express';
import { asyncHandler, createAPIError } from '../middleware/error-handler';
import { initializeDatabaseFromEnv } from '../../shared/database';

const router = Router();

/**
 * POST /auth/login
 * Login with email and password
 */
router.post(
  '/login',
  asyncHandler(async (req: Request, res: Response) => {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      throw createAPIError('email and password are required', 400, 'validation_error');
    }

    // Authenticate with Supabase
    const db = initializeDatabaseFromEnv();
    const { data, error } = await db.getClient().auth.signInWithPassword({
      email,
      password,
    });

    if (error || !data.user || !data.session) {
      throw createAPIError('Invalid email or password', 401, 'unauthorized');
    }

    // Return access token and user info
    res.json({
      access_token: data.session.access_token,
      refresh_token: data.session.refresh_token,
      expires_in: data.session.expires_in,
      token_type: 'Bearer',
      user: {
        id: data.user.id,
        email: data.user.email,
        role: data.user.user_metadata?.role || 'user',
        tenant_id: data.user.user_metadata?.tenant_id,
      },
    });
  })
);

/**
 * POST /auth/refresh
 * Refresh access token using refresh token
 */
router.post(
  '/refresh',
  asyncHandler(async (req: Request, res: Response) => {
    const { refresh_token } = req.body;

    // Validation
    if (!refresh_token) {
      throw createAPIError('refresh_token is required', 400, 'validation_error');
    }

    // Refresh session with Supabase
    const db = initializeDatabaseFromEnv();
    const { data, error } = await db.getClient().auth.refreshSession({
      refresh_token,
    });

    if (error || !data.session) {
      throw createAPIError('Invalid or expired refresh token', 401, 'unauthorized');
    }

    // Return new tokens
    res.json({
      access_token: data.session.access_token,
      refresh_token: data.session.refresh_token,
      expires_in: data.session.expires_in,
      token_type: 'Bearer',
    });
  })
);

/**
 * POST /auth/logout
 * Logout and invalidate session
 */
router.post(
  '/logout',
  asyncHandler(async (req: Request, res: Response) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      // Already logged out
      return res.json({ message: 'Logged out successfully' });
    }

    const token = authHeader.substring(7);
    const db = initializeDatabaseFromEnv();

    // Sign out from Supabase
    await db.getClient().auth.signOut();

    res.json({ message: 'Logged out successfully' });
  })
);

export default router;
