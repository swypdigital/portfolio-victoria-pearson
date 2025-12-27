-- ============================================================================
-- GenCraft v3.0 - Initial Database Schema Migration
-- ============================================================================
-- Migration: 001_initial_schema
-- Created: 2025-12-26
-- Author: groklyGroup LLC
-- Description: Foundation schema for multi-tenant GenCraft platform
--
-- Tables Created:
--   - tenants (multi-tenant isolation)
--   - users (authentication + RBAC)
--   - subscriptions (billing + tier management)
--   - svac_vertical_access (subscription vertical access control)
--   - whitelabel_config (branding customization)
--   - aien_configurations (enforcement rules)
--   - aien_audit_log (enforcement decisions)
--   - saleswriter_documents (SaleswriterCraft vertical)
--
-- Security: Row Level Security (RLS) enabled on all tables
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable pgcrypto for encryption
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Tenants: Root entity for multi-tenant isolation
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  domain TEXT UNIQUE, -- Custom domain (e.g., app.customerdomain.com)

  -- Status tracking
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'deleted')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Settings (JSONB for flexibility)
  settings JSONB NOT NULL DEFAULT '{}'::jsonb,

  -- Metadata
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for tenants
CREATE INDEX idx_tenants_slug ON tenants(slug);
CREATE INDEX idx_tenants_status ON tenants(status);
CREATE INDEX idx_tenants_created ON tenants(created_at DESC);

-- Trigger: Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER tenants_updated_at
  BEFORE UPDATE ON tenants
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================

-- Users: Authentication + RBAC
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,

  -- Profile
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,

  -- RBAC: god > tenant_admin > manager > user
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('god', 'tenant_admin', 'manager', 'user')),

  -- Status
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'deleted')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_login TIMESTAMPTZ,

  -- Settings
  settings JSONB NOT NULL DEFAULT '{}'::jsonb,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for users
CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SUBSCRIPTION & BILLING TABLES
-- ============================================================================

-- Subscriptions: Tier management + billing
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID UNIQUE NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,

  -- Subscription tier
  tier TEXT NOT NULL DEFAULT 'free' CHECK (tier IN ('free', 'starter', 'pro', 'enterprise')),

  -- Vertical access (SVAC)
  allowed_verticals TEXT[] NOT NULL DEFAULT '{}'::TEXT[],
  vertical_limit INTEGER, -- NULL = unlimited, else max number user can select

  -- Token quota
  token_limit_monthly BIGINT NOT NULL DEFAULT 10000,
  tokens_used_current_month BIGINT NOT NULL DEFAULT 0,
  tokens_rollover_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  tokens_rollover_max BIGINT DEFAULT 0,

  -- Billing cycle
  billing_cycle_start DATE NOT NULL DEFAULT CURRENT_DATE,
  billing_cycle_end DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '1 month'),
  next_billing_date DATE,

  -- Payment
  stripe_customer_id TEXT,
  stripe_subscription_id TEXT,
  payment_method_last4 TEXT,

  -- Status
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'past_due', 'cancelled', 'expired')),
  trial_ends_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Pricing (stored for historical tracking)
  price_monthly NUMERIC(10,2),
  price_annual NUMERIC(10,2),
  currency TEXT NOT NULL DEFAULT 'USD',

  -- Features (JSONB for flexibility)
  features JSONB NOT NULL DEFAULT '{}'::jsonb,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for subscriptions
CREATE INDEX idx_subscriptions_tenant ON subscriptions(tenant_id);
CREATE INDEX idx_subscriptions_tier ON subscriptions(tier);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_billing ON subscriptions(next_billing_date);

CREATE TRIGGER subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================

