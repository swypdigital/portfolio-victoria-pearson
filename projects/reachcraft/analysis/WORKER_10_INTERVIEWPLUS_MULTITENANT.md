# WORKER 10: InterviewPlus Multi-Tenant Architecture Analysis
**Target**: InterviewPlus Production System  
**Focus**: Multi-tenant isolation, RLS policies, God dashboard, Tenant management  
**Date**: 2025-12-16  
**Status**: COMPLETE

---

## EXECUTIVE SUMMARY

InterviewPlus implements a **comprehensive 5-tier role hierarchy** with **database-level tenant isolation** using PostgreSQL Row Level Security (RLS). The system supports both the main platform and white-label deployments with complete data segregation and god mode capabilities for Victoria.

### Key Findings:
- ✅ **5-Tier Role Hierarchy**: superadmin → whitelabel_superadmin → admin → whitelabel_admin → end_user
- ✅ **Complete RLS Enforcement**: All tables have tenant isolation at database level
- ✅ **God Mode Implementation**: Platform superadmin has cross-tenant access
- ✅ **White Label Ready**: Full branding customization and pricing controls
- ✅ **Audit Trail**: All admin actions logged with deployment context
- ✅ **TypeScript Middleware**: Automatic tenant_id injection and quota enforcement

---

## 1. MULTI-TENANT DATABASE SCHEMA

### 1.1 Core Tables

