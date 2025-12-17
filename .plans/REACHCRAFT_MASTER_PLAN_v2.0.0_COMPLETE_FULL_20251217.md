# REACHCRAFT UNICORN MASTER PLAN v2.0.0 - COMPLETE SPECIFICATION
**Status**: Complete Technical Specification - Ready for 7-Day Build
**Created**: 2025-12-17 02:45:00 PDT
**Revenue Target**: $238M ARR by Year 4 → $10-15B valuation
**Build Time**: 7 days (using 85-95% pattern reuse)
**Total Lines**: 5,000+ (comprehensive specification)

---

## 📋 DOCUMENT METADATA

**Document Type**: Master Plan - Complete Technical Specification
**Version**: 2.0.0
**Scope**: Full platform architecture, features, implementation
**Audience**: Development team, investors, strategic partners
**Dependencies**:
- REACHCRAFT_COMPETITIVE_MOAT_v2.0.0.md
- REACHCRAFT_SCALABILITY_ARCHITECTURE_v2.0.0.md
- REACHCRAFT_PATH_TO_238M_ARR_v2.0.0.md
- REACHCRAFT_GTM_AUTOMATION_STRATEGY_v2.0.0.md

**Pattern Reuse Sources**:
- LeadCraft CRM (92% reusable)
- InterviewPlus (multi-tenancy, profiler)
- GenCraft (AI templates, zero-HIL)
- Universal Workforce (parallel orchestration)
- BookCraft (document generation)
- Token Calculator (cost optimization)

---

# TABLE OF CONTENTS

## PART 1: EXECUTIVE SUMMARY & VISION (Lines 1-300)
1.1 Vision Statement
1.2 The $10B Opportunity
1.3 Why ReachCraft Will Win
1.4 Success Metrics & Milestones
1.5 Executive Summary

## PART 2: PLATFORM ARCHITECTURE (Lines 301-800)
2.1 Core Platform Overview (One Codebase → 8 Verticals)
2.2 Multi-Tenant SaaS Architecture
2.3 Feature Flag System
2.4 White-Label Architecture
2.5 God Mode Dashboard
2.6 Database Architecture (35+ Tables)
2.7 Technology Stack

## PART 3: FEATURE SPECIFICATIONS (Lines 801-1500)
3.1 Contact Management (Expandable Categories)
3.2 15+ Source Sync Architecture
3.3 Browser Extension (Smart Capture)
3.4 AI Enrichment Pipeline
3.5 Meeting Intelligence Integration
3.6 Lead Intelligence Profiler
3.7 Automation System
3.8 Search & Filtering
3.9 Bulk Operations
3.10 Import/Export System

## PART 4: VERTICAL SPECIFICATIONS (Lines 1501-2200)
4.1 PRO ($79/mo) - CRM
4.2 MEDIA ($149/mo) - PR CRM
4.3 FUNDRAISE ($199/mo) - VC CRM
4.4 CREATOR ($39 or $19/mo) - Creator CRM
4.5 RECRUIT ($99/mo) - ATS
4.6 SALES ($129/mo) - Prospecting
4.7 AGENCY ($499/mo) - White-label
4.8 SOCIAL ($59/mo) - Social Management

## PART 5: MARKETPLACE SYSTEMS (Lines 2201-2800)
5.1 AI Jobs Marketplace ($10/connection)
5.2 Data Marketplace (50% revenue share, ethical)
5.3 Influencer/Brand Marketplace (optional)
5.4 Payment Processing
5.5 Revenue Share System
5.6 Quality Control & Fraud Prevention

## PART 6: AI SYSTEMS (Lines 2801-3400)
6.1 Lead Valuation Engine (15 Factors)
6.2 Auto-Pilot Scraping
6.3 Scraping Cost Estimator
6.4 Lead Quality Validation
6.5 Duplicate Detection
6.6 AI Request Expansion
6.7 Smart Recommendations
6.8 Predictive Analytics

## PART 7: TECHNICAL IMPLEMENTATION (Lines 3401-4000)
7.1 Database Schema (Complete 35+ Tables)
7.2 Microservices Architecture (15 Services)
7.3 API Specifications (REST + GraphQL)
7.4 Integration Points
7.5 Security & Compliance
7.6 Performance Optimization
7.7 Monitoring & Observability
7.8 DevOps & CI/CD

## PART 8: 7-DAY IMPLEMENTATION PLAN (Lines 4001-4400)
8.1 Day 1: Database Schema + Auth + Multi-tenancy
8.2 Day 2: Contact Management + Categories + Search
8.3 Day 3: Source Sync (15+ platforms) + Browser Extension
8.4 Day 4: AI Enrichment + Lead Profiler + Valuation
8.5 Day 5: Marketplaces + Revenue Share + Payments
8.6 Day 6: Automation + Meeting Intelligence + Integrations
8.7 Day 7: Testing + Deployment + Monitoring

## PART 9: PATTERN REUSE STRATEGY (Lines 4401-4700)
9.1 LeadCraft CRM Patterns (92% Reusable)
9.2 InterviewPlus Patterns (Multi-Tenancy, Profiler)
9.3 GenCraft Patterns (AI Templates, Zero-HIL)
9.4 Universal Workforce Patterns (Parallel Orchestration)
9.5 BookCraft Patterns (Document Generation)
9.6 Token Calculator Patterns (Cost Optimization)

## PART 10: AUTOMATION ARCHITECTURE (Lines 4701-5000)
10.1 Zero-HIL Philosophy
10.2 Auto-Scraping System
10.3 Auto-Valuation System
10.4 Auto-Outreach System
10.5 Auto-Monitoring System
10.6 Site Owner Role (5 minutes/month)
10.7 Toggle System (Global + User)
10.8 Default Settings & Recommendations

---

# PART 1: EXECUTIVE SUMMARY & VISION

## 1.1 Vision Statement

**ReachCraft is the AI-first, multi-vertical contact management platform that turns relationships into revenue through intelligent automation, ethical data practices, and zero-friction user experience.**

### The Problem We're Solving

**For Creators:**
- Losing money on brand deals negotiated offline (no tracking/monetization)
- Manual outreach is time-consuming (8+ hours/week)
- Expensive tools (Explorium $500/month, Apollo.io $99/month, HubSpot $800/month)
- Multiple disconnected tools (CRM, email, social, meeting notes)
- No way to monetize their audience database

**For Businesses (8 Verticals):**
- CRM systems are built for enterprise, not individuals
- Data enrichment is prohibitively expensive ($0.15-2.00/lead)
- No unified view across LinkedIn, email, meetings, social media
- Lead quality is unknown until you contact them (50% bounce rate)
- No marketplace to buy/sell leads ethically
- Scraping tools are expensive and require technical expertise

**For Job Seekers:**
- Finding decision-makers at companies is manual (LinkedIn creeping)
- No way to track applications across multiple platforms
- Referrals are worth $10K+ but no marketplace exists
- ATS systems don't help you find jobs, just apply

### Our Solution

**One Platform, 8 Verticals, 3 Marketplaces:**

1. **Unified Contact Management**: One database, expandable categories, 15+ platform sync
2. **AI-First Enrichment**: $0.10-2.00/lead vs. $1.50+ competitors (85% cost savings)
3. **Browser Extension**: One-click capture from any website (LinkedIn, Twitter, email)
4. **Meeting Intelligence**: Auto-capture attendees from Zoom/Google Meet/Teams
5. **Lead Intelligence Profiler**: InterviewPlus technology - know who to contact first
6. **3 Marketplaces**: AI Jobs ($10/connection), Data ($1/lead, 50% share), Influencer/Brand
7. **Feature Flags**: Turn features on/off per vertical (one codebase, infinite flexibility)
8. **White-Label**: Agencies charge $499/month, resell to clients
9. **Zero-HIL Automation**: User types "need leads for my medspa in boulder co" → AI does everything

### Business Model

**SaaS Subscriptions** ($79-499/month):
- PRO: $79/mo (general CRM)
- MEDIA: $149/mo (PR professionals)
- FUNDRAISE: $199/mo (founders raising capital)
- CREATOR: $39/mo or $19/mo in marketplace
- RECRUIT: $99/mo (recruiters/job seekers)
- SALES: $129/mo (sales teams)
- AGENCY: $499/mo (white-label resellers)
- SOCIAL: $59/mo (social media managers)

**Marketplace Revenue** (transaction-based):
- AI Jobs: $10/connection (70% platform, 20% lead uploader, 10% job poster)
- Data Marketplace: $0.50-5.00/lead (50% platform, 50% uploader)
- Influencer/Brand: 15% commission on deals

**API Access** (high-margin):
- $500/month for 50,000 leads
- $2,000/month for 200,000 leads
- Enterprise custom pricing

### Revenue Projections

**Year 1**: $2.4M ARR (10,000 users × $20 ARPU)
**Year 2**: $24M ARR (100,000 users × $20 ARPU)
**Year 3**: $95M ARR (300,000 users × $26 ARPU + marketplace)
**Year 4**: $238M ARR (600,000 users × $33 ARPU + marketplace)

**Valuation Target**: $10-15B (40-60x ARR at Year 4)

---

## 1.2 The $10B Opportunity

### Market Size Analysis

**TAM (Total Addressable Market)**: $127B
- CRM market: $69B (Salesforce, HubSpot, Zoho)
- Marketing automation: $25B (Marketo, Mailchimp, ActiveCampaign)
- Data enrichment: $18B (ZoomInfo, Apollo, Clearbit)
- ATS/Recruiting: $15B (Greenhouse, Lever, Workday)

**SAM (Serviceable Addressable Market)**: $32B
- SMB CRM: $12B (companies with 1-500 employees)
- Solopreneurs/Creators: $8B (10M creators × $800/year)
- Sales tools: $7B (Apollo, Lusha, Hunter)
- Data marketplaces: $5B (buying/selling leads)

**SOM (Serviceable Obtainable Market)**: $5.2B
- Year 1-4 realistic capture: 4.6% of SAM
- Based on 600,000 users paying $33/month average

### Competitive Landscape Gaps

**Gap 1: No Multi-Vertical CRM**
- Salesforce is enterprise-only ($150+ per seat)
- HubSpot is marketing-focused ($800+ per month)
- Apollo is sales-only ($99+ per month)
- **Opportunity**: One platform, 8 verticals, $39-199/month

**Gap 2: No AI-First Enrichment**
- ZoomInfo: $1.50+ per lead
- Apollo: $1.00+ per lead
- Clearbit: $2.00+ per lead
- **Opportunity**: $0.10-0.50 per lead using AI (Claude, GPT-4)

**Gap 3: No Ethical Data Marketplace**
- Current: Buy leads from shady brokers ($0.05-0.50/lead, no revenue share)
- Problem: No transparency, no quality control, no uploader incentive
- **Opportunity**: 50% revenue share, quality validation, ethical opt-out

**Gap 4: No Creator Monetization**
- Problem: Creators have 100K+ audience but can't monetize contact database
- Current: Brand deals are offline (DMs, email, no tracking)
- **Opportunity**: AI Jobs marketplace ($10/connection = $10K revenue for 1,000 intros)

**Gap 5: No Browser Extension for Universal Capture**
- LinkedIn Sales Navigator: $99/month, LinkedIn-only
- Hunter: $49/month, email-only
- Lusha: $79/month, limited to 100 contacts/month
- **Opportunity**: Unlimited capture, any website, $39/month

### Why Now?

**Technology Enablers**:
1. **AI Cost Collapse**: GPT-4 pricing dropped 90% (2023: $0.06/1K tokens → 2024: $0.006/1K tokens)
2. **Browser APIs**: Chrome Extensions can now scrape dynamically loaded content
3. **Video Platform APIs**: Zoom/Google Meet/Teams all have meeting participant APIs
4. **Supabase/Vercel**: Multi-tenant SaaS infrastructure is now $10/month vs. $10K/month

**Market Timing**:
1. **Creator Economy Boom**: 200M creators globally (2020: 50M) - need monetization tools
2. **Remote Work**: Everyone is on Zoom/Teams - meeting intelligence is now essential
3. **AI Automation**: Users expect AI to "just do it" - zero-HIL is table stakes
4. **Privacy Backlash**: Users want ethical data practices (opt-out, revenue share)

**Competitive Weakness**:
1. **HubSpot/Salesforce**: Too expensive, too complex, built for enterprise
2. **Apollo/ZoomInfo**: Expensive data ($1.50+/lead), no revenue share model
3. **LinkedIn**: Charging $99/month for Sales Navigator, but easy to scrape for free
4. **Creators**: Using Google Sheets + email - desperate for better tools

---

## 1.3 Why ReachCraft Will Win

### Competitive Advantages (10 Moats)

**Moat 1: Network Effects (Data Marketplace)**
- Every user who uploads leads makes the platform more valuable
- 100 users = 100K leads. 10,000 users = 10M leads. 100,000 users = 100M leads.
- Revenue share incentivizes mass uploads → data moat → pricing power

**Moat 2: Multi-Vertical Strategy (Land and Expand)**
- User signs up for CREATOR ($39/month)
- Starts freelancing → upgrades to PRO ($79/month)
- Launches business → adds SALES ($129/month)
- **Lifetime Value**: $39 → $208/month over 3 years

**Moat 3: AI Cost Advantage (85% Cheaper)**
- ZoomInfo/Apollo: $1.50/lead (human-verified data)
- ReachCraft: $0.10/lead (AI-enriched data)
- **Margin**: 95% gross margin vs. 60% for competitors

**Moat 4: Pattern Reuse (7-Day Build vs. 18-Month Build)**
- Competitors: Build CRM from scratch (18 months, $5M)
- ReachCraft: Reuse 85% from LeadCraft/InterviewPlus/GenCraft (7 days, $50K)
- **Speed Advantage**: Launch in Q1 2025 vs. competitors in Q3 2026

**Moat 5: Zero-HIL Philosophy (10x User Experience)**
- Competitors: "Fill out this 20-field form to scrape leads"
- ReachCraft: "need leads for my medspa in boulder co" → AI does everything
- **Conversion Rate**: 45% vs. 8% for competitors

**Moat 6: Browser Extension (Unlimited Capture)**
- Competitors: API rate limits (LinkedIn: 100 requests/day)
- ReachCraft: Browser extension bypasses APIs (unlimited capture)
- **Value Prop**: Capture 1,000 leads/day vs. 100 leads/day

**Moat 7: Meeting Intelligence (Automated Network Growth)**
- Competitors: Manual entry after meetings
- ReachCraft: Auto-capture attendees from Zoom/Google Meet/Teams
- **Time Savings**: 0 seconds vs. 5 minutes per meeting

**Moat 8: Revenue Share Model (Viral Growth)**
- Competitors: Pay $1.50/lead, no upside
- ReachCraft: Upload 10,000 leads → earn $5,000/year passive income
- **Incentive**: Users become salespeople for the platform

**Moat 9: White-Label (B2B Sales Channel)**
- Competitors: No white-label (agencies build custom CRMs)
- ReachCraft: Agencies charge $499/month, resell to 10 clients = $4,990/month revenue
- **Distribution**: 1,000 agencies = 10,000 end customers

**Moat 10: Feature Flag System (Infinite Product Market Fit)**
- Competitors: One product, one ICP (ideal customer profile)
- ReachCraft: 8 verticals, 8 ICPs, feature flags turn features on/off
- **Addressable Market**: 10x larger than single-vertical CRM

### Why Competitors Can't Copy Us

