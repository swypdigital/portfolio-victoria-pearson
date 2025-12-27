/**
 * AIEN Routes
 * Endpoints for AI/ML enforcement checks
 */

import { Router, Request, Response } from 'express';
import { authMiddleware } from '../middleware/auth';
import { asyncHandler, createAPIError } from '../middleware/error-handler';
import { EnforcementEngine } from '../../aien/enforcement-engine';
import { initializeDatabaseFromEnv } from '../../shared/database';

const router = Router();
const enforcementEngine = new EnforcementEngine();

/**
 * POST /aien/check
 * Pre-flight enforcement check before generation
 */
router.post(
  '/check',
  authMiddleware,
  asyncHandler(async (req: Request, res: Response) => {
    const { prompt, vertical: verticalHint } = req.body;

    // Validation
    if (!prompt || typeof prompt !== 'string' || prompt.trim().length === 0) {
      throw createAPIError('prompt is required and must be a non-empty string', 400, 'validation_error');
    }

    if (!req.user) {
      throw createAPIError('Authentication required', 401, 'unauthorized');
    }

    // Get user subscription
    const db = initializeDatabaseFromEnv();
    const subscription = await db.getSubscription(req.user.tenant_id);

    if (!subscription) {
      throw createAPIError('No active subscription found', 403, 'forbidden');
    }

    // Build enforcement context
    const context = {
      userId: req.user.id,
      tenantId: req.user.tenant_id,
      prompt: prompt.trim(),
      verticalHint,
      subscription: {
        tier: subscription.tier,
        allowedVerticals: subscription.allowed_verticals || [],
        tokenLimitMonthly: subscription.token_limit_monthly || 0,
        tokensUsedCurrentMonth: subscription.tokens_used_current_month || 0,
        features: {
          previewMode: subscription.tier === 'free',
          previewWords: 100,
        },
      },
    };

    // Perform enforcement check
    const enforcementResult = await enforcementEngine.enforce(context);

    // Log enforcement decision to audit trail
    await db.logEnforcementDecision({
      tenant_id: req.user.tenant_id,
      user_id: req.user.id,
      user_prompt: prompt.trim(),
      classified_vertical: enforcementResult.vertical,
      classified_feature: enforcementResult.feature || null,
      confidence: 0.96, // TODO: Get from classification
      decision: enforcementResult.decision,
      decision_reason: enforcementResult.reason,
      processing_time_ms: enforcementResult.processingTimeMs,
    });

    // Map enforcement result to API response
    const response = {
      allowed: enforcementResult.decision === 'allow',
      vertical: enforcementResult.vertical,
      feature: enforcementResult.feature,
      confidence: 0.96, // TODO: Get from classification
      estimated_tokens: enforcementResult.estimatedTokens,
      processing_time_ms: enforcementResult.processingTimeMs,
      warnings: enforcementResult.warnings || [],

      // Add denial-specific fields
      ...(enforcementResult.decision !== 'allow' && {
        reason: mapDecisionToReason(enforcementResult.decision),
        message: enforcementResult.reason,
      }),

      // Add upgrade options for denied/soft-block
      ...(enforcementResult.upgradeOptions && {
        upgrade_options: enforcementResult.upgradeOptions.map((option) => ({
          tier: option.tier,
          price: option.price,
          features: option.features,
        })),
      }),

      // Add preview mode info for soft-block
      ...(enforcementResult.previewMode && {
        preview_mode: true,
        preview_words: enforcementResult.previewWords,
      }),
    };

    res.json(response);
  })
);

/**
 * Map AIEN decision to API reason code
 */
function mapDecisionToReason(decision: string): string {
  const reasonMap: Record<string, string> = {
    deny: 'subscription_required',
    soft_block: 'upgrade_for_full_access',
    redirect: 'alternative_vertical_suggested',
    warn: 'low_confidence_classification',
  };
  return reasonMap[decision] || 'unknown';
}

export default router;
