# Supabase Deployment Guide - GenCraft v3.0

**Last Updated:** 2025-12-27
**Version:** 1.0.0
**Author:** groklyGroup LLC

## Overview

This guide walks through deploying GenCraft v3.0 database schema to Supabase, including Row Level Security (RLS) configuration, environment setup, and validation.

## Prerequisites

- Supabase account (https://supabase.com)
- Node.js 18+ installed
- Git access to GenCraft repository
- Admin access to create Supabase project

## Deployment Steps

### 1. Create Supabase Project

1. Go to https://app.supabase.com
2. Click "New Project"
3. Configure:
   - **Project Name:** `gencraft-[environment]` (e.g., `gencraft-production`)
   - **Database Password:** Generate strong password (save securely)
   - **Region:** Choose closest to your users
   - **Pricing Plan:** Pro (recommended for production)
4. Wait for project provisioning (~2 minutes)

### 2. Get API Credentials

1. Go to **Settings** → **API**
2. Copy and save:
   - **Project URL:** `https://[your-project].supabase.co`
   - **anon/public key:** Client-side safe key
   - **service_role key:** Server-only key (NEVER expose to client)

### 3. Configure Environment Variables

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and fill in:
   ```env
   SUPABASE_URL=https://[your-project].supabase.co
   SUPABASE_ANON_KEY=[your-anon-key]
   SUPABASE_SERVICE_KEY=[your-service-role-key]
   PORT=3000
   NODE_ENV=development
   ALLOWED_ORIGINS=http://localhost:3001
   ENABLE_AIEN=true
   ```

3. **CRITICAL:** Add `.env` to `.gitignore` (already done):
   ```bash
   echo ".env" >> .gitignore
   ```

### 4. Run Database Migration

**Option A: Supabase Dashboard (Recommended for first deployment)**

1. Go to **SQL Editor** in Supabase dashboard
2. Open `database/migrations/001_initial_schema.sql` from repository
3. Copy entire contents
4. Paste into SQL Editor
5. Click **Run**
6. Verify success (should see "Success. No rows returned")

**Option B: Supabase CLI**

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref [your-project-ref]

# Run migrations
supabase db push
```

### 5. Verify Database Schema

Run this SQL query in Supabase SQL Editor to verify tables:

```sql
SELECT
  schemaname,
  tablename,
  tableowner
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

**Expected tables:**
- tenants
- users
- subscriptions
- svac_vertical_access
- whitelabel_config
- aien_configurations
- aien_audit_log
- saleswriter_documents

### 6. Verify Row Level Security (RLS)

Check RLS is enabled on all tables:

```sql
SELECT
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

All tables should show `rowsecurity = true`.

### 7. Create Initial Test Data

Run this SQL to create a test tenant and user:

```sql
-- Insert test tenant
INSERT INTO tenants (id, name, slug, status)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Test Tenant',
  'test-tenant',
  'active'
);

-- Insert test subscription
INSERT INTO subscriptions (tenant_id, tier, status, token_limit_monthly, allowed_verticals)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'starter',
  'active',
  50000,
  ARRAY['saleswriter', 'appcraft']
);

-- Note: User will be created via Supabase Auth signup
```

### 8. Test Database Connection

Create a test script `scripts/test-db-connection.ts`:

```typescript
import { initializeDatabaseFromEnv } from '../src/shared/database';

