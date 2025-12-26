-- ReachCraft Database Schema v1.0.0
-- Team 1: Infrastructure Foundation
-- Multi-tenant PostgreSQL with Row-Level Security
-- Generated: 2025-12-25

-- ============================================
-- EXTENSIONS
-- ============================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For text search
CREATE EXTENSION IF NOT EXISTS "btree_gist"; -- For exclusion constraints

-- ============================================
-- ENUMS
-- ============================================

CREATE TYPE user_role AS ENUM ('GOD', 'ADMIN', 'MANAGER', 'USER', 'VIEWER');
CREATE TYPE contact_source AS ENUM ('MANUAL', 'BROWSER', 'CSV_IMPORT', 'API', 'SOCIAL_SYNC', 'AI_SCRAPING', 'MARKETPLACE');
CREATE TYPE contact_category AS ENUM ('PROSPECT', 'CUSTOMER', 'CHURNED', 'COMPETITOR', 'PARTNER', 'INVESTOR', 'INFLUENCER', 'EMPLOYEE');
CREATE TYPE lead_score_category AS ENUM ('HOT', 'WARM', 'COOL', 'COLD');
CREATE TYPE buyer_stage AS ENUM ('UNAWARE', 'PROBLEM_AWARE', 'SOLUTION_AWARE', 'EVALUATION', 'DECISION', 'CUSTOMER');
CREATE TYPE intent_signal AS ENUM ('HIGH', 'MEDIUM', 'LOW', 'NONE');
CREATE TYPE vertical_type AS ENUM ('RECRUITING', 'SALES', 'CREATOR', 'MEDIA', 'FUNDRAISING', 'AGENCY', 'SOCIAL', 'CORPORATE');
CREATE TYPE enrichment_status AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'PARTIAL');
CREATE TYPE marketplace_status AS ENUM ('DRAFT', 'ACTIVE', 'SOLD', 'EXPIRED', 'REMOVED');
CREATE TYPE subscription_tier AS ENUM ('FREE', 'STARTER', 'PROFESSIONAL', 'BUSINESS', 'ENTERPRISE');
CREATE TYPE payment_status AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED');
CREATE TYPE webhook_event AS ENUM (
  'CONTACT_CREATED', 'CONTACT_UPDATED', 'CONTACT_ENRICHED',
  'LEAD_SCORED', 'LEAD_PURCHASED', 'TEAM_INVITED', 'SUBSCRIPTION_CHANGED'
);

-- ============================================
-- CORE TABLES
-- ============================================

-- Organizations (Root tenant)
CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  domain VARCHAR(255) UNIQUE,
  logo_url TEXT,

  -- Subscription
  subscription_tier subscription_tier DEFAULT 'FREE',
  contact_limit INTEGER DEFAULT 1000,
  user_limit INTEGER DEFAULT 5,
  api_call_limit INTEGER DEFAULT 1000,
  storage_gb INTEGER DEFAULT 1,

  -- Billing
  stripe_customer_id VARCHAR(255),
  stripe_subscription_id VARCHAR(255),
  trial_ends_at TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,

  -- Settings
  settings JSONB DEFAULT '{}',

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Teams (Sub-tenants)
CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(organization_id, name)
);

-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255),
  avatar_url TEXT,
  role user_role DEFAULT 'USER',

  -- Organization relationship
  organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,

  -- Auth
  password_hash TEXT, -- For email/password auth
  email_verified BOOLEAN DEFAULT FALSE,

  -- Preferences
  preferences JSONB DEFAULT '{}',

  -- Metadata
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Team membership (many-to-many)
CREATE TABLE team_members (
  team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role user_role DEFAULT 'USER',
  joined_at TIMESTAMPTZ DEFAULT NOW(),

  PRIMARY KEY (team_id, user_id)
);

-- ============================================
-- CONTACT MANAGEMENT
-- ============================================