#### `deployments` - Tracks All Platform Instances
```sql
CREATE TABLE public.deployments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deployment_type TEXT NOT NULL CHECK (deployment_type IN ('main', 'whitelabel')),
  deployment_name TEXT NOT NULL,
  domain TEXT UNIQUE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Single source of truth for all deployments (main platform + white labels)

#### `user_roles` - 5-Tier Role Hierarchy
```sql
CREATE TABLE public.user_roles (
  user_id UUID REFERENCES auth.users(id) PRIMARY KEY,
  role TEXT NOT NULL CHECK (role IN (
    'superadmin',           -- Platform owner (god mode) - Victoria
    'whitelabel_superadmin', -- White label owner (limited god mode)
    'admin',                 -- Main platform admin
    'whitelabel_admin',      -- White label admin
    'end_user'               -- Regular job seekers
  )),
  deployment_id UUID REFERENCES public.deployments(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraint: superadmin has no deployment, others must have deployment
  CONSTRAINT valid_deployment_for_role CHECK (
    (role = 'superadmin' AND deployment_id IS NULL) OR
    (role != 'superadmin' AND deployment_id IS NOT NULL)
  )
);
```

**Key Features**:
- Superadmin (Victoria) has `deployment_id = NULL` (god mode across all deployments)
- All other roles tied to specific deployment
- Database-enforced role hierarchy

#### `whitelabel_config` - Per-Deployment Configuration
```sql
CREATE TABLE public.whitelabel_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deployment_id UUID REFERENCES public.deployments(id) NOT NULL UNIQUE,
  
  -- Pricing Controls (White Label Superadmin can modify)
  base_interview_price DECIMAL(10,2) DEFAULT 49.99,
  credit_package_pricing JSONB DEFAULT '{"100": 29.99, "500": 99.99, "1000": 149.99}'::jsonb,
  subscription_tiers JSONB DEFAULT '{"basic": 29.99, "pro": 79.99, "enterprise": 199.99}'::jsonb,
  
  -- Feature Controls
  enabled_features JSONB DEFAULT '{"ai_feedback": true, "video_interviews": true, "analytics": true}'::jsonb,
  custom_branding JSONB DEFAULT '{}'::jsonb,
  
  -- Limits
  max_users INTEGER DEFAULT 1000,
  max_interviews_per_month INTEGER DEFAULT 10000,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: White label owners can customize pricing, features, branding, and limits for their deployment

#### `admin_actions` - Audit Trail
```sql
CREATE TABLE public.admin_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES auth.users(id) NOT NULL,
  admin_role TEXT NOT NULL,
  deployment_id UUID REFERENCES public.deployments(id),
  action_type TEXT NOT NULL,
  target_user_id UUID REFERENCES auth.users(id),
  details JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_admin_actions_admin_id ON public.admin_actions(admin_id);
CREATE INDEX idx_admin_actions_deployment_id ON public.admin_actions(deployment_id);
CREATE INDEX idx_admin_actions_created_at ON public.admin_actions(created_at DESC);
```

**Purpose**: Complete audit trail of all admin actions across all deployments

---

## 2. ROW LEVEL SECURITY (RLS) POLICIES

### 2.1 Helper Functions

```sql
-- Check if user is platform superadmin (GOD MODE)
CREATE OR REPLACE FUNCTION public.is_superadmin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid() AND role = 'superadmin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- Check if user is white label superadmin
CREATE OR REPLACE FUNCTION public.is_whitelabel_superadmin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid() AND role = 'whitelabel_superadmin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- Get user's deployment ID
CREATE OR REPLACE FUNCTION public.get_user_deployment_id()
RETURNS UUID AS $$
BEGIN
  RETURN (
    SELECT deployment_id FROM public.user_roles WHERE user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- Check if user can access deployment
CREATE OR REPLACE FUNCTION public.can_access_deployment(target_deployment_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  -- Superadmin can access all deployments (GOD MODE)
  IF public.is_superadmin() THEN
    RETURN true;
  END IF;
  
  -- Others can only access their own deployment
  RETURN target_deployment_id = public.get_user_deployment_id();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;
```

### 2.2 RLS Policy Examples

#### Deployments Table Policies
```sql
-- SUPERADMIN: Full access to all deployments (GOD MODE)
CREATE POLICY "superadmin_full_access_deployments"
ON public.deployments FOR ALL TO authenticated
USING (public.is_superadmin())
WITH CHECK (public.is_superadmin());

-- WHITE LABEL SUPERADMIN: Read own deployment only
CREATE POLICY "whitelabel_superadmin_read_own_deployment"
ON public.deployments FOR SELECT TO authenticated
USING (
  public.is_whitelabel_superadmin() AND id = public.get_user_deployment_id()
);

-- ALL USERS: Can read their own deployment info
CREATE POLICY "users_read_own_deployment"
ON public.deployments FOR SELECT TO authenticated
USING (id = public.get_user_deployment_id());
```

#### User Roles Table Policies
```sql
-- SUPERADMIN: Manage all roles (GOD MODE)
CREATE POLICY "superadmin_manage_all_roles"
ON public.user_roles FOR ALL TO authenticated
USING (public.is_superadmin())
WITH CHECK (public.is_superadmin());

-- WHITE LABEL SUPERADMIN: Manage roles in their deployment
CREATE POLICY "whitelabel_superadmin_manage_own_deployment_roles"
ON public.user_roles FOR ALL TO authenticated
USING (
  public.is_whitelabel_superadmin() AND deployment_id = public.get_user_deployment_id()
)
WITH CHECK (
  public.is_whitelabel_superadmin() AND deployment_id = public.get_user_deployment_id()
);

-- ALL USERS: Read own role
CREATE POLICY "users_read_own_role"
ON public.user_roles FOR SELECT TO authenticated
USING (user_id = auth.uid());
```

#### White Label Config Policies
```sql
-- SUPERADMIN: Full access to all configs (GOD MODE)
CREATE POLICY "superadmin_full_access_wl_config"
ON public.whitelabel_config FOR ALL TO authenticated
USING (public.is_superadmin())
WITH CHECK (public.is_superadmin());

-- WHITE LABEL SUPERADMIN: Full access to their config
CREATE POLICY "whitelabel_superadmin_manage_own_config"
ON public.whitelabel_config FOR ALL TO authenticated
USING (
  public.is_whitelabel_superadmin() AND deployment_id = public.get_user_deployment_id()
)
WITH CHECK (
  public.is_whitelabel_superadmin() AND deployment_id = public.get_user_deployment_id()
);
```

#### Admin Actions Audit Policies
```sql
-- SUPERADMIN: Read all audit logs (GOD MODE)
CREATE POLICY "superadmin_read_all_audit"
ON public.admin_actions FOR SELECT TO authenticated
USING (public.is_superadmin());

-- WHITE LABEL SUPERADMIN: Read audit logs for their deployment
CREATE POLICY "whitelabel_superadmin_read_own_audit"
ON public.admin_actions FOR SELECT TO authenticated
USING (
  public.is_whitelabel_superadmin() AND deployment_id = public.get_user_deployment_id()
);
```

---

## 3. TYPESCRIPT TENANT ISOLATION MIDDLEWARE

### 3.1 Tenant Context Management

```typescript
interface TenantContext {
  tenant_id: string;
  user_id: string;
  organization_name: string;
  subscription_tier: string;
  resource_quotas: {
    max_concurrent_generations: number;
    max_monthly_documents: number;
    rate_limit_per_minute: number;
  };
  feature_flags: Record<string, boolean>;
}

class TenantIsolationMiddleware {
  private tenantCache: Map<string, TenantConfig> = new Map();
  private rateLimitMap: Map<string, RateLimitEntry> = new Map();
  
  // Get tenant context for a user
  async getTenantContext(userId: string): Promise<TenantContext | null> {
    // Get user's organization
    const { data: user } = await supabase
      .from('users')
      .select('organization_id')
      .eq('id', userId)
      .single();
    
    // Get tenant configuration (with caching)
    const tenantConfig = await this.getTenantConfig(user.organization_id);
    
    return {
      tenant_id: tenantConfig.tenant_id,
      user_id: userId,
      organization_name: tenantConfig.organization_name,
      subscription_tier: tenantConfig.subscription_tier,
      resource_quotas: tenantConfig.resource_quotas,
      feature_flags: tenantConfig.feature_flags
    };
  }
}
```

### 3.2 Resource Quota Enforcement

```typescript
// Enforce rate limiting per tenant
async checkRateLimit(tenantId: string, context: TenantContext): Promise<{
  allowed: boolean;
  resetIn?: number;
  remaining?: number;
}> {
  const now = Date.now();
  const key = `tenant_${tenantId}`;
  const limit = context.resource_quotas.rate_limit_per_minute;
  
  let entry = this.rateLimitMap.get(key);
  
  if (!entry || now >= entry.resetAt) {
    entry = {
      count: 0,
      resetAt: now + 60000 // 1 minute from now
    };
    this.rateLimitMap.set(key, entry);
  }
  
  if (entry.count >= limit) {
    return {
      allowed: false,
      resetIn: Math.ceil((entry.resetAt - now) / 1000),
      remaining: 0
    };
  }
  
  entry.count++;
  return { allowed: true, remaining: limit - entry.count };
}

// Check concurrent generation quota
async checkConcurrentGenerations(tenantId: string, context: TenantContext): Promise<{
  allowed: boolean;
  current: number;
  limit: number;
}> {
  const { count } = await supabase
    .from('generation_jobs')
    .select('*', { count: 'exact', head: true })
    .eq('tenant_id', tenantId)
    .in('status', ['queued', 'processing']);
  
  const current = count || 0;
  const limit = context.resource_quotas.max_concurrent_generations;
  
  return { allowed: current < limit, current, limit };
}

// Check monthly document quota
async checkMonthlyQuota(tenantId: string, context: TenantContext): Promise<{
  allowed: boolean;
  used: number;
  limit: number;
}> {
  const startOfMonth = new Date();
  startOfMonth.setDate(1);
  startOfMonth.setHours(0, 0, 0, 0);
  
  const { count } = await supabase
    .from('generation_jobs')
    .select('*', { count: 'exact', head: true })
    .eq('tenant_id', tenantId)
    .eq('status', 'completed')
    .gte('created_at', startOfMonth.toISOString());
  
  const used = count || 0;
  const limit = context.resource_quotas.max_monthly_documents;
  
  return { allowed: used < limit, used, limit };
}
```

---

## 4. GOD DASHBOARD IMPLEMENTATION

### 4.1 Current Admin Dashboard Features

**File**: `src/components/AdminDashboard.tsx`

```typescript
interface AdminDashboardProps {
  user: any; // Victoria's user object
}

const AdminDashboard: React.FC<AdminDashboardProps> = ({ user }) => {
  const [activeTab, setActiveTab] = useState<'overview' | 'discounts'>('overview');
  const [securityMetrics, setSecurityMetrics] = useState<SecurityMetrics>({
    total_scans: 1247,
    safe_urls: 1189,
    suspicious_urls: 52,
    malicious_urls: 6,
    recent_threats: [...]
  });
  
  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      {/* Tab Navigation: Overview | Discount Codes */}
      
      {/* Overview Tab: */}
      {/* - User Management */}
      {/* - Security Monitoring (URL Security Scanner) */}
      {/* - System Settings */}
      {/* - Analytics Dashboard */}
      {/* - Import Success Rates (LinkedIn, GitHub, Portfolio, Blog) */}
      
      {/* Discount Codes Tab: */}
      {/* - Stripe Discount Manager */}
    </div>
  );
};
```

### 4.2 God Dashboard Enhancement Plan

**File**: `docs/plans/PHASE_4_GOD_DASHBOARD_IMPLEMENTATION_START.md`

```markdown
# Phase 4: God Dashboard Implementation

## What We're Building

God Dashboard = AI Provider Configuration + Cost Tracking + Feature Flags

This is the foundation layer that all other features depend on.

## Files to Create:

1. AIProviderRegistry Service (src/services/AIProviderRegistry.ts)
   - Single source of truth for ALL AI provider calls
   
2. AI Generator Config Panel (src/components/admin/AIGeneratorConfigPanel.tsx)
   - UI for Victoria to configure providers
   
3. Cost Tracking Service (src/services/CostTrackingService.ts)
   - Track AI usage and costs
   
4. Feature Flag Service (src/services/FeatureFlagService.ts)
   - Enable/disable features per tier
   
5. Database Migrations (supabase/migrations/20251209_god_dashboard.sql)
   - Tables for providers, costs, flags
```

### 4.3 White Label Branding System

**File**: `BRANDING_CUSTOMIZATION_SPECIFICATION.md`

**Comprehensive branding customization for white label deployments**:

#### Color Theme Customization
- Primary/Secondary/Accent colors with auto-generated scales
- Semantic colors (success, warning, error, info)
- Dark mode support with separate palette
- WCAG contrast validation (AA/AAA compliance)

#### Logo & Visual Assets
- Primary logo upload (PNG, SVG, JPG, WEBP)
- Light/dark mode variants
- Favicon auto-generation
- Login page background image
- Email header logo
- Social share image (og:image)

#### Typography Controls
- Google Fonts integration (1000+ fonts)
- Custom font upload (.woff, .woff2, .ttf)
- Heading/Body/Monospace font families
- Font sizing scales (Compact, Default, Large, Custom)
- Line height and letter spacing controls

#### Custom CSS Injection
- Monaco Editor (VS Code-style)
- Syntax highlighting and linting
- Security validation (whitelist approach)
- Blocked: external URLs, position: fixed, z-index manipulation
- CSP enforcement

#### Layout & Spacing
- Component spacing controls (padding, margin, gap)
- Border radius presets (Sharp, Subtle, Moderate, Rounded, Pill)
- Shadow presets (None, Subtle, Moderate, Strong, Custom)

#### Database Schema
```json
{
  "whitelabel_config": {
    "custom_branding": {
      "colors": { "primary": {...}, "secondary": {...}, "darkMode": {...} },
      "logo": { "primary": {...}, "darkMode": {...}, "favicon": {...} },
      "typography": { "heading": {...}, "body": {...}, "monospace": {...} },
      "layout": { "borderRadius": "0.5rem", "spacing": "default", "shadows": "moderate" },
      "components": { "button": {...}, "input": {...}, "navigation": {...} },
      "animations": { "speed": "normal", "pageTransition": "fade", "hoverEffect": "lift" },
      "customCSS": "/* User-defined CSS */",
      "accessibility": { "enforceContrast": true, "minimumFontSize": "14px", "rtlSupport": false },
      "domain": { "custom": "interviews.acme.com", "verified": true, "sslEnabled": true }
    }
  }
}
```

---

## 5. REACHCRAFT APPLICATION

### 5.1 Tenant Management for Victoria (God Mode)

**Key Features to Extract**:

1. **Cross-Tenant User Management**
   - View all users across all deployments
   - Assign/modify roles (5-tier hierarchy)
   - Impersonate users for support
   - Audit trail of all admin actions

2. **Deployment Management**
   - Create/edit/delete deployments
   - Toggle deployment active status
   - View deployment metrics (users, interviews, revenue)
   - Manage white label configs

3. **White Label Config Dashboard**
   - Set pricing per deployment
   - Configure feature flags per deployment
   - Set resource limits (max users, max interviews)
   - Apply branding presets

4. **System-Wide Analytics**
   - Revenue across all deployments
   - User growth trends
   - Interview completion rates
   - AI usage and costs

5. **Security Monitoring**
   - URL security scanner (malicious link detection)
   - Audit log viewer (all admin actions)
   - Failed login attempts
   - Suspicious activity alerts

### 5.2 White Label Superadmin Dashboard

**Key Features to Extract**:

1. **Own Deployment Management**
   - View deployment info (domain, users, limits)
   - Manage users within own deployment
   - Cannot access other deployments

2. **Pricing & Feature Control**
   - Customize base interview price
   - Set credit package pricing
   - Configure subscription tiers
   - Enable/disable features

3. **Branding Customization**
   - Upload logo (light/dark mode)
   - Customize color scheme
   - Set typography
   - Inject custom CSS (validated)

4. **User Management (Own Deployment)**
   - View/edit users in own deployment
   - Assign roles (whitelabel_admin, end_user)
   - Cannot create superadmins

5. **Deployment Analytics**
   - User count and growth
   - Interview completion stats
   - Revenue (own deployment only)
   - Feature usage

### 5.3 Admin Dashboard (Main Platform)

**Key Features**:

1. **User Management (Main Platform)**
   - View/edit users on main platform
   - Assign roles (admin, end_user)
   - Cannot manage white label deployments

2. **Security Monitoring**
   - URL security scanner
   - Threat detection
   - Audit log viewer (main platform only)

3. **Discount Code Management**
   - Create Stripe discount codes
   - Manage coupons
   - View redemption stats

---

## 6. REACHCRAFT INTEGRATION PATTERNS

### 6.1 Database Schema Patterns

**For ReachCraft, implement**:

```sql
-- Deployments table (ReachCraft instances)
CREATE TABLE public.reachcraft_deployments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deployment_type TEXT NOT NULL CHECK (deployment_type IN ('main', 'whitelabel')),
  deployment_name TEXT NOT NULL, -- "groklyGroup Main", "Acme Corp Instance"
  domain TEXT UNIQUE, -- "reachcraft.app", "outreach.acme.com"
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User roles (5-tier hierarchy)
CREATE TABLE public.reachcraft_user_roles (
  user_id UUID REFERENCES auth.users(id) PRIMARY KEY,
  role TEXT NOT NULL CHECK (role IN (
    'superadmin',           -- Victoria (god mode)
    'whitelabel_superadmin', -- White label owner
    'admin',                 -- Platform admin
    'whitelabel_admin',      -- White label admin
    'end_user'               -- Regular users
  )),
  deployment_id UUID REFERENCES public.reachcraft_deployments(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  CONSTRAINT valid_deployment_for_role CHECK (
    (role = 'superadmin' AND deployment_id IS NULL) OR
    (role != 'superadmin' AND deployment_id IS NOT NULL)
  )
);

-- White label config (pricing, branding, limits)
CREATE TABLE public.reachcraft_whitelabel_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deployment_id UUID REFERENCES public.reachcraft_deployments(id) NOT NULL UNIQUE,
  
  -- Pricing Controls
  base_contact_price DECIMAL(10,2) DEFAULT 0.50, -- Per contact found
  enrichment_price DECIMAL(10,2) DEFAULT 0.25,   -- Per enrichment
  credit_package_pricing JSONB DEFAULT '{"1000": 99.99, "5000": 399.99}'::jsonb,
  
  -- Feature Controls
  enabled_features JSONB DEFAULT '{
    "email_finder": true,
    "phone_finder": true, 
    "social_enrichment": true,
    "ai_personalization": true,
    "campaign_automation": true
  }'::jsonb,
  
  -- Branding
  custom_branding JSONB DEFAULT '{}'::jsonb,
  
  -- Limits
  max_users INTEGER DEFAULT 100,
  max_contacts_per_month INTEGER DEFAULT 10000,
  max_campaigns_per_month INTEGER DEFAULT 50,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Admin actions audit
CREATE TABLE public.reachcraft_admin_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES auth.users(id) NOT NULL,
  admin_role TEXT NOT NULL,
  deployment_id UUID REFERENCES public.reachcraft_deployments(id),
  action_type TEXT NOT NULL, -- 'create_user', 'update_pricing', 'change_limits', etc.
  target_user_id UUID REFERENCES auth.users(id),
  details JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 6.2 RLS Policy Patterns

**Apply same patterns**:

```sql
-- Helper functions (identical pattern)
CREATE OR REPLACE FUNCTION public.reachcraft_is_superadmin() ...
CREATE OR REPLACE FUNCTION public.reachcraft_is_whitelabel_superadmin() ...
CREATE OR REPLACE FUNCTION public.reachcraft_get_user_deployment_id() ...

-- RLS policies (identical pattern)
CREATE POLICY "superadmin_full_access" ON public.reachcraft_deployments ...
CREATE POLICY "whitelabel_superadmin_read_own" ON public.reachcraft_deployments ...
```

### 6.3 God Dashboard UI Patterns

**For Victoria's ReachCraft God Dashboard**:

```typescript
// src/components/admin/ReachCraftGodDashboard.tsx
interface GodDashboardProps {
  user: { id: string; role: 'superadmin' }; // Victoria only
}

const ReachCraftGodDashboard: React.FC<GodDashboardProps> = ({ user }) => {
  const [activeTab, setActiveTab] = useState<'deployments' | 'users' | 'analytics' | 'security'>('deployments');
  
  return (
    <div className="max-w-7xl mx-auto">
      {/* Tabs: Deployments | Users | Analytics | Security | Settings */}
      
      {/* Deployments Tab: */}
      {/* - List all deployments (main + white labels) */}
      {/* - Create new deployment */}
      {/* - Edit deployment config (pricing, features, limits) */}
      {/* - View deployment metrics */}
      
      {/* Users Tab: */}
      {/* - List all users across all deployments */}
      {/* - Filter by deployment */}
      {/* - Change user roles */}
      {/* - Impersonate user */}
      
      {/* Analytics Tab: */}
      {/* - Revenue across all deployments */}
      {/* - User growth trends */}
      {/* - Contact finding success rates */}
      {/* - AI personalization usage */}
      
      {/* Security Tab: */}
      {/* - Audit log viewer */}
      {/* - Failed login attempts */}
      {/* - API key usage */}
    </div>
  );
};
```

**For White Label Superadmin Dashboard**:

```typescript
// src/components/admin/WhiteLabelDashboard.tsx
interface WhiteLabelDashboardProps {
  user: { id: string; role: 'whitelabel_superadmin'; deployment_id: string };
}

const WhiteLabelDashboard: React.FC<WhiteLabelDashboardProps> = ({ user }) => {
  const [activeTab, setActiveTab] = useState<'users' | 'pricing' | 'branding' | 'analytics'>('users');
  
  return (
    <div className="max-w-7xl mx-auto">
      {/* Tabs: Users | Pricing | Branding | Analytics | Settings */}
      
      {/* Users Tab: (own deployment only) */}
      {/* - List users in own deployment */}
      {/* - Add/edit/delete users */}
      {/* - Assign roles (whitelabel_admin, end_user) */}
      
      {/* Pricing Tab: */}
      {/* - Customize base prices */}
      {/* - Set credit package pricing */}
      {/* - Configure subscription tiers */}
      
      {/* Branding Tab: */}
      {/* - Upload logo */}
      {/* - Customize colors */}
      {/* - Set typography */}
      {/* - Inject custom CSS */}
      
      {/* Analytics Tab: (own deployment only) */}
      {/* - User count and growth */}
      {/* - Contact finding stats */}
      {/* - Revenue (own deployment) */}
    </div>
  );
};
```

---

## 7. KEY TAKEAWAYS FOR REACHCRAFT

### 7.1 Database Architecture
✅ **Use identical 4-table pattern**:
- `reachcraft_deployments` (main + white labels)
- `reachcraft_user_roles` (5-tier hierarchy)
- `reachcraft_whitelabel_config` (pricing, features, branding)
- `reachcraft_admin_actions` (audit trail)

### 7.2 RLS Enforcement
✅ **Apply same helper functions**:
- `is_superadmin()` - Victoria's god mode
- `is_whitelabel_superadmin()` - White label owner check
- `get_user_deployment_id()` - Get user's deployment
- `can_access_deployment()` - Cross-tenant access check

### 7.3 God Mode Features
✅ **Victoria needs**:
- View/manage all deployments
- View/manage all users (cross-tenant)
- Configure pricing/features per deployment
- System-wide analytics
- Complete audit log access

### 7.4 White Label Features
✅ **White label owners need**:
- Manage own deployment config
- Customize pricing (within limits set by Victoria)
- Full branding customization
- User management (own deployment only)
- Analytics (own deployment only)

### 7.5 Tenant Isolation
✅ **Critical security**:
- Database-level RLS enforcement (not app-level)
- All queries auto-filtered by `deployment_id`
- Helper functions use `SECURITY DEFINER` to prevent privilege escalation
- TypeScript middleware enforces quotas and rate limits

### 7.6 Audit Trail
✅ **Track everything**:
- All admin actions logged
- Include: admin_id, admin_role, deployment_id, action_type, target_user_id
- Superadmin sees all logs
- White label superadmin sees own deployment logs only

---

## 8. NEXT STEPS FOR REACHCRAFT

### Phase 1: Database Schema (Week 1)
1. Create `reachcraft_deployments` table
2. Create `reachcraft_user_roles` table
3. Create `reachcraft_whitelabel_config` table
4. Create `reachcraft_admin_actions` table
5. Create RLS helper functions
6. Apply RLS policies to all tables

### Phase 2: TypeScript Middleware (Week 2)
1. Create `TenantIsolationMiddleware` class
2. Implement tenant context caching
3. Add rate limiting per tenant
4. Add resource quota enforcement
5. Add feature flag checking

### Phase 3: God Dashboard (Week 3)
1. Build deployment management UI
2. Build cross-tenant user management
3. Build white label config editor
4. Build system-wide analytics
5. Build audit log viewer

### Phase 4: White Label Dashboard (Week 4)
1. Build white label superadmin UI
2. Build branding customization panel
3. Build pricing config UI
4. Build user management (own deployment)
5. Build deployment analytics

### Phase 5: Testing (Week 5)
1. Unit tests for RLS policies
2. Integration tests for tenant isolation
3. E2E tests for god dashboard
4. E2E tests for white label dashboard
5. Security audit (penetration testing)

---

## 9. SECURITY CONSIDERATIONS

### 9.1 RLS Policy Testing
```sql
-- Test superadmin god mode
SET request.jwt.claim.sub = 'victoria-user-id';
SELECT * FROM reachcraft_deployments; -- Should see all deployments

-- Test white label isolation
SET request.jwt.claim.sub = 'whitelabel-user-id';
SELECT * FROM reachcraft_deployments; -- Should see only own deployment

-- Test end user isolation
SET request.jwt.claim.sub = 'end-user-id';
SELECT * FROM reachcraft_deployments; -- Should see only own deployment
```

### 9.2 SQL Injection Prevention
- All helper functions use `SECURITY DEFINER`
- Search path restricted to `public, pg_temp`
- No dynamic SQL in helper functions
- All inputs validated at app layer

### 9.3 Privilege Escalation Prevention
- Role changes require god mode or white label superadmin
- White label superadmin cannot create superadmins
- End users cannot change their own roles
- All role changes logged in audit trail

---

## 10. FILES & LOCATIONS

### Database Migrations
- `/supabase/migrations/20251030122718_20251030130000_multi_tenant_core_tables.sql`
- `/supabase/migrations/20251030122759_20251030130002_multi_tenant_core_rls_policies.sql`
- `/supabase/migrations/20251030122734_20251030130001_multi_tenant_helper_functions.sql`
- `/supabase/migrations/20251030122848_20251030130003_add_deployment_id_to_user_tables.sql`

### TypeScript Services
- `/src/lib/security/tenant-isolation.ts` - Tenant isolation middleware
- `/src/lib/security/middleware.ts` - Security middleware

### UI Components
- `/src/components/AdminDashboard.tsx` - Current admin dashboard
- `/docs/plans/PHASE_4_GOD_DASHBOARD_IMPLEMENTATION_START.md` - God dashboard plan
- `/BRANDING_CUSTOMIZATION_SPECIFICATION.md` - White label branding spec

### Tests
- `/tests/multi-tenant-security.test.ts` - RLS policy tests
- `/tests/multi-tenant-validation.test.ts` - Tenant isolation tests

---

## CONCLUSION

InterviewPlus implements a **production-ready multi-tenant architecture** with:
- ✅ Database-level tenant isolation (RLS policies)
- ✅ 5-tier role hierarchy (superadmin → end_user)
- ✅ God mode for Victoria (cross-tenant access)
- ✅ White label support (pricing, branding, feature flags)
- ✅ Complete audit trail
- ✅ TypeScript middleware for quota enforcement

**ReachCraft should adopt this exact architecture**, replacing InterviewPlus-specific concepts with ReachCraft concepts (interviews → contacts, documents → campaigns, etc.).

The pattern is **proven, secure, and scalable** for multi-tenant SaaS platforms.

---

**Analysis Complete** | Worker 10/50 | 2025-12-16

---

## QUICK REFERENCE SUMMARY

### Multi-Tenant Schema (4 Core Tables)
1. **deployments** - Track main platform + white label instances
2. **user_roles** - 5-tier hierarchy (superadmin → whitelabel_superadmin → admin → whitelabel_admin → end_user)
3. **whitelabel_config** - Per-deployment pricing, features, branding, limits
4. **admin_actions** - Complete audit trail of admin actions

### RLS Helper Functions (4 Essential)
1. **is_superadmin()** - Check if Victoria (god mode)
2. **is_whitelabel_superadmin()** - Check if white label owner
3. **get_user_deployment_id()** - Get user's deployment
4. **can_access_deployment(uuid)** - Check cross-tenant access

### God Mode (Victoria)
- `deployment_id = NULL` in user_roles table
- Can access ALL deployments
- Can manage ALL users
- Can view ALL audit logs
- Can configure ALL white label configs

### White Label Superadmin
- `deployment_id = <specific uuid>` in user_roles table
- Can access ONLY own deployment
- Can manage users in own deployment
- Can view audit logs for own deployment
- Can configure own white label config (pricing, branding, features)

### Tenant Isolation Enforcement
- **Database Level**: RLS policies on all tables
- **Application Level**: TypeScript middleware for quotas/rate limits
- **API Level**: Helper functions validate access before queries
- **Audit Level**: All admin actions logged with deployment context

### ReachCraft Adaptation
Replace:
- `deployments` → `reachcraft_deployments`
- `user_roles` → `reachcraft_user_roles`
- `whitelabel_config` → `reachcraft_whitelabel_config`
- `admin_actions` → `reachcraft_admin_actions`

Customize:
- Pricing: interviews → contacts/campaigns
- Features: ai_feedback → email_finder, phone_finder, ai_personalization
- Limits: max_interviews → max_contacts_per_month, max_campaigns_per_month

Same patterns, different domain!

---

**WORKER 10 COMPLETE** ✅
