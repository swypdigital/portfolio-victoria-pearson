# ENTERPRISE SAAS ARCHITECTURE TEMPLATE v1.0.0
**Comprehensive Production-Ready Template**

*Created: 2025-12-05*
*Based on: GenCraft v3.0 Enterprise Patterns*
*Author: groklyGroup LLC*
*Status: Production-Ready Template*

---

## TABLE OF CONTENTS

1. [Executive Summary](#executive-summary)
2. [Architecture Overview](#architecture-overview)
3. [Security Architecture](#security-architecture)
4. [User Types & RBAC](#user-types--rbac)
5. [UI/UX Architecture](#uiux-architecture)
6. [Feature Control System](#feature-control-system)
7. [Technology Stack](#technology-stack)
8. [Infrastructure Architecture](#infrastructure-architecture)
9. [Testing Framework](#testing-framework)
10. [Deployment Pipeline](#deployment-pipeline)
11. [Monitoring & Observability](#monitoring--observability)
12. [Cost Optimization](#cost-optimization)
13. [Implementation Checklist](#implementation-checklist)

---

## EXECUTIVE SUMMARY

This template provides a complete enterprise-grade SaaS architecture based on proven patterns from GenCraft v3.0. It includes:

- **Zero-HIL (Human-in-the-Loop) Architecture**: Fully autonomous operation
- **Multi-Tenant Security**: Enterprise-grade isolation with zero-trust
- **Tiered Feature Control**: God Dashboard with dynamic feature flags
- **Cost Optimization**: 82-86% AI cost reduction through intelligent routing
- **Self-Healing Systems**: Autonomous error detection and correction
- **10-Phase Testing Framework**: Zero false positives guarantee

### Key Principles

1. **No Technical Debt**: Build it right the first time
2. **Enterprise-Grade Only**: No MVP shortcuts
3. **Security First**: Zero-trust at every layer
4. **User Experience**: Friction-free, intuitive, accessible
5. **Scalability**: 1M+ records, 10K+ concurrent users
6. **Observability**: Complete transparency into system behavior

---

## ARCHITECTURE OVERVIEW

### System Architecture Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                              │
│  Web App (React/Next.js) | Mobile App | API Clients         │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    API GATEWAY                               │
│  - Authentication/Authorization                              │
│  - Rate Limiting                                             │
│  - Request Routing                                           │
│  - API Versioning                                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                 MICROSERVICES LAYER                          │
├──────────────────────────────────────────────────────────────┤
│  Auth Service    │  Core Service    │  Analytics Service    │
│  User Service    │  Feature Service │  Payment Service      │
│  Notification    │  Integration     │  Support Service      │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    DATA LAYER                                │
│  PostgreSQL  │  Redis  │  MongoDB  │  S3/Object Storage     │
│  (Primary)   │ (Cache) │  (Logs)   │  (Assets)              │
└─────────────────────────────────────────────────────────────┘
```

### Monorepo Structure

```
/project-root
├── /apps                        # Applications
│   ├── /web                    # Web application (Next.js)
│   ├── /mobile                 # Mobile app (React Native)
│   ├── /admin                  # Admin dashboard
│   └── /api                    # API gateway
├── /services                    # Microservices
│   ├── /auth                   # Authentication service
│   ├── /users                  # User management
│   ├── /core                   # Core business logic
│   ├── /analytics              # Analytics engine
│   ├── /payments               # Payment processing
│   └── /notifications          # Notification system
├── /packages                    # Shared packages
│   ├── /ui                     # UI component library
│   ├── /database              # Database schemas/migrations
│   ├── /types                  # TypeScript types
│   ├── /utils                  # Shared utilities
│   └── /config                 # Shared configuration
├── /infrastructure              # Infrastructure as Code
│   ├── /kubernetes            # K8s manifests
│   ├── /terraform             # Terraform configs
│   └── /docker                # Docker configs
├── /docs                        # Documentation
│   ├── /architecture          # Architecture docs
│   ├── /api                   # API documentation
│   └── /deployment            # Deployment guides
└── /tests                       # E2E tests
    ├── /integration           # Integration tests
    ├── /e2e                   # End-to-end tests
    └── /load                  # Load/performance tests
```

### Data Flow Architecture

**Request Flow (Write Operation)**:
```
User → API Gateway → Auth Middleware → Rate Limiter →
Service Router → Business Logic → Database →
Cache Invalidation → Event Bus → Response
```

**Request Flow (Read Operation)**:
```
User → API Gateway → Auth Middleware → Cache Check →
[HIT: Return from Cache] | [MISS: Query Database → Update Cache] →
Response
```

### Event-Driven Architecture

```yaml
event_bus:
  type: Redis Pub/Sub | RabbitMQ | Kafka
  events:
    - user.created
    - user.updated
    - payment.processed
    - feature.enabled
    - error.detected
    - security.alert

  subscribers:
    user.created:
      - email-service
      - analytics-service
      - onboarding-service
    payment.processed:
      - billing-service
      - analytics-service
      - notification-service
```

---

## SECURITY ARCHITECTURE

### Zero-Trust Security Model

**Core Principles**:
1. **Never Trust, Always Verify**: Every request authenticated and authorized
2. **Least Privilege**: Minimal permissions by default
3. **Assume Breach**: Defense in depth at every layer
4. **Continuous Monitoring**: Real-time security analytics

### Security Layers

```
┌─────────────────────────────────────────────────────────┐
│  Layer 7: Application Security                          │
│  - Input Validation                                     │
│  - Output Encoding                                      │
│  - CSRF/XSS Protection                                  │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│  Layer 6: Authentication & Authorization                │
│  - Multi-Factor Authentication (MFA)                    │
│  - Role-Based Access Control (RBAC)                     │
│  - Attribute-Based Access Control (ABAC)               │
│  - Session Management                                   │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│  Layer 5: API Security                                  │
│  - API Key Management                                   │
│  - Rate Limiting                                        │
│  - Request Signing                                      │
│  - JWT Validation                                       │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│  Layer 4: Network Security                              │
│  - TLS 1.3 Encryption                                   │
│  - WAF (Web Application Firewall)                       │
│  - DDoS Protection                                      │
│  - IP Whitelisting                                      │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│  Layer 3: Container Security                            │
│  - Container Isolation                                  │
│  - Image Scanning                                       │
│  - Runtime Protection                                   │
│  - Secret Management                                    │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│  Layer 2: Data Security                                 │
│  - Encryption at Rest (AES-256)                         │
│  - Encryption in Transit (TLS 1.3)                      │
│  - Database Access Controls                             │
│  - Audit Logging                                        │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│  Layer 1: Infrastructure Security                       │
│  - Kubernetes RBAC                                      │
│  - Network Policies                                     │
│  - Security Groups                                      │
│  - Compliance Monitoring                                │
└─────────────────────────────────────────────────────────┘
```

### Authentication Flow

```typescript
// Multi-Factor Authentication (MFA)
interface AuthenticationFlow {
  stage1: {
    method: 'email_password' | 'oauth' | 'saml';
    verification: 'password_hash' | 'oauth_token' | 'saml_assertion';
  };

  stage2_mfa: {
    method: 'totp' | 'sms' | 'email' | 'webauthn';
    required_for: ['admin', 'payment_operations'];
    optional_for: ['standard_users'];
  };

  session: {
    token_type: 'JWT';
    expiration: '15m' | '1h' | '24h';
    refresh_token: '30d';
    rotation: 'automatic';
  };
}

// Example Implementation
class AuthService {
  async authenticate(credentials: Credentials): Promise<AuthResult> {
    // Stage 1: Verify credentials
    const user = await this.verifyCredentials(credentials);

    // Stage 2: Check if MFA required
    if (this.requiresMFA(user.role)) {
      const mfaToken = await this.generateMFAChallenge(user);
      return { status: 'mfa_required', mfaToken };
    }

    // Generate session
    const session = await this.createSession(user);
    return { status: 'authenticated', session };
  }

  private requiresMFA(role: UserRole): boolean {
    return ['admin', 'superadmin', 'finance'].includes(role);
  }
}
```

### Authorization (RBAC + ABAC)

```typescript
// Role-Based Access Control (RBAC)
interface RBACSystem {
  roles: {
    superadmin: {
      permissions: ['*']; // All permissions
      description: 'God mode - full system access';
    };
    admin: {
      permissions: [
        'users.read', 'users.write', 'users.delete',
        'settings.read', 'settings.write',
        'analytics.read'
      ];
      description: 'Administrative access';
    };
    team_lead: {
      permissions: [
        'users.read', 'team.read', 'team.write',
        'analytics.read'
      ];
      description: 'Team management access';
    };
    user: {
      permissions: [
        'profile.read', 'profile.write',
        'content.read', 'content.write'
      ];
      description: 'Standard user access';
    };
  };
}

// Attribute-Based Access Control (ABAC)
interface ABACPolicy {
  resource: string;
  action: string;
  conditions: {
    user_attributes?: Record<string, any>;
    resource_attributes?: Record<string, any>;
    environment?: Record<string, any>;
  };
}

// Example ABAC Policy
const documentAccessPolicy: ABACPolicy = {
  resource: 'document',
  action: 'read',
  conditions: {
    user_attributes: {
      department: 'engineering' // User must be in engineering
    },
    resource_attributes: {
      classification: ['public', 'internal'] // Document must be public or internal
    },
    environment: {
      ip_whitelist: true, // Must be from whitelisted IP
      time_range: '09:00-17:00' // Only during business hours
    }
  }
};

// Permission Check
class PermissionService {
  async checkPermission(
    user: User,
    resource: string,
    action: string
  ): Promise<boolean> {
    // RBAC Check
    const hasRBACPermission = this.checkRBAC(user.role, resource, action);
    if (!hasRBACPermission) return false;

    // ABAC Check
    const hasABACPermission = await this.checkABAC(user, resource, action);
    return hasABACPermission;
  }
}
```

### Security Best Practices Checklist

- [ ] **Input Validation**: All user inputs sanitized and validated
- [ ] **Output Encoding**: All outputs properly encoded (prevent XSS)
- [ ] **SQL Injection Prevention**: Parameterized queries only
- [ ] **CSRF Protection**: Anti-CSRF tokens on all forms
- [ ] **Rate Limiting**: API endpoints protected from abuse
- [ ] **Secrets Management**: No secrets in code (use Vault/KMS)
- [ ] **Audit Logging**: All security events logged
- [ ] **Encryption**: Data encrypted at rest and in transit
- [ ] **Dependency Scanning**: Regular vulnerability scans
- [ ] **Penetration Testing**: Annual third-party security audit

---

## USER TYPES & RBAC

### User Hierarchy

```
SuperAdmin (God Mode)
    ↓
Admin (Organization Owner)
    ↓
Manager (Team Lead)
    ↓
Team Member (Collaborator)
    ↓
Standard User (Individual)
    ↓
Guest (Limited Access)
```

### User Roles Definition

```typescript
enum UserRole {
  SUPERADMIN = 'superadmin',    // Platform owner (you)
  ADMIN = 'admin',              // Organization owner
  MANAGER = 'manager',          // Team lead
  MEMBER = 'member',            // Team member
  USER = 'user',                // Standard user
  GUEST = 'guest'               // Limited access
}

interface UserPermissions {
  role: UserRole;
  permissions: Permission[];
  restrictions: Restriction[];
  featureFlags: FeatureFlag[];
}

// Permission Structure
interface Permission {
  resource: string;          // e.g., 'users', 'documents', 'settings'
  actions: Action[];         // e.g., ['create', 'read', 'update', 'delete']
  scope: 'own' | 'team' | 'organization' | 'global';
  conditions?: Condition[];  // Optional conditions
}

// Example: Admin Permissions
const adminPermissions: UserPermissions = {
  role: UserRole.ADMIN,
  permissions: [
    {
      resource: 'users',
      actions: ['create', 'read', 'update', 'delete'],
      scope: 'organization'
    },
    {
      resource: 'billing',
      actions: ['read', 'update'],
      scope: 'organization'
    },
    {
      resource: 'analytics',
      actions: ['read'],
      scope: 'organization'
    },
    {
      resource: 'settings',
      actions: ['read', 'update'],
      scope: 'organization'
    }
  ],
  restrictions: [
    { action: 'delete_organization', requires: 'email_verification' },
    { action: 'change_plan', requires: 'payment_method' }
  ],
  featureFlags: [
    'advanced_analytics',
    'team_collaboration',
    'api_access',
    'custom_branding'
  ]
};
```

### Multi-Tenancy Model

```typescript
// Organization (Tenant) Structure
interface Organization {
  id: string;
  name: string;
  plan: 'free' | 'starter' | 'professional' | 'enterprise';
  users: User[];
  settings: OrganizationSettings;
  limits: ResourceLimits;
}

// Resource Limits by Plan
interface ResourceLimits {
  max_users: number;
  max_storage_gb: number;
  max_api_calls_per_month: number;
  max_concurrent_sessions: number;
  features_enabled: string[];
}

const planLimits: Record<string, ResourceLimits> = {
  free: {
    max_users: 1,
    max_storage_gb: 1,
    max_api_calls_per_month: 1000,
    max_concurrent_sessions: 1,
    features_enabled: ['basic_features']
  },
  professional: {
    max_users: 50,
    max_storage_gb: 100,
    max_api_calls_per_month: 100000,
    max_concurrent_sessions: 10,
    features_enabled: ['basic_features', 'advanced_analytics', 'api_access']
  },
  enterprise: {
    max_users: -1, // Unlimited
    max_storage_gb: -1, // Unlimited
    max_api_calls_per_month: -1, // Unlimited
    max_concurrent_sessions: -1, // Unlimited
    features_enabled: ['*'] // All features
  }
};

// Data Isolation Strategy
class DataIsolationService {
  // Schema-based isolation (recommended)
  async getUserData(userId: string, orgId: string): Promise<any> {
    return await db
      .schema(`org_${orgId}`)
      .select('*')
      .from('users')
      .where('id', userId);
  }

  // Row-level security (alternative)
  async getUserDataRLS(userId: string, orgId: string): Promise<any> {
    return await db
      .select('*')
      .from('users')
      .where({ id: userId, organization_id: orgId });
  }
}
```

### User Onboarding Flow

```typescript
// User Registration & Onboarding
interface OnboardingFlow {
  step1_registration: {
    fields: ['email', 'password', 'name'];
    validation: 'email_verification';
    mfa_setup: 'optional';
  };

  step2_organization_setup: {
    fields: ['organization_name', 'industry', 'team_size'];
    automatic_role: 'admin'; // First user becomes admin
  };

  step3_feature_discovery: {
    method: 'guided_tour' | 'video' | 'documentation';
    skip_allowed: true;
  };

  step4_integration_setup: {
    optional_integrations: ['slack', 'email', 'api'];
    skip_allowed: true;
  };
}

// Welcome Email & First Value
class OnboardingService {
  async completeOnboarding(user: User): Promise<void> {
    // Send welcome email
    await this.emailService.sendWelcome(user);

    // Create sample data
    await this.createSampleData(user);

    // Schedule follow-up emails
    await this.scheduleOnboardingSequence(user);

    // Track onboarding progress
    await this.analytics.track('onboarding_completed', { userId: user.id });
  }
}
```

---

## UI/UX ARCHITECTURE

### Design System

```typescript
// Design Tokens
const designTokens = {
  colors: {
    primary: {
      50: '#E3F2FD',
      100: '#BBDEFB',
      500: '#2196F3',
      900: '#0D47A1'
    },
    secondary: {
      50: '#F3E5F5',
      500: '#9C27B0'
    },
    semantic: {
      success: '#4CAF50',
      warning: '#FF9800',
      error: '#F44336',
      info: '#2196F3'
    }
  },

  typography: {
    fontFamily: {
      sans: 'Inter, system-ui, sans-serif',
      mono: 'JetBrains Mono, monospace'
    },
    fontSize: {
      xs: '0.75rem',
      sm: '0.875rem',
      base: '1rem',
      lg: '1.125rem',
      xl: '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem'
    },
    fontWeight: {
      normal: 400,
      medium: 500,
      semibold: 600,
      bold: 700
    }
  },

  spacing: {
    0: '0',
    1: '0.25rem',
    2: '0.5rem',
    4: '1rem',
    8: '2rem',
    16: '4rem'
  },

  borderRadius: {
    none: '0',
    sm: '0.25rem',
    md: '0.375rem',
    lg: '0.5rem',
    full: '9999px'
  }
};

// Component Library Structure
const componentLibrary = {
  atoms: [
    'Button',
    'Input',
    'Label',
    'Badge',
    'Icon',
    'Avatar'
  ],
  molecules: [
    'FormField',
    'SearchBar',
    'Card',
    'Dropdown',
    'Modal',
    'Tooltip'
  ],
  organisms: [
    'Header',
    'Sidebar',
    'DataTable',
    'Form',
    'Dashboard',
    'UserMenu'
  ],
  templates: [
    'DashboardLayout',
    'AuthLayout',
    'SettingsLayout',
    'LandingPage'
  ]
};
```

### Responsive Design Strategy

```css
/* Mobile-First Breakpoints */
:root {
  --breakpoint-sm: 640px;   /* Small devices */
  --breakpoint-md: 768px;   /* Tablets */
  --breakpoint-lg: 1024px;  /* Desktops */
  --breakpoint-xl: 1280px;  /* Large desktops */
  --breakpoint-2xl: 1536px; /* Extra large */
}

/* Responsive Grid System */
.container {
  width: 100%;
  padding: 0 1rem;
}

@media (min-width: 640px) {
  .container { max-width: 640px; }
}

@media (min-width: 768px) {
  .container { max-width: 768px; }
}

@media (min-width: 1024px) {
  .container { max-width: 1024px; }
}
```

### Accessibility (WCAG 2.1 AA)

```typescript
// Accessibility Requirements
const accessibilityStandards = {
  perceivable: {
    text_alternatives: 'All images have alt text',
    captions: 'Video content has captions',
    color_contrast: 'Minimum 4.5:1 contrast ratio',
    text_resize: 'Text resizable up to 200%'
  },

  operable: {
    keyboard_accessible: 'All functionality available via keyboard',
    no_timing: 'No time limits or they are adjustable',
    seizures: 'No content flashing more than 3 times/second',
    navigation: 'Multiple ways to navigate'
  },

  understandable: {
    language: 'Page language identified',
    predictable: 'Consistent navigation and identification',
    input_assistance: 'Error identification and suggestions',
    labels: 'Clear labels and instructions'
  },

  robust: {
    compatible: 'Compatible with assistive technologies',
    valid_markup: 'Valid HTML/ARIA markup',
    status_messages: 'Proper ARIA live regions'
  }
};

// Accessibility Implementation
class AccessibilityService {
  // Keyboard Navigation
  setupKeyboardNavigation(): void {
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Tab') {
        document.body.classList.add('keyboard-navigation');
      }
    });

    document.addEventListener('mousedown', () => {
      document.body.classList.remove('keyboard-navigation');
    });
  }

  // Screen Reader Announcements
  announce(message: string, priority: 'polite' | 'assertive' = 'polite'): void {
    const announcer = document.getElementById('sr-announcer');
    if (announcer) {
      announcer.setAttribute('aria-live', priority);
      announcer.textContent = message;

      setTimeout(() => {
        announcer.textContent = '';
      }, 1000);
    }
  }

  // Focus Management
  trapFocus(element: HTMLElement): void {
    const focusableElements = element.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    const firstElement = focusableElements[0] as HTMLElement;
    const lastElement = focusableElements[focusableElements.length - 1] as HTMLElement;

    element.addEventListener('keydown', (e) => {
      if (e.key === 'Tab') {
        if (e.shiftKey && document.activeElement === firstElement) {
          e.preventDefault();
          lastElement.focus();
        } else if (!e.shiftKey && document.activeElement === lastElement) {
          e.preventDefault();
          firstElement.focus();
        }
      }
    });
  }
}
```

### User Experience Patterns

```typescript
// Loading States
interface LoadingStates {
  skeleton: 'Show content placeholder during initial load';
  spinner: 'Show spinner for quick operations (<2s)';
  progress_bar: 'Show progress for long operations (>2s)';
  optimistic_ui: 'Update UI immediately, rollback on error';
}

// Error Handling UX
class ErrorHandlingUX {
  // User-Friendly Error Messages
  private errorMessages: Record<string, string> = {
    'NETWORK_ERROR': 'Connection lost. Please check your internet.',
    'AUTH_FAILED': 'Invalid credentials. Please try again.',
    'PERMISSION_DENIED': "You don't have permission to access this.",
    'RATE_LIMIT': 'Too many requests. Please wait a moment.',
    'SERVER_ERROR': 'Something went wrong. Our team has been notified.'
  };

  displayError(errorCode: string): void {
    const message = this.errorMessages[errorCode] || 'An unexpected error occurred.';
    this.toast.error(message, {
      duration: 5000,
      action: {
        label: 'Retry',
        onClick: () => this.retryLastAction()
      }
    });
  }

  // Inline Validation
  async validateField(field: string, value: any): Promise<ValidationResult> {
    const result = await this.validator.validate(field, value);

    if (!result.valid) {
      this.showInlineError(field, result.message);
    } else {
      this.clearInlineError(field);
    }

    return result;
  }
}

// Empty States
const emptyStateTemplates = {
  no_data: {
    icon: 'InboxIcon',
    title: 'No items yet',
    description: 'Get started by creating your first item.',
    action: { label: 'Create Item', onClick: 'openCreateDialog' }
  },
  no_results: {
    icon: 'SearchIcon',
    title: 'No results found',
    description: 'Try adjusting your search or filters.',
    action: { label: 'Clear Filters', onClick: 'clearFilters' }
  },
  error_state: {
    icon: 'AlertIcon',
    title: 'Unable to load data',
    description: 'Please try again in a moment.',
    action: { label: 'Retry', onClick: 'retryLoad' }
  }
};
```

---

## FEATURE CONTROL SYSTEM

### God Dashboard Architecture

```typescript
// Feature Flag System
interface FeatureFlag {
  id: string;
  name: string;
  description: string;
  enabled: boolean;
  rollout_percentage?: number; // Gradual rollout (0-100)
  user_targeting?: {
    include_users?: string[];
    exclude_users?: string[];
    include_organizations?: string[];
    exclude_organizations?: string[];
    user_attributes?: Record<string, any>;
  };
  environment?: 'development' | 'staging' | 'production' | 'all';
  created_at: Date;
  updated_at: Date;
  created_by: string;
}

// Example Feature Flags
const featureFlags: FeatureFlag[] = [
  {
    id: 'advanced_analytics',
    name: 'Advanced Analytics',
    description: 'Access to advanced analytics dashboard',
    enabled: true,
    user_targeting: {
      user_attributes: { plan: ['professional', 'enterprise'] }
    },
    environment: 'all'
  },
  {
    id: 'ai_assistant',
    name: 'AI Assistant (Beta)',
    description: 'AI-powered content generation assistant',
    enabled: true,
    rollout_percentage: 25, // 25% of users
    environment: 'production'
  },
  {
    id: 'team_collaboration',
    name: 'Team Collaboration',
    description: 'Real-time collaboration features',
    enabled: true,
    user_targeting: {
      user_attributes: { plan: ['professional', 'enterprise'] }
    },
    environment: 'all'
  }
];

// Feature Flag Service
class FeatureFlagService {
  async isEnabled(
    flagId: string,
    user: User,
    organization: Organization
  ): Promise<boolean> {
    const flag = await this.getFlag(flagId);

    if (!flag || !flag.enabled) return false;

    // Check environment
    if (flag.environment !== 'all' && flag.environment !== process.env.NODE_ENV) {
      return false;
    }

    // Check user targeting
    if (flag.user_targeting) {
      if (!this.matchesTargeting(flag.user_targeting, user, organization)) {
        return false;
      }
    }

    // Check rollout percentage
    if (flag.rollout_percentage !== undefined) {
      const hash = this.hashUser(user.id + flagId);
      const percentage = (hash % 100) + 1;
      if (percentage > flag.rollout_percentage) {
        return false;
      }
    }

    return true;
  }

  private matchesTargeting(
    targeting: UserTargeting,
    user: User,
    organization: Organization
  ): boolean {
    // Include/exclude users
    if (targeting.include_users?.includes(user.id)) return true;
    if (targeting.exclude_users?.includes(user.id)) return false;

    // Include/exclude organizations
    if (targeting.include_organizations?.includes(organization.id)) return true;
    if (targeting.exclude_organizations?.includes(organization.id)) return false;

    // Check user attributes (e.g., plan type)
    if (targeting.user_attributes) {
      for (const [key, values] of Object.entries(targeting.user_attributes)) {
        if (!values.includes(organization[key])) {
          return false;
        }
      }
    }

    return true;
  }
}
```

### Tier-Based Feature Control

```typescript
// Pricing Tiers
enum PricingTier {
  FREE = 'free',
  STARTER = 'starter',
  PROFESSIONAL = 'professional',
  ENTERPRISE = 'enterprise'
}

// Features by Tier
interface TierFeatures {
  tier: PricingTier;
  price_monthly: number;
  price_annual: number;
  features: {
    [key: string]: boolean | number | string;
  };
}

const tierDefinitions: TierFeatures[] = [
  {
    tier: PricingTier.FREE,
    price_monthly: 0,
    price_annual: 0,
    features: {
      max_users: 1,
      max_projects: 3,
      max_storage_gb: 1,
      basic_features: true,
      advanced_analytics: false,
      api_access: false,
      custom_branding: false,
      priority_support: false,
      sla_guarantee: false
    }
  },
  {
    tier: PricingTier.PROFESSIONAL,
    price_monthly: 99,
    price_annual: 948, // 2 months free
    features: {
      max_users: 10,
      max_projects: -1, // Unlimited
      max_storage_gb: 100,
      basic_features: true,
      advanced_analytics: true,
      api_access: true,
      custom_branding: true,
      priority_support: true,
      sla_guarantee: '99.9%'
    }
  },
  {
    tier: PricingTier.ENTERPRISE,
    price_monthly: 499,
    price_annual: 4788, // 2 months free
    features: {
      max_users: -1, // Unlimited
      max_projects: -1, // Unlimited
      max_storage_gb: -1, // Unlimited
      basic_features: true,
      advanced_analytics: true,
      api_access: true,
      custom_branding: true,
      priority_support: true,
      dedicated_account_manager: true,
      sla_guarantee: '99.99%',
      custom_integrations: true,
      sso: true,
      audit_logs: true
    }
  }
];

// Feature Gating
class FeatureGateService {
  async canAccessFeature(
    feature: string,
    organization: Organization
  ): Promise<{ allowed: boolean; reason?: string }> {
    const tierFeatures = tierDefinitions.find(t => t.tier === organization.plan);

    if (!tierFeatures) {
      return { allowed: false, reason: 'Invalid plan' };
    }

    const featureValue = tierFeatures.features[feature];

    if (featureValue === false) {
      return {
        allowed: false,
        reason: `This feature is not available on your ${organization.plan} plan. Upgrade to access it.`
      };
    }

    if (typeof featureValue === 'number' && featureValue !== -1) {
      // Check usage limits
      const currentUsage = await this.getCurrentUsage(organization.id, feature);
      if (currentUsage >= featureValue) {
        return {
          allowed: false,
          reason: `You've reached the limit for ${feature}. Upgrade your plan for more.`
        };
      }
    }

    return { allowed: true };
  }

  // Upsell Prompt
  async promptUpgrade(feature: string, currentTier: PricingTier): Promise<void> {
    const nextTier = this.getNextTier(currentTier);

    await this.modal.show({
      title: 'Upgrade Required',
      content: `${feature} is available on our ${nextTier} plan.`,
      actions: [
        { label: 'Upgrade Now', onClick: () => this.redirectToUpgrade(nextTier) },
        { label: 'Learn More', onClick: () => this.showPricingPage() },
        { label: 'Maybe Later', onClick: () => this.modal.close() }
      ]
    });
  }
}
```

### Usage-Based Rate Limiting

```typescript
// Rate Limit Configuration
interface RateLimitConfig {
  endpoint: string;
  limits: {
    free: { requests: number; window: string };
    professional: { requests: number; window: string };
    enterprise: { requests: number; window: string };
  };
}

const rateLimits: RateLimitConfig[] = [
  {
    endpoint: '/api/generate',
    limits: {
      free: { requests: 10, window: '1h' },
      professional: { requests: 1000, window: '1h' },
      enterprise: { requests: -1, window: '1h' } // Unlimited
    }
  },
  {
    endpoint: '/api/analytics',
    limits: {
      free: { requests: 100, window: '1d' },
      professional: { requests: 10000, window: '1d' },
      enterprise: { requests: -1, window: '1d' }
    }
  }
];

// Rate Limiter Middleware
class RateLimiterMiddleware {
  async checkRateLimit(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const user = req.user;
    const organization = await this.getOrganization(user.organizationId);
    const endpoint = req.path;

    const config = rateLimits.find(r => endpoint.startsWith(r.endpoint));
    if (!config) return next();

    const limit = config.limits[organization.plan];
    if (limit.requests === -1) return next(); // Unlimited

    const key = `rate_limit:${organization.id}:${endpoint}`;
    const current = await redis.incr(key);

    if (current === 1) {
      await redis.expire(key, this.parseWindow(limit.window));
    }

    if (current > limit.requests) {
      return res.status(429).json({
        error: 'Rate limit exceeded',
        limit: limit.requests,
        window: limit.window,
        retry_after: await redis.ttl(key)
      });
    }

    res.setHeader('X-RateLimit-Limit', limit.requests.toString());
    res.setHeader('X-RateLimit-Remaining', (limit.requests - current).toString());
    res.setHeader('X-RateLimit-Reset', (Date.now() + await redis.ttl(key) * 1000).toString());

    next();
  }
}
```

---

## TECHNOLOGY STACK

### Frontend Stack

```typescript
const frontendStack = {
  framework: {
    primary: 'Next.js 14 (React 18)',
    alternative: 'SvelteKit | Nuxt.js (Vue) | Remix',
    rationale: 'Server-side rendering, SEO, performance'
  },

  styling: {
    primary: 'Tailwind CSS',
    component_library: 'Shadcn/ui | Radix UI',
    alternative: 'Chakra UI | Material UI | Ant Design'
  },

  state_management: {
    server_state: 'TanStack Query (React Query)',
    client_state: 'Zustand | Jotai',
    forms: 'React Hook Form + Zod validation'
  },

  build_tools: {
    bundler: 'Turbopack (Next.js) | Vite',
    package_manager: 'pnpm',
    monorepo: 'Turborepo'
  },

  testing: {
    unit: 'Vitest | Jest',
    integration: 'React Testing Library',
    e2e: 'Playwright | Cypress'
  }
};
```

### Backend Stack

```typescript
const backendStack = {
  runtime: {
    primary: 'Node.js 20 LTS',
    alternative: 'Deno | Bun'
  },

  framework: {
    api: 'Fastify | Express | Hono',
    graphql: 'Apollo Server | GraphQL Yoga (optional)'
  },

  database: {
    primary: 'PostgreSQL 16',
    orm: 'Drizzle ORM | Prisma',
    migrations: 'Drizzle Kit | Prisma Migrate'
  },

  caching: {
    primary: 'Redis 7',
    use_cases: ['Session storage', 'Rate limiting', 'Queue', 'Cache']
  },

  queue: {
    primary: 'BullMQ (Redis)',
    alternative: 'RabbitMQ | AWS SQS'
  },

  search: {
    primary: 'Typesense | Meilisearch',
    alternative: 'Elasticsearch | Algolia'
  },

  storage: {
    files: 'AWS S3 | Cloudflare R2 | MinIO',
    cdn: 'Cloudflare CDN | AWS CloudFront'
  },

  authentication: {
    sessions: 'Redis sessions',
    tokens: 'JWT',
    oauth: 'NextAuth.js | Lucia'
  }
};
```

### Infrastructure Stack

```typescript
const infrastructureStack = {
  containerization: {
    runtime: 'Docker',
    orchestration: 'Kubernetes (K8s)',
    local_dev: 'Docker Compose'
  },

  cloud_provider: {
    primary: 'AWS | GCP | Azure',
    serverless: 'Vercel | Netlify | Cloudflare Workers'
  },

  infrastructure_as_code: {
    primary: 'Terraform',
    alternative: 'Pulumi | AWS CDK'
  },

  ci_cd: {
    primary: 'GitHub Actions',
    alternative: 'GitLab CI | CircleCI'
  },

  monitoring: {
    apm: 'Datadog | New Relic | Sentry',
    logs: 'Better Stack | Loki + Grafana',
    metrics: 'Prometheus + Grafana',
    uptime: 'Better Uptime | Pingdom'
  },

  security: {
    secrets: 'AWS Secrets Manager | HashiCorp Vault',
    waf: 'Cloudflare WAF | AWS WAF',
    ddos: 'Cloudflare | AWS Shield'
  }
};
```

### Development Tools

```typescript
const developmentTools = {
  version_control: 'Git + GitHub',

  code_quality: {
    linting: 'ESLint + Prettier',
    type_checking: 'TypeScript strict mode',
    commit_hooks: 'Husky + lint-staged'
  },

  api_development: {
    documentation: 'OpenAPI (Swagger) | GraphQL Schema',
    testing: 'Postman | Insomnia | Bruno'
  },

  database_tools: {
    gui: 'TablePlus | DBeaver',
    migrations: 'Drizzle Studio | Prisma Studio'
  },

  collaboration: {
    project_management: 'Linear | GitHub Projects',
    documentation: 'Notion | GitBook',
    design: 'Figma'
  }
};
```

---

## INFRASTRUCTURE ARCHITECTURE

### Kubernetes Deployment

```yaml
# Namespace
apiVersion: v1
kind: Namespace
metadata:
  name: production

---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
      - name: api
        image: your-registry/api:latest
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: database-secrets
              key: url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: redis-secrets
              key: url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5

---
# Service
apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: production
spec:
  selector:
    app: api-server
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: LoadBalancer

---
# HorizontalPodAutoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### Database Architecture

```sql
-- Multi-Tenant Database Schema (Schema-based isolation)

-- Create organization-specific schemas
CREATE SCHEMA org_123;
CREATE SCHEMA org_456;

-- Users table (per organization)
CREATE TABLE org_123.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  role VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row-Level Security (RLS) alternative
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  role VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(organization_id, email)
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- RLS Policy
CREATE POLICY tenant_isolation ON users
  USING (organization_id = current_setting('app.current_organization_id')::UUID);

-- Indexes for performance
CREATE INDEX idx_users_org_id ON users(organization_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- Audit logging
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL,
  user_id UUID,
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(100),
  resource_id UUID,
  changes JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_org ON audit_logs(organization_id);
CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at);
```

### Caching Strategy

```typescript
// Redis Caching Patterns
class CacheService {
  // Cache-Aside Pattern
  async get<T>(key: string, fetchFn: () => Promise<T>, ttl: number = 3600): Promise<T> {
    // Try to get from cache
    const cached = await redis.get(key);
    if (cached) {
      return JSON.parse(cached);
    }

    // Cache miss - fetch from source
    const data = await fetchFn();

    // Store in cache
    await redis.setex(key, ttl, JSON.stringify(data));

    return data;
  }

  // Cache Invalidation
  async invalidate(pattern: string): Promise<void> {
    const keys = await redis.keys(pattern);
    if (keys.length > 0) {
      await redis.del(...keys);
    }
  }

  // Cache Warming (Pre-populate frequently accessed data)
  async warmCache(): Promise<void> {
    const popularItems = await this.getPopularItems();

    await Promise.all(
      popularItems.map(item =>
        this.set(`item:${item.id}`, item, 3600)
      )
    );
  }
}

// Cache Key Patterns
const cacheKeys = {
  user: (id: string) => `user:${id}`,
  organization: (id: string) => `org:${id}`,
  userPermissions: (userId: string) => `permissions:${userId}`,
  featureFlag: (flagId: string, orgId: string) => `flag:${flagId}:${orgId}`,
  rateLimit: (ip: string, endpoint: string) => `ratelimit:${ip}:${endpoint}`
};
```

### CDN & Asset Optimization

```typescript
// Asset Optimization Strategy
const assetStrategy = {
  images: {
    formats: ['WebP', 'AVIF', 'JPEG'],
    sizes: [320, 640, 768, 1024, 1280, 1920],
    lazy_loading: true,
    cdn: 'Cloudflare Images | Imgix'
  },

  static_assets: {
    bundling: 'Code splitting + Tree shaking',
    compression: 'Brotli + Gzip',
    cache_control: 'Immutable with hash-based versioning',
    cdn: 'Cloudflare CDN'
  },

  fonts: {
    loading: 'font-display: swap',
    subset: 'Only required characters',
    formats: ['WOFF2', 'WOFF']
  }
};

// Next.js Image Optimization
import Image from 'next/image';

function OptimizedImage({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={800}
      height={600}
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      loading="lazy"
      placeholder="blur"
    />
  );
}
```

---

## TESTING FRAMEWORK

### 10-Phase Testing System (GenCraft Pattern)

```typescript
// Phase 0: Pre-flight Validation
class PreflightValidator {
  async validate(): Promise<ValidationResult> {
    const checks = [
      this.checkDependencies(),
      this.checkEnvironment(),
      this.checkDatabaseConnection(),
      this.checkRedisConnection(),
      this.checkExternalServices()
    ];

    const results = await Promise.all(checks);
    return {
      passed: results.every(r => r.passed),
      results
    };
  }
}

// Phase 1: Test Discovery & Classification
class TestDiscovery {
  async discoverTests(): Promise<TestSuite[]> {
    const tests = await this.scanTestFiles();

    return tests.map(test => ({
      ...test,
      category: this.classifyTest(test),
      priority: this.calculatePriority(test),
      dependencies: this.extractDependencies(test)
    }));
  }

  private classifyTest(test: Test): TestCategory {
    if (test.path.includes('/unit/')) return 'unit';
    if (test.path.includes('/integration/')) return 'integration';
    if (test.path.includes('/e2e/')) return 'e2e';
    if (test.path.includes('/security/')) return 'security';
    return 'other';
  }
}

// Phase 2: Dependency Resolution & Ordering
class DependencyResolver {
  async orderTests(tests: Test[]): Promise<Test[]> {
    const graph = this.buildDependencyGraph(tests);
    return this.topologicalSort(graph);
  }
}

// Phase 3: System Snapshot for Rollback
class SnapshotManager {
  async createSnapshot(): Promise<Snapshot> {
    return {
      database: await this.snapshotDatabase(),
      files: await this.snapshotFiles(),
      config: await this.snapshotConfig(),
      timestamp: new Date()
    };
  }

  async rollback(snapshot: Snapshot): Promise<void> {
    await this.restoreDatabase(snapshot.database);
    await this.restoreFiles(snapshot.files);
    await this.restoreConfig(snapshot.config);
  }
}

// Phase 4: Parallel Execution with Validation
class ParallelTestRunner {
  async run(tests: Test[], workers: number = 8): Promise<TestResult[]> {
    const chunks = this.chunkTests(tests, workers);

    const results = await Promise.all(
      chunks.map(chunk => this.runTestChunk(chunk))
    );

    return results.flat();
  }
}

// Phase 5: Multi-stage Result Validation
class ResultValidator {
  async validate(result: TestResult): Promise<ValidationResult> {
    // Stage 1: Deterministic Validation
    const stage1 = this.deterministicValidation(result);
    if (!stage1.passed) return stage1;

    // Stage 2: Statistical Analysis
    const stage2 = await this.statisticalAnalysis(result);
    if (!stage2.passed) return stage2;

    // Stage 3: Behavioral Verification
    const stage3 = await this.behavioralVerification(result);
    if (!stage3.passed) return stage3;

    // Stage 4: Temporal Consistency
    const stage4 = await this.temporalConsistency(result);
    if (!stage4.passed) return stage4;

    // Stage 5: Quantum Validation (future-proof)
    const stage5 = await this.quantumValidation(result);

    return stage5;
  }
}

// Phase 6: Cross-validation
class CrossValidator {
  async crossValidate(result: TestResult): Promise<CrossValidationResult> {
    const validators = [
      new Validator1(),
      new Validator2(),
      new Validator3()
    ];

    const results = await Promise.all(
      validators.map(v => v.validate(result))
    );

    return {
      consensus: results.every(r => r.passed),
      disagreements: results.filter(r => !r.passed),
      confidence: this.calculateConfidence(results)
    };
  }
}

// Phase 7: Consensus Verification
class ConsensusVerifier {
  async verify(results: ValidationResult[]): Promise<boolean> {
    const threshold = 0.67; // 2/3 consensus required
    const passed = results.filter(r => r.passed).length;
    const total = results.length;

    return (passed / total) >= threshold;
  }
}

// Phase 8: Enterprise Report Generation
class ReportGenerator {
  async generate(results: TestResult[]): Promise<EnterpriseReport> {
    return {
      summary: this.generateSummary(results),
      details: this.generateDetails(results),
      compliance: this.checkCompliance(results),
      recommendations: this.generateRecommendations(results),
      exportFormats: ['JSON', 'HTML', 'PDF']
    };
  }
}

// Phase 9: Claude Projects Synchronization
class ProjectSynchronizer {
  async sync(report: EnterpriseReport): Promise<void> {
    await this.updateQuantumTodo(report);
    await this.updateDocumentation(report);
    await this.notifyStakeholders(report);
  }
}
```

### Test Examples

```typescript
// Unit Test Example
describe('UserService', () => {
  it('should create a new user', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'secure_password',
      name: 'Test User'
    };

    const user = await userService.create(userData);

    expect(user).toHaveProperty('id');
    expect(user.email).toBe(userData.email);
    expect(user.password_hash).not.toBe(userData.password);
  });

  it('should not create duplicate users', async () => {
    const userData = {
      email: 'existing@example.com',
      password: 'password'
    };

    await userService.create(userData);

    await expect(
      userService.create(userData)
    ).rejects.toThrow('User already exists');
  });
});

// Integration Test Example
describe('Authentication Flow', () => {
  it('should complete full auth flow', async () => {
    // Register
    const registerResponse = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'newuser@example.com',
        password: 'SecurePass123!',
        name: 'New User'
      })
      .expect(201);

    // Login
    const loginResponse = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'newuser@example.com',
        password: 'SecurePass123!'
      })
      .expect(200);

    expect(loginResponse.body).toHaveProperty('access_token');

    // Access protected route
    const protectedResponse = await request(app)
      .get('/api/user/profile')
      .set('Authorization', `Bearer ${loginResponse.body.access_token}`)
      .expect(200);

    expect(protectedResponse.body.email).toBe('newuser@example.com');
  });
});

// E2E Test Example (Playwright)
test('complete user journey', async ({ page }) => {
  // Navigate to landing page
  await page.goto('https://app.example.com');

  // Click sign up
  await page.click('[data-testid="signup-button"]');

  // Fill registration form
  await page.fill('[data-testid="email-input"]', 'e2e@example.com');
  await page.fill('[data-testid="password-input"]', 'SecurePass123!');
  await page.fill('[data-testid="name-input"]', 'E2E Test User');

  // Submit form
  await page.click('[data-testid="submit-button"]');

  // Wait for redirect to dashboard
  await page.waitForURL('**/dashboard');

  // Verify user is logged in
  const userName = await page.textContent('[data-testid="user-name"]');
  expect(userName).toBe('E2E Test User');

  // Create a new item
  await page.click('[data-testid="create-item-button"]');
  await page.fill('[data-testid="item-title"]', 'Test Item');
  await page.click('[data-testid="save-item-button"]');

  // Verify item was created
  const itemTitle = await page.textContent('[data-testid="item-0-title"]');
  expect(itemTitle).toBe('Test Item');
});
```

---

## DEPLOYMENT PIPELINE

### CI/CD Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '20.x'
  PNPM_VERSION: '8.x'

jobs:
  # Job 1: Code Quality
  code-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Lint
        run: pnpm lint

      - name: Type check
        run: pnpm type-check

      - name: Format check
        run: pnpm format:check

  # Job 2: Unit & Integration Tests
  test:
    runs-on: ubuntu-latest
    needs: code-quality

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Run migrations
        run: pnpm db:migrate
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test

      - name: Run tests
        run: pnpm test:ci
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test
          REDIS_URL: redis://localhost:6379

      - name: Upload coverage
        uses: codecov/codecov-action@v3

  # Job 3: E2E Tests
  e2e:
    runs-on: ubuntu-latest
    needs: test

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Install Playwright
        run: pnpm playwright install --with-deps

      - name: Run E2E tests
        run: pnpm test:e2e

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/

  # Job 4: Build & Security Scan
  build:
    runs-on: ubuntu-latest
    needs: [test, e2e]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Build
        run: pnpm build

      - name: Security audit
        run: pnpm audit --audit-level=moderate

      - name: Docker build
        run: docker build -t myapp:${{ github.sha }} .

      - name: Trivy scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'

      - name: Upload scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'

  # Job 5: Deploy to Staging
  deploy-staging:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment:
      name: staging
      url: https://staging.example.com

    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Deploy to ECS
        run: |
          # Update task definition
          # Deploy to staging environment
          aws ecs update-service \
            --cluster staging-cluster \
            --service myapp-service \
            --force-new-deployment

  # Job 6: Deploy to Production
  deploy-production:
    runs-on: ubuntu-latest
    needs: deploy-staging
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://app.example.com

    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Blue-Green Deployment
        run: |
          # Deploy to green environment
          # Run smoke tests
          # Switch traffic to green
          # Keep blue as backup for 1 hour
```

### Deployment Strategies

```typescript
// Blue-Green Deployment
class BlueGreenDeployment {
  async deploy(newVersion: string): Promise<void> {
    // Deploy to green environment
    await this.deployToGreen(newVersion);

    // Run smoke tests
    const smokeTestsPassed = await this.runSmokeTests('green');
    if (!smokeTestsPassed) {
      throw new Error('Smoke tests failed');
    }

    // Switch traffic (0% → 100% in 5 minutes)
    await this.switchTraffic('blue', 'green', {
      duration: '5m',
      strategy: 'linear'
    });

    // Keep blue as backup
    await this.scheduleBackupCleanup('blue', '1h');
  }
}

// Canary Deployment
class CanaryDeployment {
  async deploy(newVersion: string): Promise<void> {
    // Deploy canary
    await this.deployCanary(newVersion);

    // Route 5% traffic to canary
    await this.routeTraffic('canary', 5);

    // Monitor for 10 minutes
    const metrics = await this.monitorMetrics('canary', '10m');

    if (metrics.errorRate > 0.01) {
      // Rollback
      await this.rollback();
      throw new Error('Canary deployment failed');
    }

    // Gradually increase traffic
    await this.routeTraffic('canary', 25);
    await this.waitAndMonitor('5m');

    await this.routeTraffic('canary', 50);
    await this.waitAndMonitor('5m');

    await this.routeTraffic('canary', 100);
  }
}
```

---

## MONITORING & OBSERVABILITY

### Metrics & Alerting

```typescript
// Prometheus Metrics
import { Counter, Histogram, Gauge } from 'prom-client';

// HTTP request metrics
const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Business metrics
const activeUsers = new Gauge({
  name: 'active_users_total',
  help: 'Number of active users'
});

const subscriptionRevenue = new Gauge({
  name: 'subscription_revenue_usd',
  help: 'Total subscription revenue in USD'
});

// Middleware to track metrics
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;

    httpRequestDuration
      .labels(req.method, req.route?.path || req.path, res.statusCode.toString())
      .observe(duration);

    httpRequestTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode.toString())
      .inc();
  });

  next();
});
```

### Logging Strategy

```typescript
// Structured Logging
import { createLogger, format, transports } from 'winston';

const logger = createLogger({
  level: 'info',
  format: format.combine(
    format.timestamp(),
    format.errors({ stack: true }),
    format.json()
  ),
  defaultMeta: {
    service: 'api',
    environment: process.env.NODE_ENV
  },
  transports: [
    new transports.Console({
      format: format.combine(
        format.colorize(),
        format.simple()
      )
    }),
    new transports.File({ filename: 'error.log', level: 'error' }),
    new transports.File({ filename: 'combined.log' })
  ]
});

// Usage
logger.info('User created', {
  userId: user.id,
  email: user.email,
  organizationId: user.organizationId
});

logger.error('Payment failed', {
  userId: user.id,
  error: error.message,
  stack: error.stack,
  paymentId: payment.id
});
```

### Error Tracking (Sentry)

```typescript
import * as Sentry from '@sentry/node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 0.1, // 10% of transactions
  beforeSend(event, hint) {
    // Filter sensitive data
    if (event.request) {
      delete event.request.headers?.authorization;
      delete event.request.cookies;
    }
    return event;
  }
});

// Error middleware
app.use((err, req, res, next) => {
  Sentry.captureException(err, {
    user: {
      id: req.user?.id,
      email: req.user?.email
    },
    tags: {
      endpoint: req.path,
      method: req.method
    }
  });

  res.status(500).json({ error: 'Internal server error' });
});
```

### Uptime Monitoring

```typescript
// Health Check Endpoint
app.get('/health', async (req, res) => {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    external_api: await checkExternalAPI()
  };

  const allHealthy = Object.values(checks).every(c => c.healthy);

  res.status(allHealthy ? 200 : 503).json({
    status: allHealthy ? 'healthy' : 'degraded',
    checks,
    timestamp: new Date().toISOString()
  });
});

async function checkDatabase(): Promise<HealthCheck> {
  try {
    await db.raw('SELECT 1');
    return { healthy: true };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}
```

---

## COST OPTIMIZATION

### AI Cost Optimization (GenCraft Pattern)

```typescript
// Intelligent Model Routing (82-86% cost reduction)
class ModelRouter {
  async route(request: AIRequest): Promise<AIResponse> {
    // Stage 1: Check surrogate model
    const surrogateConfidence = await this.surrogateModel.assess(request);

    if (surrogateConfidence > 0.85) {
      // Use fast, cheap surrogate (87% of requests)
      return await this.surrogateModel.generate(request);
    }

    // Stage 2: Bayesian uncertainty quantification
    const uncertainty = await this.calculateUncertainty(request);

    if (uncertainty < 0.1) {
      // Use Haiku (fast, cheap) - 78% of LLM requests
      return await this.callClaude('haiku', request);
    } else if (uncertainty < 0.3) {
      // Use Sonnet (balanced) - 18% of LLM requests
      return await this.callClaude('sonnet', request);
    } else {
      // Use Opus (highest quality) - 4% of LLM requests
      return await this.callClaude('opus', request);
    }
  }

  // SINDy-RL: Learn patterns to improve surrogate
  async learnFromFeedback(request: AIRequest, response: AIResponse, feedback: Feedback): Promise<void> {
    // Extract features
    const features = this.extractFeatures(request);

    // Discover sparse equation
    const equation = await this.sparsifyDynamics(features, feedback);
    // Example: quality = 0.4×sections + 0.3×hasImages + 0.2×hasCTA

    // Update surrogate model
    await this.surrogateModel.update(equation);

    // Propagate to all verticals (meta-learning)
    await this.propagateToAllVerticals(equation);
  }
}

// Cost tracking
class CostTracker {
  async trackCost(request: AIRequest, model: string): Promise<void> {
    const cost = this.calculateCost(request, model);

    await this.metrics.record({
      model,
      tokens: request.tokens,
      cost,
      timestamp: Date.now()
    });

    // Alert if costs exceed budget
    const dailyCost = await this.getDailyCost();
    if (dailyCost > this.dailyBudget) {
      await this.alertTeam('Cost budget exceeded');
    }
  }
}
```

### Infrastructure Cost Optimization

```typescript
// Auto-scaling based on load
const autoScalingConfig = {
  min_replicas: 2,
  max_replicas: 10,

  scale_up: {
    cpu_threshold: 70,
    memory_threshold: 80,
    request_queue_length: 100
  },

  scale_down: {
    cpu_threshold: 30,
    memory_threshold: 40,
    cooldown_period: '5m'
  }
};

// Reserved instances for predictable workloads
const reservedInstances = {
  type: 't3.medium',
  count: 2, // Base capacity
  commitment: '1-year',
  savings: '40%' // vs on-demand
};

// Spot instances for batch processing
const spotInstances = {
  type: 'c5.xlarge',
  max_price: '$0.05/hour',
  use_cases: ['data processing', 'report generation'],
  savings: '70%' // vs on-demand
};
```

---

## IMPLEMENTATION CHECKLIST

### Phase 1: Foundation (Week 1-2)

- [ ] **Repository Setup**
  - [ ] Create monorepo with Turborepo
  - [ ] Configure TypeScript
  - [ ] Setup ESLint + Prettier
  - [ ] Configure Git hooks (Husky)
  - [ ] Create GitHub workflows

- [ ] **Database Setup**
  - [ ] Provision PostgreSQL
  - [ ] Setup Drizzle ORM
  - [ ] Create initial schema
  - [ ] Setup migrations
  - [ ] Configure backups

- [ ] **Authentication System**
  - [ ] Implement user registration
  - [ ] Implement login/logout
  - [ ] Add JWT authentication
  - [ ] Add MFA support
  - [ ] Add OAuth providers

### Phase 2: Core Features (Week 3-4)

- [ ] **User Management**
  - [ ] User CRUD operations
  - [ ] Profile management
  - [ ] Role-based access control
  - [ ] Organization management

- [ ] **Feature Control**
  - [ ] Feature flag system
  - [ ] Tier-based gating
  - [ ] Usage tracking
  - [ ] Rate limiting

- [ ] **UI/UX**
  - [ ] Design system
  - [ ] Component library
  - [ ] Responsive layouts
  - [ ] Accessibility compliance

### Phase 3: Advanced Features (Week 5-6)

- [ ] **Analytics**
  - [ ] User analytics
  - [ ] Business metrics
  - [ ] Dashboard creation
  - [ ] Report generation

- [ ] **Integrations**
  - [ ] API development
  - [ ] Webhook system
  - [ ] Third-party integrations
  - [ ] API documentation

- [ ] **Payments**
  - [ ] Stripe integration
  - [ ] Subscription management
  - [ ] Invoice generation
  - [ ] Usage-based billing

### Phase 4: Production Readiness (Week 7-8)

- [ ] **Testing**
  - [ ] Unit tests (80%+ coverage)
  - [ ] Integration tests
  - [ ] E2E tests
  - [ ] Load testing

- [ ] **Security**
  - [ ] Security audit
  - [ ] Penetration testing
  - [ ] GDPR compliance
  - [ ] SOC 2 preparation

- [ ] **Infrastructure**
  - [ ] Production deployment
  - [ ] Monitoring setup
  - [ ] Backup strategy
  - [ ] Disaster recovery

- [ ] **Documentation**
  - [ ] API documentation
  - [ ] User guides
  - [ ] Admin guides
  - [ ] Developer docs

### Phase 5: Launch (Week 9-10)

- [ ] **Soft Launch**
  - [ ] Beta user onboarding
  - [ ] Feedback collection
  - [ ] Bug fixes
  - [ ] Performance tuning

- [ ] **Public Launch**
  - [ ] Marketing site
  - [ ] Launch announcement
  - [ ] Customer support
  - [ ] Growth tracking

---

## MAINTENANCE & UPDATES

### Regular Maintenance Tasks

```typescript
const maintenanceTasks = {
  daily: [
    'Monitor error rates',
    'Check disk space',
    'Review security alerts',
    'Check backup status'
  ],

  weekly: [
    'Update dependencies',
    'Review performance metrics',
    'Database optimization',
    'Clean up old logs'
  ],

  monthly: [
    'Security audit',
    'Cost optimization review',
    'Feature usage analysis',
    'Customer feedback review'
  ],

  quarterly: [
    'Major dependency updates',
    'Infrastructure review',
    'Disaster recovery test',
    'Compliance audit'
  ]
};
```

### Upgrade Strategy

```typescript
// Zero-downtime upgrades
class UpgradeStrategy {
  async upgrade(newVersion: string): Promise<void> {
    // 1. Deploy new version alongside old
    await this.deployParallel(newVersion);

    // 2. Run database migrations (backward compatible)
    await this.runMigrations(newVersion);

    // 3. Gradually shift traffic
    await this.gradualTrafficShift({
      from: 'current',
      to: newVersion,
      duration: '30m'
    });

    // 4. Monitor for issues
    const issues = await this.monitorForIssues('30m');

    if (issues.length > 0) {
      // Rollback
      await this.rollback();
      throw new Error('Upgrade failed, rolled back');
    }

    // 5. Cleanup old version
    await this.cleanupOldVersion();
  }
}
```

---

## APPENDIX

### Useful Resources

- **Documentation**: https://docs.yourapp.com
- **API Reference**: https://api.yourapp.com/docs
- **Status Page**: https://status.yourapp.com
- **GitHub**: https://github.com/yourorg/yourapp

### Support & Contact

- **Email**: support@yourapp.com
- **Discord**: https://discord.gg/yourapp
- **Twitter**: @yourapp

---

**End of Template**

*This template is based on production patterns from GenCraft v3.0 and represents enterprise-grade architecture. Customize as needed for your specific use case.*