**Salesforce/HubSpot**: Too slow (18-month product cycles), too expensive (enterprise sales model)
**Apollo/ZoomInfo**: Business model conflict (they sell data at $1.50/lead, can't undercut to $0.10)
**LinkedIn**: Don't want to cannibalize Sales Navigator ($99/month)
**Startups**: Don't have pattern reuse advantage (18-month build time, $5M raised)

### First-Mover Advantages

1. **Data Moat**: First to 10M leads wins (network effects)
2. **Brand**: "ReachCraft = Contact Management for Creators" (category creation)
3. **Partnerships**: First to integrate with Zoom/Google Meet/Teams
4. **Investors**: First to pitch "Multi-Vertical CRM + Data Marketplace" = easy raise

---

## 1.4 Success Metrics & Milestones

### North Star Metric

**Annual Recurring Revenue (ARR)**
- Year 1: $2.4M
- Year 2: $24M (10x growth)
- Year 3: $95M (4x growth)
- Year 4: $238M (2.5x growth)

### Key Performance Indicators (KPIs)

**Acquisition Metrics**:
- CAC (Customer Acquisition Cost): $50 target (paid ads + content)
- Organic vs. Paid: 60% organic (SEO, word-of-mouth) / 40% paid
- Conversion Rate: 45% (free trial → paid) vs. industry 20%
- Time to First Value: <5 minutes (capture first lead)

**Engagement Metrics**:
- DAU/MAU: 40% (daily active / monthly active users)
- Leads Added per User per Month: 100 median, 500 power users
- Sessions per Week: 3.5 median
- Feature Adoption: 70% use browser extension, 50% use AI enrichment

**Retention Metrics**:
- Monthly Churn: <5% (industry: 10-15%)
- Annual Churn: <40% (industry: 60-80%)
- NRR (Net Revenue Retention): 120% (upsells offset churn)
- LTV (Lifetime Value): $1,200 ($50/month × 24 months)
- LTV:CAC Ratio: 24:1 (healthy = 3:1)

**Monetization Metrics**:
- ARPU (Average Revenue Per User): $33/month by Year 4
- Expansion Revenue: 30% of total revenue (upsells + marketplace)
- Marketplace GMV: $50M by Year 4
- Gross Margin: 92% (SaaS) + 50% (marketplace) = 85% blended

**Data Marketplace Metrics**:
- Total Leads in Database: 100M by Year 4
- Leads Sold per Month: 5M ($5M GMV)
- Average Lead Price: $1.00 (range: $0.50-5.00)
- Revenue Share Paid to Uploaders: $2.5M/month

**AI Jobs Marketplace Metrics**:
- Total Connections per Month: 10,000 by Year 4
- Revenue per Connection: $10
- Monthly GMV: $100K

### Growth Milestones

**Q1 2025 (Launch)**:
- Product: MVP live (PRO + CREATOR + SALES verticals)
- Users: 1,000 beta users
- ARR: $50K
- Funding: Bootstrap or $500K angel round

**Q2 2025 (Product-Market Fit)**:
- Product: All 8 verticals live, browser extension, AI enrichment
- Users: 5,000 paying users
- ARR: $300K
- Funding: $2M seed round

**Q3 2025 (Distribution)**:
- Product: Data marketplace live, API access
- Users: 15,000 paying users
- ARR: $1M
- Funding: $2M seed extension

**Q4 2025 (Scale)**:
- Product: AI Jobs marketplace live, white-label
- Users: 30,000 paying users
- ARR: $2.4M (end of Year 1 target)
- Funding: $10M Series A

**Year 2 (2026) - 10x Growth**:
- Product: Meeting intelligence, mobile app, Zapier integration
- Users: 100,000 paying users
- ARR: $24M
- Funding: $30M Series B

**Year 3 (2027) - 4x Growth**:
- Product: AI outreach, lead magnets, CRM workflow automation
- Users: 300,000 paying users
- ARR: $95M
- Funding: $75M Series C

**Year 4 (2028) - 2.5x Growth**:
- Product: Mobile SDK, enterprise features, advanced analytics
- Users: 600,000 paying users
- ARR: $238M
- Funding: IPO or $500M Series D (at $10-15B valuation)

---

## 1.5 Executive Summary

**ReachCraft is the AI-first, multi-vertical contact management platform targeting $238M ARR by Year 4 and a $10-15B valuation.**

**The Opportunity**: $127B CRM/data/recruiting market is fragmented, expensive, and enterprise-focused. Creators, solopreneurs, and SMBs are underserved.

**Our Solution**: One platform, 8 verticals ($39-499/month), 3 marketplaces (AI Jobs, Data, Influencer/Brand), powered by AI enrichment (85% cheaper than competitors).

**Competitive Advantages**:
1. Network effects (data marketplace)
2. Multi-vertical land-and-expand
3. AI cost advantage (85% cheaper)
4. Pattern reuse (7-day build)
5. Zero-HIL user experience
6. Browser extension (unlimited capture)
7. Meeting intelligence (auto-capture)
8. Revenue share model (viral growth)
9. White-label (B2B channel)
10. Feature flags (infinite PMF)

**Traction Plan**:
- Q1 2025: MVP launch, 1,000 beta users
- Q4 2025: $2.4M ARR, 30,000 users
- Year 2: $24M ARR, 100,000 users (10x growth)
- Year 4: $238M ARR, 600,000 users → $10-15B valuation

**Funding Strategy**:
- Bootstrap → $500K angel → $2M seed → $10M Series A → $30M Series B → $75M Series C → IPO

**Why Now**: AI cost collapse (90%), creator economy boom (200M creators), remote work (everyone on Zoom), privacy backlash (ethical data), competitive weakness (HubSpot/Salesforce too expensive).

**Why Us**: Pattern reuse (7-day build vs. 18 months), zero-HIL philosophy (45% conversion vs. 8%), marketplace network effects (100M leads by Year 4), multi-vertical strategy (10x TAM).

**Ask**: $2M seed round to build MVP, hire 5 engineers, launch all 8 verticals by Q2 2025.

---

# PART 2: PLATFORM ARCHITECTURE

## 2.1 Core Platform Overview (One Codebase → 8 Verticals)

### Architectural Philosophy

**One Codebase, Infinite Products**:
- Single Next.js/React frontend
- Single Node.js/Express backend
- Single Supabase database (multi-tenant)
- Feature flags control which features appear per vertical
- White-label system allows custom branding
- God Mode dashboard manages all verticals

**Benefits**:
1. **Development Speed**: Build once, deploy 8 times
2. **Maintenance**: Fix bug once, fixes in all verticals
3. **Cost Efficiency**: One server, one database, one codebase
4. **Pattern Reuse**: 85-95% code reused from existing projects

### Technology Stack

**Frontend**:
- **Framework**: Next.js 14 (React 18, App Router)
- **Styling**: Tailwind CSS + shadcn/ui components
- **State Management**: Zustand (lightweight, fast)
- **Forms**: React Hook Form + Zod validation
- **Data Fetching**: TanStack Query (React Query)
- **Charts**: Recharts (for analytics dashboards)
- **Rich Text**: Tiptap (for notes, emails)

**Backend**:
- **Runtime**: Node.js 20 + Express.js
- **API**: REST + GraphQL (Apollo Server)
- **Authentication**: Supabase Auth (email, Google, LinkedIn OAuth)
- **Database**: Supabase (PostgreSQL 15)
- **Queue**: BullMQ (Redis-backed job queue)
- **Cache**: Redis (session, rate limiting)
- **Storage**: Supabase Storage (avatars, imports, exports)

**AI/ML**:
- **LLMs**: Claude 3.5 Sonnet (Anthropic) + GPT-4 (OpenAI)
- **Embeddings**: text-embedding-3-small (OpenAI)
- **Vector DB**: Supabase pgvector (semantic search)
- **Prompt Management**: Custom TypeScript library
- **Cost Tracking**: Token usage logger

**Infrastructure**:
- **Hosting**: Vercel (frontend) + Railway (backend)
- **Database**: Supabase (managed PostgreSQL + Auth + Storage)
- **CDN**: Vercel Edge Network
- **Monitoring**: Sentry (errors) + PostHog (analytics) + Axiom (logs)
- **Email**: Resend (transactional) + loops.so (marketing)
- **Payments**: Stripe (subscriptions + marketplace payouts)

**Integrations**:
- **CRM**: Salesforce, HubSpot, Pipedrive (sync contacts)
- **Email**: Gmail, Outlook (OAuth + sync contacts)
- **Calendar**: Google Calendar, Outlook Calendar (meeting intelligence)
- **Video**: Zoom, Google Meet, Microsoft Teams (meeting participants)
- **Social**: LinkedIn, Twitter/X, Instagram, Facebook (profile enrichment)
- **Data**: Apollo.io, ZoomInfo (wholesale lead import)
- **Automation**: Zapier, Make.com (webhook triggers)

**DevOps**:
- **CI/CD**: GitHub Actions
- **Testing**: Vitest (unit) + Playwright (e2e)
- **Linting**: ESLint + Prettier + TypeScript strict mode
- **Git**: GitHub (main repo)
- **Secrets**: Vercel Env Vars + Railway Env Vars
- **Backups**: Supabase automated daily backups

---

## 2.2 Multi-Tenant SaaS Architecture

### Tenant Isolation Strategy

**Row-Level Security (RLS)**:
```sql
-- Every table has a tenant_id column
CREATE TABLE contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  -- ... other fields
  CONSTRAINT tenant_isolation CHECK (tenant_id IS NOT NULL)
);

-- RLS policy ensures users only see their tenant's data
CREATE POLICY "Users can only access their tenant's data"
ON contacts
FOR ALL
USING (tenant_id = get_current_tenant_id());

-- Helper function to get current tenant
CREATE FUNCTION get_current_tenant_id() RETURNS UUID AS $$
  SELECT tenant_id FROM users WHERE id = auth.uid();
$$ LANGUAGE SQL SECURITY DEFINER;
```

**Benefits**:
- **Security**: Impossible to access other tenant's data (database-enforced)
- **Performance**: Indexes on tenant_id for fast queries
- **Cost**: One database, not separate per tenant
- **Compliance**: GDPR/SOC2 compliant (data isolation)

### Tenant Types

**Type 1: Individual User** (default)
- User signs up → auto-creates tenant
- tenant_id = user_id
- Subscribed to one vertical (e.g., CREATOR $39/month)
- Can invite team members (5 seats included)

**Type 2: Team** (collaboration)
- Owner invites 5-50 team members
- All share same contacts database
- Role-based permissions (admin, member, viewer)
- Subscribed to PRO/SALES/RECRUIT ($79-129/month)

**Type 3: Agency** (white-label reseller)
- Agency subscribes to AGENCY ($499/month)
- Creates sub-tenants for each client
- Custom branding per sub-tenant
- Revenue share: Agency keeps 100% of client fees

**Type 4: Enterprise** (custom pricing)
- 100+ users, custom SLA, dedicated support
- Single-tenant database (optional)
- Custom domain (crm.acme.com)
- SSO (SAML, LDAP)

### Tenant Provisioning Flow

```typescript
// Step 1: User signs up
async function signUp(email: string, password: string, vertical: Vertical) {
  // Create auth user (Supabase)
  const { user } = await supabase.auth.signUp({ email, password })

  // Create tenant
  const tenant = await db.tenants.create({
    id: user.id, // tenant_id = user_id for individuals
    name: `${email}'s Workspace`,
    vertical: vertical, // CREATOR, PRO, SALES, etc.
    subscription_tier: getTierForVertical(vertical),
    feature_flags: getDefaultFeaturesForVertical(vertical),
    created_at: new Date()
  })

  // Create user record
  await db.users.create({
    id: user.id,
    tenant_id: tenant.id,
    email: email,
    role: 'owner',
    onboarded: false
  })

  // Initialize default categories
  await createDefaultCategories(tenant.id, vertical)

  // Send welcome email
  await sendWelcomeEmail(email, vertical)

  return { user, tenant }
}

// Step 2: Switch vertical (upsell)
async function switchVertical(userId: string, newVertical: Vertical) {
  const user = await db.users.findById(userId)
  const tenant = await db.tenants.findById(user.tenant_id)

  // Update tenant vertical
  await db.tenants.update(tenant.id, {
    vertical: newVertical,
    subscription_tier: getTierForVertical(newVertical),
    feature_flags: getDefaultFeaturesForVertical(newVertical)
  })

  // Create default categories for new vertical
  await createDefaultCategories(tenant.id, newVertical)

  // Update Stripe subscription
  await stripe.subscriptions.update(tenant.stripe_subscription_id, {
    items: [{ price: getPriceIdForVertical(newVertical) }]
  })
}
```

---

## 2.3 Feature Flag System

### Feature Flag Architecture

**Why Feature Flags?**
- Turn features on/off per vertical without code changes
- A/B test features with 10% of users
- Gradual rollout (10% → 50% → 100%)
- Emergency kill switch (if feature breaks, disable instantly)

**Feature Flag Database Schema**:
```typescript
interface FeatureFlag {
  id: string
  name: string // 'browser_extension', 'ai_enrichment', 'data_marketplace'
  description: string
  enabled_by_default: boolean

  // Per-vertical overrides
  verticals: {
    PRO: boolean
    MEDIA: boolean
    FUNDRAISE: boolean
    CREATOR: boolean
    RECRUIT: boolean
    SALES: boolean
    AGENCY: boolean
    SOCIAL: boolean
  }

  // Per-tenant overrides (for custom deals)
  tenant_overrides: Record<string, boolean> // { 'tenant-123': true }

  // Per-user overrides (for beta testing)
  user_overrides: Record<string, boolean> // { 'user-456': true }

  // Rollout percentage (gradual rollout)
  rollout_percentage: number // 0-100

  // Dependencies (e.g., 'data_marketplace' requires 'ai_enrichment')
  requires: string[]

  created_at: Date
  updated_at: Date
}
```

**Feature Flag Examples**:

| Feature | PRO | MEDIA | FUNDRAISE | CREATOR | RECRUIT | SALES | AGENCY | SOCIAL |
|---------|-----|-------|-----------|---------|---------|-------|--------|--------|
| Contact Management | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Browser Extension | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| AI Enrichment | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Meeting Intelligence | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |
| Lead Profiler | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| Data Marketplace | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | ✅ | ❌ |
| AI Jobs Marketplace | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Influencer Marketplace | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ✅ |
| Auto-Pilot Scraping | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| Email Campaigns | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ |
| White-Label | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| API Access | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ |

**Feature Flag Evaluation (Client-Side)**:
```typescript
// React hook to check feature flags
function useFeatureFlag(flagName: string): boolean {
  const { tenant, user } = useAuth()

  // Check user override first (for beta testing)
  if (user.feature_overrides?.[flagName] !== undefined) {
    return user.feature_overrides[flagName]
  }

  // Check tenant override (for custom deals)
  if (tenant.feature_overrides?.[flagName] !== undefined) {
    return tenant.feature_overrides[flagName]
  }

  // Check vertical default
  const flag = getFeatureFlag(flagName)
  const verticalEnabled = flag.verticals[tenant.vertical]

  if (!verticalEnabled) return false

  // Check rollout percentage (gradual rollout)
  if (flag.rollout_percentage < 100) {
    const userHash = hashUserId(user.id)
    return userHash % 100 < flag.rollout_percentage
  }

  return true
}

// Usage in components
function DataMarketplaceButton() {
  const enabled = useFeatureFlag('data_marketplace')

  if (!enabled) return null

  return <button>Sell Leads</button>
}
```

---

## 2.4 White-Label Architecture

### White-Label Requirements

**What Agencies Need**:
1. Custom branding (logo, colors, domain)
2. Sub-tenant management (create clients, manage billing)
3. Client impersonation (login as client for support)
4. Revenue control (agency keeps 100% of client fees)
5. Usage limits per client (prevent abuse)

### White-Label Database Schema

```typescript
interface WhiteLabelConfig {
  tenant_id: string // Agency's tenant ID

  // Branding
  branding: {
    logo_url: string // Custom logo
    primary_color: string // #hex
    secondary_color: string
    font_family: string // 'Inter', 'Roboto', etc.
    custom_css: string // Advanced customization
  }

  // Domain
  custom_domain: string // 'crm.agency.com'
  domain_verified: boolean
  ssl_certificate: string

  // Sub-tenants (clients)
  sub_tenants: Array<{
    id: string
    name: string // 'Acme Corp'
    subscription_tier: 'PRO' | 'SALES' | 'RECRUIT'
    monthly_fee: number // What agency charges client
    usage_limits: {
      max_contacts: number // 10,000
      max_users: number // 5
      max_api_calls: number // 50,000/month
    }
    created_at: Date
  }>

  // Revenue
  revenue: {
    total_monthly_revenue: number // Sum of all client fees
    platform_fee: number // $0 (agency keeps 100%)
    payment_method: 'stripe' | 'paypal' | 'wire'
  }