-- SVAC Vertical Access: Tracks which verticals tenant has access to
CREATE TABLE svac_vertical_access (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID NOT NULL REFERENCES subscriptions(id) ON DELETE CASCADE,

  -- Vertical identification
  vertical_name TEXT NOT NULL,
  vertical_display_name TEXT,

  -- Access tracking
  granted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  granted_by UUID REFERENCES users(id),
  expires_at TIMESTAMPTZ,

  -- Usage tracking
  requests_count BIGINT NOT NULL DEFAULT 0,
  tokens_used BIGINT NOT NULL DEFAULT 0,
  last_used_at TIMESTAMPTZ,

  -- Metadata
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,

  UNIQUE(subscription_id, vertical_name)
);

-- Indexes for svac_vertical_access
CREATE INDEX idx_svac_subscription ON svac_vertical_access(subscription_id);
CREATE INDEX idx_svac_vertical ON svac_vertical_access(vertical_name);
CREATE INDEX idx_svac_expires ON svac_vertical_access(expires_at);

-- ============================================================================
-- WHITE LABEL CUSTOMIZATION
-- ============================================================================

-- White Label Config: Tenant branding customization
CREATE TABLE whitelabel_config (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID UNIQUE NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,

  -- Branding
  brand_name TEXT,
  logo_url TEXT,
  favicon_url TEXT,
  primary_color TEXT DEFAULT '#3B82F6',
  secondary_color TEXT DEFAULT '#10B981',
  accent_color TEXT DEFAULT '#F59E0B',

  -- Custom CSS
  custom_css TEXT,
  custom_js TEXT,

  -- Email branding
  email_from_name TEXT,
  email_from_address TEXT,
  email_footer_html TEXT,
  support_email TEXT,
  support_url TEXT,

  -- Domain
  custom_domain TEXT UNIQUE,
  custom_domain_verified BOOLEAN NOT NULL DEFAULT FALSE,
  custom_domain_verified_at TIMESTAMPTZ,

  -- Legal
  terms_url TEXT,
  privacy_url TEXT,

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for whitelabel_config
CREATE INDEX idx_whitelabel_tenant ON whitelabel_config(tenant_id);
CREATE INDEX idx_whitelabel_domain ON whitelabel_config(custom_domain);

CREATE TRIGGER whitelabel_config_updated_at
  BEFORE UPDATE ON whitelabel_config
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- AIEN (AI/ML ENFORCEMENT ENGINE)
-- ============================================================================

-- AIEN Configurations: Enforcement rules per tenant
CREATE TABLE aien_configurations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,

  -- Configuration type
  config_type TEXT NOT NULL CHECK (config_type IN (
    'subscription',  -- Tier-based access
    'quota',         -- Usage limits
    'rbac',          -- Role-based access
    'compliance',    -- Legal/regulatory
    'cost',          -- Budget constraints
    'quality',       -- Quality gates
    'time',          -- Time-based rules
    'geography'      -- Region restrictions
  )),

  -- Rules (JSONB for maximum flexibility)
  rules JSONB NOT NULL DEFAULT '{}'::jsonb,

  -- Enforcement mode
  enforcement_mode TEXT NOT NULL DEFAULT 'hard_block' CHECK (enforcement_mode IN (
    'hard_block',    -- Complete denial
    'soft_block',    -- Preview then paywall
    'redirect',      -- Suggest alternative
    'warn',          -- Allow with warning
    'log_only'       -- Audit without blocking
  )),

  -- Response configuration
  response_config JSONB NOT NULL DEFAULT '{}'::jsonb,

  -- Priority (lower = higher priority)
  priority INTEGER NOT NULL DEFAULT 100,

  -- Status
  enabled BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Metadata
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for aien_configurations
CREATE INDEX idx_aien_tenant ON aien_configurations(tenant_id);
CREATE INDEX idx_aien_type ON aien_configurations(config_type);
CREATE INDEX idx_aien_priority ON aien_configurations(priority);
CREATE INDEX idx_aien_enabled ON aien_configurations(enabled);

CREATE TRIGGER aien_configurations_updated_at
  BEFORE UPDATE ON aien_configurations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================

-- AIEN Audit Log: Record all enforcement decisions
CREATE TABLE aien_audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Request details
  request_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  user_prompt TEXT,
  request_id TEXT, -- For correlation

  -- Intent classification
  classified_vertical TEXT,
  classified_feature TEXT,
  classification_confidence NUMERIC(5,2),
  alternative_classifications JSONB,

  -- Enforcement decision
  decision TEXT NOT NULL CHECK (decision IN ('allow', 'deny', 'soft_block', 'redirect', 'warn')),
  decision_reason TEXT,
  rules_applied JSONB,
  blocked_by_config UUID REFERENCES aien_configurations(id),

  -- Response
  response_type TEXT,
  response_data JSONB,

  -- Performance metrics
  processing_time_ms INTEGER,
  classification_time_ms INTEGER,
  evaluation_time_ms INTEGER,

  -- Request metadata
  ip_address INET,
  user_agent TEXT,
  session_id TEXT,

  -- Additional context
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for aien_audit_log (optimized for analytics)
CREATE INDEX idx_audit_tenant_time ON aien_audit_log(tenant_id, request_timestamp DESC);
CREATE INDEX idx_audit_user ON aien_audit_log(user_id);
CREATE INDEX idx_audit_decision ON aien_audit_log(decision);
CREATE INDEX idx_audit_vertical ON aien_audit_log(classified_vertical);
CREATE INDEX idx_audit_request ON aien_audit_log(request_id);
CREATE INDEX idx_audit_timestamp ON aien_audit_log(request_timestamp DESC);

-- Partition by month for performance (execute annually)
-- CREATE TABLE aien_audit_log_2025_12 PARTITION OF aien_audit_log
--   FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

-- ============================================================================
-- VERTICAL: SALESWRITERCRAFT
-- ============================================================================

-- SaleswriterCraft Documents: Generated sales content
CREATE TABLE saleswriter_documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Document metadata
  title TEXT NOT NULL,
  description TEXT,
  document_type TEXT DEFAULT 'sales_letter' CHECK (document_type IN (
    'sales_letter',
    'email_campaign',
    'landing_page',
    'product_description',
    'social_ad'
  )),

  -- Generation inputs
  prompt TEXT NOT NULL,
  template_id UUID, -- Reference to template (future)
  target_audience TEXT,
  product_name TEXT,
  key_benefits TEXT[],

  -- Generated content
  generated_content TEXT,
  word_count INTEGER,
  character_count INTEGER,

  -- AI metadata
  model_used TEXT, -- e.g., 'gpt-4', 'claude-opus'
  tokens_used INTEGER,
  generation_time_ms INTEGER,
  quality_score NUMERIC(3,2), -- 0.00 to 5.00

  -- Status tracking
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN (
    'draft',
    'generating',
    'completed',
    'failed',
    'archived'
  )),
  error_message TEXT,

  -- Revision tracking
  version INTEGER NOT NULL DEFAULT 1,
  parent_id UUID REFERENCES saleswriter_documents(id),
  is_latest_version BOOLEAN NOT NULL DEFAULT TRUE,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  archived_at TIMESTAMPTZ,

  -- Export tracking
  exported_pdf BOOLEAN NOT NULL DEFAULT FALSE,
  exported_docx BOOLEAN NOT NULL DEFAULT FALSE,
  exported_html BOOLEAN NOT NULL DEFAULT FALSE,
  last_exported_at TIMESTAMPTZ,

  -- Metadata
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Indexes for saleswriter_documents
CREATE INDEX idx_saleswriter_tenant ON saleswriter_documents(tenant_id);
CREATE INDEX idx_saleswriter_user ON saleswriter_documents(user_id);
CREATE INDEX idx_saleswriter_status ON saleswriter_documents(status);
CREATE INDEX idx_saleswriter_created ON saleswriter_documents(created_at DESC);
CREATE INDEX idx_saleswriter_type ON saleswriter_documents(document_type);
CREATE INDEX idx_saleswriter_parent ON saleswriter_documents(parent_id);