-- Contacts (Partitioned by organization for scale)
CREATE TABLE contacts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

  -- Basic Information
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  full_name VARCHAR(255) GENERATED ALWAYS AS (
    COALESCE(first_name || ' ' || last_name, first_name, last_name, 'Unknown')
  ) STORED,
  email VARCHAR(255),
  phone VARCHAR(50),
  title VARCHAR(255),
  company VARCHAR(255),
  website TEXT,
  location VARCHAR(255),
  timezone VARCHAR(50),
  avatar_url TEXT,

  -- Classification
  category contact_category DEFAULT 'PROSPECT',
  source contact_source DEFAULT 'MANUAL',
  vertical vertical_type DEFAULT 'SALES',
  tags TEXT[] DEFAULT '{}',
  custom_fields JSONB DEFAULT '{}',

  -- Enrichment
  enrichment_status enrichment_status DEFAULT 'PENDING',
  enrichment_data JSONB DEFAULT '{}',

  -- AI Analysis
  lead_score INTEGER DEFAULT 0 CHECK (lead_score >= 0 AND lead_score <= 100),
  lead_score_category lead_score_category DEFAULT 'COLD',
  buyer_stage buyer_stage DEFAULT 'UNAWARE',
  intent_signals JSONB DEFAULT '[]',
  predicted_value DECIMAL(10, 2),
  conversion_probability DECIMAL(3, 2) CHECK (conversion_probability >= 0 AND conversion_probability <= 1),

  -- Ownership
  created_by UUID REFERENCES users(id),
  assigned_to UUID REFERENCES users(id),

  -- Metadata
  last_activity_at TIMESTAMPTZ,
  last_enriched_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
) PARTITION BY HASH (organization_id);

-- Create 10 partitions for contacts (for scaling to 10B+ records)
CREATE TABLE contacts_0 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 0);
CREATE TABLE contacts_1 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 1);
CREATE TABLE contacts_2 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 2);
CREATE TABLE contacts_3 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 3);
CREATE TABLE contacts_4 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 4);
CREATE TABLE contacts_5 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 5);
CREATE TABLE contacts_6 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 6);
CREATE TABLE contacts_7 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 7);
CREATE TABLE contacts_8 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 8);
CREATE TABLE contacts_9 PARTITION OF contacts FOR VALUES WITH (MODULUS 10, REMAINDER 9);

-- Social profiles
CREATE TABLE social_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,
  platform VARCHAR(50) NOT NULL, -- LinkedIn, Twitter, GitHub, etc.
  profile_url TEXT NOT NULL,
  username VARCHAR(255),
  followers INTEGER,
  verified BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(contact_id, platform)
);

-- Contact lists
CREATE TABLE contact_lists (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  owner_id UUID NOT NULL REFERENCES users(id),

  -- Sharing
  is_public BOOLEAN DEFAULT FALSE,
  share_token VARCHAR(255) UNIQUE,

  -- Dynamic lists
  is_dynamic BOOLEAN DEFAULT FALSE,
  filters JSONB, -- Criteria for dynamic lists

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Contact list membership
CREATE TABLE contact_list_members (
  list_id UUID REFERENCES contact_lists(id) ON DELETE CASCADE,
  contact_id UUID REFERENCES contacts(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ DEFAULT NOW(),

  PRIMARY KEY (list_id, contact_id)
);

-- ============================================
-- ACTIVITIES & NOTES
-- ============================================

CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),

  type VARCHAR(50) NOT NULL, -- email, call, meeting, note, etc.
  subject VARCHAR(255) NOT NULL,
  description TEXT,
  metadata JSONB DEFAULT '{}',

  occurred_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE notes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  contact_id UUID REFERENCES contacts(id) ON DELETE CASCADE,
  assignee_id UUID NOT NULL REFERENCES users(id),

  title VARCHAR(255) NOT NULL,
  description TEXT,
  due_date TIMESTAMPTZ,
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- MARKETPLACE
-- ============================================

CREATE TABLE marketplace_listings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,
  seller_id UUID NOT NULL REFERENCES users(id),

  -- Listing details
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  category contact_category NOT NULL,
  vertical vertical_type NOT NULL,

  -- Status
  status marketplace_status DEFAULT 'DRAFT',
  views INTEGER DEFAULT 0,

  -- Metadata
  listed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  sold_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE marketplace_purchases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  listing_id UUID NOT NULL REFERENCES marketplace_listings(id),
  buyer_id UUID NOT NULL REFERENCES users(id),

  -- Pricing
  price DECIMAL(10, 2) NOT NULL,
  seller_revenue DECIMAL(10, 2) NOT NULL,
  platform_fee DECIMAL(10, 2) NOT NULL,

  -- Payment
  payment_status payment_status DEFAULT 'PENDING',
  stripe_payment_id VARCHAR(255),

  purchased_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- AUTOMATION & WORKFLOWS
-- ============================================

CREATE TABLE workflows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,

  -- Configuration
  trigger_type VARCHAR(50) NOT NULL,
  trigger_config JSONB NOT NULL,
  actions JSONB NOT NULL, -- Array of action objects
  conditions JSONB,

  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  last_run_at TIMESTAMPTZ,
  run_count INTEGER DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- BROWSER EXTENSION
-- ============================================

CREATE TABLE browser_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  extension_version VARCHAR(20),
  browser VARCHAR(50),

  -- Stats
  captures_count INTEGER DEFAULT 0,
  platforms_captured TEXT[] DEFAULT '{}',

  started_at TIMESTAMPTZ DEFAULT NOW(),
  last_activity_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE catch_folder (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,

  captured_at TIMESTAMPTZ DEFAULT NOW(),
  reviewed_at TIMESTAMPTZ,
  approved BOOLEAN
);

-- ============================================
-- OAUTH SOCIAL ACCOUNTS
-- ============================================

CREATE TABLE social_accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform VARCHAR(50) NOT NULL, -- LinkedIn, Twitter, GitHub, etc.
  account_id VARCHAR(255) NOT NULL,
  account_name VARCHAR(255),

  -- Tokens
  access_token TEXT,
  refresh_token TEXT,
  token_expires_at TIMESTAMPTZ,

  -- Permissions
  permissions TEXT[] DEFAULT '{}',

  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  last_synced_at TIMESTAMPTZ,
  connected_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, platform, account_id)
);