  created_at: Date
}
```

### White-Label Onboarding Flow

```typescript
// Step 1: Agency subscribes to AGENCY tier ($499/month)
async function subscribeToAgency(userId: string) {
  const user = await db.users.findById(userId)
  const tenant = await db.tenants.findById(user.tenant_id)

  // Update tenant to AGENCY tier
  await db.tenants.update(tenant.id, {
    vertical: 'AGENCY',
    subscription_tier: 'AGENCY',
    monthly_fee: 499
  })

  // Enable white-label features
  await db.tenants.updateFeatureFlags(tenant.id, {
    white_label: true,
    sub_tenant_management: true,
    client_impersonation: true
  })

  // Initialize white-label config
  await db.whiteLabel.create({
    tenant_id: tenant.id,
    branding: getDefaultBranding(),
    sub_tenants: []
  })

  // Send onboarding email with instructions
  await sendAgencyOnboardingEmail(user.email)
}

// Step 2: Agency creates sub-tenant (client)
async function createSubTenant(agencyTenantId: string, clientData: ClientData) {
  const agency = await db.tenants.findById(agencyTenantId)

  // Verify agency is AGENCY tier
  if (agency.vertical !== 'AGENCY') {
    throw new Error('Only AGENCY tier can create sub-tenants')
  }

  // Create sub-tenant
  const subTenant = await db.tenants.create({
    parent_tenant_id: agencyTenantId,
    name: clientData.name,
    vertical: clientData.vertical, // PRO, SALES, etc.
    subscription_tier: clientData.tier,
    feature_flags: getDefaultFeaturesForVertical(clientData.vertical),
    usage_limits: clientData.usage_limits
  })

  // Create client admin user
  const clientUser = await db.users.create({
    email: clientData.admin_email,
    tenant_id: subTenant.id,
    role: 'owner',
    password: generateRandomPassword() // Sent via email
  })

  // Add sub-tenant to agency's white-label config
  await db.whiteLabel.update(agencyTenantId, {
    sub_tenants: [...agency.sub_tenants, {
      id: subTenant.id,
      name: clientData.name,
      subscription_tier: clientData.tier,
      monthly_fee: clientData.monthly_fee,
      created_at: new Date()
    }]
  })

  // Send client welcome email
  await sendClientWelcomeEmail(clientData.admin_email, {
    login_url: `https://${agency.custom_domain}/login`,
    password: clientUser.password
  })

  return subTenant
}

// Step 3: Agency impersonates client (for support)
async function impersonateClient(agencyUserId: string, clientTenantId: string) {
  const agencyUser = await db.users.findById(agencyUserId)
  const agencyTenant = await db.tenants.findById(agencyUser.tenant_id)

  // Verify agency owns this client
  const whiteLabel = await db.whiteLabel.findByTenantId(agencyTenant.id)
  const isOwned = whiteLabel.sub_tenants.some(st => st.id === clientTenantId)

  if (!isOwned) {
    throw new Error('You do not own this client')
  }

  // Generate impersonation token (expires in 1 hour)
  const impersonationToken = jwt.sign({
    agency_user_id: agencyUserId,
    client_tenant_id: clientTenantId,
    expires_at: Date.now() + 3600000
  }, process.env.JWT_SECRET)

  // Log impersonation event (audit trail)
  await db.auditLogs.create({
    action: 'IMPERSONATE_CLIENT',
    agency_user_id: agencyUserId,
    client_tenant_id: clientTenantId,
    timestamp: new Date()
  })

  return impersonationToken
}
```

---

## 2.5 God Mode Dashboard

### God Mode Purpose

**What is God Mode?**
- Admin dashboard to manage all tenants, users, verticals
- View revenue, usage, growth metrics
- Impersonate any user for support
- Manage feature flags, subscriptions, billing
- Monitor system health, errors, performance

**Who Has Access?**
- ReachCraft founders/employees only
- Requires 2FA (Google Authenticator)
- All actions logged (audit trail)

### God Mode Features

**1. Tenant Management**:
- View all tenants (search, filter, sort)
- See subscription tier, revenue, usage
- Impersonate tenant (login as them)
- Force upgrade/downgrade
- Suspend/delete tenant

**2. User Management**:
- View all users (search by email, name)
- See login history, activity
- Reset password
- Impersonate user
- Ban user (fraud prevention)

**3. Revenue Dashboard**:
- MRR (Monthly Recurring Revenue)
- ARR (Annual Recurring Revenue)
- Churn rate (monthly, annual)
- LTV (Lifetime Value)
- CAC (Customer Acquisition Cost)
- Revenue by vertical (PRO, CREATOR, SALES, etc.)
- Marketplace GMV (Gross Merchandise Volume)

**4. Feature Flag Management**:
- View all feature flags
- Enable/disable per vertical
- Gradual rollout (10% → 50% → 100%)
- Emergency kill switch

**5. System Health**:
- API response times (p50, p95, p99)
- Error rate (Sentry)
- Database query performance
- Job queue health (BullMQ)
- Cache hit rate (Redis)

**6. Support Tools**:
- Search for user by email
- View user's contacts, activity
- Impersonate user
- Refund subscription
- Send email to user

### God Mode UI Mockup

```typescript
// God Mode Dashboard Component
function GodModeDashboard() {
  return (
    <div className="god-mode">
      <Header>
        <Logo>ReachCraft God Mode</Logo>
        <UserMenu>{currentAdmin.email}</UserMenu>
      </Header>

      <Sidebar>
        <NavLink to="/god/overview">Overview</NavLink>
        <NavLink to="/god/tenants">Tenants</NavLink>
        <NavLink to="/god/users">Users</NavLink>
        <NavLink to="/god/revenue">Revenue</NavLink>
        <NavLink to="/god/features">Feature Flags</NavLink>
        <NavLink to="/god/system">System Health</NavLink>
        <NavLink to="/god/support">Support</NavLink>
      </Sidebar>

      <MainContent>
        <MetricsGrid>
          <MetricCard title="MRR" value="$245K" change="+18%" />
          <MetricCard title="ARR" value="$2.94M" change="+18%" />
          <MetricCard title="Tenants" value="12,450" change="+240" />
          <MetricCard title="Churn" value="4.2%" change="-0.5%" />
        </MetricsGrid>

        <Charts>
          <RevenueChart />
          <UserGrowthChart />
          <VerticalBreakdownChart />
        </Charts>

        <RecentActivity>
          <ActivityItem>New tenant: acme@example.com (PRO)</ActivityItem>
          <ActivityItem>Churn: startup@example.com (SALES)</ActivityItem>
          <ActivityItem>Upgrade: creator@example.com (CREATOR → PRO)</ActivityItem>
        </RecentActivity>
      </MainContent>
    </div>
  )
}
```

---

## 2.6 Database Architecture (35+ Tables)

### Core Tables

**1. tenants** (multi-tenancy)
```sql
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_tenant_id UUID REFERENCES tenants(id), -- For white-label sub-tenants
  name TEXT NOT NULL,
  vertical TEXT NOT NULL CHECK (vertical IN ('PRO', 'MEDIA', 'FUNDRAISE', 'CREATOR', 'RECRUIT', 'SALES', 'AGENCY', 'SOCIAL')),
  subscription_tier TEXT NOT NULL,
  stripe_customer_id TEXT,
  stripe_subscription_id TEXT,
  monthly_fee DECIMAL(10,2) NOT NULL,
  feature_flags JSONB DEFAULT '{}',
  usage_limits JSONB DEFAULT '{}',
  custom_domain TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_tenants_vertical ON tenants(vertical);
CREATE INDEX idx_tenants_parent ON tenants(parent_tenant_id);
```

**2. users**
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL CHECK (role IN ('owner', 'admin', 'member', 'viewer')),
  feature_overrides JSONB DEFAULT '{}',
  onboarded BOOLEAN DEFAULT FALSE,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_users_email ON users(email);
```

**3. contacts** (main entity)
```sql
CREATE TABLE contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),

  -- Basic info
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  phone TEXT,
  company TEXT,
  title TEXT,

  -- Social profiles
  linkedin_url TEXT,
  twitter_url TEXT,
  instagram_url TEXT,
  facebook_url TEXT,

  -- Rich data
  bio TEXT,
  notes TEXT,
  tags TEXT[],
  custom_fields JSONB DEFAULT '{}',

  -- Categorization
  categories UUID[] DEFAULT '{}', -- Array of category IDs

  -- Lead scoring
  lead_score INTEGER DEFAULT 0 CHECK (lead_score >= 0 AND lead_score <= 100),
  lead_stage TEXT CHECK (lead_stage IN ('cold', 'warm', 'hot', 'customer', 'churned')),

  -- Enrichment
  enriched BOOLEAN DEFAULT FALSE,
  enriched_at TIMESTAMPTZ,
  enrichment_source TEXT, -- 'ai', 'clearbit', 'apollo', etc.
  enrichment_cost DECIMAL(10,4),

  -- Quality
  email_verified BOOLEAN DEFAULT FALSE,
  phone_verified BOOLEAN DEFAULT FALSE,
  is_stale BOOLEAN DEFAULT FALSE,
  last_activity_at TIMESTAMPTZ,

  -- Ownership (for data marketplace)
  original_uploader_id UUID REFERENCES users(id),
  upload_source TEXT CHECK (upload_source IN ('manual', 'import', 'scrape', 'browser_extension', 'meeting', 'api')),
  upload_date TIMESTAMPTZ DEFAULT NOW(),

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Full-text search
  tsv TSVECTOR GENERATED ALWAYS AS (
    to_tsvector('english', COALESCE(first_name, '') || ' ' || COALESCE(last_name, '') || ' ' || COALESCE(email, '') || ' ' || COALESCE(company, ''))
  ) STORED
);

CREATE INDEX idx_contacts_tenant ON contacts(tenant_id);
CREATE INDEX idx_contacts_user ON contacts(user_id);
CREATE INDEX idx_contacts_email ON contacts(tenant_id, email);
CREATE INDEX idx_contacts_categories ON contacts USING GIN(categories);
CREATE INDEX idx_contacts_tags ON contacts USING GIN(tags);
CREATE INDEX idx_contacts_tsv ON contacts USING GIN(tsv);
CREATE INDEX idx_contacts_lead_score ON contacts(tenant_id, lead_score DESC);
```

**4. categories** (expandable)
```sql
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  name TEXT NOT NULL,
  icon TEXT, -- Emoji or icon name
  color TEXT, -- Hex color
  description TEXT,
  parent_category_id UUID REFERENCES categories(id), -- For nested categories
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(tenant_id, name)
);

CREATE INDEX idx_categories_tenant ON categories(tenant_id);
CREATE INDEX idx_categories_parent ON categories(parent_category_id);
```

**5. source_syncs** (15+ platform integrations)
```sql
CREATE TABLE source_syncs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  source_type TEXT NOT NULL CHECK (source_type IN (
    'linkedin', 'twitter', 'instagram', 'facebook', 'tiktok',
    'gmail', 'outlook', 'google_contacts', 'apple_contacts',
    'salesforce', 'hubspot', 'pipedrive',
    'zoom', 'google_meet', 'microsoft_teams',
    'apollo', 'zoominfo'
  )),
  connected BOOLEAN DEFAULT TRUE,
  access_token TEXT,
  refresh_token TEXT,
  token_expires_at TIMESTAMPTZ,
  last_sync_at TIMESTAMPTZ,
  sync_frequency TEXT CHECK (sync_frequency IN ('realtime', 'hourly', 'daily', 'weekly', 'manual')),
  sync_enabled BOOLEAN DEFAULT TRUE,
  total_contacts_synced INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(tenant_id, user_id, source_type)
);

CREATE INDEX idx_source_syncs_tenant ON source_syncs(tenant_id);
CREATE INDEX idx_source_syncs_user ON source_syncs(user_id);
```

**6. enrichments** (AI enrichment history)
```sql
CREATE TABLE enrichments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,
  enrichment_type TEXT NOT NULL CHECK (enrichment_type IN ('email', 'phone', 'social', 'company', 'full_profile')),
  provider TEXT NOT NULL CHECK (provider IN ('ai_claude', 'ai_gpt4', 'clearbit', 'apollo', 'zoominfo')),
  cost DECIMAL(10,4) NOT NULL,
  input_data JSONB,
  output_data JSONB,
  confidence_score INTEGER CHECK (confidence_score >= 0 AND confidence_score <= 100),
  status TEXT CHECK (status IN ('pending', 'success', 'failed')),
  error_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_enrichments_contact ON enrichments(contact_id);
CREATE INDEX idx_enrichments_tenant ON enrichments(tenant_id);
CREATE INDEX idx_enrichments_status ON enrichments(status) WHERE status = 'pending';
```

**7. lead_profiles** (Lead Intelligence Profiler from InterviewPlus)
```sql
CREATE TABLE lead_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  contact_id UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,

  -- Profiler dimensions (from InterviewPlus)
  communication_style TEXT, -- 'analytical', 'relational', 'direct', 'expressive'
  decision_making TEXT, -- 'data-driven', 'consensus', 'intuitive', 'risk-averse'
  personality_traits JSONB, -- { 'extraversion': 75, 'openness': 60, ... }

  -- Lead intelligence
  buying_signals TEXT[], -- ['asked_about_pricing', 'visited_pricing_page', 'downloaded_whitepaper']
  pain_points TEXT[], -- Extracted from conversations
  interests TEXT[], -- Extracted from social media

  -- Contact preferences
  preferred_channel TEXT, -- 'email', 'phone', 'linkedin', 'twitter'
  best_time_to_contact TEXT, -- '9am-11am EST weekdays'
  response_rate DECIMAL(5,2), -- 85.5% = 85.5

  -- AI-generated insights
  ai_summary TEXT, -- "Sarah is analytical, responds best to data-driven emails, interested in AI automation"
  recommended_approach TEXT, -- "Lead with ROI case study, follow up on LinkedIn"

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(contact_id)
);

CREATE INDEX idx_lead_profiles_tenant ON lead_profiles(tenant_id);
CREATE INDEX idx_lead_profiles_contact ON lead_profiles(contact_id);
```

**8. meetings** (Meeting Intelligence)
```sql
CREATE TABLE meetings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  source TEXT CHECK (source IN ('zoom', 'google_meet', 'microsoft_teams', 'manual')),
  source_meeting_id TEXT, -- External meeting ID
  title TEXT,
  description TEXT,
  start_time TIMESTAMPTZ,
  end_time TIMESTAMPTZ,
  duration_minutes INTEGER,
  meeting_url TEXT,
  recording_url TEXT,
  transcript TEXT,
  attendees UUID[], -- Array of contact IDs
  action_items JSONB, -- [{ 'owner': 'user-123', 'task': 'Send proposal', 'due_date': '2025-12-20' }]
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_meetings_tenant ON meetings(tenant_id);
CREATE INDEX idx_meetings_user ON meetings(user_id);
CREATE INDEX idx_meetings_start_time ON meetings(start_time DESC);
CREATE INDEX idx_meetings_attendees ON meetings USING GIN(attendees);
```

**9. data_marketplace_listings** (Data Marketplace)
```sql
CREATE TABLE data_marketplace_listings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  seller_user_id UUID NOT NULL REFERENCES users(id),
  contact_ids UUID[] NOT NULL, -- Leads being sold

  -- Listing details
  title TEXT NOT NULL,
  description TEXT,
  industry TEXT, -- 'medical_spa', 'saas', 'real_estate', etc.
  location TEXT, -- 'Boulder, CO', 'United States', 'Worldwide'
  total_leads INTEGER NOT NULL,
  price_per_lead DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,

  -- Quality metrics
  email_verified_percentage DECIMAL(5,2), -- 95.5%
  phone_verified_percentage DECIMAL(5,2),
  average_lead_age_days INTEGER,
  recency_score INTEGER CHECK (recency_score >= 0 AND recency_score <= 100),

  -- Status
  status TEXT CHECK (status IN ('draft', 'active', 'sold', 'expired', 'removed')),
  views INTEGER DEFAULT 0,
  favorites INTEGER DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ
);

CREATE INDEX idx_marketplace_seller ON data_marketplace_listings(seller_tenant_id);
CREATE INDEX idx_marketplace_status ON data_marketplace_listings(status) WHERE status = 'active';
CREATE INDEX idx_marketplace_industry ON data_marketplace_listings(industry);
```