CREATE TRIGGER saleswriter_documents_updated_at
  BEFORE UPDATE ON saleswriter_documents
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE svac_vertical_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE whitelabel_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE aien_configurations ENABLE ROW LEVEL SECURITY;
ALTER TABLE aien_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE saleswriter_documents ENABLE ROW LEVEL SECURITY;

-- Force RLS (even for table owners)
ALTER TABLE tenants FORCE ROW LEVEL SECURITY;
ALTER TABLE users FORCE ROW LEVEL SECURITY;
ALTER TABLE subscriptions FORCE ROW LEVEL SECURITY;
ALTER TABLE svac_vertical_access FORCE ROW LEVEL SECURITY;
ALTER TABLE whitelabel_config FORCE ROW LEVEL SECURITY;
ALTER TABLE aien_configurations FORCE ROW LEVEL SECURITY;
ALTER TABLE aien_audit_log FORCE ROW LEVEL SECURITY;
ALTER TABLE saleswriter_documents FORCE ROW LEVEL SECURITY;

-- RLS Policy: Users can only access data from their tenant
CREATE POLICY tenant_isolation_users ON users
  FOR ALL
  USING (tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid()));

CREATE POLICY tenant_isolation_subscriptions ON subscriptions
  FOR ALL
  USING (tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid()));