async function testConnection() {
  try {
    console.log('Testing database connection...');

    const db = initializeDatabaseFromEnv();
    const healthy = await db.healthCheck();

    if (healthy) {
      console.log('✅ Database connection successful');

      // Test query
      const { data, error } = await db
        .getClient()
        .from('tenants')
        .select('id, name, slug')
        .limit(5);

      if (error) throw error;

      console.log('✅ Test query successful');
      console.log('Tenants:', data);
    } else {
      console.error('❌ Database connection failed');
      process.exit(1);
    }
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

testConnection();
```

Run:
```bash
npx tsx scripts/test-db-connection.ts
```

### 9. Configure Supabase Auth

1. Go to **Authentication** → **Providers**
2. Enable **Email** provider
3. Configure email templates (optional)
4. Set **Site URL:** Your frontend URL
5. Add **Redirect URLs:** Allowed OAuth callback URLs

### 10. Security Hardening

**Database Security:**
```sql
-- Revoke public schema permissions
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO authenticated;

-- Ensure service_role can bypass RLS
ALTER TABLE tenants FORCE ROW LEVEL SECURITY;
-- Repeat for all tables
```

**API Security:**
- ✅ Never expose `SUPABASE_SERVICE_KEY` to client
- ✅ Use `SUPABASE_ANON_KEY` for client-side only
- ✅ Enable RLS on all tables
- ✅ Validate JWT tokens on server
- ✅ Use HTTPS only in production

### 11. Monitoring Setup

1. Go to **Reports** in Supabase dashboard
2. Enable:
   - API requests monitoring
   - Database performance tracking
   - Auth events logging
3. Set up alerts for:
   - High error rates
   - Slow queries (>500ms)
   - Auth failures

## Production Deployment Checklist

Before deploying to production:

- [ ] Database migration completed successfully
- [ ] RLS policies tested and verified
- [ ] Test data created and API tested
- [ ] Environment variables configured
- [ ] `.env` file NOT committed to git
- [ ] Supabase Auth configured
- [ ] Security hardening applied
- [ ] Monitoring and alerts enabled
- [ ] Backup strategy configured
- [ ] Database connection pooling tested
- [ ] Performance benchmarks met (<100ms queries)

## Rollback Plan

If deployment fails:

1. **Stop API server:**
   ```bash
   pkill -f "node dist/server.js"
   ```

2. **Restore previous database state:**
   - Supabase automatically maintains point-in-time recovery
   - Go to **Database** → **Backups**
   - Restore from last known good backup

3. **Revert environment variables:**
   ```bash
   git checkout .env
   ```

4. **Verify rollback:**
   ```bash
   npx tsx scripts/test-db-connection.ts
   ```

## Performance Optimization

**Database Indexes:**
- All indexes created automatically by migration
- Verify with: `SELECT * FROM pg_indexes WHERE schemaname = 'public';`

**Connection Pooling:**
- Supabase provides connection pooling by default
- Use `Database.getInstance()` for singleton pattern
- Max connections: Configure in Supabase dashboard

**Query Performance:**
- Enable query logging: Settings → Database → Enable Query Logging
- Monitor slow queries (>100ms)
- Optimize with EXPLAIN ANALYZE

## Troubleshooting

### Connection Errors

**Error:** `Unable to connect to database`
- Verify `SUPABASE_URL` is correct
- Check project is not paused (free tier auto-pauses after 7 days inactivity)
- Verify network/firewall allows Supabase connections

### RLS Policy Errors

**Error:** `row-level security policy violation`
- Check RLS policies exist for table
- Verify user has correct tenant_id in JWT
- Use service_role key for admin operations

### Migration Errors

**Error:** `relation already exists`
- Database already has tables
- Either drop existing tables or use different database
- Check migration hasn't already run

## Next Steps

After successful deployment:

1. **API Testing:** Run integration tests against deployed database
2. **Load Testing:** Use k6 to verify performance under load
3. **Security Audit:** Run security scans on API endpoints
4. **Monitoring:** Set up Sentry/DataDog for production monitoring
5. **Documentation:** Update API docs with production URLs

## Support

For issues or questions:
- **Documentation:** https://supabase.com/docs
- **GenCraft Repo:** https://github.com/swypdigital/portfolio-victoria-pearson
- **Supabase Discord:** https://discord.supabase.com

---

**End of Deployment Guide**
Document Version: 1.0.0
Last Updated: 2025-12-27