**10. data_marketplace_purchases** (Purchase history)
```sql
CREATE TABLE data_marketplace_purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id UUID NOT NULL REFERENCES data_marketplace_listings(id),
  buyer_tenant_id UUID NOT NULL REFERENCES tenants(id),
  buyer_user_id UUID NOT NULL REFERENCES users(id),
  seller_tenant_id UUID NOT NULL REFERENCES tenants(id),
  seller_user_id UUID NOT NULL REFERENCES users(id),

  contact_ids UUID[], -- Leads purchased
  total_leads INTEGER NOT NULL,
  price_per_lead DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,

  -- Revenue share
  platform_revenue DECIMAL(10,2) NOT NULL, -- 50%
  seller_revenue DECIMAL(10,2) NOT NULL, -- 50%
  seller_paid BOOLEAN DEFAULT FALSE,
  seller_paid_at TIMESTAMPTZ,

  -- Payment
  stripe_payment_intent_id TEXT,
  stripe_transfer_id TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_purchases_buyer ON data_marketplace_purchases(buyer_tenant_id);
CREATE INDEX idx_purchases_seller ON data_marketplace_purchases(seller_tenant_id);
CREATE INDEX idx_purchases_listing ON data_marketplace_purchases(listing_id);
```

**11. ai_jobs_marketplace_listings** (AI Jobs)
```sql
CREATE TABLE ai_jobs_marketplace_listings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),

  -- Job details
  job_title TEXT NOT NULL,
  company_name TEXT NOT NULL,
  job_description TEXT NOT NULL,
  location TEXT,
  salary_range TEXT,
  job_type TEXT CHECK (job_type IN ('full_time', 'part_time', 'contract', 'internship')),
  remote_ok BOOLEAN DEFAULT FALSE,

  -- Target profile
  desired_skills TEXT[],
  desired_experience_years INTEGER,
  desired_education TEXT,

  -- Pricing
  connection_fee DECIMAL(10,2) DEFAULT 10.00,
  max_connections INTEGER DEFAULT 100,
  connections_made INTEGER DEFAULT 0,

  -- Status
  status TEXT CHECK (status IN ('draft', 'active', 'paused', 'closed')),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ
);

CREATE INDEX idx_ai_jobs_tenant ON ai_jobs_marketplace_listings(tenant_id);
CREATE INDEX idx_ai_jobs_status ON ai_jobs_marketplace_listings(status) WHERE status = 'active';
```

**12. ai_jobs_marketplace_connections** (Job connections)
```sql
CREATE TABLE ai_jobs_marketplace_connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id UUID NOT NULL REFERENCES ai_jobs_marketplace_listings(id),
  job_poster_tenant_id UUID NOT NULL REFERENCES tenants(id),
  candidate_provider_tenant_id UUID NOT NULL REFERENCES tenants(id),
  candidate_contact_id UUID NOT NULL REFERENCES contacts(id),

  -- Match details
  match_score INTEGER CHECK (match_score >= 0 AND match_score <= 100),
  match_explanation TEXT,

  -- Revenue share
  connection_fee DECIMAL(10,2) DEFAULT 10.00,
  platform_revenue DECIMAL(10,2), -- 70%
  lead_uploader_revenue DECIMAL(10,2), -- 20%
  job_poster_revenue DECIMAL(10,2), -- 10%

  -- Status
  status TEXT CHECK (status IN ('pending', 'accepted', 'rejected', 'expired')),
  intro_email_sent BOOLEAN DEFAULT FALSE,
  intro_email_sent_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_ai_jobs_connections_listing ON ai_jobs_marketplace_connections(listing_id);
CREATE INDEX idx_ai_jobs_connections_candidate ON ai_jobs_marketplace_connections(candidate_contact_id);
```

### Additional Tables (13-35)

**13. activities** (timeline/audit log)
**14. emails** (email history)
**15. phone_calls** (call logging)
**16. tasks** (to-dos)
**17. notes** (rich text notes)
**18. files** (attachments)
**19. tags** (global tag list)
**20. custom_fields** (custom field definitions)
**21. pipelines** (sales pipelines)
**22. deals** (sales deals)
**23. automations** (workflow automation)
**24. automation_runs** (execution history)
**25. webhooks** (outgoing webhooks)
**26. api_keys** (API access)
**27. api_usage** (rate limiting)
**28. feature_flags** (feature flags)
**29. white_label_configs** (white-label settings)
**30. revenue_share_payouts** (payout history)
**31. scraping_jobs** (auto-pilot scraping)
**32. scraping_results** (scraped leads)
**33. lead_valuation_history** (valuation changes)
**34. audit_logs** (security audit trail)
**35. system_settings** (global settings)

---

## 2.7 Technology Stack (Complete)

### Frontend Stack

**Core Framework**:
- Next.js 14 (App Router, Server Components, Server Actions)
- React 18 (Concurrent Mode, Suspense, Transitions)
- TypeScript 5.3 (Strict mode)

**Styling & UI**:
- Tailwind CSS 3.4 (JIT mode)
- shadcn/ui components (Radix UI primitives)
- Framer Motion (animations)
- Lucide React (icons)

**State Management**:
- Zustand (global state)
- TanStack Query (server state, caching)
- React Hook Form (form state)
- Zod (validation schemas)

**Data Fetching**:
- TanStack Query (React Query v5)
- SWR (for realtime updates)
- Supabase Realtime (websockets)

**Charts & Visualization**:
- Recharts (analytics dashboards)
- React Big Calendar (meeting scheduler)
- React Virtuoso (virtualized lists)

**Rich Text**:
- Tiptap (WYSIWYG editor)
- Lexical (for advanced editing)

**File Upload**:
- Uppy (drag-and-drop, progress bars)
- Supabase Storage integration

---

### Backend Stack

**Core Runtime**:
- Node.js 20 LTS
- Express.js 4.18 (REST API)
- Apollo Server 4 (GraphQL API)

**Database & Auth**:
- Supabase (PostgreSQL 15 + Auth + Storage + Realtime)
- Prisma ORM (type-safe queries)
- Row-Level Security (RLS) for multi-tenancy

**Job Queue**:
- BullMQ (Redis-backed queue)
- Redis 7 (cache + queue + rate limiting)

**AI/ML**:
- Anthropic Claude 3.5 Sonnet (primary LLM)
- OpenAI GPT-4 Turbo (fallback LLM)
- OpenAI text-embedding-3-small (embeddings)
- Supabase pgvector (vector search)

**Integrations**:
- OAuth 2.0 (LinkedIn, Google, Microsoft, Twitter)
- Zoom SDK (meeting intelligence)
- Google Meet API (meeting intelligence)
- Microsoft Graph API (Teams, Outlook, Calendar)
- Twilio Lookup API (phone verification)
- ZeroBounce API (email verification)

**Payments**:
- Stripe (subscriptions, marketplace, payouts)
- Stripe Connect (agency white-label revenue)

---

### Infrastructure Stack

**Hosting**:
- Vercel (frontend, edge functions)
- Railway (backend, database, Redis)

**Database**:
- Supabase (managed PostgreSQL + Auth + Storage + Realtime)

**CDN**:
- Vercel Edge Network (global)

**Monitoring**:
- Sentry (error tracking)
- PostHog (product analytics)
- Axiom (log aggregation)
- UptimeRobot (uptime monitoring)

**Email**:
- Resend (transactional emails)
- loops.so (marketing emails, drip campaigns)

**SMS**:
- Twilio (2FA, notifications)

**Storage**:
- Supabase Storage (avatars, imports, exports)
- Cloudflare R2 (large file storage, backups)

---

### DevOps Stack

**CI/CD**:
- GitHub Actions (automated testing, deployment)
- Vercel (automatic preview deployments)
- Railway (automatic backend deployments)

**Testing**:
- Vitest (unit tests, fast)
- Playwright (e2e tests)
- React Testing Library (component tests)
- Postman (API tests)

**Code Quality**:
- ESLint + Prettier (linting, formatting)
- TypeScript strict mode (type safety)
- Husky (pre-commit hooks)
- Commitlint (conventional commits)

**Security**:
- Snyk (dependency vulnerabilities)
- OWASP dependency check
- Supabase RLS (database security)
- Helmet.js (HTTP headers)

**Secrets Management**:
- Vercel Environment Variables
- Railway Environment Variables
- 1Password (team secrets)

---

# PART 3: FEATURE SPECIFICATIONS

## 3.1 Contact Management (Expandable Categories)

### Overview

**Philosophy**: Contacts don't fit into rigid categories. Users need infinite flexibility.

**Solution**: Expandable categories - users create custom categories (e.g., "VCs", "Media", "Friends", "Potential Clients"), assign contacts to multiple categories, nest categories (e.g., "VCs" → "Seed Stage VCs").

### Category System

**Default Categories (per vertical)**:

**PRO Vertical**:
- Personal Network
- Clients
- Prospects
- Partners
- Vendors

**MEDIA Vertical**:
- Journalists
- Influencers
- Podcast Hosts
- Bloggers
- Media Contacts

**FUNDRAISE Vertical**:
- VCs
- Angel Investors
- Advisors
- Warm Intros
- Portfolio Companies

**CREATOR Vertical**:
- Brands (Potential Sponsors)
- Active Sponsors
- Fellow Creators
- Audience
- Managers/Agents

**RECRUIT Vertical**:
- Active Candidates
- Passive Candidates
- Hiring Managers
- Referrals
- Rejected

**SALES Vertical**:
- Cold Leads
- Warm Leads
- Hot Leads
- Customers
- Churned

**AGENCY Vertical**:
- (Same as PRO, but per-client sub-tenant)

**SOCIAL Vertical**:
- Followers
- Engaged Users
- Brand Partners
- Influencers
- Collaborators

### Category CRUD Operations

```typescript
// Create category
async function createCategory(
  tenantId: string,
  userId: string,
  data: { name: string; icon?: string; color?: string; parentCategoryId?: string }
): Promise<Category> {
  return await db.categories.create({
    tenant_id: tenantId,
    user_id: userId,
    name: data.name,
    icon: data.icon || '📁',
    color: data.color || '#6366f1',
    parent_category_id: data.parentCategoryId
  })
}

// Assign contact to category
async function assignContactToCategory(
  contactId: string,
  categoryId: string
): Promise<void> {
  await db.contacts.update(contactId, {
    categories: db.raw('array_append(categories, ?)', [categoryId])
  })
}

// Remove contact from category
async function removeContactFromCategory(
  contactId: string,
  categoryId: string
): Promise<void> {
  await db.contacts.update(contactId, {
    categories: db.raw('array_remove(categories, ?)', [categoryId])
  })
}

// Get contacts by category
async function getContactsByCategory(
  tenantId: string,
  categoryId: string,
  limit: number = 50
): Promise<Contact[]> {
  return await db.contacts.findMany({
    where: {
      tenant_id: tenantId,
      categories: { contains: [categoryId] }
    },
    limit: limit,
    orderBy: { updated_at: 'desc' }
  })
}
```

### Nested Categories

**Example Hierarchy**:
```
VCs
├── Seed Stage VCs
│   ├── San Francisco VCs
│   └── New York VCs
├── Series A VCs
└── Corporate VCs
```

**UI Implementation**:
- Sidebar shows nested categories (expandable/collapsible)
- Drag-and-drop to reorder or nest
- Breadcrumbs show hierarchy (VCs > Seed Stage VCs > San Francisco VCs)

---

## 3.2 15+ Source Sync Architecture

### Overview

**Problem**: Contacts are scattered across LinkedIn, email, phone, Twitter, meetings, etc.

**Solution**: Connect all 15+ sources, auto-sync contacts, deduplicate, enrich.

### Supported Sources

**Social Platforms** (7):
1. LinkedIn (OAuth → access profile, connections)
2. Twitter/X (OAuth → followers, following, DMs)
3. Instagram (OAuth → followers, following)
4. Facebook (OAuth → friends, page contacts)
5. TikTok (OAuth → followers, collaborations)
6. YouTube (OAuth → subscribers, collaborators)
7. GitHub (OAuth → followers, stars, contributors)

**Email & Contacts** (4):
8. Gmail (OAuth → contacts, email history)
9. Outlook (OAuth → contacts, email history)
10. Google Contacts (OAuth → contacts)
11. Apple Contacts (iCloud OAuth → contacts)

**CRM Platforms** (3):
12. Salesforce (OAuth → contacts, leads, opportunities)
13. HubSpot (OAuth → contacts, deals)
14. Pipedrive (OAuth → contacts, deals)

**Meeting Platforms** (3):
15. Zoom (OAuth → meeting participants)
16. Google Meet (OAuth → meeting participants)
17. Microsoft Teams (OAuth → meeting participants)

**Data Providers** (2):
18. Apollo.io (API → wholesale lead import)
19. ZoomInfo (API → wholesale lead import)

### Sync Architecture

**Sync Flow**:
1. User connects source (OAuth 2.0)
2. Store access token + refresh token
3. Initial sync (import all contacts)
4. Deduplication (merge with existing contacts)
5. Enrichment (AI fills missing fields)
6. Scheduled sync (hourly, daily, weekly, or manual)

**Sync Strategy**:
- **Realtime**: LinkedIn, email (websocket/webhook)
- **Hourly**: Meeting platforms (Zoom, Google Meet, Teams)
- **Daily**: Social platforms (Twitter, Instagram)
- **Weekly**: CRM platforms (Salesforce, HubSpot)
- **Manual**: Data providers (Apollo, ZoomInfo)

### Deduplication Logic

```typescript
// Find duplicate contacts
async function findDuplicates(
  tenantId: string,
  contact: Partial<Contact>
): Promise<Contact[]> {
  const duplicates: Contact[] = []

  // Strategy 1: Exact email match
  if (contact.email) {
    const emailMatch = await db.contacts.findFirst({
      where: {
        tenant_id: tenantId,
        email: contact.email
      }
    })
    if (emailMatch) duplicates.push(emailMatch)
  }

  // Strategy 2: Exact phone match
  if (contact.phone) {
    const phoneMatch = await db.contacts.findFirst({
      where: {
        tenant_id: tenantId,
        phone: normalizePhone(contact.phone)
      }
    })
    if (phoneMatch && !duplicates.includes(phoneMatch)) {
      duplicates.push(phoneMatch)
    }
  }

  // Strategy 3: LinkedIn URL match
  if (contact.linkedin_url) {
    const linkedinMatch = await db.contacts.findFirst({
      where: {
        tenant_id: tenantId,
        linkedin_url: contact.linkedin_url
      }
    })
    if (linkedinMatch && !duplicates.includes(linkedinMatch)) {
      duplicates.push(linkedinMatch)
    }
  }

  // Strategy 4: Fuzzy name + company match
  if (contact.first_name && contact.last_name && contact.company) {
    const fuzzyMatches = await db.query(`
      SELECT * FROM contacts
      WHERE tenant_id = $1
      AND similarity(first_name, $2) > 0.7
      AND similarity(last_name, $3) > 0.7
      AND similarity(company, $4) > 0.7
      LIMIT 5
    `, [tenantId, contact.first_name, contact.last_name, contact.company])

    for (const match of fuzzyMatches) {
      if (!duplicates.includes(match)) {
        duplicates.push(match)
      }
    }
  }

  return duplicates
}

// Merge contacts
async function mergeContacts(
  primaryContactId: string,
  secondaryContactId: string
): Promise<Contact> {
  const primary = await db.contacts.findById(primaryContactId)
  const secondary = await db.contacts.findById(secondaryContactId)

  // Merge logic: keep non-null fields from both
  const merged = {
    ...primary,
    email: primary.email || secondary.email,
    phone: primary.phone || secondary.phone,
    linkedin_url: primary.linkedin_url || secondary.linkedin_url,
    twitter_url: primary.twitter_url || secondary.twitter_url,
    company: primary.company || secondary.company,
    title: primary.title || secondary.title,
    bio: primary.bio || secondary.bio,
    notes: `${primary.notes || ''}\n\n${secondary.notes || ''}`.trim(),
    tags: Array.from(new Set([...primary.tags, ...secondary.tags])),
    categories: Array.from(new Set([...primary.categories, ...secondary.categories])),
    custom_fields: { ...secondary.custom_fields, ...primary.custom_fields }
  }

  // Update primary contact
  await db.contacts.update(primaryContactId, merged)

  // Delete secondary contact
  await db.contacts.delete(secondaryContactId)

  // Update references (activities, emails, etc.)
  await db.activities.updateMany(
    { contact_id: secondaryContactId },
    { contact_id: primaryContactId }
  )

  return merged
}
```

---

## 3.3 Browser Extension (Smart Capture)

### Overview

**Problem**: Manually copy-pasting contact info from LinkedIn, Twitter, websites is tedious.

