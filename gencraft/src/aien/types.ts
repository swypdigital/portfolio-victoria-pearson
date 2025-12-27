/**
 * AIEN (AI/ML Enforcement Engine) - Core Types
 * Component #46 from SAAS Framework v7.0
 * 
 * Universal constraint enforcement for AI/ML systems with <250ms total latency
 */

export type AIENEnforcementMode = 
  | 'hard_block'    // Complete denial of access
  | 'soft_block'    // Preview/teaser mode with upgrade prompt
  | 'redirect'      // Redirect to alternative vertical
  | 'warn'          // Allow with warning
  | 'log_only';     // Allow with audit trail only

export type AIENConfigType =
  | 'subscription'  // Tier-based access control
  | 'quota'         // Token/usage limits
  | 'rbac'          // Role-based access
  | 'compliance'    // Legal/regulatory constraints
  | 'cost'          // Budget-based limits
  | 'quality'       // Minimum quality thresholds
  | 'time'          // Time-based restrictions
  | 'geography';    // Geographic restrictions

export type AIENDecision = 
  | 'allow'
  | 'deny'
  | 'soft_block'
  | 'redirect'
  | 'warn';

export interface AIENClassificationResult {
  vertical: string;
  feature: string;
  confidence: number;  // 0.0 to 1.0
  processingTimeMs: number;
  alternatives?: string[];  // Suggested alternative verticals
}

export interface AIENEnforcementResult {
  decision: AIENDecision;
  reason: string;
  vertical: string;
  feature?: string;
  processingTimeMs: number;
  
  // For soft_block/redirect
  previewMode?: boolean;
  previewWords?: number;
  redirectTo?: string;
  
  // For deny
  upgradeOptions?: {
    tier: string;
    price: number;
    features: string[];
  }[];
  
  // For allow
  estimatedTokens?: number;
  warnings?: string[];
}

export interface AIENConfiguration {
  id: string;
  tenantId: string;
  configType: AIENConfigType;
  rules: Record<string, any>;  // JSON configuration
  enforcementMode: AIENEnforcementMode;
  priority: number;  // Higher = evaluated first
  active: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface AIENAuditLog {
  id: string;
  tenantId: string;
  userId: string | null;
  requestTimestamp: Date;
  userPrompt: string;
  classifiedVertical: string;
  classifiedFeature: string | null;
  confidence: number;
  decision: AIENDecision;
  decisionReason: string;
  processingTimeMs: number;
  metadata?: Record<string, any>;
}

export interface SubscriptionConfig {
  tier: 'free' | 'starter' | 'pro' | 'enterprise';
  allowedVerticals: string[];
  tokenLimitMonthly: number;
  tokensUsedCurrentMonth: number;
  features: {
    previewMode?: boolean;
    previewWords?: number;
    [key: string]: any;
  };
}