CREATE POLICY tenant_isolation_whitelabel ON whitelabel_config
  FOR ALL
  USING (tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid()));

CREATE POLICY tenant_isolation_aien_config ON aien_configurations
  FOR ALL
  USING (tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid()));

CREATE POLICY tenant_isolation_aien_audit ON aien_audit_log
  FOR ALL
  USING (tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid()));

CREATE POLICY tenant_isolation_saleswriter ON saleswriter_documents
  FOR ALL
  USING (tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid()));

-- God mode: god users can see all tenants
CREATE POLICY god_mode_users ON users
  FOR ALL
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'god');

-- Tenant admins: can manage users in their tenant
CREATE POLICY tenant_admin_users ON users
  FOR ALL
  USING (
    tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid())
    AND
    (SELECT role FROM users WHERE id = auth.uid()) IN ('god', 'tenant_admin')
  );

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function: Get user's tenant_id
CREATE OR REPLACE FUNCTION get_user_tenant_id()
RETURNS UUID AS $
BEGIN
  RETURN (SELECT tenant_id FROM users WHERE id = auth.uid());
END;
$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Check if user has role
CREATE OR REPLACE FUNCTION user_has_role(required_role TEXT)
RETURNS BOOLEAN AS $
BEGIN
  RETURN (
    SELECT role FROM users WHERE id = auth.uid()
  ) = required_role;
END;
$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Reset monthly token quota (run on billing cycle start)
CREATE OR REPLACE FUNCTION reset_monthly_token_quota()
RETURNS VOID AS $
DECLARE
  sub RECORD;
BEGIN
  FOR sub IN SELECT * FROM subscriptions WHERE billing_cycle_end <= CURRENT_DATE LOOP
    -- Rollover logic
    IF sub.tokens_rollover_enabled THEN
      UPDATE subscriptions
      SET
        tokens_used_current_month = GREATEST(0, sub.tokens_used_current_month - sub.token_limit_monthly),
        billing_cycle_start = sub.billing_cycle_end,
        billing_cycle_end = sub.billing_cycle_end + INTERVAL '1 month'
      WHERE id = sub.id;
    ELSE
      -- No rollover
      UPDATE subscriptions
      SET
        tokens_used_current_month = 0,
        billing_cycle_start = sub.billing_cycle_end,
        billing_cycle_end = sub.billing_cycle_end + INTERVAL '1 month'
      WHERE id = sub.id;
    END IF;
  END LOOP;
END;
$ LANGUAGE plpgsql;

-- ============================================================================
-- MIGRATION COMPLETE
-- ============================================================================

-- Insert migration record (for tracking)
CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO schema_migrations (version) VALUES ('001_initial_schema');

-- Success message
SELECT 'GenCraft v3.0 Initial Schema Migration Complete!' AS status;