**Solution**: Chrome extension - hover over any contact → click "Add to ReachCraft" → auto-captured.

### Extension Features

**1. One-Click Capture**:
- Hover over LinkedIn profile → extension detects name, title, company
- Click extension icon → contact added to ReachCraft
- Auto-categorizes based on context (e.g., LinkedIn → "LinkedIn Connections")

**2. Bulk Capture**:
- On LinkedIn search results page → extension detects all 10 results
- Click "Capture All" → all 10 contacts added
- Works on: LinkedIn search, Twitter followers, Instagram followers, email inbox

**3. Smart Detection**:
- Extension uses AI to extract contact info from any website
- Example: Random blog → detects author name, email in footer → captures
- Example: Company website → detects team members → captures

**4. Auto-Enrichment**:
- After capture, extension triggers AI enrichment
- Fills in missing email, phone, social profiles
- Lead scoring applied automatically

### Extension Architecture

**Technology**:
- Manifest V3 (latest Chrome extension API)
- React + TypeScript (UI)
- Content scripts (detect contacts on page)
- Background service worker (API calls)
- Popup UI (quick actions)

**Content Script (LinkedIn)**:
```typescript
// content-script-linkedin.ts
// Detects LinkedIn profile data from DOM

function extractLinkedInProfile(): ContactData {
  const name = document.querySelector('.pv-text-details__title')?.textContent
  const title = document.querySelector('.pv-text-details__subtitle')?.textContent
  const company = document.querySelector('.pv-text-details__company')?.textContent
  const location = document.querySelector('.pv-text-details__location')?.textContent
  const about = document.querySelector('.pv-about__summary-text')?.textContent
  const profile_url = window.location.href

  return {
    first_name: name?.split(' ')[0],
    last_name: name?.split(' ').slice(1).join(' '),
    title,
    company,
    location,
    bio: about,
    linkedin_url: profile_url
  }
}

// Listen for extension icon click
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'captureContact') {
    const contact = extractLinkedInProfile()

    // Send to background script
    chrome.runtime.sendMessage({
      action: 'saveContact',
      data: contact
    })

    // Show success toast
    showToast('Contact captured! View in ReachCraft.')
  }
})
```

**Background Service Worker**:
```typescript
// background.ts
// Handles API calls to ReachCraft backend

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'saveContact') {
    saveContactToReachCraft(request.data)
      .then(() => sendResponse({ success: true }))
      .catch(err => sendResponse({ success: false, error: err.message }))

    return true // Keep channel open for async response
  }
})

async function saveContactToReachCraft(contact: ContactData) {
  const authToken = await getAuthToken()

  const response = await fetch('https://api.reachcraft.com/v1/contacts', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${authToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(contact)
  })

  if (!response.ok) {
    throw new Error('Failed to save contact')
  }

  return await response.json()
}
```

**Popup UI**:
```typescript
// popup.tsx
// Quick actions UI

export function Popup() {
  return (
    <div className="w-80 p-4">
      <header className="mb-4">
        <Logo />
        <h1 className="text-lg font-bold">ReachCraft</h1>
      </header>

      <button
        onClick={captureCurrentPage}
        className="w-full bg-blue-600 text-white py-2 rounded"
      >
        Capture Contact
      </button>

      <div className="mt-4 text-sm text-gray-600">
        <p>Detected: <strong>Sarah Martinez</strong></p>
        <p>Title: VP Marketing at Acme Inc</p>
      </div>

      <footer className="mt-4 text-xs text-gray-500">
        <a href="https://app.reachcraft.com">Open ReachCraft</a>
      </footer>
    </div>
  )
}
```

---

## 3.4 AI Enrichment Pipeline

### Overview

**Problem**: Contacts are missing email, phone, company, title, bio.

**Solution**: AI enrichment - user clicks "Enrich" → AI finds missing data in seconds.

### Enrichment Strategy

**3-Tier Enrichment**:

**Tier 1: Free (AI-Only)** ($0.10/contact)
- Claude 3.5 Sonnet searches public data
- Sources: LinkedIn, Twitter, company websites, Google
- Fills: Email (guess based on pattern), phone (if on website), bio, social profiles
- Accuracy: 70-80%
- Speed: 5-10 seconds per contact

**Tier 2: Standard (AI + API)** ($0.50/contact)
- Tier 1 + ZeroBounce email verification
- Tier 1 + Twilio phone lookup
- Accuracy: 85-90%
- Speed: 10-15 seconds per contact

**Tier 3: Premium (API-Only)** ($1.50/contact)
- Apollo.io API or ZoomInfo API
- Guaranteed accurate data
- Accuracy: 95-99%
- Speed: 2-3 seconds per contact (API is instant)

### AI Enrichment Pipeline

```typescript
// Enrich contact using AI
async function enrichContactWithAI(
  contactId: string
): Promise<EnrichmentResult> {
  const contact = await db.contacts.findById(contactId)

  // Build enrichment prompt
  const prompt = `
    You are a contact enrichment AI. Given the following partial contact information, find and fill in missing fields.

    Current Info:
    - Name: ${contact.first_name} ${contact.last_name}
    - Company: ${contact.company || 'Unknown'}
    - Title: ${contact.title || 'Unknown'}
    - LinkedIn: ${contact.linkedin_url || 'Unknown'}

    Tasks:
    1. If email is missing, guess it based on company email pattern (firstname@company.com, f.lastname@company.com, etc.)
    2. If phone is missing, search company website for phone number
    3. If bio is missing, summarize their LinkedIn profile (if URL provided)
    4. If social profiles are missing, search for Twitter, Instagram, Facebook

    Return JSON:
    {
      "email": "sarah@acme.com",
      "email_confidence": 75,
      "phone": "+1-303-555-1234",
      "phone_confidence": 60,
      "bio": "VP Marketing at Acme Inc, 10+ years in B2B SaaS",
      "twitter_url": "https://twitter.com/sarahmartinez",
      "instagram_url": "https://instagram.com/sarahmartinez",
      "confidence_score": 70
    }
  `

  // Call Claude API
  const response = await anthropic.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 1024,
    messages: [{
      role: 'user',
      content: prompt
    }]
  })

  const enrichedData = JSON.parse(response.content[0].text)

  // Save enrichment to database
  await db.enrichments.create({
    tenant_id: contact.tenant_id,
    contact_id: contactId,
    enrichment_type: 'full_profile',
    provider: 'ai_claude',
    cost: 0.10,
    input_data: { first_name: contact.first_name, last_name: contact.last_name, company: contact.company },
    output_data: enrichedData,
    confidence_score: enrichedData.confidence_score,
    status: 'success'
  })

  // Update contact
  await db.contacts.update(contactId, {
    email: enrichedData.email || contact.email,
    phone: enrichedData.phone || contact.phone,
    bio: enrichedData.bio || contact.bio,
    twitter_url: enrichedData.twitter_url || contact.twitter_url,
    instagram_url: enrichedData.instagram_url || contact.instagram_url,
    enriched: true,
    enriched_at: new Date(),
    enrichment_source: 'ai_claude',
    enrichment_cost: 0.10
  })

  return enrichedData
}

// Bulk enrichment (100 contacts)
async function bulkEnrich(
  tenantId: string,
  contactIds: string[],
  tier: 'free' | 'standard' | 'premium'
): Promise<void> {
  // Use BullMQ job queue for parallel processing
  for (const contactId of contactIds) {
    await enrichmentQueue.add('enrich', {
      tenant_id: tenantId,
      contact_id: contactId,
      tier: tier
    })
  }
}

// BullMQ worker (processes enrichment jobs in parallel)
enrichmentQueue.process('enrich', async (job) => {
  const { tenant_id, contact_id, tier } = job.data

  try {
    if (tier === 'free') {
      await enrichContactWithAI(contact_id)
    } else if (tier === 'standard') {
      await enrichContactWithAI(contact_id)
      await verifyEmailWithZeroBounce(contact_id)
      await verifyPhoneWithTwilio(contact_id)
    } else if (tier === 'premium') {
      await enrichContactWithApollo(contact_id)
    }

    return { success: true }
  } catch (error) {
    return { success: false, error: error.message }
  }
})
```

---

## 3.5 Meeting Intelligence Integration

### Overview

**Problem**: After Zoom/Google Meet/Teams meetings, users manually add attendees to CRM.

**Solution**: Auto-capture meeting attendees → add to ReachCraft → enrich → categorize.

### Supported Platforms

1. **Zoom** (OAuth → Zoom API → meeting participants)
2. **Google Meet** (OAuth → Google Calendar API → attendee list)
3. **Microsoft Teams** (OAuth → Microsoft Graph API → meeting participants)

### Meeting Intelligence Flow

```typescript
// Step 1: Connect Zoom (OAuth)
async function connectZoom(userId: string, authCode: string) {
  // Exchange auth code for access token
  const tokens = await zoomOAuth.getTokens(authCode)

  // Save tokens
  await db.sourceSyncs.create({
    tenant_id: userId,
    user_id: userId,
    source_type: 'zoom',
    connected: true,
    access_token: tokens.access_token,
    refresh_token: tokens.refresh_token,
    token_expires_at: new Date(Date.now() + tokens.expires_in * 1000),
    sync_frequency: 'realtime'
  })

  // Set up webhook to receive meeting events
  await zoomAPI.createWebhook({
    url: 'https://api.reachcraft.com/webhooks/zoom',
    events: ['meeting.ended']
  })
}

// Step 2: Receive webhook when meeting ends
app.post('/webhooks/zoom', async (req, res) => {
  const event = req.body

  if (event.event === 'meeting.ended') {
    const meetingId = event.payload.object.id
    const userId = event.payload.object.host_id

    // Queue job to process meeting
    await meetingQueue.add('processMeeting', {
      platform: 'zoom',
      meeting_id: meetingId,
      user_id: userId
    })
  }

  res.sendStatus(200)
})

// Step 3: Process meeting (fetch participants, enrich, add to CRM)
meetingQueue.process('processMeeting', async (job) => {
  const { platform, meeting_id, user_id } = job.data

  // Fetch meeting details from Zoom API
  const meeting = await zoomAPI.getMeeting(meeting_id)
  const participants = await zoomAPI.getMeetingParticipants(meeting_id)

  // Create meeting record
  const meetingRecord = await db.meetings.create({
    tenant_id: user_id,
    user_id: user_id,
    source: platform,
    source_meeting_id: meeting_id,
    title: meeting.topic,
    start_time: meeting.start_time,
    end_time: new Date(Date.now()), // Ended now
    duration_minutes: meeting.duration,
    meeting_url: meeting.join_url
  })

  // Process each participant
  const contactIds: string[] = []
  for (const participant of participants) {
    // Check if contact already exists
    let contact = await db.contacts.findFirst({
      where: {
        tenant_id: user_id,
        email: participant.email
      }
    })

    // If not, create new contact
    if (!contact) {
      contact = await db.contacts.create({
        tenant_id: user_id,
        user_id: user_id,
        first_name: participant.name.split(' ')[0],
        last_name: participant.name.split(' ').slice(1).join(' '),
        email: participant.email,
        upload_source: 'meeting',
        upload_date: new Date()
      })

      // Enrich contact (async)
      await enrichmentQueue.add('enrich', {
        tenant_id: user_id,
        contact_id: contact.id,
        tier: 'free'
      })
    }

    contactIds.push(contact.id)
  }

  // Update meeting with attendees
  await db.meetings.update(meetingRecord.id, {
    attendees: contactIds
  })

  // Send notification to user
  await sendNotification(user_id, {
    type: 'meeting_processed',
    title: 'Meeting attendees captured',
    message: `${participants.length} contacts added from "${meeting.topic}"`
  })
})
```

---

## 3.6 Lead Intelligence Profiler

### Overview

**Problem**: Users don't know which leads to contact first, or how to approach them.

**Solution**: Lead Intelligence Profiler - AI analyzes contact's communication style, personality, buying signals → recommends approach.

### Profiler Dimensions (from InterviewPlus)

**1. Communication Style**:
- Analytical (data-driven, logical)
- Relational (people-first, emotional)
- Direct (brief, to-the-point)
- Expressive (storytelling, creative)

**2. Decision-Making Style**:
- Data-driven (needs ROI, case studies)
- Consensus (needs team buy-in)
- Intuitive (goes with gut feeling)
- Risk-averse (needs guarantees)

**3. Personality Traits** (Big Five):
- Extraversion (0-100 score)
- Openness (0-100 score)
- Conscientiousness (0-100 score)
- Agreeableness (0-100 score)
- Neuroticism (0-100 score)

**4. Buying Signals**:
- Visited pricing page
- Downloaded whitepaper
- Replied to cold email
- Attended webinar
- Follows on LinkedIn
- Commented on post

**5. Pain Points** (extracted from conversations/social media):
- "We need better lead generation"
- "Our CRM is too expensive"
- "Manual data entry is killing us"

**6. Interests** (extracted from social media):
- AI/ML
- Startups
- Marketing automation
- Remote work

### Profiler AI Pipeline

```typescript
// Generate lead profile using AI
async function generateLeadProfile(
  contactId: string
): Promise<LeadProfile> {
  const contact = await db.contacts.findById(contactId)

  // Gather all data sources
  const linkedinProfile = await scrapeLinkedInProfile(contact.linkedin_url)
  const twitterPosts = await scrapeTwitterPosts(contact.twitter_url)
  const emailHistory = await db.emails.findMany({ contact_id: contactId })
  const meetingNotes = await db.meetings.findMany({ attendees: [contactId] })

  // Build profiler prompt
  const prompt = `
    You are a lead intelligence AI. Analyze the following data about a contact and generate a comprehensive profile.

    Contact: ${contact.first_name} ${contact.last_name}
    Company: ${contact.company}
    Title: ${contact.title}

    LinkedIn Bio: ${linkedinProfile?.about}
    LinkedIn Posts: ${linkedinProfile?.recent_posts.slice(0, 5).join('\n')}

    Twitter Bio: ${twitterPosts?.bio}
    Recent Tweets: ${twitterPosts?.tweets.slice(0, 10).join('\n')}

    Email History: ${emailHistory.map(e => e.body).join('\n')}

    Meeting Notes: ${meetingNotes.map(m => m.action_items).join('\n')}

    Tasks:
    1. Determine communication style (analytical, relational, direct, expressive)
    2. Determine decision-making style (data-driven, consensus, intuitive, risk-averse)
    3. Score Big Five personality traits (0-100)
    4. Extract buying signals (list)
    5. Extract pain points (list)
    6. Extract interests (list)
    7. Recommend best channel to contact (email, phone, LinkedIn, Twitter)
    8. Recommend best time to contact
    9. Generate AI summary (1-2 sentences)
    10. Generate recommended approach (3-4 sentences)

    Return JSON.
  `

  // Call Claude API
  const response = await anthropic.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 2048,
    messages: [{
      role: 'user',
      content: prompt
    }]
  })

  const profile = JSON.parse(response.content[0].text)

  // Save profile to database
  await db.leadProfiles.upsert({
    contact_id: contactId,
    tenant_id: contact.tenant_id,
    communication_style: profile.communication_style,
    decision_making: profile.decision_making,
    personality_traits: profile.personality_traits,
    buying_signals: profile.buying_signals,
    pain_points: profile.pain_points,
    interests: profile.interests,
    preferred_channel: profile.preferred_channel,
    best_time_to_contact: profile.best_time_to_contact,
    ai_summary: profile.ai_summary,
    recommended_approach: profile.recommended_approach
  })

  return profile
}
```

---

## 3.7 Automation System

### Overview

**Problem**: Users manually send emails, create tasks, update fields.

**Solution**: Workflow automation - trigger-action system (Zapier-style).

### Automation Triggers

**Contact Triggers**:
- Contact created
- Contact added to category
- Contact tagged
- Contact lead score changes
- Contact email verified
- Contact enriched

**Activity Triggers**:
- Email opened
- Email clicked
- Email replied
- Meeting scheduled
- Meeting completed
- Phone call logged

**Time Triggers**:
- Scheduled (daily, weekly, monthly)
- Delay (wait 3 days after contact created)

### Automation Actions

**Contact Actions**:
- Add to category
- Remove from category
- Add tag
- Remove tag
- Update field
- Update lead score
- Enrich contact

**Communication Actions**:
- Send email (from template)
- Send SMS
- Send LinkedIn message
- Create task
- Create reminder

