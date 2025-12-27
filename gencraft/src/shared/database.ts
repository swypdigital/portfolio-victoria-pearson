/**
 * Supabase Database Client
 * Provides type-safe database access with connection pooling
 */

import { createClient, SupabaseClient } from '@supabase/supabase-js';

export interface DatabaseConfig {
  supabaseUrl: string;
  supabaseKey: string;
  options?: {
    auth?: {
      persistSession?: boolean;
    };
    db?: {
      schema?: string;
    };
  };
}

export class Database {
  private client: SupabaseClient;
  private static instance: Database;

  private constructor(config: DatabaseConfig) {
    this.client = createClient(
      config.supabaseUrl,
      config.supabaseKey,
      config.options || {}
    );
  }

  /**
   * Get or create singleton database instance
   */
  static getInstance(config?: DatabaseConfig): Database {
    if (!Database.instance) {
      if (!config) {
        throw new Error('Database config required for first initialization');
      }
      Database.instance = new Database(config);
    }
    return Database.instance;
  }

  /**
   * Get Supabase client
   */
  getClient(): SupabaseClient {
    return this.client;
  }

  /**
   * Get subscription for a tenant
   */
  async getSubscription(tenantId: string) {
    const { data, error } = await this.client
      .from('subscriptions')
      .select('*')
      .eq('tenant_id', tenantId)
      .single();

    if (error) throw error;
    return data;
  }

  /**
   * Log AIEN enforcement decision
   */
  async logEnforcementDecision(log: {
    tenant_id: string;
    user_id: string | null;
    user_prompt: string;
    classified_vertical: string;
    classified_feature: string | null;
    confidence: number;
    decision: string;
    decision_reason: string;
    processing_time_ms: number;
    metadata?: Record<string, any>;
  }) {
    const { error } = await this.client
      .from('aien_audit_log')
      .insert(log);

    if (error) throw error;
  }

  /**
   * Get AIEN configurations for a tenant
   */
  async getAIENConfigurations(tenantId: string) {
    const { data, error } = await this.client
      .from('aien_configurations')
      .select('*')
      .eq('tenant_id', tenantId)
      .eq('active', true)
      .order('priority', { ascending: false });

    if (error) throw error;
    return data || [];
  }

  /**
   * Update token usage for subscription
   */
  async updateTokenUsage(tenantId: string, tokensUsed: number) {
    const { error } = await this.client.rpc('increment_token_usage', {
      p_tenant_id: tenantId,
      p_tokens: tokensUsed,
    });

    if (error) throw error;
  }

  /**
   * Check database health
   */
  async healthCheck(): Promise<boolean> {
    try {
      const { error } = await this.client
        .from('tenants')
        .select('id')
        .limit(1);

      return !error;
    } catch {
      return false;
    }
  }
}

/**
 * Helper function to initialize database from environment
 */
export function initializeDatabaseFromEnv(): Database {
  const config: DatabaseConfig = {
    supabaseUrl: process.env.SUPABASE_URL || '',
    supabaseKey: process.env.SUPABASE_ANON_KEY || '',
    options: {
      auth: {
        persistSession: false,
      },
    },
  };

  if (!config.supabaseUrl || !config.supabaseKey) {
    throw new Error(
      'Missing required environment variables: SUPABASE_URL and SUPABASE_ANON_KEY'
    );
  }

  return Database.getInstance(config);
}
