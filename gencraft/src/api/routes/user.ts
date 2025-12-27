/**
 * User Routes
 * Endpoints for user profile management
 */

import { Router, Request, Response } from 'express';
import { authMiddleware } from '../middleware/auth';
import { asyncHandler, createAPIError } from '../middleware/error-handler';
import { initializeDatabaseFromEnv } from '../../shared/database';

const router = Router();

/**
 * GET /me
 * Get current user profile with subscription info
 */
router.get(
  '/me',
  authMiddleware,
  asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) {
      throw createAPIError('Authentication required', 401, 'unauthorized');
    }

    const db = initializeDatabaseFromEnv();

    // Get user details from Supabase
    const { data: userData, error: userError } = await db
      .getClient()
      .from('users')
      .select('*')
      .eq('id', req.user.id)
      .single();

    if (userError) {
      throw createAPIError('Failed to fetch user profile', 500, 'internal_error');
    }

    // Get tenant details
    const { data: tenantData, error: tenantError } = await db
      .getClient()
      .from('tenants')
      .select('*')
      .eq('id', req.user.tenant_id)
      .single();

    if (tenantError) {
      throw createAPIError('Failed to fetch tenant info', 500, 'internal_error');
    }

    // Get subscription details
    const subscription = await db.getSubscription(req.user.tenant_id);

    // Build response
    res.json({
      id: userData.id,
      email: userData.email,
      full_name: userData.full_name,
      avatar_url: userData.avatar_url,
      role: userData.role,
      tenant: {
        id: tenantData.id,
        name: tenantData.name,
        slug: tenantData.slug,
      },
      subscription: subscription
        ? {
            tier: subscription.tier,
            tokens_remaining:
              subscription.token_limit_monthly - subscription.tokens_used_current_month,
            allowed_verticals: subscription.allowed_verticals,
          }
        : null,
    });
  })
);

/**
 * PATCH /me
 * Update current user profile
 */
router.patch(
  '/me',
  authMiddleware,
  asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) {
      throw createAPIError('Authentication required', 401, 'unauthorized');
    }

    const { full_name, avatar_url, settings } = req.body;

    // Build update object
    const updates: any = {};
    if (full_name !== undefined) updates.full_name = full_name;
    if (avatar_url !== undefined) updates.avatar_url = avatar_url;
    if (settings !== undefined) updates.settings = settings;
    updates.updated_at = new Date().toISOString();

    if (Object.keys(updates).length === 0) {
      throw createAPIError('No valid fields provided for update', 400, 'validation_error');
    }

    // Update user in database
    const db = initializeDatabaseFromEnv();
    const { data, error } = await db
      .getClient()
      .from('users')
      .update(updates)
      .eq('id', req.user.id)
      .select()
      .single();

    if (error) {
      throw createAPIError('Failed to update user profile', 500, 'internal_error');
    }

    res.json({
      id: data.id,
      email: data.email,
      full_name: data.full_name,
      avatar_url: data.avatar_url,
      updated_at: data.updated_at,
    });
  })
);

export default router;