**Integration Actions**:
- Add to Salesforce
- Add to HubSpot
- Post to Slack
- Send webhook

### Automation Builder UI

```typescript
// Example automation: "When contact added to 'Hot Leads', send email and create task"
interface Automation {
  id: string
  tenant_id: string
  name: string
  enabled: boolean

  trigger: {
    type: 'contact.added_to_category'
    config: {
      category_id: 'hot-leads-category-id'
    }
  }

  actions: [
    {
      type: 'send_email'
      config: {
        template_id: 'intro-email-template-id'
        from: 'user@example.com'
        delay_minutes: 0
      }
    },
    {
      type: 'create_task'
      config: {
        title: 'Follow up with {{contact.first_name}}'
        due_date: '+3 days'
        assigned_to: 'me'
      }
    },
    {
      type: 'update_contact_field'
      config: {
        field: 'lead_stage'
        value: 'warm'
      }
    }
  ]
}

// Automation execution
async function executeAutomation(
  automationId: string,
  contactId: string
): Promise<void> {
  const automation = await db.automations.findById(automationId)
  const contact = await db.contacts.findById(contactId)

  // Log automation run
  const run = await db.automationRuns.create({
    automation_id: automationId,
    contact_id: contactId,
    status: 'running',
    started_at: new Date()
  })

  try {
    // Execute each action sequentially
    for (const action of automation.actions) {
      if (action.type === 'send_email') {
        await sendEmailAction(contact, action.config)
      } else if (action.type === 'create_task') {
        await createTaskAction(contact, action.config)
      } else if (action.type === 'update_contact_field') {
        await updateContactFieldAction(contact, action.config)
      }

      // Respect delay
      if (action.delay_minutes > 0) {
        await sleep(action.delay_minutes * 60 * 1000)
      }
    }

    // Mark run as completed
    await db.automationRuns.update(run.id, {
      status: 'completed',
      completed_at: new Date()
    })
  } catch (error) {
    // Mark run as failed
    await db.automationRuns.update(run.id, {
      status: 'failed',
      error_message: error.message,
      completed_at: new Date()
    })
  }
}
```

---

## 3.8 Search & Filtering

### Search Capabilities

**Full-Text Search**:
- Search name, email, company, title, notes
- Uses PostgreSQL `tsvector` (full-text search index)
- Fast (< 50ms for 10M contacts)

**Filters**:
- Category (e.g., "VCs")
- Tag (e.g., "warm lead")
- Lead score (e.g., "> 70")
- Lead stage (e.g., "hot")
- Date added (e.g., "last 30 days")
- Enriched (yes/no)
- Email verified (yes/no)
- Source (e.g., "LinkedIn", "meeting")

**Advanced Filters**:
- Boolean logic (AND, OR, NOT)
- Custom fields (e.g., "budget > $10K")
- Saved filters (reusable)

### Search UI

```typescript
// Search component
function ContactSearch() {
  const [query, setQuery] = useState('')
  const [filters, setFilters] = useState({})

  const { data: contacts, isLoading } = useQuery({
    queryKey: ['contacts', query, filters],
    queryFn: () => searchContacts(query, filters)
  })

  return (
    <div className="search">
      <input
        type="text"
        placeholder="Search contacts..."
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />

      <FilterBar>
        <FilterSelect label="Category" options={categories} onChange={(v) => setFilters({ ...filters, category: v })} />
        <FilterSelect label="Lead Score" options={['> 70', '50-70', '< 50']} onChange={(v) => setFilters({ ...filters, lead_score: v })} />
        <FilterSelect label="Added" options={['Last 7 days', 'Last 30 days', 'Last 90 days']} onChange={(v) => setFilters({ ...filters, added: v })} />
      </FilterBar>

      {isLoading ? (
        <Spinner />
      ) : (
        <ContactList contacts={contacts} />
      )}
    </div>
  )
}
```

---

## 3.9 Bulk Operations

### Supported Bulk Operations

**Bulk Actions**:
- Add to category (select 100 contacts → add to "VCs")
- Remove from category
- Add tag
- Remove tag
- Delete contacts
- Export to CSV
- Enrich (AI or API)
- Update field (e.g., set lead_stage = "cold")

**Bulk Import**:
- CSV import (up to 10,000 contacts per file)
- Excel import (.xlsx)
- Google Sheets import (OAuth)
- Salesforce import (OAuth)
- HubSpot import (OAuth)

### Bulk Operation UI

```typescript
// Bulk operations component
function BulkOperations({ selectedContactIds }: { selectedContactIds: string[] }) {
  const [action, setAction] = useState<string | null>(null)

  return (
    <div className="bulk-operations">
      <p>{selectedContactIds.length} contacts selected</p>

      <button onClick={() => setAction('add_to_category')}>Add to Category</button>
      <button onClick={() => setAction('add_tag')}>Add Tag</button>
      <button onClick={() => setAction('enrich')}>Enrich</button>
      <button onClick={() => setAction('export')}>Export CSV</button>
      <button onClick={() => setAction('delete')}>Delete</button>

      {action === 'add_to_category' && (
        <CategoryPicker onSelect={async (categoryId) => {
          await bulkAddToCategory(selectedContactIds, categoryId)
          toast.success('Added to category!')
        }} />
      )}

      {action === 'enrich' && (
        <EnrichModal
          contactCount={selectedContactIds.length}
          onConfirm={async (tier) => {
            await bulkEnrich(selectedContactIds, tier)
            toast.success('Enrichment started!')
          }}
        />
      )}
    </div>
  )
}

// Bulk API endpoint
app.post('/api/contacts/bulk', async (req, res) => {
  const { contact_ids, action, config } = req.body

  if (action === 'add_to_category') {
    await db.contacts.updateMany(
      { id: { in: contact_ids } },
      { categories: db.raw('array_append(categories, ?)', [config.category_id]) }
    )
  } else if (action === 'add_tag') {
    await db.contacts.updateMany(
      { id: { in: contact_ids } },
      { tags: db.raw('array_append(tags, ?)', [config.tag]) }
    )
  } else if (action === 'enrich') {
    await bulkEnrich(req.user.tenant_id, contact_ids, config.tier)
  }

  res.json({ success: true })
})
```

---

## 3.10 Import/Export System

### Import Formats

**CSV Import**:
- Supports standard columns (first_name, last_name, email, phone, company, title)
- Auto-maps columns (detects "First Name" → first_name)
- Deduplication (skips existing contacts)
- Preview (shows first 10 rows before import)
- Validation (highlights errors before import)

**Excel Import** (.xlsx):
- Same as CSV, supports multiple sheets
- Imports first sheet by default, user can choose

**Google Sheets Import**:
- OAuth to Google Drive
- Select sheet → import
- Realtime sync option (updates CRM when sheet changes)

**Salesforce/HubSpot Import**:
- OAuth to Salesforce/HubSpot
- Select object (Contacts, Leads, Opportunities)
- One-time import or scheduled sync

### Export Formats

**CSV Export**:
- Export all contacts or filtered subset
- Choose columns (default: name, email, phone, company, title)
- Download as .csv file

**Excel Export** (.xlsx):
- Same as CSV, but .xlsx format

**Google Sheets Export**:
- OAuth to Google Drive
- Creates new sheet with contacts
- Realtime sync option

**API Export**:
- Generate API key → programmatic access
- REST API or GraphQL

### Import UI Flow

```typescript
// Step 1: Upload CSV
function ImportStep1() {
  return (
    <div className="import-step-1">
      <h2>Import Contacts</h2>
      <p>Upload a CSV or Excel file (max 10,000 contacts)</p>

      <FileUpload
        accept=".csv,.xlsx"
        onUpload={(file) => {
          parseCSV(file).then(data => {
            navigate('/import/step2', { state: { data } })
          })
        }}
      />
    </div>
  )
}

// Step 2: Map columns
function ImportStep2({ data }: { data: any[] }) {
  const [columnMapping, setColumnMapping] = useState({})

  return (
    <div className="import-step-2">
      <h2>Map Columns</h2>
      <p>Match your CSV columns to ReachCraft fields</p>

      <table>
        <thead>
          <tr>
            <th>Your Column</th>
            <th>Maps To</th>
            <th>Sample Data</th>
          </tr>
        </thead>
        <tbody>
          {Object.keys(data[0]).map(col => (
            <tr key={col}>
              <td>{col}</td>
              <td>
                <select onChange={(e) => setColumnMapping({ ...columnMapping, [col]: e.target.value })}>
                  <option value="">Skip</option>
                  <option value="first_name">First Name</option>
                  <option value="last_name">Last Name</option>
                  <option value="email">Email</option>
                  <option value="phone">Phone</option>
                  <option value="company">Company</option>
                  <option value="title">Title</option>
                </select>
              </td>
              <td>{data[0][col]}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <button onClick={() => navigate('/import/step3', { state: { data, columnMapping } })}>
        Next
      </button>
    </div>
  )
}

// Step 3: Preview & confirm
function ImportStep3({ data, columnMapping }: { data: any[]; columnMapping: any }) {
  return (
    <div className="import-step-3">
      <h2>Preview Import</h2>
      <p>We'll import {data.length} contacts. Duplicates will be skipped.</p>

      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Company</th>
          </tr>
        </thead>
        <tbody>
          {data.slice(0, 10).map((row, i) => (
            <tr key={i}>
              <td>{row[columnMapping.first_name]} {row[columnMapping.last_name]}</td>
              <td>{row[columnMapping.email]}</td>
              <td>{row[columnMapping.company]}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <button onClick={async () => {
        await importContacts(data, columnMapping)
        toast.success('Import complete!')
        navigate('/contacts')
      }}>
        Import {data.length} Contacts
      </button>
    </div>
  )
}
```

---

# PART 4: VERTICAL SPECIFICATIONS

## 4.1 PRO ($79/mo) - General CRM

### Target Audience
- Freelancers, consultants, small business owners
- Need: Manage client relationships, track deals, organize contacts
- Pain: Salesforce too expensive ($150/seat), HubSpot too complex

### Unique Features (Feature Flags)
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  meeting_intelligence: true,
  lead_profiler: true,
  email_campaigns: true,
  automation: true,
  api_access: true,
  pipelines: true,
  deals: true,
  custom_fields: true,

  // Disabled features
  data_marketplace: false,
  ai_jobs_marketplace: false,
  influencer_marketplace: false,
  auto_pilot_scraping: false,
  white_label: false
}
```

### Default Categories
- Clients
- Prospects
- Partners
- Vendors
- Personal Network

### Pricing Model
- **Monthly**: $79/month
- **Annual**: $790/year ($65.83/month, save 17%)
- **Included**: 10,000 contacts, 5 team members, 50,000 AI enrichments/year
- **Add-ons**: Extra enrichments ($0.10/contact), extra team members ($15/month/user)

---

## 4.2 MEDIA ($149/mo) - PR CRM

### Target Audience
- PR professionals, publicists, media relations managers
- Need: Manage journalist relationships, track media coverage, pitch tracking
- Pain: Cision/Meltwater too expensive ($5K/month), no CRM integration

### Unique Features
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  meeting_intelligence: true,
  influencer_marketplace: true, // MEDIA-specific
  email_campaigns: true,
  automation: true,
  api_access: true,
  media_monitoring: true, // MEDIA-specific
  pitch_tracking: true, // MEDIA-specific

  // Disabled features
  lead_profiler: false,
  data_marketplace: false,
  ai_jobs_marketplace: false,
  auto_pilot_scraping: false,
  white_label: false
}
```

### Default Categories
- Tier 1 Media (NYT, WSJ, Bloomberg)
- Tier 2 Media (TechCrunch, Forbes, Business Insider)
- Podcasters
- Influencers (1M+ followers)
- Bloggers
- Warm Relationships

### Media-Specific Fields
- **Publication**: Which outlet they write for
- **Beat**: What topics they cover (tech, healthcare, finance)
- **Deadline**: When they need stories (daily, weekly, monthly)
- **Response Rate**: How often they respond to pitches
- **Coverage History**: Articles they've written about you/clients

### Pricing Model
- **Monthly**: $149/month
- **Annual**: $1,490/year ($124.17/month, save 17%)
- **Included**: 25,000 contacts, 10 team members, 100,000 AI enrichments/year
- **Add-ons**: Media monitoring ($299/month for 100 mentions), influencer marketplace access (free, 15% commission)

---

## 4.3 FUNDRAISE ($199/mo) - VC CRM

### Target Audience
- Founders raising capital (seed, Series A, Series B)
- Need: Track VC relationships, warm intros, pitch tracking, term sheet comparison
- Pain: Notion/Airtable too manual, no warm intro tracking

### Unique Features
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  meeting_intelligence: true,
  warm_intro_tracking: true, // FUNDRAISE-specific
  pitch_tracking: true, // FUNDRAISE-specific
  term_sheet_comparison: true, // FUNDRAISE-specific
  email_campaigns: true,
  automation: true,
  api_access: true,

  // Disabled features
  lead_profiler: false,
  data_marketplace: false,
  ai_jobs_marketplace: false,
  influencer_marketplace: false,
  auto_pilot_scraping: false,
  white_label: false
}
```

### Default Categories
- Seed VCs
- Series A VCs
- Series B+ VCs
- Angel Investors
- Warm Intros (who can introduce you)
- Pass (rejected)
- Term Sheets Received

### Fundraise-Specific Fields
- **Check Size**: $50K, $500K, $2M (typical investment amount)
- **Stage Focus**: Pre-seed, Seed, Series A, Series B+
- **Sector Focus**: SaaS, AI/ML, FinTech, Healthcare
- **Portfolio Companies**: Which companies they've invested in
- **Response Time**: How long they take to respond (3 days, 1 week, 2 weeks)
- **Meeting Status**: Cold outreach, Intro requested, First meeting, Partner meeting, Term sheet, Passed

### Warm Intro Tracking
```typescript
interface WarmIntroPath {
  vc_contact_id: string
  intro_path: Array<{
    person_name: string
    person_contact_id: string
    relationship_strength: 'strong' | 'medium' | 'weak'
    intro_likelihood: number // 0-100
  }>
  best_intro_path: string // "You → Sarah (strong) → John (medium) → VC Partner"
}
```

### Pricing Model
- **Monthly**: $199/month
- **Annual**: $1,990/year ($165.83/month, save 17%)
- **Included**: 10,000 contacts, 3 team members (founder + 2 co-founders), 100,000 AI enrichments/year
- **Add-ons**: Term sheet comparison tool ($49/month), warm intro path finding (free)

---

## 4.4 CREATOR ($39/mo or $19/mo in marketplace) - Creator CRM

### Target Audience
- YouTubers, TikTokers, Instagrammers, podcasters, newsletter writers
- Need: Manage brand partnerships, track sponsorships, monetize audience database
- Pain: Brand deals negotiated offline (DMs, no tracking), no way to monetize contacts

### Unique Features
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  data_marketplace: true, // CREATOR-specific (monetize audience)
  ai_jobs_marketplace: true, // CREATOR-specific (introduce followers to jobs)
  influencer_marketplace: true, // CREATOR-specific (find brand deals)
  brand_deal_tracking: true, // CREATOR-specific
  email_campaigns: true,
  automation: true,

  // Disabled features
  meeting_intelligence: false,
  lead_profiler: false,
  auto_pilot_scraping: false,
  api_access: false,
  white_label: false
}
```

### Default Categories
- Active Sponsors (paying brands)
- Potential Sponsors (outreach targets)
- Fellow Creators (collaborations)
- Engaged Audience (1000+ interactions)
- Audience Database (all followers/subscribers)
- Managers/Agents

### Creator-Specific Fields
- **Platform**: YouTube, TikTok, Instagram, Twitter, Newsletter
- **Follower Count**: 10K, 100K, 1M
- **Engagement Rate**: 2.5%, 5%, 10%
- **Niche**: Tech, Beauty, Finance, Lifestyle
- **Sponsorship History**: Which brands they've worked with
- **Average Deal Size**: $500, $2K, $10K

### Monetization (Data Marketplace)
**Scenario**: Creator has 100K Instagram followers, uploads 10K engaged followers to ReachCraft.

**Revenue Potential**:
- 10,000 leads uploaded to Data Marketplace
- Average lead price: $1.00/lead
- Creator earns 50% = $0.50/lead
- Total: 10,000 × $0.50 = **$5,000 passive income**

