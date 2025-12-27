/**
 * AIEN Enforcement Engine
 * Enforces subscription-based access control with <250ms total latency
 *
 * Component #46 from SAAS Framework v7.0
 */

import { IntentClassifier } from './intent-classifier';
import {
  AIENEnforcementResult,
  AIENDecision,
  AIENClassificationResult,
  SubscriptionConfig,
  AIENEnforcementMode,
} from './types';

export interface EnforcementContext {
  userId: string;
  tenantId: string;
  prompt: string;
  verticalHint?: string;
  subscription: SubscriptionConfig;
}

export class EnforcementEngine {
  private classifier: IntentClassifier;
  private performanceThresholdMs = 250;

  constructor() {
    this.classifier = new IntentClassifier();
  }

  /**
   * Enforce access control for a user prompt
   *
   * @param context - User and subscription context
   * @returns Enforcement decision with latency tracking
   */
  async enforce(context: EnforcementContext): Promise<AIENEnforcementResult> {
    const startTime = Date.now();

    try {
      // Step 1: Classify the intent (<200ms requirement)
      const classification = await this.classifier.classify(
        context.prompt,
        context.verticalHint
      );

      // Step 2: Check subscription access
      const decision = this.checkSubscriptionAccess(
        classification,
        context.subscription
      );

      // Step 3: Build enforcement result
      const result = this.buildEnforcementResult(
        classification,
        decision,
        context.subscription,
        startTime
      );

      // Step 4: Verify performance requirement
      if (result.processingTimeMs > this.performanceThresholdMs) {
        console.warn(
          `⚠️ AIEN enforcement exceeded ${this.performanceThresholdMs}ms: ${result.processingTimeMs}ms`
        );
      }

      return result;
    } catch (error) {
      // Fail-safe: deny on error
      return {
        decision: 'deny',
        reason: 'Internal error during enforcement check',
        vertical: 'unknown',
        processingTimeMs: Date.now() - startTime,
      };
    }
  }

  /**
   * Check if subscription allows access to classified vertical
   */
  private checkSubscriptionAccess(
    classification: AIENClassificationResult,
    subscription: SubscriptionConfig
  ): AIENDecision {
    // Unknown intent = deny
    if (classification.vertical === 'unknown' || classification.confidence < 0.5) {
      return 'deny';
    }

    // Check if vertical is in allowed list
    const hasAccess = subscription.allowedVerticals.includes(
      classification.vertical
    );

    if (!hasAccess) {
      // Check if preview mode is available for free tier
      if (subscription.tier === 'free' && subscription.features.previewMode) {
        return 'soft_block';
      }
      return 'deny';
    }

    // Check token quota
    if (subscription.tokensUsedCurrentMonth >= subscription.tokenLimitMonthly) {
      return 'deny';
    }

    // Confidence warning for medium-confidence classifications
    if (classification.confidence < 0.85) {
      return 'warn';
    }

    return 'allow';
  }

  /**
   * Build complete enforcement result with upgrade options
   */
  private buildEnforcementResult(
    classification: AIENClassificationResult,
    decision: AIENDecision,
    subscription: SubscriptionConfig,
    startTime: number
  ): AIENEnforcementResult {
    const baseResult: AIENEnforcementResult = {
      decision,
      reason: this.getDecisionReason(decision, classification, subscription),
      vertical: classification.vertical,
      feature: classification.feature,
      processingTimeMs: Date.now() - startTime,
    };

    // Add decision-specific details
    switch (decision) {
      case 'soft_block':
        return {
          ...baseResult,
          previewMode: true,
          previewWords: subscription.features.previewWords || 100,
          upgradeOptions: this.getUpgradeOptions(subscription.tier),
        };

      case 'deny':
        return {
          ...baseResult,
          upgradeOptions: this.getUpgradeOptions(subscription.tier),
        };

      case 'warn':
        return {
          ...baseResult,
          warnings: [
            `Classification confidence (${(classification.confidence * 100).toFixed(0)}%) below 85% threshold`,
            classification.alternatives && classification.alternatives.length > 0
              ? `Alternative interpretations: ${classification.alternatives.join(', ')}`
              : undefined,
          ].filter(Boolean) as string[],
        };

      case 'allow':
        return {
          ...baseResult,
          estimatedTokens: this.estimateTokens(classification.vertical),
        };

      default:
        return baseResult;
    }
  }

