# GenCraft v3.0 - Subscription Vertical Access Control (SVAC) Implementation Guide

**SVAC: Specific Implementation of AIEN for Subscription-Based Access Control**

**Document ID:** GENCRAFT-V3-SVAC-IMPLEMENTATION-v1.0.0
**Version:** 1.0.0
**Release Date:** December 24, 2025
**Author:** groklyGroup LLC
**Status:** Implementation Ready
**Phase:** Phase 1, Weeks 3-10
**Copyright:** © 2025 groklyGroup LLC. All rights reserved.

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [SVAC vs. AIEN Relationship](#svac-vs-aien-relationship)
3. [GenCraft Business Model](#gencraft-business-model)
4. [Implementation Timeline](#implementation-timeline)
5. [Database Schema](#database-schema)
6. [Vertical Intent Classifier](#vertical-intent-classifier)
7. [Middleware Integration](#middleware-integration)
8. [Enforcement Logic](#enforcement-logic)
9. [Site Owner Configuration](#site-owner-configuration)
10. [Testing Strategy](#testing-strategy)
11. [Deployment Checklist](#deployment-checklist)

---

## Executive Summary

**SVAC (Subscription Vertical Access Control)** is GenCraft's specific implementation of the Universal AI/ML Enforcement Engine (AIEN) for subscription-based business models. While AIEN provides the universal framework for any constraint type, SVAC focuses exclusively on controlling access to GenCraft's 24 verticals based on subscription tiers.

### The Core Problem SVAC Solves

**Problem:** GenCraft has 900+ hours of planning but zero production code. During architectural review, a critical gap was identified:

> "GenCraft has feature optimization flags (quality on/off) but NO enforcement mechanism preventing users from prompting for verticals outside their subscription. A Free tier user can still prompt 'generate me an app' and GenCraft would attempt generation (lower quality) - undermining the entire business model."

**SVAC Solution:**
- ✅ Detects which vertical user is requesting (via intent classification)
- ✅ Checks if user's subscription includes that vertical
- ✅ Blocks unauthorized requests with clear upgrade messaging
- ✅ 100% configurable by site owners (white-label architecture)
- ✅ <50ms enforcement overhead

---

## SVAC vs. AIEN Relationship

### Conceptual Hierarchy

```
AIEN (Universal Framework)
  ├── Subscription Enforcement (SVAC) ← GenCraft uses this
  ├── Quota Enforcement
  ├── RBAC Enforcement
  ├── Compliance Enforcement
  ├── Cost Control Enforcement
  └── Quality Gate Enforcement
```

### Key Differences

| Aspect | AIEN | SVAC |
|--------|------|------|
| **Scope** | Universal (any constraint) | Subscription-specific |
| **Use Cases** | 10+ constraint types | 1 type (tier-based access) |
| **Configuration** | Flexible JSONB rules | Structured tier definitions |
| **Components** | All 5 AIEN layers | Subset optimized for subscriptions |
| **Deployment** | Standalone service | GenCraft middleware |

**Bottom Line:** SVAC is a "pre-configured AIEN" optimized for GenCraft's subscription business model.

---

## GenCraft Business Model

### Pricing Tiers (Site Owner Configurable)

**Default Tier Structure** (site owners can customize):

#### Free Tier
- **Vertical Access:** View-only (all 24 verticals)
- **Generation:** None (can browse examples)
- **Features:**
  - Explore vertical capabilities
  - View curated example outputs
  - Access basic document templates
- **Goal:** Awareness and conversion

#### Starter Tier ($49/month - example)
- **Vertical Access:** Choose 3 verticals
- **Token Limit:** 500,000/month (site owner configurable)
- **Features:**
  - Full generation in selected verticals
  - Export to PDF/DOCX
  - Basic analytics
- **Goal:** Small businesses, freelancers

#### Pro Tier ($149/month - example)
- **Vertical Access:** Choose 12 verticals
- **Token Limit:** 2,000,000/month
- **Features:**
  - Priority generation queue
  - Advanced analytics
  - A/B testing capabilities
- **Goal:** Growing businesses, agencies

#### Enterprise Tier (Custom pricing)
- **Vertical Access:** All 24 verticals
- **Token Limit:** 10,000,000+/month (negotiable)
- **Features:**
  - Dedicated MOECraft instance (82-86% cost reduction)
  - White-label capabilities
  - Custom integrations
  - SLA guarantees
- **Goal:** Large enterprises, white-label partners

**CRITICAL:** These tiers are **EXAMPLES ONLY**. Site owners configure actual tiers, pricing, and limits via admin panel.

### The 24 GenCraft Verticals

**Documented Verticals** (as of v3.0 Master Plan):
1. SaleswriterCraft
2. LegalCraft
3. AppCraft
4. CodeCraft
5. ContentCraft
6. MarketResearchCraft
7. StrategyCraft
8. AnalyticsCraft
... (plus 16 more to be identified during implementation)

**Note:** Actual vertical list may expand to 43 verticals × 10 overlays = 430 product SKUs (per Payment Service spec).

---

## Implementation Timeline

### Phase 1: Weeks 3-10 (Parallel with Document Management System)

**Week 3-4: Database & Schema**
- Create SVAC tables
- Migrate tenant configuration
- Set up vertical access mappings

**Week 5-6: Intent Classifier Training**
- Collect training dataset (10,000+ examples)
- Train vertical classifier
- Validate accuracy >95%

**Week 7-8: Middleware & API Integration**
- Implement enforcement middleware
- Integrate with Document 07
- Connect to MOECraft orchestrator

**Week 9: Site Owner Admin Panel**
- Build configuration UI
- Enable real-time tier updates
- Preview mode for testing

**Week 10: Testing & Deployment**
- 10-phase testing framework
- Load testing (1000 req/sec)
- Production deployment

---

## Database Schema

### Core Tables

```sql
-- ============================================
-- SVAC CONFIGURATION TABLES
-- ============================================

-- 1. Subscription Tiers (Site Owner Configured)
CREATE TABLE svac_subscription_tiers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,

  -- Tier Definition
  tier_name TEXT NOT NULL,  -- e.g., 'free', 'starter', 'pro', 'enterprise'
  tier_display_name TEXT,   -- e.g., 'Starter Plan'
  tier_description TEXT,

  -- Pricing (site owner sets)
  price_monthly NUMERIC(10,2),
  price_annual NUMERIC(10,2),

  -- Vertical Access
  vertical_access_model TEXT CHECK (vertical_access_model IN (
    'none',          -- Free tier (view-only)
    'choose_N',      -- User chooses N verticals
    'specific_list', -- Pre-defined vertical list
    'all'            -- Enterprise (all verticals)
  )),
  vertical_limit INTEGER,  -- For 'choose_N' model
  allowed_verticals TEXT[],  -- For 'specific_list' model

  -- Resource Limits
  token_limit_monthly INTEGER,
  token_rollover_enabled BOOLEAN DEFAULT false,
  token_rollover_max INTEGER,

  -- Features
  features JSONB DEFAULT '{}',  -- tier-specific features

  -- Enforcement Settings
  enforcement_mode TEXT CHECK (enforcement_mode IN (
    'hard_block', 'soft_block', 'redirect', 'warn', 'log_only'
  )) DEFAULT 'hard_block',

  preview_words INTEGER DEFAULT 100,  -- For soft_block mode
  redirect_vertical TEXT,  -- For redirect mode

  -- Metadata
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(tenant_id, tier_name)
);

-- 2. User Vertical Access (Runtime Access Control)
CREATE TABLE svac_user_vertical_access (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,

  -- Subscription Details
  subscription_tier_id UUID REFERENCES svac_subscription_tiers(id),
  tier_name TEXT NOT NULL,

  -- Allowed Verticals for This User
  allowed_verticals TEXT[] NOT NULL,  -- e.g., ['SaleswriterCraft', 'LegalCraft', 'AppCraft']

  -- Token Tracking
  token_limit_monthly INTEGER,
  tokens_used_current_month INTEGER DEFAULT 0,
  billing_period_start DATE,
  billing_period_end DATE,

  -- Status
  active BOOLEAN DEFAULT true,
  suspended BOOLEAN DEFAULT false,
  suspension_reason TEXT,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, tenant_id)
);

-- 3. Vertical Definitions (Master List)
CREATE TABLE svac_verticals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID REFERENCES tenants(id),  -- NULL = global definition

  -- Vertical Identity
  vertical_id TEXT NOT NULL,  -- e.g., 'SaleswriterCraft'
  vertical_name TEXT NOT NULL,
  vertical_description TEXT,
  vertical_category TEXT,  -- e.g., 'Content', 'Development', 'Analysis'

  -- Resource Estimates
  avg_tokens_per_request INTEGER,
  avg_generation_time_ms INTEGER,

  -- Requirements
  requires_advanced_model BOOLEAN DEFAULT false,
  min_tier TEXT,  -- Minimum tier required (if set globally)

  -- Metadata
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(tenant_id, vertical_id)
);

-- 4. Access Denial Log (Audit & Analytics)
CREATE TABLE svac_access_denials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID REFERENCES tenants(id),
  user_id UUID REFERENCES users(id),

  -- Request Details
  request_timestamp TIMESTAMPTZ DEFAULT NOW(),
  user_prompt TEXT,

  -- Classification
  detected_vertical TEXT,
  classification_confidence NUMERIC(5,2),

  -- Denial Reason
  denial_reason TEXT CHECK (denial_reason IN (
    'subscription_tier_insufficient',
    'vertical_not_in_allowed_list',
    'token_quota_exceeded',
    'subscription_suspended',
    'vertical_not_available',
    'other'
  )),

  -- User Context
  user_tier TEXT,
  user_allowed_verticals TEXT[],
  user_tokens_remaining INTEGER,

  -- Enforcement Action
  enforcement_action TEXT CHECK (enforcement_action IN (
    'hard_block', 'soft_block_preview', 'redirect', 'warn'
  )),

  -- Response Shown
  response_message TEXT,
  upgrade_cta_shown BOOLEAN DEFAULT false,

  -- Metadata
  ip_address INET,
  user_agent TEXT,
  session_id TEXT
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_user_vertical_access_user ON svac_user_vertical_access(user_id);
CREATE INDEX idx_user_vertical_access_tenant ON svac_user_vertical_access(tenant_id);
CREATE INDEX idx_access_denials_user_time ON svac_access_denials(user_id, request_timestamp DESC);
CREATE INDEX idx_access_denials_vertical ON svac_access_denials(detected_vertical);
CREATE INDEX idx_access_denials_reason ON svac_access_denials(denial_reason);

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Check if user has access to a vertical
CREATE OR REPLACE FUNCTION svac_check_vertical_access(
  p_user_id UUID,
  p_vertical TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_has_access BOOLEAN;
BEGIN
  SELECT
    p_vertical = ANY(allowed_verticals)
    AND active = true
    AND suspended = false
  INTO v_has_access
  FROM svac_user_vertical_access
  WHERE user_id = p_user_id;

  RETURN COALESCE(v_has_access, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Deduct tokens from user quota
CREATE OR REPLACE FUNCTION svac_deduct_tokens(
  p_user_id UUID,
  p_tokens_used INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
  v_tokens_remaining INTEGER;
BEGIN
  -- Update and return new balance
  UPDATE svac_user_vertical_access
  SET
    tokens_used_current_month = tokens_used_current_month + p_tokens_used,
    updated_at = NOW()
  WHERE user_id = p_user_id
  RETURNING (token_limit_monthly - tokens_used_current_month) INTO v_tokens_remaining;

  -- Return true if user still has tokens
  RETURN v_tokens_remaining >= 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Sample Data (Default Configuration)

```sql
-- Example: Site owner's default tier configuration
INSERT INTO svac_subscription_tiers (tenant_id, tier_name, tier_display_name, price_monthly, vertical_access_model, vertical_limit, token_limit_monthly, features, enforcement_mode)
VALUES
  -- Free Tier
  ('tenant-uuid', 'free', 'Free Plan', 0.00, 'none', 0, 10000,
   '{"preview_mode": true, "view_only": true, "basic_templates": true}',
   'soft_block'),

  -- Starter Tier
  ('tenant-uuid', 'starter', 'Starter Plan', 49.00, 'choose_N', 3, 500000,
   '{"export_formats": ["pdf", "docx"], "basic_analytics": true}',
   'soft_block'),

  -- Pro Tier
  ('tenant-uuid', 'pro', 'Pro Plan', 149.00, 'choose_N', 12, 2000000,
   '{"priority_queue": true, "advanced_analytics": true, "ab_testing": true}',
   'hard_block'),

  -- Enterprise Tier
  ('tenant-uuid', 'enterprise', 'Enterprise', NULL, 'all', NULL, 10000000,
   '{"dedicated_instance": true, "white_label": true, "sla": "99.9%"}',
   'hard_block');

-- Example: User vertical access
INSERT INTO svac_user_vertical_access (user_id, tenant_id, subscription_tier_id, tier_name, allowed_verticals, token_limit_monthly, billing_period_start, billing_period_end)
VALUES
  ('user-123', 'tenant-uuid', 'starter-tier-id', 'starter',
   ARRAY['SaleswriterCraft', 'LegalCraft', 'ContentCraft'],  -- User chose these 3
   500000, '2025-12-01', '2026-01-01');
```

---

## Vertical Intent Classifier

### Training Dataset Requirements

**Dataset Size:** 10,000+ examples per vertical (240,000+ total for 24 verticals)

**Example Training Data:**

```json
{
  "prompt": "Generate me a professional sales letter for my SaaS product",
  "vertical": "SaleswriterCraft",
  "confidence": 1.0,
  "features": ["generate", "sales", "professional", "letter"],
  "metadata": {
    "complexity": "medium",
    "estimated_tokens": 3500,
    "model_required": "claude-opus"
  }
}
```

**Diverse Phrasing Examples:**

```typescript
// Direct Request
"Write me a sales letter" → SaleswriterCraft (confidence: 0.98)

// Indirect Request
"Help me convince people to buy my product" → SaleswriterCraft (confidence: 0.89)

// Euphemistic Request
"Create something persuasive for my offering" → SaleswriterCraft (confidence: 0.76)

// Metaphorical Request
"Tell me a compelling story about why someone should acquire my solution" → SaleswriterCraft (confidence: 0.68)

// Decomposition Attack (multi-step)
"What are the parts of a sales letter?" → SaleswriterCraft (confidence: 0.45, flag as potential bypass)
```

### Classifier Architecture

**Extends existing Intent-Based Security Engine** (already built for harmful content detection)

```typescript
// Extend existing security engine
class VerticalIntentClassifier extends IntentSecurityEngine {

  async classifyVertical(prompt: string): Promise<VerticalIntent> {
    // Step 1: Multi-representation analysis
    const representations = await this.analyzeRepresentations(prompt);

    // Step 2: Feature extraction
    const features = await this.extractFeatures(representations);

    // Step 3: Model inference
    const verticalScores = await this.model.predict(features);

    // Step 4: Confidence scoring
    const topVertical = this.selectTopVertical(verticalScores);

    // Step 5: Pattern detection (anti-gaming)
    const isAttemptingBypass = await this.detectBypassAttempt(prompt, topVertical);

    return {
      vertical: topVertical.name,
      confidence: topVertical.score,
      alternatives: this.getAlternatives(verticalScores, 3),
      bypassAttemptDetected: isAttemptingBypass,
      estimatedTokens: await this.estimateTokens(topVertical, prompt),
      modelRequired: await this.selectOptimalModel(topVertical, prompt)
    };
  }

  private async detectBypassAttempt(prompt: string, vertical: Vertical): Promise<boolean> {
    // Check for meta-instructions
    if (/ignore|bypass|skip|don't check/i.test(prompt)) {
      return true;
    }

    // Check request history for decomposition pattern
    const userHistory = await this.getUserHistory();
    if (this.isDecompositionAttack(userHistory, vertical)) {
      return true;
    }

    return false;
  }
}
```

### Training the Classifier

```bash
# 1. Collect training data
npm run collect-training-data --verticals 24 --samples 10000

# 2. Generate augmented samples (synonyms, paraphrases)
npm run augment-dataset --factor 3  # 3x dataset size

# 3. Train model
npm run train-vertical-classifier \
  --dataset ./datasets/gencraft-verticals-v1.json \
  --model-type transformer \
  --epochs 50 \
  --batch-size 32

# 4. Validate accuracy
npm run validate-classifier --test-split 0.2

# Expected output:
# Accuracy: 96.3%
# F1 Score: 0.94
# Avg. Latency: 187ms
# False Positive Rate: 1.8%

# 5. Export trained model
npm run export-model --output ./models/vertical-classifier-v1.0.0.pb
```

---

## Middleware Integration

### API Gateway Enforcement

```typescript
// middleware/svac-enforcement.ts

import { Request, Response, NextFunction } from 'express';
import { VerticalIntentClassifier } from '@gencraft/intent-classifier';
import { SVACEngine } from '@gencraft/svac-engine';

export async function svacEnforcementMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    // Extract user and prompt
    const user = req.user;  // From authentication middleware
    const prompt = req.body.prompt;

    // Step 1: Classify intent
    const intent = await VerticalIntentClassifier.classify(prompt);

    console.log(`[SVAC] User ${user.id} requesting vertical: ${intent.vertical} (confidence: ${intent.confidence})`);

    // Step 2: Check access
    const hasAccess = await SVACEngine.checkAccess(user.id, intent.vertical);

    if (!hasAccess) {
      // BLOCKED - User doesn't have access to this vertical

      // Log denial
      await logAccessDenial({
        userId: user.id,
        prompt,
        detectedVertical: intent.vertical,
        confidence: intent.confidence,
        reason: 'subscription_tier_insufficient',
        userTier: user.subscription_tier,
        userAllowedVerticals: user.allowed_verticals
      });

      // Get enforcement mode from tenant config
      const config = await getTenantConfig(user.tenant_id);

      // Generate response based on enforcement mode
      const response = await generateDenialResponse(
        config.enforcement_mode,
        intent,
        user,
        config
      );

      return res.status(403).json(response);
    }

    // Step 3: Check token quota
    const hasTokens = await SVACEngine.checkTokenQuota(
      user.id,
      intent.estimatedTokens
    );

    if (!hasTokens) {
      // BLOCKED - Insufficient tokens

      await logAccessDenial({
        userId: user.id,
        prompt,
        detectedVertical: intent.vertical,
        reason: 'token_quota_exceeded',
        userTokensRemaining: user.tokens_remaining
      });

      return res.status(429).json({
        error: 'token_quota_exceeded',
        message: 'You have insufficient tokens for this request',
        tokensRequired: intent.estimatedTokens,
        tokensRemaining: user.tokens_remaining,
        upgradeOptions: await getUpgradeOptions(user)
      });
    }

    // ACCESS GRANTED - Proceed with generation

    // Attach metadata to request
    req.metadata = {
      detectedVertical: intent.vertical,
      estimatedTokens: intent.estimatedTokens,
      confidence: intent.confidence
    };

    next();

  } catch (error) {
    console.error('[SVAC] Enforcement error:', error);

    // Fail open (allow request) or fail closed (deny request)?
    // Recommendation: Fail closed for security
    return res.status(500).json({
      error: 'enforcement_error',
      message: 'Unable to validate access. Please try again.'
    });
  }
}

// Apply middleware to all generation endpoints
app.post('/api/generate',
  authMiddleware,
  svacEnforcementMiddleware,
  generateHandler
);

app.post('/api/verticals/:vertical/generate',
  authMiddleware,
  svacEnforcementMiddleware,
  generateVerticalHandler
);
```

### Document 07 Integration

```typescript
// gencraft/document-07-bootloader.ts

import { SVACEngine } from '@gencraft/svac-engine';

export class Document07 {

  static async generate(prompt: string, user: User): Promise<Document> {

    // SVAC CHECK BEFORE META-GENERATION
    const intent = await VerticalIntentClassifier.classify(prompt);
    const hasAccess = await SVACEngine.checkAccess(user.id, intent.vertical);

    if (!hasAccess) {
      throw new SVACDeniedError({
        vertical: intent.vertical,
        userTier: user.subscription_tier,
        allowedVerticals: user.allowed_verticals
      });
    }

    // ACCESS GRANTED - Proceed with Document 07 meta-generation
    console.log(`[Document07] Generating for vertical: ${intent.vertical}`);

    const document = await this.metaGenerate(prompt, {
      vertical: intent.vertical,
      user,
      modelConstraints: {
        maxTokens: intent.estimatedTokens,
        preferredModel: intent.modelRequired
      }
    });

    // Deduct tokens from user quota
    await SVACEngine.deductTokens(user.id, document.tokensUsed);

    return document;
  }
}
```

### MOECraft Integration

```typescript
// gencraft/moecraft-orchestrator.ts

import { SVACEngine } from '@gencraft/svac-engine';

export class MOECraft {

  static async selectModel(request: GenerationRequest): Promise<LLMModel> {

    // Check if user's subscription allows optimal model
    const userTier = request.user.subscription_tier;
    const optimalModel = this.getOptimalModel(request);

    // SVAC: Model downgrade based on subscription tier
    if (userTier === 'free' || userTier === 'starter') {
      if (optimalModel === 'claude-opus' || optimalModel === 'gpt-4') {
        console.log(`[MOECraft] Downgrading ${optimalModel} → gpt-3.5-turbo (subscription tier: ${userTier})`);
        return 'gpt-3.5-turbo';
      }
    }

    // Pro and Enterprise tiers can use any model
    return optimalModel;
  }
}
```

---

## Enforcement Logic

### Decision Flow

```typescript
async function enforceVerticalAccess(
  userId: string,
  vertical: string
): Promise<EnforcementDecision> {

  // Load user access configuration
  const userAccess = await db.query(`
    SELECT
      tier_name,
      allowed_verticals,
      token_limit_monthly,
      tokens_used_current_month,
      suspended
    FROM svac_user_vertical_access
    WHERE user_id = $1
  `, [userId]);

  if (!userAccess) {
    return {
      allowed: false,
      reason: 'no_subscription',
      message: 'You need a subscription to access GenCraft verticals.'
    };
  }

  if (userAccess.suspended) {
    return {
      allowed: false,
      reason: 'subscription_suspended',
      message: 'Your subscription is suspended. Please contact support.'
    };
  }

  // Check vertical access
  const hasVerticalAccess = userAccess.allowed_verticals.includes(vertical);

  if (!hasVerticalAccess) {
    // User doesn't have this vertical

    // Load enforcement mode
    const tierConfig = await getTierConfig(userAccess.tenant_id, userAccess.tier_name);

    if (tierConfig.enforcement_mode === 'hard_block') {
      return {
        allowed: false,
        reason: 'vertical_not_in_subscription',
        message: `${vertical} is not included in your ${userAccess.tier_name} plan.`,
        upgradeOptions: await getUpgradeOptions(userId, vertical)
      };
    } else if (tierConfig.enforcement_mode === 'soft_block') {
      return {
        allowed: 'preview_only',
        reason: 'vertical_not_in_subscription',
        previewWords: tierConfig.preview_words || 100,
        message: `Preview available. Upgrade to unlock full ${vertical} capabilities.`,
        upgradeOptions: await getUpgradeOptions(userId, vertical)
      };
    } else if (tierConfig.enforcement_mode === 'redirect') {
      return {
        allowed: false,
        reason: 'vertical_not_in_subscription',
        redirectTo: tierConfig.redirect_vertical || 'BasicWriter',
        message: `Try our free alternative while you consider upgrading.`,
        upgradeOptions: await getUpgradeOptions(userId, vertical)
      };
    }
  }

  // Check token quota
  const tokensRemaining = userAccess.token_limit_monthly - userAccess.tokens_used_current_month;

  if (tokensRemaining <= 0) {
    return {
      allowed: false,
      reason: 'token_quota_exceeded',
      message: 'You have used all your tokens for this billing period.',
      upgradeOptions: await getUpgradeOptions(userId, null, 'more_tokens')
    };
  }

  // ACCESS GRANTED
  return {
    allowed: true,
    tokensRemaining,
    vertical
  };
}
```

### Response Generation

```typescript
async function generateDenialResponse(
  mode: EnforcementMode,
  intent: VerticalIntent,
  user: User,
  config: TenantConfig
): Promise<DenialResponse> {

  switch (mode) {
    case 'hard_block':
      return {
        allowed: false,
        error: 'subscription_required',
        message: config.customMessages?.hardBlock ||
          `${intent.vertical} requires ${getMinimumTier(intent.vertical)} plan or higher.`,

        upgradeOptions: await getUpgradeOptions(user, intent.vertical),

        alternatives: config.suggestAlternatives ?
          await getSuggestedAlternatives(intent.vertical, user.tier) : null,

        cta: {
          text: 'Upgrade Now',
          link: `/upgrade?vertical=${intent.vertical}`
        }
      };

    case 'soft_block':
      // Generate preview (first N words)
      const preview = await generatePreview(intent, config.preview_words || 100);

      return {
        allowed: 'partial',
        preview: {
          content: preview.text,
          wordCount: config.preview_words,
          fullContentLocked: true
        },
        message: `Preview available. Upgrade to unlock full ${intent.vertical} capabilities.`,
        estimatedFullTokens: intent.estimatedTokens,
        upgradeOptions: await getUpgradeOptions(user, intent.vertical),
        cta: {
          text: `Unlock Full ${intent.vertical}`,
          link: `/upgrade?vertical=${intent.vertical}`
        }
      };

    case 'redirect':
      const redirectVertical = config.redirect_vertical || 'BasicWriter';

      return {
        allowed: false,
        error: 'subscription_required',
        redirect: {
          vertical: redirectVertical,
          message: `While you consider upgrading, try our free ${redirectVertical}.`,
          capabilities: await getVerticalCapabilities(redirectVertical)
        },
        comparison: {
          requested: {
            name: intent.vertical,
            tier: getMinimumTier(intent.vertical),
            features: await getVerticalFeatures(intent.vertical)
          },
          alternative: {
            name: redirectVertical,
            tier: 'free',
            features: await getVerticalFeatures(redirectVertical)
          }
        },
        upgradeOptions: await getUpgradeOptions(user, intent.vertical),
        cta: {
          primary: {
            text: `Try ${redirectVertical}`,
            link: `/generate?vertical=${redirectVertical}`
          },
          secondary: {
            text: `Upgrade to ${intent.vertical}`,
            link: `/upgrade?vertical=${intent.vertical}`
          }
        }
      };

    case 'warn':
      return {
        allowed: true,
        warnings: [
          {
            type: 'approaching_limit',
            message: `You're using ${intent.vertical} which isn't in your plan. This is a courtesy access.`,
            recommendation: 'Upgrade to ensure continued access.'
          }
        ],
        upgradeOptions: await getUpgradeOptions(user, intent.vertical)
      };

    case 'log_only':
      // Allow but log for analytics
      await logAccessEvent({
        userId: user.id,
        vertical: intent.vertical,
        allowed: true,
        note: 'log_only mode - would have been blocked in production'
      });

      return {
        allowed: true
      };
  }
}
```

---

## Site Owner Configuration

### Admin Panel Interface

```typescript
// admin/svac-configuration.tsx

export const SVACConfigurationPanel = () => {
  const [tiers, setTiers] = useState<SubscriptionTier[]>([]);

  return (
    <div className="svac-config-panel">
      <h1>Subscription & Vertical Access Control</h1>

      {/* Step 1: Configure Tiers */}
      <section>
        <h2>1. Configure Subscription Tiers</h2>

        <TierList tiers={tiers} onUpdate={setTiers} />

        <button onClick={() => addTier('new_tier')}>
          + Add Custom Tier
        </button>
      </section>

      {/* Step 2: Define Vertical Access */}
      <section>
        <h2>2. Define Vertical Access Per Tier</h2>

        {tiers.map(tier => (
          <TierVerticalConfig key={tier.id} tier={tier}>
            <VerticalAccessMode
              mode={tier.vertical_access_model}
              onChange={(mode) => updateTier(tier.id, { vertical_access_model: mode })}
            />

            {tier.vertical_access_model === 'choose_N' && (
              <input
                type="number"
                value={tier.vertical_limit}
                onChange={(e) => updateTier(tier.id, { vertical_limit: e.target.value })}
                label="Number of verticals user can choose"
              />
            )}

            {tier.vertical_access_model === 'specific_list' && (
              <VerticalSelector
                verticals={getAllVerticals()}
                selected={tier.allowed_verticals}
                onChange={(verticals) => updateTier(tier.id, { allowed_verticals: verticals })}
              />
            )}
          </TierVerticalConfig>
        ))}
      </section>

      {/* Step 3: Set Enforcement Mode */}
      <section>
        <h2>3. Choose Enforcement Mode</h2>

        <select
          value={config.enforcement_mode}
          onChange={(e) => setConfig({ enforcement_mode: e.target.value })}
        >
          <option value="hard_block">Hard Block (Strict)</option>
          <option value="soft_block">Soft Block (Preview + Paywall)</option>
          <option value="redirect">Redirect (Suggest Alternative)</option>
          <option value="warn">Warn (Allow with Notice)</option>
          <option value="log_only">Log Only (Testing Mode)</option>
        </select>

        <EnforcementModeExplainer mode={config.enforcement_mode} />
      </section>

      {/* Step 4: Customize Messages */}
      <section>
        <h2>4. Customize User-Facing Messages</h2>

        <textarea
          value={config.customMessages.hardBlock}
          onChange={(e) => updateCustomMessage('hardBlock', e.target.value)}
          placeholder="Message shown when user is blocked..."
        />

        <MessagePreview
          mode={config.enforcement_mode}
          message={config.customMessages.hardBlock}
        />
      </section>

      {/* Step 5: Preview & Test */}
      <section>
        <h2>5. Preview Configuration</h2>

        <TestEnforcementPanel
          tiers={tiers}
          config={config}
          onTest={(testCase) => runEnforcementTest(testCase)}
        />
      </section>

      {/* Step 6: Deploy */}
      <section>
        <button
          onClick={deployConfiguration}
          className="btn-primary"
        >
          Deploy Configuration
        </button>

        <p className="deploy-note">
          Changes take effect within 5 seconds across all servers.
        </p>
      </section>
    </div>
  );
};
```

---

## Testing Strategy

### 10-Phase Testing Framework

**MANDATORY:** SVAC must pass 100% of tests across all 10 phases before production deployment.

#### Phase 0: Pre-flight Validation
- Database schema validation
- Vertical definitions complete
- Intent classifier trained (>95% accuracy)

#### Phase 1: Test Discovery & Classification
- Unit tests: Enforcement logic
- Integration tests: API middleware
- E2E tests: Full user flow

#### Phase 2: Dependency Resolution
- Database connection pool
- Cache layer (Redis)
- Intent classifier service

#### Phase 3: System Snapshot
- Backup production configuration
- Create rollback procedure
- Document current state

#### Phase 4: Parallel Execution
- Run all tests in parallel
- Performance benchmarks
- Load tests (1000 req/sec)

#### Phase 5: Multi-Stage Result Validation
- **Stage 1 (Deterministic):** Exact match verification
- **Stage 2 (Statistical):** Confidence score validation
- **Stage 3 (Behavioral):** Pattern analysis
- **Stage 4 (Temporal):** Time-based validation
- **Stage 5 (Quantum):** Future-proof security

#### Phase 6: Cross-Validation
- 3+ validators agree on results
- Manual QA review
- Security audit

#### Phase 7: Consensus Verification
- All validators must agree (100% consensus)
- No discrepancies tolerated

#### Phase 8: Enterprise Report Generation
- Compliance documentation
- Test coverage report
- Performance metrics

#### Phase 9: Claude Projects Synchronization
- Update GenCraft master plan
- Sync with SAAS Framework v7.0
- Document integration points

### Test Scenarios

```typescript
describe('SVAC Enforcement', () => {

  test('Free tier blocked from generating in any vertical', async () => {
    const user = { tier: 'free', allowed_verticals: [] };
    const prompt = 'Generate a sales letter';

    const response = await svacMiddleware(user, prompt);

    expect(response.allowed).toBe(false);
    expect(response.reason).toBe('vertical_not_in_subscription');
  });

  test('Starter tier allowed in selected verticals', async () => {
    const user = {
      tier: 'starter',
      allowed_verticals: ['SaleswriterCraft', 'LegalCraft', 'ContentCraft']
    };
    const prompt = 'Write me a sales letter';

    const response = await svacMiddleware(user, prompt);

    expect(response.allowed).toBe(true);
  });

  test('Starter tier blocked from non-selected vertical', async () => {
    const user = {
      tier: 'starter',
      allowed_verticals: ['SaleswriterCraft']  // Only 1 vertical
    };
    const prompt = 'Build me a mobile app';  // AppCraft not in list

    const response = await svacMiddleware(user, prompt);

    expect(response.allowed).toBe(false);
    expect(response.upgradeOptions).toBeDefined();
  });

  test('Token quota enforcement', async () => {
    const user = {
      tier: 'starter',
      allowed_verticals: ['SaleswriterCraft'],
      token_limit: 500000,
      tokens_used: 498000  // 2000 remaining
    };
    const prompt = 'Generate comprehensive sales strategy';  // ~5000 tokens

    const response = await svacMiddleware(user, prompt);

    expect(response.allowed).toBe(false);
    expect(response.reason).toBe('token_quota_exceeded');
  });

  test('Workaround detection (decomposition attack)', async () => {
    const user = { tier: 'free' };

    // Sequential requests building up to full vertical
    await svacMiddleware(user, 'What are the parts of a sales letter?');
    await svacMiddleware(user, 'Write me a headline');
    await svacMiddleware(user, 'Now write an opening paragraph');
    const response = await svacMiddleware(user, 'Now write the benefits section');

    expect(response.allowed).toBe(false);
    expect(response.reason).toContain('bypass_attempt_detected');
  });

  test('Multi-tenant isolation', async () => {
    const tenant1User = { tenant_id: 'tenant-1', tier: 'pro' };
    const tenant2User = { tenant_id: 'tenant-2', tier: 'pro' };

    // Tenant 1 configures different enforcement than Tenant 2
    await configureTenant('tenant-1', { enforcement_mode: 'hard_block' });
    await configureTenant('tenant-2', { enforcement_mode: 'soft_block' });

    const response1 = await svacMiddleware(tenant1User, 'Generate content');
    const response2 = await svacMiddleware(tenant2User, 'Generate content');

    // Different responses based on tenant config
    expect(response1.allowed).toBe(false);  // Hard block
    expect(response2.allowed).toBe('partial');  // Soft block (preview)
  });

  test('Performance: <50ms enforcement overhead', async () => {
    const user = { tier: 'pro', allowed_verticals: ['SaleswriterCraft'] };
    const prompt = 'Write sales letter';

    const start = Date.now();
    await svacMiddleware(user, prompt);
    const duration = Date.now() - start;

    expect(duration).toBeLessThan(50);
  });
});
```

---

## Deployment Checklist

### Pre-Deployment

- [ ] Database migrations executed
- [ ] Intent classifier trained (>95% accuracy)
- [ ] All 10 testing phases passed (100% pass rate)
- [ ] Load testing completed (1000 req/sec sustained)
- [ ] Multi-tenant configuration tested
- [ ] Rollback procedure documented
- [ ] Site owner admin panel accessible
- [ ] Documentation complete

### Deployment Steps

1. **Deploy Database Schema**
   ```bash
   npm run migrate -- --env production
   ```

2. **Deploy Intent Classifier Model**
   ```bash
   scp ./models/vertical-classifier-v1.0.0.pb production:/models/
   ```

3. **Deploy SVAC Service**
   ```bash
   docker build -t gencraft/svac:1.0.0 .
   docker push gencraft/svac:1.0.0
   kubectl apply -f k8s/svac-deployment.yaml
   ```

4. **Enable Middleware**
   ```bash
   # Feature flag: Enable SVAC enforcement
   kubectl set env deployment/api-gateway SVAC_ENABLED=true
   ```

5. **Verify Deployment**
   ```bash
   curl https://api.gencraft.com/health/svac
   # Expected: {"status": "healthy", "version": "1.0.0"}
   ```

6. **Monitor for 1 hour**
   - Watch error logs
   - Monitor latency (should be <50ms)
   - Verify block rate matches expectations

### Post-Deployment

- [ ] Monitoring dashboards configured
- [ ] Alerts set up (latency, error rate, block rate)
- [ ] Site owners notified of new configuration panel
- [ ] Documentation published
- [ ] Support team trained

---

## Conclusion

SVAC provides GenCraft with **zero business model leakage** - every generation request is validated against the user's subscription before execution. By implementing SVAC in Phase 1 (Weeks 3-10), GenCraft ensures that:

✅ **No unauthorized vertical access** - Users can only generate in verticals they've paid for
✅ **Token quota enforcement** - Usage limits prevent runaway costs
✅ **100% site owner control** - White-label architecture allows complete customization
✅ **High performance** - <50ms enforcement overhead
✅ **Anti-gaming protection** - Detects and blocks bypass attempts
✅ **Observable** - Complete audit trail for analytics and optimization

**Critical to remember:** SVAC is a **specific implementation** of the universal AIEN framework. While GenCraft uses SVAC for subscription enforcement, the same AIEN foundation supports quota-based, RBAC, compliance, cost control, and any other constraint model - making this architecture reusable across all SAAS Framework v7.0 applications.

**Next Steps:**
1. Begin Week 3 implementation (database schema)
2. Train vertical intent classifier (Week 5-6)
3. Implement middleware integration (Week 7-8)
4. Build site owner admin panel (Week 9)
5. Complete 10-phase testing (Week 10)
6. Deploy to production

---

**Document Version:** 1.0.0
**Last Updated:** December 24, 2025
**Author:** groklyGroup LLC
**Phase:** Phase 1, Weeks 3-10
**Status:** Implementation Ready
**Copyright:** © 2025 groklyGroup LLC. All rights reserved.