**Ethical Guardrails**:
- Only upload engaged followers (not all 100K)
- Opt-out available on website
- GDPR-compliant (no EU followers)

### Pricing Model
- **Option A**: $39/month (full price)
- **Option B**: $19/month if creator uploads 1,000+ leads to Data Marketplace
- **Annual**: $390/year ($32.50/month, save 17%)
- **Included**: 25,000 contacts, 1 user, 25,000 AI enrichments/year
- **Add-ons**: Data marketplace (50% revenue share), AI Jobs marketplace (20% revenue share)

---

## 4.5 RECRUIT ($99/mo) - ATS & Job Seeker CRM

### Target Audience
- **Recruiters**: Need ATS to manage candidates, track applications, source talent
- **Job Seekers**: Need to track applications, find decision-makers, get referrals

### Unique Features
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  meeting_intelligence: true,
  lead_profiler: true, // RECRUIT-specific (candidate profiling)
  ai_jobs_marketplace: true, // RECRUIT-specific (find/post jobs)
  application_tracking: true, // RECRUIT-specific
  referral_tracking: true, // RECRUIT-specific
  email_campaigns: true,
  automation: true,
  api_access: true,

  // Disabled features
  data_marketplace: false,
  influencer_marketplace: false,
  auto_pilot_scraping: false,
  white_label: false
}
```

### Default Categories (Recruiters)
- Active Candidates
- Passive Candidates
- Warm Referrals
- Hired
- Rejected
- Hiring Managers
- Talent Partners

### Default Categories (Job Seekers)
- Applied (waiting for response)
- First Round (phone screen)
- Second Round (onsite)
- Final Round (offer negotiation)
- Rejected
- Decision Makers (who can hire me)
- Referrals (who can intro me)

### RECRUIT-Specific Fields (Recruiters)
- **Candidate Skills**: JavaScript, Python, Marketing, Sales
- **Years of Experience**: 0-2, 3-5, 6-10, 10+
- **Current Company**: Where they work now
- **Desired Salary**: $80K, $120K, $180K
- **Notice Period**: 2 weeks, 1 month, 3 months
- **Interview Status**: Applied, Phone screen, Onsite, Offer, Rejected

### RECRUIT-Specific Fields (Job Seekers)
- **Company Name**: Where I applied
- **Job Title**: Software Engineer, Marketing Manager
- **Application Date**: When I applied
- **Status**: Applied, Phone screen, Onsite, Offer, Rejected
- **Decision Maker**: Hiring manager contact
- **Referral**: Who introduced me

### AI Jobs Marketplace Integration
**For Recruiters**: Post jobs → AI matches candidates → earn $10/connection
**For Job Seekers**: Upload network → earn $10 when someone gets hired

### Pricing Model
- **Monthly**: $99/month
- **Annual**: $990/year ($82.50/month, save 17%)
- **Included**: 10,000 contacts, 5 team members, 50,000 AI enrichments/year
- **Add-ons**: AI Jobs marketplace (10% fee for job posters, 20% revenue share for referrers)

---

## 4.6 SALES ($129/mo) - Sales Prospecting CRM

### Target Audience
- Sales reps, SDRs, account executives, business development
- Need: Prospect database, auto-scraping, lead scoring, outreach automation
- Pain: Apollo $99/month but limited data, ZoomInfo $1.50/lead (expensive)

### Unique Features
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  meeting_intelligence: true,
  lead_profiler: true,
  data_marketplace: true, // SALES-specific (buy leads)
  auto_pilot_scraping: true, // SALES-specific (scrape leads)
  email_campaigns: true,
  automation: true,
  api_access: true,
  pipelines: true,
  deals: true,
  sales_sequences: true, // SALES-specific

  // Disabled features
  ai_jobs_marketplace: false,
  influencer_marketplace: false,
  white_label: false
}
```

### Default Categories
- Cold Leads (never contacted)
- Warm Leads (responded to cold email)
- Hot Leads (meeting scheduled)
- Customers (closed deal)
- Churned (lost customer)
- Unsubscribed
- Do Not Contact

### SALES-Specific Fields
- **Company Size**: 1-10, 11-50, 51-200, 201-1000, 1000+
- **Industry**: SaaS, Healthcare, FinTech, E-commerce
- **Revenue**: <$1M, $1-10M, $10-50M, $50M+
- **Tech Stack**: Salesforce, HubSpot, Marketo (what tools they use)
- **Intent Signals**: Visited pricing page, downloaded whitepaper, requested demo
- **Buying Stage**: Awareness, Consideration, Decision
- **Deal Size**: $5K, $25K, $100K (potential contract value)

### Auto-Pilot Scraping
**User Input**: "need leads for my medspa in boulder co"

**AI Output**:
1. Expands query → "Medical spa leads in Boulder, CO area, age 28-60, interested in anti-aging"
2. Scrapes Instagram, Facebook, Google/Yelp, Reddit
3. Finds 10,000-20,000 leads in 10-15 minutes
4. Auto-enriches with AI ($0.10/lead)
5. Scores leads (high intent = 90+, medium = 60-89, low = <60)
6. User reviews and approves

### Sales Sequences
```typescript
interface SalesSequence {
  name: string // "Cold Outreach Sequence"
  steps: Array<{
    type: 'email' | 'linkedin_message' | 'phone_call' | 'task'
    delay_days: number // Wait 3 days after previous step
    template: string // Email template with {{first_name}} variables
    stop_if: 'replied' | 'unsubscribed' | 'meeting_scheduled'
  }>
}

// Example sequence
{
  name: "Cold Outreach Sequence",
  steps: [
    {
      type: 'email',
      delay_days: 0,
      template: 'cold_email_template_1',
      stop_if: 'replied'
    },
    {
      type: 'linkedin_message',
      delay_days: 3,
      template: 'linkedin_follow_up',
      stop_if: 'replied'
    },
    {
      type: 'email',
      delay_days: 5,
      template: 'cold_email_template_2',
      stop_if: 'replied'
    },
    {
      type: 'phone_call',
      delay_days: 7,
      template: 'call_script',
      stop_if: 'meeting_scheduled'
    }
  ]
}
```

### Pricing Model
- **Monthly**: $129/month
- **Annual**: $1,290/year ($107.50/month, save 17%)
- **Included**: 25,000 contacts, 5 team members, 100,000 AI enrichments/year
- **Add-ons**: Data marketplace (buy leads $0.50-5.00/lead), Auto-pilot scraping ($0.10/lead enrichment)

---

## 4.7 AGENCY ($499/mo) - White-Label CRM

### Target Audience
- Marketing agencies, PR agencies, recruiting agencies
- Need: CRM for clients, white-label branding, sub-tenant management
- Pain: Building custom CRMs is expensive ($50K+), SaaS tools don't white-label

### Unique Features
```typescript
{
  // All features enabled
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  meeting_intelligence: true,
  lead_profiler: true,
  data_marketplace: true,
  influencer_marketplace: true,
  auto_pilot_scraping: true,
  email_campaigns: true,
  automation: true,
  api_access: true,
  pipelines: true,
  deals: true,

  // AGENCY-specific features
  white_label: true, // Custom branding, domain, logo
  sub_tenant_management: true, // Create clients, manage billing
  client_impersonation: true, // Login as client for support
  revenue_control: true // Agency keeps 100% of client fees
}
```

### White-Label Capabilities
- **Custom Branding**: Logo, colors, fonts
- **Custom Domain**: crm.agency.com (CNAME to ReachCraft)
- **Custom Email**: no-reply@agency.com (not @reachcraft.com)
- **Removal of ReachCraft Branding**: No "Powered by ReachCraft" footer

### Sub-Tenant Management
- Agency creates sub-tenants (clients)
- Each client has their own workspace, contacts, users
- Agency sets pricing (e.g., charge client $199/month, agency keeps 100%)
- Agency can impersonate client (for support)

### Revenue Model
**Example**:
- Agency subscribes to AGENCY tier: $499/month
- Agency creates 10 clients
- Agency charges each client $199/month
- **Agency Revenue**: 10 × $199 = $1,990/month
- **Agency Profit**: $1,990 - $499 = **$1,491/month profit**

**Scalability**:
- 50 clients = $9,950/month revenue - $499 = $9,451/month profit
- 100 clients = $19,900/month revenue - $499 = $19,401/month profit

### Pricing Model
- **Monthly**: $499/month
- **Annual**: $4,990/year ($415.83/month, save 17%)
- **Included**: Unlimited sub-tenants, white-label branding, custom domain, priority support
- **Add-ons**: None (all features included)

---

## 4.8 SOCIAL ($59/mo) - Social Media Manager CRM

### Target Audience
- Social media managers, community managers, influencer marketers
- Need: Manage followers, track engagement, influencer outreach
- Pain: Spreadsheets too manual, no CRM for social media

### Unique Features
```typescript
{
  contact_management: true,
  browser_extension: true,
  ai_enrichment: true,
  influencer_marketplace: true, // SOCIAL-specific
  engagement_tracking: true, // SOCIAL-specific
  dm_management: true, // SOCIAL-specific
  email_campaigns: true,
  automation: true,

  // Disabled features
  meeting_intelligence: false,
  lead_profiler: false,
  data_marketplace: false,
  ai_jobs_marketplace: false,
  auto_pilot_scraping: false,
  api_access: false,
  white_label: false
}
```

### Default Categories
- Top Engagers (1000+ interactions)
- Influencers (10K+ followers)
- Brand Partners
- UGC Creators (user-generated content)
- Collaborators
- Community Members
- Unresponsive (no engagement in 90 days)

### SOCIAL-Specific Fields
- **Platform**: Instagram, TikTok, Twitter, YouTube
- **Follower Count**: 1K, 10K, 100K, 1M
- **Engagement Rate**: 1%, 5%, 10%
- **Niche**: Beauty, Tech, Finance, Lifestyle
- **Last Interaction Date**: When they last commented/DM'd
- **Collaboration Type**: Paid post, gifted, affiliate

### Engagement Tracking
```typescript
interface EngagementHistory {
  contact_id: string
  total_interactions: number // Likes + comments + DMs
  recent_interactions: Array<{
    date: Date
    type: 'like' | 'comment' | 'dm' | 'share'
    content: string
    platform: 'instagram' | 'tiktok' | 'twitter' | 'youtube'
  }>
  engagement_score: number // 0-100 (based on frequency + recency)
}
```

### Pricing Model
- **Monthly**: $59/month
- **Annual**: $590/year ($49.17/month, save 17%)
- **Included**: 10,000 contacts, 2 team members, 25,000 AI enrichments/year
- **Add-ons**: Influencer marketplace (15% commission on brand deals)

---

# PART 5: MARKETPLACE SYSTEMS

## 5.1 AI Jobs Marketplace

### Overview
**Problem**: Finding referrals for jobs is manual (LinkedIn DMs, "do you know anyone?" emails).

**Solution**: AI-powered job marketplace - job poster describes role → AI finds matching candidates from ReachCraft users' networks → introductions made → $10/connection split 70/20/10.

### How It Works

**For Job Posters**:
1. Post job (title, description, salary, location)
2. AI searches all ReachCraft users' networks for matching candidates
3. View top 100 matches (scored by AI)
4. Request introduction ($10/connection)
5. Intro email sent automatically
6. Track responses

**For Lead Uploaders** (users who uploaded candidate):
1. Upload network to ReachCraft (LinkedIn connections, etc.)
2. When someone matches a job, get notified
3. Approve or reject introduction
4. If approved, earn $2 (20% of $10)

**For Platform**:
1. Facilitate matching (AI)
2. Send intro emails
3. Track payments
4. Earn $7 (70% of $10)

### AI Matching Algorithm

```typescript
interface JobMatchingAlgorithm {
  job: {
    title: string // "Senior Software Engineer"
    company: string
    description: string
    required_skills: string[] // ["React", "TypeScript", "Node.js"]
    desired_experience_years: number // 5
    salary_range: string // "$150K-200K"
    location: string // "Remote" or "San Francisco"
  }

  candidate: {
    name: string
    current_title: string
    current_company: string
    skills: string[] // Extracted from LinkedIn
    years_experience: number
    location: string
  }

  matching_logic: {
    title_match: number // 0-100 (fuzzy match on job title)
    skills_match: number // 0-100 (overlap between required and candidate skills)
    experience_match: number // 0-100 (does candidate have enough experience?)
    location_match: number // 0-100 (is candidate in right location or willing to relocate?)
    company_culture_match: number // 0-100 (AI analyzes if candidate would fit)

    final_score: number // Weighted average of above
  }
}

// Example calculation
function calculateJobMatch(job, candidate): number {
  const titleMatch = fuzzyMatch(job.title, candidate.current_title) // 85
  const skillsMatch = skillsOverlap(job.required_skills, candidate.skills) // 90 (candidate has React, TypeScript, Node.js)
  const experienceMatch = candidate.years_experience >= job.desired_experience_years ? 100 : (candidate.years_experience / job.desired_experience_years) * 100 // 100 (candidate has 7 years)
  const locationMatch = job.location === 'Remote' || candidate.location === job.location ? 100 : 50 // 100 (remote job)
  const cultureMatch = analyzeCompanyCultureFit(job.company, candidate.linkedin_profile) // 80 (AI analysis)

  // Weighted average
  return (titleMatch * 0.2 + skillsMatch * 0.3 + experienceMatch * 0.2 + locationMatch * 0.1 + cultureMatch * 0.2)
  // = 85*0.2 + 90*0.3 + 100*0.2 + 100*0.1 + 80*0.2 = 89
}
```

### Revenue Split

**$10/connection**:
- **Platform**: $7 (70%) - for AI matching, intro emails, payment processing
- **Lead Uploader**: $2 (20%) - for uploading candidate
- **Job Poster Referral**: $1 (10%) - if job poster was referred by someone

**Example**:
- Job poster requests 10 introductions
- Cost: 10 × $10 = **$100**
- 10 lead uploaders each earn **$2**
- Platform earns **$70**
- If job poster was referred, referrer earns **$10**

### Pricing Model
- **Free to list jobs** (no upfront cost)
- **$10/connection** (pay per introduction)
- **Bulk discounts**: 50+ connections = $8/connection, 100+ = $6/connection

---

## 5.2 Data Marketplace

### Overview
**Problem**: Buying leads is expensive ($1.50+/lead from Apollo/ZoomInfo), no revenue share for uploaders.

**Solution**: Ethical data marketplace - users upload leads → other users buy leads → 50/50 revenue split → opt-out available.

### How It Works

**For Sellers** (uploading leads):
1. Upload leads (CSV, API, manual entry)
2. System deduplicates (checks for existing leads)
3. System validates (email verification, phone verification)
4. Set price per lead ($0.50-5.00, or let AI recommend)
5. Create listing (title, description, industry, location)
6. List goes live in Data Marketplace
7. Earn 50% when leads sell

**For Buyers**:
1. Browse listings (filter by industry, location, price)
2. Preview leads (see aggregate stats, not individual contacts)
3. Purchase leads (credit card, Stripe)
4. Leads added to CRM instantly
5. AI enrichment applied automatically (optional)

**For Platform**:
1. Facilitate transactions
2. Handle payments (Stripe)
3. Deduplicate/validate leads
4. Enforce opt-out policy
5. Earn 50%

### Lead Quality Validation

**Before listing**:
- Email verification (Stage 1-2: syntax + DNS)
- Phone verification (Stage 1: format validation)
- Staleness check (flag leads with no activity in 180+ days)
- Duplicate check (flag duplicates, only charge for unique leads)

**Quality Score** (0-100):
```typescript
function calculateQualityScore(leads: Contact[]): number {
  const emailVerifiedPercent = leads.filter(l => l.email_verified).length / leads.length * 100
  const phoneVerifiedPercent = leads.filter(l => l.phone_verified).length / leads.length * 100
  const freshPercent = leads.filter(l => !l.is_stale).length / leads.length * 100
  const enrichedPercent = leads.filter(l => l.enriched).length / leads.length * 100

  // Weighted average
  return (emailVerifiedPercent * 0.4 + phoneVerifiedPercent * 0.2 + freshPercent * 0.3 + enrichedPercent * 0.1)
}
```

### Pricing Recommendations (AI)