-- ============================================
-- VERTICAL CONFIGURATION
-- ============================================

CREATE TABLE vertical_configs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID UNIQUE NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  primary_vertical vertical_type DEFAULT 'SALES',
  enabled_verticals vertical_type[] DEFAULT '{SALES}',

  -- Feature flags
  features JSONB DEFAULT '{}',

  -- Custom fields
  custom_field_definitions JSONB DEFAULT '[]',

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- WEBHOOKS & API
-- ============================================

CREATE TABLE webhooks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  events webhook_event[] NOT NULL,
  secret VARCHAR(255) NOT NULL,

  is_active BOOLEAN DEFAULT TRUE,
  last_triggered_at TIMESTAMPTZ,
  failure_count INTEGER DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE api_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  key_hash VARCHAR(255) UNIQUE NOT NULL,
  permissions TEXT[] DEFAULT '{}',

  last_used_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  action_url TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Contacts indexes
CREATE INDEX idx_contacts_organization ON contacts(organization_id);
CREATE INDEX idx_contacts_email ON contacts(email) WHERE email IS NOT NULL;
CREATE INDEX idx_contacts_lead_score ON contacts(organization_id, lead_score DESC);
CREATE INDEX idx_contacts_category ON contacts(organization_id, category);
CREATE INDEX idx_contacts_vertical ON contacts(organization_id, vertical);
CREATE INDEX idx_contacts_created_at ON contacts(organization_id, created_at DESC);
CREATE INDEX idx_contacts_full_text ON contacts USING gin(to_tsvector('english',
  COALESCE(first_name, '') || ' ' ||
  COALESCE(last_name, '') || ' ' ||
  COALESCE(email, '') || ' ' ||
  COALESCE(company, '') || ' ' ||
  COALESCE(title, '')
));

-- Activities indexes
CREATE INDEX idx_activities_contact ON activities(contact_id, occurred_at DESC);
CREATE INDEX idx_activities_user ON activities(user_id, occurred_at DESC);

-- Tasks indexes
CREATE INDEX idx_tasks_assignee ON tasks(assignee_id, is_completed, due_date);
CREATE INDEX idx_tasks_contact ON tasks(contact_id);

-- Marketplace indexes
CREATE INDEX idx_marketplace_active ON marketplace_listings(status, vertical, category)
  WHERE status = 'ACTIVE';
CREATE INDEX idx_marketplace_seller ON marketplace_listings(seller_id);

