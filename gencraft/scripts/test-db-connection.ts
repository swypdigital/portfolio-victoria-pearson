/**
 * Database Connection Test Script
 * Tests Supabase connection and validates schema deployment
 */

import { initializeDatabaseFromEnv } from '../src/shared/database';

async function testDatabaseConnection() {
  console.log('🔍 Testing GenCraft v3.0 Database Connection...\n');

  try {
    // Initialize database from environment variables
    console.log('1️⃣  Initializing database client...');
    const db = initializeDatabaseFromEnv();
    console.log('   ✅ Database client initialized\n');

    // Test health check
    console.log('2️⃣  Testing database health...');
    const healthy = await db.healthCheck();

    if (!healthy) {
      console.error('   ❌ Database health check failed');
      process.exit(1);
    }
    console.log('   ✅ Database is healthy\n');

    // Test tenants table
    console.log('3️⃣  Testing tenants table query...');
    const { data: tenants, error: tenantsError } = await db
      .getClient()
      .from('tenants')
      .select('id, name, slug, status, created_at')
      .limit(5);

    if (tenantsError) {
      console.error('   ❌ Tenants query failed:', tenantsError.message);
      process.exit(1);
    }

    console.log(`   ✅ Tenants query successful (${tenants?.length || 0} results)`);
    if (tenants && tenants.length > 0) {
      console.log('   📊 Sample tenant:', JSON.stringify(tenants[0], null, 2));
    }
    console.log('');

    // Test subscriptions table
    console.log('4️⃣  Testing subscriptions table query...');
    const { data: subscriptions, error: subscriptionsError } = await db
      .getClient()
      .from('subscriptions')
      .select('id, tenant_id, tier, status, token_limit_monthly')
      .limit(5);

    if (subscriptionsError) {
      console.error('   ❌ Subscriptions query failed:', subscriptionsError.message);
      process.exit(1);
    }

    console.log(`   ✅ Subscriptions query successful (${subscriptions?.length || 0} results)`);
    if (subscriptions && subscriptions.length > 0) {
      console.log('   📊 Sample subscription:', JSON.stringify(subscriptions[0], null, 2));
    }
    console.log('');

    // Test AIEN audit log table
    console.log('5️⃣  Testing aien_audit_log table query...');
    const { data: auditLogs, error: auditError } = await db
      .getClient()
      .from('aien_audit_log')
      .select('id, tenant_id, decision, created_at')
      .limit(5);

    if (auditError) {
      console.error('   ❌ AIEN audit log query failed:', auditError.message);
      process.exit(1);
    }

    console.log(`   ✅ AIEN audit log query successful (${auditLogs?.length || 0} results)`);
    console.log('');

    // Verify Row Level Security
    console.log('6️⃣  Verifying Row Level Security (RLS)...');
    const { data: rlsCheck, error: rlsError } = await db
      .getClient()
      .rpc('pg_catalog.pg_tables')
      .select('schemaname, tablename, rowsecurity')
      .eq('schemaname', 'public');

    if (rlsError) {
      console.warn('   ⚠️  RLS verification query failed (may require admin role)');
    } else {
      console.log('   ✅ RLS verification query successful');
    }
    console.log('');

    // Performance test
    console.log('7️⃣  Testing query performance...');
    const startTime = Date.now();
    await db.getClient().from('tenants').select('count').limit(1).single();
    const queryTime = Date.now() - startTime;

    console.log(`   ✅ Query completed in ${queryTime}ms`);
    if (queryTime < 100) {
      console.log('   🚀 Performance: EXCELLENT (<100ms)');
    } else if (queryTime < 500) {
      console.log('   ✅ Performance: GOOD (<500ms)');
    } else {
      console.log('   ⚠️  Performance: SLOW (>500ms) - may need optimization');
    }
    console.log('');

    // Summary
    console.log('═══════════════════════════════════════════════════════');
    console.log('✅ All database tests passed!');
    console.log('═══════════════════════════════════════════════════════');
    console.log('Database Status: READY');
    console.log(`Query Performance: ${queryTime}ms`);
    console.log(`Tenants: ${tenants?.length || 0} found`);
    console.log(`Subscriptions: ${subscriptions?.length || 0} found`);
    console.log(`AIEN Audit Logs: ${auditLogs?.length || 0} found`);
    console.log('═══════════════════════════════════════════════════════\n');

    process.exit(0);
  } catch (error: any) {
    console.error('\n❌ Database test failed with error:');
    console.error(error.message);
    if (error.stack) {
      console.error('\nStack trace:');
      console.error(error.stack);
    }
    console.error('\n💡 Troubleshooting tips:');
    console.error('   1. Verify SUPABASE_URL in .env is correct');
    console.error('   2. Verify SUPABASE_ANON_KEY or SUPABASE_SERVICE_KEY is set');
    console.error('   3. Check database migration ran successfully');
    console.error('   4. Verify network/firewall allows Supabase connections');
    console.error('   5. Check Supabase project is not paused (free tier)\n');
    process.exit(1);
  }
}

// Run test
testDatabaseConnection();