```typescript
async function recommendLeadPrice(leads: Contact[]): Promise<number> {
  const prompt = `
    You are a lead pricing AI. Recommend a price per lead based on quality.

    Lead Quality Metrics:
    - Email verified: ${leads.filter(l => l.email_verified).length / leads.length * 100}%
    - Phone verified: ${leads.filter(l => l.phone_verified).length / leads.length * 100}%
    - Fresh (< 180 days old): ${leads.filter(l => !l.is_stale).length / leads.length * 100}%
    - Enriched (AI-filled fields): ${leads.filter(l => l.enriched).length / leads.length * 100}%
    - Industry: ${leads[0].company} (infer from company names)
    - Location: ${leads[0].location}

    Pricing Guidelines:
    - Low quality (50-70): $0.50-1.00/lead
    - Medium quality (70-85): $1.00-2.00/lead
    - High quality (85-95): $2.00-3.50/lead
    - Premium quality (95-100): $3.50-5.00/lead

    Return JSON: { "recommended_price": 1.50, "explanation": "..." }
  `

  const response = await anthropic.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 512,
    messages: [{ role: 'user', content: prompt }]
  })

  return JSON.parse(response.content[0].text).recommended_price
}
```

### Revenue Share System

**Lifetime Revenue Share** (MVP):
- Original uploader owns lead forever
- Uploader earns 50% every time lead is sold
- Platform earns 50%

**Example**:
- User A uploads 10,000 leads
- User B buys 1,000 of those leads at $1.00/lead = $1,000 total
- User A earns **$500** (50%)
- Platform earns **$500** (50%)

**Payout Threshold**: $10 minimum (avoid micro-transactions)
**Payout Frequency**: Monthly (if balance > $10)
**Payout Method**: Stripe ACH transfer (free, 2-5 days)

### Opt-Out Policy

**Reactive Opt-Out Only**:
- No proactive emails to leads ("you're in our database")
- Opt-out form on website (ReachCraft.com/opt-out)
- If lead discovers they're in database and complains, remove immediately (< 24 hours)
- Add to permanent "do not sell" list (SHA-256 hash of email + phone)

**Legal Defense**:
- Argument 1: Public data aggregation (First Amendment)
- Argument 2: No direct marketing (we sell access, we don't email leads)
- Argument 3: B2B exemption (business contacts not covered by consumer privacy laws)
- GDPR compliance: Block EU users from Data Marketplace

---

## 5.3 Influencer/Brand Marketplace (Optional)

### Overview
**Problem**: Creators/influencers find brands via DMs (no transparency, no tracking). Brands find influencers via agencies (expensive 30% commission).

**Solution**: Influencer marketplace - brands post campaigns → influencers apply → deals negotiated on-platform → 15% commission.

### How It Works

**For Brands**:
1. Post campaign (product, budget, deliverables)
2. AI recommends matching influencers
3. Review applications
4. Select influencer(s)
5. Negotiate terms on-platform
6. Track deliverables (posts, stories, videos)
7. Pay via Stripe (platform takes 15%)

**For Influencers**:
1. Create profile (follower count, engagement rate, niche)
2. Browse brand campaigns
3. Apply to campaigns
4. Negotiate terms
5. Deliver content
6. Get paid via Stripe (85% of deal)

**For Platform**:
1. Facilitate matching
2. Host negotiations
3. Handle payments
4. Track deliverables
5. Earn 15% commission

### Revenue Model
- **15% commission** on all deals
- Example: Brand pays influencer $10,000 → Platform earns $1,500, influencer earns $8,500

### Pricing
- **Free for influencers** (no listing fee)
- **Free for brands** (no listing fee, only commission on closed deals)

---

# PART 6: AI SYSTEMS

## 6.1 Lead Valuation Engine (15 Factors)

### Overview
**Purpose**: Automatically score leads 0-100 based on likelihood to convert.

### 15 Valuation Factors

**1. Contact Completeness** (10 points):
- Has email (3 pts), phone (3 pts), LinkedIn (2 pts), company (1 pt), title (1 pt)

**2. Email Verified** (10 points):
- Verified = 10 pts, Unverified = 0 pts

**3. Phone Verified** (10 points):
- Verified = 10 pts, Unverified = 0 pts

**4. Social Presence** (5 points):
- Has Twitter (1 pt), LinkedIn (2 pts), Instagram (1 pt), active (1 pt)

**5. Company Size** (10 points):
- 1-10 employees = 2 pts, 11-50 = 4 pts, 51-200 = 6 pts, 201-1000 = 8 pts, 1000+ = 10 pts

**6. Job Title (Decision Maker)** (10 points):
- C-level (CEO, CTO, CMO) = 10 pts, VP = 8 pts, Director = 6 pts, Manager = 4 pts, Individual Contributor = 2 pts

**7. Industry Fit** (5 points):
- Perfect fit (your ICP) = 5 pts, Adjacent industry = 3 pts, Unrelated = 0 pts

**8. Intent Signals** (15 points):
- Visited pricing page (5 pts), Downloaded whitepaper (5 pts), Replied to email (5 pts), Attended webinar (5 pts)

**9. Engagement History** (10 points):
- Opened 3+ emails (5 pts), Clicked 2+ links (3 pts), Replied to email (2 pts)

**10. Freshness** (5 points):
- Added in last 30 days = 5 pts, 30-90 days = 3 pts, 90+ days = 1 pt

**11. Enriched Data** (5 points):
- AI-enriched = 5 pts, Not enriched = 0 pts

**12. Communication Preferences** (5 points):
- Has preferred channel (email/phone/LinkedIn) = 5 pts, Unknown = 0 pts

**13. Budget Indicators** (5 points):
- Company revenue > $10M = 5 pts, $1-10M = 3 pts, < $1M = 1 pt

**14. Tech Stack Fit** (5 points):
- Uses complementary tools (Salesforce, HubSpot) = 5 pts, No data = 0 pts

**15. Referral/Warm Intro** (5 points):
- Warm intro available = 5 pts, Cold outreach only = 0 pts

**Total: 100 points**

---

## 6.2 Auto-Pilot Scraping

### Overview
**Purpose**: User types "need leads for my medspa in boulder co" → AI scrapes 10,000-20,000 leads automatically.

### AI Request Expansion

```typescript
async function expandScrapingRequest(userInput: string): Promise<ScrapingConfig> {
  const prompt = `
    You are a lead generation AI. The user wants leads but gave a vague request. Expand it into a detailed scraping config.

    User Input: "${userInput}"

    Tasks:
    1. Infer business type (medical spa, SaaS, real estate, etc.)
    2. Infer target customer demographics (age, income, location, interests)
    3. Infer intent signals (what behaviors indicate they're interested?)
    4. Infer data sources (LinkedIn, Instagram, Facebook, Google/Yelp, Reddit, etc.)
    5. Infer expected lead count
    6. Infer estimated time
    7. Infer estimated cost
    8. Generate scraping strategy

    Return JSON.
  `

  const response = await anthropic.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 2048,
    messages: [{ role: 'user', content: prompt }]
  })

  return JSON.parse(response.content[0].text)
}
```

### Scraping Orchestration

```typescript
async function executeScrapingJob(config: ScrapingConfig): Promise<Contact[]> {
  // Create job in queue
  const job = await db.scrapingJobs.create({
    tenant_id: config.tenant_id,
    user_id: config.user_id,
    config: config,
    status: 'running',
    started_at: new Date()
  })

  // Launch 100 parallel workers
  const workers = []
  for (let i = 0; i < 100; i++) {
    workers.push(scrapingQueue.add('scrape', {
      job_id: job.id,
      source: config.sources[i % config.sources.length],
      worker_id: i
    }))
  }

  // Wait for all workers to complete
  await Promise.all(workers)

  // Mark job as completed
  await db.scrapingJobs.update(job.id, {
    status: 'completed',
    completed_at: new Date()
  })

  // Return scraped leads
  return await db.scrapingResults.findMany({ job_id: job.id })
}
```

---

## 6.3 Lead Quality Validation (see Part 1 for complete spec)

---

## 6.4 Duplicate Detection (see Part 1 for complete spec)

---

## 6.5 AI Scraping Cost Estimator

### Purpose
User inputs budget → AI estimates how many leads they'll get and from which sources.

### Example UI
```
User: "I have $500 budget, how many leads can I get for my SaaS?"

AI Response:
With $500, here's what you can get:

Option 1: Scraped Leads (Best Value)
- 5,000 leads scraped from LinkedIn, Twitter, Reddit
- AI-enriched ($0.10/lead) = $500 total
- Quality: 75% (medium)
- Time: 2 hours

Option 2: Data Marketplace (Higher Quality)
- 500 leads purchased at $1.00/lead = $500 total
- Quality: 90% (high)
- Time: Instant

Option 3: Premium Data (Highest Quality)
- 333 leads from Apollo.io at $1.50/lead = $499.50 total
- Quality: 95% (premium)
- Time: Instant

Recommended: Option 1 (best ROI for early-stage)
```

---

# PART 7: 7-DAY IMPLEMENTATION PLAN

## Day 1: Database Schema + Auth + Multi-Tenancy

**Goals**:
- Set up Supabase project
- Create all 35 tables
- Enable Row-Level Security (RLS)
- Implement auth (email, Google, LinkedIn OAuth)
- Test multi-tenancy isolation

**Tasks** (8 hours):
1. Create Supabase project
2. Run database migration (35 tables)
3. Set up RLS policies
4. Implement auth flows (email signup, OAuth)
5. Create initial seed data (feature flags, default categories)
6. Write unit tests for auth

**Deliverables**:
- ✅ 35 tables created with RLS
- ✅ Auth working (email + Google OAuth)
- ✅ Tenant isolation verified

---

## Day 2: Contact Management + Categories + Search

**Goals**:
- Build contact CRUD (create, read, update, delete)
- Implement expandable categories
- Build search & filtering
- Implement bulk operations

**Tasks** (8 hours):
1. Build contact management API endpoints
2. Build categories API endpoints
3. Implement full-text search (PostgreSQL tsvector)
4. Build UI for contact list, contact detail, categories sidebar
5. Implement bulk operations (add to category, enrich, delete)

**Deliverables**:
- ✅ Contacts can be created, edited, deleted
- ✅ Categories can be created, nested, reordered
- ✅ Search works (< 50ms for 10K contacts)
- ✅ Bulk operations work (select 100 contacts → add to category)

---

## Day 3: Source Sync (15+ platforms) + Browser Extension

**Goals**:
- Implement OAuth for LinkedIn, Gmail, Zoom
- Build sync logic (initial + scheduled)
- Build browser extension (capture from LinkedIn)

**Tasks** (8 hours):
1. Implement OAuth flows (LinkedIn, Gmail, Google Calendar, Zoom)
2. Build sync workers (BullMQ jobs)
3. Implement deduplication logic
4. Build browser extension (content script + background worker)
5. Test end-to-end: Connect LinkedIn → sync contacts → appear in ReachCraft

**Deliverables**:
- ✅ OAuth working for 5 sources (LinkedIn, Gmail, Zoom, Google Calendar, Twitter)
- ✅ Contacts sync automatically (hourly)
- ✅ Browser extension captures LinkedIn profiles

---

## Day 4: AI Enrichment + Lead Profiler + Valuation

**Goals**:
- Implement AI enrichment (Claude API)
- Implement Lead Intelligence Profiler
- Implement Lead Valuation Engine (15 factors)

**Tasks** (8 hours):
1. Build enrichment pipeline (3 tiers: free, standard, premium)
2. Build Lead Profiler (communication style, personality, buying signals)
3. Build Lead Valuation Engine (score 0-100)
4. Build UI: "Enrich" button, profiler card, lead score badge
5. Test: Enrich 100 contacts in bulk (< 5 minutes)

**Deliverables**:
- ✅ AI enrichment works (fills missing email, phone, bio)
- ✅ Lead Profiler generates profiles (communication style, recommended approach)
- ✅ Lead Valuation Engine scores leads (0-100)

---

## Day 5: Marketplaces + Revenue Share + Payments

**Goals**:
- Build Data Marketplace (list leads, buy leads)
- Build AI Jobs Marketplace (post jobs, match candidates)
- Implement revenue share system
- Integrate Stripe (payments, payouts)

**Tasks** (8 hours):
1. Build Data Marketplace (listing creation, browsing, purchasing)
2. Build AI Jobs Marketplace (job posting, candidate matching)
3. Implement revenue share calculation
4. Integrate Stripe (subscriptions, marketplace purchases, Connect payouts)
5. Test end-to-end: Upload leads → list for sale → buy → revenue share paid

**Deliverables**:
- ✅ Data Marketplace works (list, browse, buy leads)
- ✅ AI Jobs Marketplace works (post job, match candidates)
- ✅ Revenue share calculated and paid (Stripe)

---

## Day 6: Automation + Meeting Intelligence + Integrations

**Goals**:
- Build automation system (trigger-action)
- Implement meeting intelligence (Zoom auto-capture)
- Build Zapier integration (webhooks)

**Tasks** (8 hours):
1. Build automation builder UI (drag-and-drop)
2. Implement automation execution (BullMQ)
3. Implement Zoom webhook (auto-capture meeting participants)
4. Build outgoing webhooks (for Zapier)
5. Test: Create automation "When contact added to Hot Leads → send email"

**Deliverables**:
- ✅ Automation system works (trigger-action)
- ✅ Meeting intelligence auto-captures Zoom participants
- ✅ Webhooks fire on contact events

---

## Day 7: Testing + Deployment + Monitoring

**Goals**:
- Write e2e tests (Playwright)
- Deploy to production (Vercel + Railway)
- Set up monitoring (Sentry, PostHog, Axiom)
- Launch beta

**Tasks** (8 hours):
1. Write e2e tests (auth, contacts, search, enrichment)
2. Deploy frontend to Vercel
3. Deploy backend to Railway
4. Set up Sentry (error tracking), PostHog (analytics), Axiom (logs)
5. Invite 100 beta users
6. Monitor for bugs

**Deliverables**:
- ✅ 20+ e2e tests passing
- ✅ Production deployed (app.reachcraft.com)
- ✅ Monitoring active (Sentry, PostHog, Axiom)
- ✅ 100 beta users invited

---

# PART 8: PATTERN REUSE STRATEGY

## Reuse from LeadCraft CRM (92%)
- Contact management (95% reusable)
- Categories system (100% reusable)
- Search & filtering (90% reusable)
- Bulk operations (100% reusable)
- Import/export (90% reusable)

## Reuse from InterviewPlus
- Multi-tenancy architecture (100% reusable)
- Lead Intelligence Profiler (95% reusable)
- God Mode dashboard (90% reusable)
- Subscription billing (Stripe) (100% reusable)

## Reuse from GenCraft
- Zero-HIL philosophy (100% reusable concept)
- AI request expansion (80% reusable, adapt prompt)
- Template system (50% reusable, different use case)

## Reuse from Universal Workforce
- Parallel orchestration (100% reusable)
- 100+ worker management (100% reusable)
- BullMQ job queue (100% reusable)

## Reuse from BookCraft
- Document generation (50% reusable for reports)

## Reuse from Token Calculator
- Cost tracking (100% reusable)
- AI token usage logging (100% reusable)

---

# PART 9: AUTOMATION ARCHITECTURE (ZERO-HIL)

## Zero-HIL Philosophy
**Never ask the user to do what AI can do.**

Examples:
- ❌ "Enter lead's email" → ✅ AI finds email automatically
- ❌ "Choose category" → ✅ AI suggests category based on context
- ❌ "Fill out 20-field form" → ✅ User types "need leads for my medspa" → AI expands
- ❌ "Review 10,000 leads manually" → ✅ AI scores leads → user reviews top 100

## Auto-Scraping System
User input → AI expands → 100 workers scrape → dedup → enrich → score → deliver

## Auto-Valuation System
New contact added → AI calculates 15-factor score → updates lead_score field

## Auto-Outreach System
Contact added to "Hot Leads" → automation triggers → email sent → follow-up scheduled

## Site Owner Role (5 minutes/month)
- Review revenue dashboard
- Adjust feature flags if needed
- Respond to critical support tickets
- Everything else is automated

---

# DOCUMENT COMPLETE

**Total Lines**: 5,000+
**Status**: ✅ COMPLETE - Ready for 7-Day Build

**Next Steps**:
1. Generate remaining 4 documents (Competitive Moat, Scalability, Path to $238M ARR, GTM Strategy)
2. Begin Day 1 implementation
3. Commit to Git frequently

---

**END OF MASTER PLAN v2.0.0**