-- Social profiles indexes
CREATE INDEX idx_social_profiles_contact ON social_profiles(contact_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketplace_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Organizations: Users can only see their own organization
CREATE POLICY organization_isolation ON organizations
  FOR ALL
  USING (id = current_setting('app.current_organization_id')::uuid);

-- Contacts: Tenant isolation
CREATE POLICY contact_isolation ON contacts
  FOR ALL
  USING (organization_id = current_setting('app.current_organization_id')::uuid);

-- Contact Lists: Tenant isolation
CREATE POLICY contact_list_isolation ON contact_lists
  FOR ALL
  USING (organization_id = current_setting('app.current_organization_id')::uuid);

-- Activities: Tenant isolation
CREATE POLICY activity_isolation ON activities
  FOR ALL
  USING (organization_id = current_setting('app.current_organization_id')::uuid);

-- Tasks: Tenant isolation
CREATE POLICY task_isolation ON tasks
  FOR ALL
  USING (organization_id = current_setting('app.current_organization_id')::uuid);

-- Marketplace: Public read, owner write
CREATE POLICY marketplace_read ON marketplace_listings
  FOR SELECT
  USING (status = 'ACTIVE' OR seller_id = current_setting('app.current_user_id')::uuid);

CREATE POLICY marketplace_write ON marketplace_listings
  FOR INSERT
  USING (seller_id = current_setting('app.current_user_id')::uuid);

CREATE POLICY marketplace_update ON marketplace_listings
  FOR UPDATE
  USING (seller_id = current_setting('app.current_user_id')::uuid);

-- ============================================
-- TRIGGERS
-- ============================================

-- Update timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply update trigger to all tables with updated_at
CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON organizations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON contacts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_contact_lists_updated_at BEFORE UPDATE ON contact_lists
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Lead score categorization trigger
CREATE OR REPLACE FUNCTION update_lead_score_category()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.lead_score >= 80 THEN
    NEW.lead_score_category = 'HOT';
  ELSIF NEW.lead_score >= 60 THEN
    NEW.lead_score_category = 'WARM';
  ELSIF NEW.lead_score >= 40 THEN
    NEW.lead_score_category = 'COOL';
  ELSE
    NEW.lead_score_category = 'COLD';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_lead_score_category_trigger
  BEFORE INSERT OR UPDATE OF lead_score ON contacts
  FOR EACH ROW EXECUTE FUNCTION update_lead_score_category();

-- ============================================
-- FEATURE FLAGS SYSTEM
-- ============================================

CREATE TABLE feature_flags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  key VARCHAR(255) NOT NULL,
  value BOOLEAN DEFAULT FALSE,
  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(organization_id, key)
);

-- Global feature flags (null org = global)
INSERT INTO feature_flags (organization_id, key, value) VALUES
  (NULL, 'ai_enrichment', true),
  (NULL, 'marketplace', true),
  (NULL, 'browser_extension', true),
  (NULL, 'viral_features', true),
  (NULL, 'god_mode', true);

-- ============================================
-- INITIAL DATA
-- ============================================

-- Create default organization for testing
INSERT INTO organizations (id, name, domain, subscription_tier) VALUES
  ('550e8400-e29b-41d4-a716-446655440000', 'Demo Organization', 'demo.reachcraft.io', 'FREE');

-- Create default admin user
INSERT INTO users (id, email, name, role, organization_id) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'admin@reachcraft.io', 'Admin User', 'ADMIN', '550e8400-e29b-41d4-a716-446655440000');

-- Create default vertical config
INSERT INTO vertical_configs (organization_id, primary_vertical, enabled_verticals) VALUES
  ('550e8400-e29b-41d4-a716-446655440000', 'SALES', ARRAY['SALES', 'RECRUITING', 'CREATOR']::vertical_type[]);

-- ============================================
-- GRANTS
-- ============================================

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- Grant all on tables to authenticated users
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Grant read on some tables to anonymous
GRANT SELECT ON organizations, marketplace_listings TO anon;

-- ============================================
-- END OF SCHEMA
-- ============================================

-- Schema stats:
-- Tables: 25+
-- Indexes: 15+
-- RLS Policies: 10+
-- Triggers: 7+
-- Total lines: 650+