  /**
   * Generate human-readable reason for decision
   */
  private getDecisionReason(
    decision: AIENDecision,
    classification: AIENClassificationResult,
    subscription: SubscriptionConfig
  ): string {
    switch (decision) {
      case 'allow':
        return `Access granted to ${classification.vertical}`;

      case 'deny':
        if (classification.vertical === 'unknown') {
          return 'Unable to determine vertical from prompt';
        }
        if (classification.confidence < 0.5) {
          return 'Prompt classification confidence too low';
        }
        if (!subscription.allowedVerticals.includes(classification.vertical)) {
          return `${classification.vertical} not included in ${subscription.tier} plan`;
        }
        if (
          subscription.tokensUsedCurrentMonth >= subscription.tokenLimitMonthly
        ) {
          return 'Monthly token limit exceeded';
        }
        return 'Access denied';

      case 'soft_block':
        return `Preview mode: ${classification.vertical} requires ${this.getMinimumTier(classification.vertical)} plan or higher`;

      case 'warn':
        return `Proceeding with ${classification.vertical}, but classification confidence below optimal threshold`;

      default:
        return 'Unknown decision';
    }
  }

  /**
   * Get upgrade options based on current tier
   */
  private getUpgradeOptions(currentTier: string): {
    tier: string;
    price: number;
    features: string[];
  }[] {
    const tiers = [
      {
        tier: 'starter',
        price: 49.0,
        features: [
          'SaleswriterCraft',
          'AppCraft',
          'ContentCraft',
          '500K tokens/month',
          'Email support',
        ],
      },
      {
        tier: 'pro',
        price: 149.0,
        features: [
          'All Starter features',
          'LegalCraft',
          'MarketingCraft',
          '2M tokens/month',
          'Priority support',
          'Custom templates',
        ],
      },
      {
        tier: 'enterprise',
        price: 499.0,
        features: [
          'All Pro features',
          'All 24 verticals',
          'Unlimited tokens',
          '24/7 dedicated support',
          'Custom integrations',
          'White-label',
          'SSO',
        ],
      },
    ];

    // Return tiers above current
    const tierOrder = ['free', 'starter', 'pro', 'enterprise'];
    const currentIndex = tierOrder.indexOf(currentTier);

    return tiers.filter((_, index) => index > currentIndex);
  }

  /**
   * Determine minimum tier required for a vertical
   */
  private getMinimumTier(vertical: string): string {
    // Phase 1 verticals
    if (vertical === 'SaleswriterCraft') return 'starter';

    // Phase 3 verticals
    if (['AppCraft', 'ContentCraft'].includes(vertical)) return 'starter';
    if (['LegalCraft', 'MarketingCraft'].includes(vertical)) return 'pro';

    // All others enterprise
    return 'enterprise';
  }

  /**
   * Estimate token usage for a vertical (rough approximation)
   */
  private estimateTokens(vertical: string): number {
    // Rough estimates based on average output length
    const estimates: Record<string, number> = {
      SaleswriterCraft: 3500, // ~2500 word sales letter
      EmailCampaign: 1500, // ~5 emails in series
      LandingPage: 2000, // ~1500 word page
      AppCraft: 8000, // Code generation
      LegalCraft: 5000, // Legal documents
      ContentCraft: 2500, // Blog posts
    };

    return estimates[vertical] || 3000; // Default estimate
  }

  /**
   * Get enforcement statistics for monitoring
   */
  getStats(): {
    averageLatencyMs: number;
    performanceViolations: number;
  } {
    // TODO: Implement tracking with sliding window
    return {
      averageLatencyMs: 0,
      performanceViolations: 0,
    };
  }
}
