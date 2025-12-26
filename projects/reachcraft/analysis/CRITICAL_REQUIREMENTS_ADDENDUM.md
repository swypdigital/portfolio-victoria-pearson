# REACHCRAFT CRITICAL REQUIREMENTS ADDENDUM
**Missed Enterprise Features from Previous Session**

**Date:** 2025-12-16
**Status:** CRITICAL ADDITIONS TO PATTERN EXTRACTION

---

## 🚨 CRITICAL MISSED REQUIREMENTS

### 1. AUTO/MANUAL TOGGLE FOR EVERY AUTOMATION ASPECT

**Requirement:** User must have granular control over ALL automation - nothing should be forced into automatic mode.

#### Pattern from GenCraft Zero-HIL (Enhanced):
```typescript
interface AutomationControl {
  // Global automation settings
  globalMode: 'auto' | 'manual' | 'hybrid';

  // Per-feature automation toggles
  features: {
    contactSync: AutomationToggle;
    leadScoring: AutomationToggle;
    outreachCampaigns: AutomationToggle;
    emailGeneration: AutomationToggle;
    followUpSequences: AutomationToggle;
    duplicateMerging: AutomationToggle;
    webScraping: AutomationToggle;
    leadEnrichment: AutomationToggle;
    pipelineProgression: AutomationToggle;
  };
}

interface AutomationToggle {
  mode: 'auto' | 'manual' | 'approval-required';

  // Auto mode: runs without user interaction
  autoConfig?: {
    enabled: boolean;
    schedule?: string; // cron expression
    batchSize?: number;
    notifyOnCompletion: boolean;
  };

  // Approval mode: requires user confirmation at checkpoints
  approvalConfig?: {
    enabled: boolean;
    checkpoints: ApprovalCheckpoint[];
    timeout?: number; // auto-approve after X seconds if no response
  };

  // Manual mode: user must explicitly trigger
  manualConfig?: {
    showDashboard: boolean;
    quickActionButton: boolean;
    batchProcessing: boolean;
  };
}

interface ApprovalCheckpoint {
  stage: string; // e.g., 'before-send', 'after-scrape', 'before-merge'
  requiresApproval: boolean;
  autoApproveAfter?: number; // ms
  notificationMethod: 'email' | 'sms' | 'in-app' | 'all';
}

// Example: User control for email campaign
const emailCampaignControl = {
  mode: 'approval-required',
  approvalConfig: {
    enabled: true,
    checkpoints: [
      {
        stage: 'before-send',
        requiresApproval: true,
        autoApproveAfter: 3600000, // 1 hour
        notificationMethod: 'in-app'
      },
      {
        stage: 'after-batch',
        requiresApproval: true, // Review results after each 50 emails
        notificationMethod: 'email'
      }
    ]
  }
};

// UI Component: Automation Toggle
function AutomationToggleUI({ feature }: { feature: string }) {
  const [mode, setMode] = useState<'auto' | 'manual' | 'approval'>('manual');

  return (
    <div className="automation-control">
      <h3>{feature} Automation</h3>

      <ToggleGroup value={mode} onValueChange={setMode}>
        <ToggleGroupItem value="manual">
          <Icon name="hand" />
          Manual
          <p>You trigger every action</p>
        </ToggleGroupItem>

        <ToggleGroupItem value="approval">
          <Icon name="check-circle" />
          Approval Required
          <p>System asks before acting</p>
        </ToggleGroupItem>

        <ToggleGroupItem value="auto">
          <Icon name="zap" />
          Fully Automatic
          <p>System acts autonomously</p>
        </ToggleGroupItem>
      </ToggleGroup>

      {mode === 'approval' && (
        <ApprovalCheckpointConfig feature={feature} />
      )}

      {mode === 'auto' && (
        <AutoScheduleConfig feature={feature} />
      )}
    </div>
  );
}
```

---

### 2. WEB SCRAPING FOR LEAD DISCOVERY

**Requirement:** AI-powered web scraping to find contacts that match project goals, with manual review/approval before adding to CRM.

#### New Pattern: AI-Driven Lead Scraping Engine
```typescript
interface ScrapingProject {
  id: string;
  name: string;
  goal: string; // Natural language: "Find CTOs at SaaS companies with 50-200 employees"

  // AI-generated specifications
  targetProfile: {
    titles: string[]; // Auto-generated: ["CTO", "Chief Technology Officer", "VP Engineering"]
    industries: string[]; // Auto-generated: ["SaaS", "Software", "Cloud Computing"]
    companySize: { min: number; max: number };
    locations?: string[];
    technologies?: string[]; // Inferred from goal
    keywords?: string[];
  };

  // Scraping configuration
  sources: ScrapingSource[];

  // Manual review settings
  reviewMode: 'manual' | 'auto' | 'approval-threshold';
  approvalThreshold?: number; // Auto-approve if confidence > X%

  // Results
  scrapedLeads: ScrapedLead[];
  approvedLeads: string[]; // IDs of leads added to CRM
  rejectedLeads: string[]; // IDs of leads rejected
}

interface ScrapingSource {
  type: 'linkedin' | 'google' | 'company-websites' | 'directories' | 'news';
  enabled: boolean;
  config: {
    searchQuery?: string; // AI-generated
    maxResults?: number;
    rateLimit?: number;
  };
}

interface ScrapedLead {
  id: string;
  source: string;
  scrapedAt: Date;

  // Scraped data
  name?: string;
  title?: string;
  company?: string;
  email?: string;
  phone?: string;
  linkedIn?: string;
  website?: string;
  location?: string;

  // AI analysis
  matchScore: number; // 0-100 based on project goal
  matchReasons: string[]; // Why this lead matches
  confidence: number; // 0-100 confidence in data accuracy

  // Enrichment
  enrichedData?: {
    companyInfo?: CompanyData;
    socialProfiles?: SocialProfile[];
    recentActivity?: Activity[];
  };

  // Review status
  status: 'pending' | 'approved' | 'rejected';
  reviewedBy?: string;
  reviewedAt?: Date;
  reviewNotes?: string;
}

// AI Goal Parser
class LeadScrapingAI {
  async parseGoal(goal: string): Promise<TargetProfile> {
    const prompt = `
      Analyze this lead generation goal and extract structured criteria:
      Goal: "${goal}"

      Extract:
      1. Job titles to target
      2. Industries to focus on
      3. Company size range
      4. Geographic locations (if any)
      5. Technologies/tools they might use
      6. Keywords to search for

      Return JSON with extracted criteria.
    `;

    const result = await llm.generate(prompt, { format: 'json' });

    return {
      titles: result.titles || [],
      industries: result.industries || [],
      companySize: result.companySize || { min: 1, max: 10000 },
      locations: result.locations || [],
      technologies: result.technologies || [],
      keywords: result.keywords || []
    };
  }

  async generateSearchQueries(profile: TargetProfile): Promise<string[]> {
    const queries = [];

    // LinkedIn queries
    for (const title of profile.titles) {
      for (const industry of profile.industries) {
        queries.push(`${title} ${industry} ${profile.locations?.[0] || ''}`);
      }
    }

    // Google queries
    queries.push(`${profile.titles[0]} contact email ${profile.industries[0]}`);

    return queries;
  }

  async scoreLeadMatch(lead: ScrapedLead, profile: TargetProfile): Promise<number> {
    let score = 0;

    // Title match (40 points)
    if (profile.titles.some(t => lead.title?.toLowerCase().includes(t.toLowerCase()))) {
      score += 40;
    }

    // Industry match (30 points)
    if (profile.industries.some(i => lead.company?.toLowerCase().includes(i.toLowerCase()))) {
      score += 30;
    }

    // Has contact info (20 points)
    if (lead.email) score += 10;
    if (lead.phone) score += 5;
    if (lead.linkedIn) score += 5;

    // Location match (10 points)
    if (profile.locations && lead.location &&
        profile.locations.some(l => lead.location.includes(l))) {
      score += 10;
    }

    return Math.min(score, 100);
  }
}

// Web Scraper (LinkedIn example)
class LinkedInScraper {
  async search(query: string, maxResults: number = 100): Promise<ScrapedLead[]> {
    const results = [];

    // LinkedIn Sales Navigator API (requires premium)
    // OR LinkedIn search scraping (must comply with ToS)

    // Pseudocode:
    const searchResults = await linkedInAPI.search({
      keywords: query,
      limit: maxResults
    });

    for (const result of searchResults) {
      results.push({
        id: generateId(),
        source: 'linkedin',
        scrapedAt: new Date(),
        name: result.name,
        title: result.title,
        company: result.company,
        linkedIn: result.profileUrl,
        location: result.location,
        status: 'pending'
      });
    }

    return results;
  }
}

// Review Dashboard Component
function ScrapedLeadsReview({ projectId }: { projectId: string }) {
  const { leads } = useScrapedLeads(projectId);
  const pendingLeads = leads.filter(l => l.status === 'pending');

  return (
    <div className="scraped-leads-review">
      <h2>Review Scraped Leads ({pendingLeads.length} pending)</h2>

      {pendingLeads.map(lead => (
        <LeadCard key={lead.id} lead={lead}>
          <div className="match-info">
            <MatchScore score={lead.matchScore} />
            <MatchReasons reasons={lead.matchReasons} />
          </div>

          <div className="actions">
            <Button onClick={() => approveLead(lead.id)} variant="success">
              Add to CRM
            </Button>
            <Button onClick={() => rejectLead(lead.id)} variant="danger">
              Reject
            </Button>
            <Button onClick={() => enrichLead(lead.id)} variant="secondary">
              Enrich Data
            </Button>
          </div>
        </LeadCard>
      ))}

      <div className="bulk-actions">
        <Button onClick={() => approveAllAboveThreshold(80)}>
          Auto-approve all with score > 80%
        </Button>
      </div>
    </div>
  );
}
```

---

### 3. MULTI-PROJECT MANAGEMENT

**Requirement:** Each user can have multiple projects, each with own goals, leads, campaigns, and settings.

#### Pattern: Project-Based Multi-Tenancy
```typescript
interface Project {
  id: string;
  userId: string;
  orgId: string;

  // Project identity
  name: string;
  description: string;
  goal: string; // Natural language goal for AI

  // Project settings
  settings: {
    automation: AutomationControl;
    scraping: ScrapingConfig;
    outreach: OutreachConfig;
    featureFlags: FeatureFlags; // Per-project feature toggles
  };

  // Project data (isolated per project)
  leads: string[]; // Lead IDs
  campaigns: string[]; // Campaign IDs
  pipelines: Pipeline[];
  tags: string[];

  // Project status
  status: 'active' | 'paused' | 'archived';
  createdAt: Date;
  lastActivity: Date;

  // Team access (multi-user projects)
  team: ProjectTeamMember[];
}

interface ProjectTeamMember {
  userId: string;
  role: 'owner' | 'admin' | 'member' | 'viewer';
  permissions: string[];
  addedAt: Date;
}

// Database: RLS policies for project isolation
CREATE POLICY "Users see projects they're members of"
ON projects
FOR ALL
USING (
  id IN (
    SELECT project_id
    FROM project_team_members
    WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Leads belong to projects"
ON leads
FOR ALL
USING (
  project_id IN (
    SELECT id FROM projects
    WHERE id IN (
      SELECT project_id
      FROM project_team_members
      WHERE user_id = auth.uid()
    )
  )
);

// UI: Project Switcher
function ProjectSwitcher() {
  const { projects } = useProjects();
  const { currentProject, switchProject } = useCurrentProject();

  return (
    <DropdownMenu>
      <DropdownMenuTrigger>
        <div className="project-selector">
          <FolderIcon />
          {currentProject.name}
          <ChevronDownIcon />
        </div>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        {projects.map(project => (
          <DropdownMenuItem
            key={project.id}
            onClick={() => switchProject(project.id)}
          >
            <FolderIcon />
            {project.name}
            <Badge>{project.leads.length} leads</Badge>
          </DropdownMenuItem>
        ))}

        <DropdownMenuSeparator />

        <DropdownMenuItem onClick={createNewProject}>
          <PlusIcon />
          New Project
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
```

---

### 4. FEATURE FLAGS IN GOD MODE ADMIN

**Requirement:** All features must be toggleable via God Mode for individual users, groups, tiers, etc.

#### Pattern: Enterprise Feature Flag System
```typescript
interface FeatureFlag {
  id: string;
  name: string;
  description: string;
  category: 'core' | 'automation' | 'integrations' | 'ai' | 'enterprise';

  // Global default
  defaultEnabled: boolean;

  // Targeting rules (evaluated in order)
  rules: FeatureFlagRule[];
}

interface FeatureFlagRule {
  id: string;
  enabled: boolean;
  priority: number; // Higher = evaluated first

  // Targeting
  target: {
    type: 'user' | 'org' | 'tier' | 'group' | 'all';
    ids?: string[]; // User IDs, org IDs, etc.
    tiers?: string[]; // 'free', 'pro', 'enterprise'
    groups?: string[]; // User groups
  };

  // Rollout strategy
  rollout?: {
    percentage: number; // 0-100
    sticky: boolean; // Same user always gets same result
  };

  // Date constraints
  activeFrom?: Date;
  activeUntil?: Date;
}

// Example feature flags
const FEATURE_FLAGS: FeatureFlag[] = [
  {
    id: 'ai-email-generation',
    name: 'AI Email Generation',
    description: 'LLM-powered email content creation',
    category: 'ai',
    defaultEnabled: false,
    rules: [
      {
        enabled: true,
        priority: 100,
        target: { type: 'tier', tiers: ['enterprise', 'pro'] }
      },
      {
        enabled: true,
        priority: 50,
        target: { type: 'user', ids: ['beta-tester-1', 'beta-tester-2'] },
        rollout: { percentage: 100, sticky: true }
      }
    ]
  },
  {
    id: 'web-scraping',
    name: 'Web Scraping',
    description: 'Automated lead scraping from web sources',
    category: 'automation',
    defaultEnabled: false,
    rules: [
      {
        enabled: true,
        priority: 100,
        target: { type: 'tier', tiers: ['enterprise'] }
      },
      {
        enabled: true,
        priority: 50,
        target: { type: 'group', groups: ['early-access'] },
        rollout: { percentage: 50, sticky: true } // 50% rollout to early access group
      }
    ]
  },
  {
    id: '8-source-sync',
    name: '8-Source Contact Sync',
    description: 'Sync contacts from all 8 sources',
    category: 'integrations',
    defaultEnabled: true, // Available to all
    rules: []
  },
  {
    id: 'linkedin-outreach',
    name: 'LinkedIn Outreach',
    description: 'Automated LinkedIn connection requests and messages',
    category: 'integrations',
    defaultEnabled: false,
    rules: [
      {
        enabled: true,
        priority: 100,
        target: { type: 'tier', tiers: ['enterprise'] }
      }
    ]
  }
];

// Feature flag evaluation
class FeatureFlagService {
  async isEnabled(flagId: string, context: FlagContext): Promise<boolean> {
    const flag = await this.getFlag(flagId);

    // Evaluate rules in priority order
    const sortedRules = flag.rules.sort((a, b) => b.priority - a.priority);

    for (const rule of sortedRules) {
      if (this.matchesTarget(rule.target, context)) {
        // Check date constraints
        if (rule.activeFrom && new Date() < rule.activeFrom) continue;
        if (rule.activeUntil && new Date() > rule.activeUntil) continue;

        // Check rollout percentage
        if (rule.rollout) {
          const bucket = this.getUserBucket(context.userId, flagId);
          if (bucket > rule.rollout.percentage) continue;
        }

        return rule.enabled;
      }
    }

    // No matching rules, use default
    return flag.defaultEnabled;
  }

  private matchesTarget(target: FeatureFlagTarget, context: FlagContext): boolean {
    switch (target.type) {
      case 'all':
        return true;

      case 'user':
        return target.ids?.includes(context.userId);

      case 'org':
        return target.ids?.includes(context.orgId);

      case 'tier':
        return target.tiers?.includes(context.tier);

      case 'group':
        return context.groups?.some(g => target.groups?.includes(g));

      default:
        return false;
    }
  }

  private getUserBucket(userId: string, flagId: string): number {
    // Consistent hash to bucket user (0-100)
    const hash = crypto.createHash('md5')
      .update(`${userId}:${flagId}`)
      .digest('hex');

    return parseInt(hash.substring(0, 2), 16) % 100;
  }
}

// God Mode Admin UI
function GodModeFeatureFlags() {
  const { flags } = useFeatureFlags();

  return (
    <div className="god-mode-feature-flags">
      <h1>Feature Flags Control</h1>

      {flags.map(flag => (
        <Card key={flag.id}>
          <CardHeader>
            <h3>{flag.name}</h3>
            <Badge>{flag.category}</Badge>
          </CardHeader>

          <CardContent>
            <p>{flag.description}</p>

            <div className="default-toggle">
              <Switch
                checked={flag.defaultEnabled}
                onCheckedChange={(enabled) => updateFlagDefault(flag.id, enabled)}
              />
              <label>Default Enabled for All</label>
            </div>

            <h4>Targeting Rules</h4>
            {flag.rules.map(rule => (
              <div key={rule.id} className="rule">
                <Switch
                  checked={rule.enabled}
                  onCheckedChange={(enabled) => updateRule(flag.id, rule.id, { enabled })}
                />

                <RuleEditor rule={rule} onUpdate={(updated) => updateRule(flag.id, rule.id, updated)} />

                <Button variant="ghost" onClick={() => deleteRule(flag.id, rule.id)}>
                  Delete
                </Button>
              </div>
            ))}

            <Button onClick={() => addRule(flag.id)}>
              Add Rule
            </Button>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
```

---

### 5. CONTAINERIZED MICROSERVICES ARCHITECTURE

**Requirement:** Zero technical debt, no hard-coded dependencies, containerized, microservices, enterprise scalable.

#### Pattern: Microservices with Docker + Kubernetes
```yaml
# docker-compose.yml (Development)
version: '3.8'

services:
  # API Gateway
  gateway:
    build: ./services/gateway
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - AUTH_SERVICE_URL=http://auth:3001
      - CONTACTS_SERVICE_URL=http://contacts:3002
      - CAMPAIGNS_SERVICE_URL=http://campaigns:3003
    depends_on:
      - auth
      - contacts
      - campaigns

  # Authentication Service
  auth:
    build: ./services/auth
    ports:
      - "3001:3001"
    environment:
      - DATABASE_URL=${AUTH_DB_URL}
      - JWT_SECRET=${JWT_SECRET}
    volumes:
      - ./services/auth:/app

  # Contacts Service
  contacts:
    build: ./services/contacts
    ports:
      - "3002:3002"
    environment:
      - DATABASE_URL=${CONTACTS_DB_URL}
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis

  # Campaigns Service
  campaigns:
    build: ./services/campaigns
    ports:
      - "3003:3003"
    environment:
      - DATABASE_URL=${CAMPAIGNS_DB_URL}
      - QUEUE_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis

  # Scraping Service
  scraper:
    build: ./services/scraper
    environment:
      - DATABASE_URL=${SCRAPER_DB_URL}
      - QUEUE_URL=redis://redis:6379
    depends_on:
      - redis

  # AI Service (LLM orchestration)
  ai:
    build: ./services/ai
    ports:
      - "3004:3004"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

  # Integration Service (OAuth, webhooks)
  integrations:
    build: ./services/integrations
    ports:
      - "3005:3005"
    environment:
      - GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
      - GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
      - MICROSOFT_CLIENT_ID=${MICROSOFT_CLIENT_ID}

  # Worker Pool (background jobs)
  workers:
    build: ./services/workers
    deploy:
      replicas: 4
    environment:
      - QUEUE_URL=redis://redis:6379
    depends_on:
      - redis

  # Databases
  postgres:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

```yaml
# kubernetes/deployment.yaml (Production)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: contacts-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: contacts
  template:
    metadata:
      labels:
        app: contacts
    spec:
      containers:
      - name: contacts
        image: reachcraft/contacts:latest
        ports:
        - containerPort: 3002
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secrets
              key: contacts-db-url
        - name: REDIS_URL
          valueFrom:
            configMapKeyRef:
              name: redis-config
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
            port: 3002
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3002
          initialDelaySeconds: 5
          periodSeconds: 5

---
apiVersion: v1
kind: Service
metadata:
  name: contacts-service
spec:
  selector:
    app: contacts
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3002
  type: LoadBalancer

---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: contacts-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: contacts-service
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

#### Service Communication Pattern
```typescript
// services/contacts/src/index.ts
import express from 'express';
import { createClient } from 'redis';

const app = express();
const redis = createClient({ url: process.env.REDIS_URL });

// Service registry (for dynamic discovery)
class ServiceRegistry {
  async register(serviceName: string, url: string) {
    await redis.set(`service:${serviceName}`, url, { EX: 60 }); // 60s TTL
  }

  async discover(serviceName: string): Promise<string | null> {
    return await redis.get(`service:${serviceName}`);
  }
}

// Inter-service communication
class ServiceClient {
  async call(service: string, endpoint: string, data?: any) {
    const serviceUrl = await registry.discover(service);
    if (!serviceUrl) throw new Error(`Service ${service} not found`);

    const response = await fetch(`${serviceUrl}${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });

    return await response.json();
  }
}

// Example: Contacts service calls AI service
app.post('/contacts/:id/enrich', async (req, res) => {
  const contact = await db.contacts.findById(req.params.id);

  // Call AI service to generate insights
  const insights = await serviceClient.call('ai', '/analyze-contact', { contact });

  await db.contacts.update(req.params.id, { insights });

  res.json({ contact, insights });
});
```

---

### 6. ENTERPRISE SAAS FRAMEWORK INTEGRATION

**Requirement:** Fully integrate Enterprise SaaS Framework, Enterprise Code Framework, and 10-Phase Testing Protocol.

#### Pattern: Framework Integration Checklist
```typescript
// Enterprise SaaS Framework Compliance
interface EnterpriseCompliance {
  // Multi-Tenancy (REQUIRED)
  multiTenancy: {
    implemented: boolean;
    rlsPolicies: boolean;
    dataIsolation: boolean;
    crossTenantAdmin: boolean; // God mode
  };

  // Security (REQUIRED)
  security: {
    treasuryGrade: boolean;
    auditTrails: boolean;
    encryption: boolean; // at rest + in transit
    zeroTrust: boolean;
  };

  // Scalability (REQUIRED)
  scalability: {
    under100msQueries: boolean;
    tested1MRecords: boolean;
    horizontalScaling: boolean;
    autoScaling: boolean;
  };

  // White Label (REQUIRED)
  whiteLabel: {
    configurableBranding: boolean;
    customDomains: boolean;
    perOrgFeatureFlags: boolean;
  };

  // Admin Hierarchy (REQUIRED)
  adminHierarchy: {
    godMode: boolean;
    orgAdmin: boolean;
    manager: boolean;
    user: boolean;
    viewer: boolean;
  };

  // Compliance & Governance (REQUIRED)
  compliance: {
    gdpr: boolean;
    ccpa: boolean;
    auditTrails: boolean;
    dataExport: boolean;
    dataDelete: boolean;
  };

  // Self-Maintaining (REQUIRED)
  selfMaintaining: {
    autoCleanup: boolean;
    healthChecks: boolean;
    selfHealing: boolean;
    monitoringAlerts: boolean;
  };

  // Integration Ready (REQUIRED)
  integration: {
    restAPI: boolean;
    webhooks: boolean;
    events: boolean;
    rateLimiting: boolean;
  };

  // Monitoring & Observability (REQUIRED)
  monitoring: {
    structuredLogging: boolean;
    metrics: boolean;
    tracing: boolean;
    dashboards: boolean;
  };

  // Zero Technical Debt (REQUIRED)
  zeroDebt: {
    noTODOs: boolean;
    noHardcodedValues: boolean;
    noSymlinks: boolean;
    noWrappers: boolean;
    contractualPathsOnly: boolean;
  };

  // 10-Phase Testing (REQUIRED)
  testing: {
    phase0PreFlight: boolean;
    phase1Discovery: boolean;
    phase2DependencyResolution: boolean;
    phase3Snapshot: boolean;
    phase4ParallelExecution: boolean;
    phase5MultiStageValidation: boolean;
    phase6CrossValidation: boolean;
    phase7ConsensusVerification: boolean;
    phase8EnterpriseReport: boolean;
    phase9Synchronization: boolean;
    passRate100Percent: boolean;
  };
}

// Validation script
async function validateEnterpriseCompliance(): Promise<ComplianceReport> {
  const report: ComplianceReport = {
    timestamp: new Date(),
    overallScore: 0,
    categories: []
  };

  // Check each category
  for (const category of Object.keys(EnterpriseCompliance)) {
    const checks = await runCategoryChecks(category);
    const score = (checks.passed / checks.total) * 100;

    report.categories.push({
      name: category,
      score,
      passed: checks.passed,
      total: checks.total,
      failures: checks.failures
    });
  }

  // Overall score
  report.overallScore = report.categories.reduce((sum, c) => sum + c.score, 0) / report.categories.length;

  // Enforcement
  if (report.overallScore < 100) {
    throw new Error(`Enterprise compliance failed: ${report.overallScore}% (100% required)`);
  }

  return report;
}

// CI/CD Integration
// .github/workflows/enterprise-compliance.yml
name: Enterprise Compliance Check

on: [push, pull_request]

jobs:
  compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Enterprise Compliance Tests
        run: npm run test:enterprise-compliance

      - name: Validate 100% Pass Rate
        run: |
          SCORE=$(node -e "console.log(require('./compliance-report.json').overallScore)")
          if [ "$SCORE" != "100" ]; then
            echo "❌ Enterprise compliance failed: $SCORE%"
            exit 1
          fi
          echo "✅ Enterprise compliance: 100%"

      - name: Upload Compliance Report
        uses: actions/upload-artifact@v3
        with:
          name: compliance-report
          path: compliance-report.json
```

---

### 7. AI-POWERED AUTO-SPEC GENERATION FOR SCRAPING

**Requirement:** When user launches auto-scrape, system generates specifications automatically based on project goal.

#### Pattern: AI Goal-to-Specification Engine
```typescript
class AutoScrapingSpecGenerator {
  async generateFromGoal(goal: string): Promise<ScrapingSpecification> {
    // Step 1: Parse natural language goal
    const parsedGoal = await this.parseGoal(goal);

    // Step 2: Generate search criteria
    const searchCriteria = await this.generateSearchCriteria(parsedGoal);

    // Step 3: Identify optimal sources
    const sources = await this.identifyBestSources(searchCriteria);

    // Step 4: Generate validation rules
    const validationRules = await this.generateValidationRules(parsedGoal);

    // Step 5: Create complete specification
    return {
      goal,
      parsedGoal,
      searchCriteria,
      sources,
      validationRules,
      confidence: await this.calculateConfidence(parsedGoal, searchCriteria),
      generatedAt: new Date()
    };
  }

  private async parseGoal(goal: string): Promise<ParsedGoal> {
    const prompt = `
      Analyze this lead generation goal and extract ALL relevant information:

      Goal: "${goal}"

      Extract:
      1. WHO: Job titles, roles, seniority levels
      2. WHERE: Companies, industries, company sizes, locations
      3. WHAT: Technologies, tools, pain points, interests
      4. WHY: Intent signals, behaviors, triggers
      5. WHEN: Timing, events, milestones
      6. HOW MANY: Target quantity, priority distribution

      Be extremely thorough - extract every possible detail.
      Return comprehensive JSON.
    `;

    const result = await llm.generate(prompt, { format: 'json', model: 'gpt-4' });

    return {
      who: {
        titles: result.titles || [],
        roles: result.roles || [],
        seniority: result.seniority || []
      },
      where: {
        companies: result.companies || [],
        industries: result.industries || [],
        companySize: result.companySize || { min: 1, max: 10000 },
        locations: result.locations || []
      },
      what: {
        technologies: result.technologies || [],
        tools: result.tools || [],
        painPoints: result.painPoints || [],
        interests: result.interests || []
      },
      why: {
        intentSignals: result.intentSignals || [],
        behaviors: result.behaviors || [],
        triggers: result.triggers || []
      },
      when: {
        timing: result.timing || [],
        events: result.events || [],
        milestones: result.milestones || []
      },
      howMany: {
        target: result.targetQuantity || 100,
        priority: result.priorityDistribution || { high: 30, medium: 50, low: 20 }
      }
    };
  }

  private async generateSearchCriteria(parsed: ParsedGoal): Promise<SearchCriteria> {
    // LinkedIn criteria
    const linkedInQueries = [];
    for (const title of parsed.who.titles) {
      for (const industry of parsed.where.industries) {
        linkedInQueries.push({
          title,
          industry,
          location: parsed.where.locations[0],
          keywords: parsed.what.technologies.slice(0, 3).join(' OR ')
        });
      }
    }

    // Google search criteria
    const googleQueries = parsed.who.titles.map(title => {
      return `${title} ${parsed.where.industries[0]} contact email`;
    });

    // Company website criteria
    const companyCriteria = {
      industries: parsed.where.industries,
      size: parsed.where.companySize,
      technologies: parsed.what.technologies
    };

    return {
      linkedin: linkedInQueries,
      google: googleQueries,
      companies: companyCriteria
    };
  }

  private async identifyBestSources(criteria: SearchCriteria): Promise<ScrapingSource[]> {
    const sources: ScrapingSource[] = [];

    // LinkedIn (best for B2B contacts)
    if (criteria.linkedin.length > 0) {
      sources.push({
        type: 'linkedin',
        enabled: true,
        priority: 100, // Highest priority
        estimatedResults: criteria.linkedin.length * 50,
        config: {
          queries: criteria.linkedin,
          maxResults: 500,
          rateLimit: 100 // per day
        }
      });
    }

    // Google Search (broad coverage)
    if (criteria.google.length > 0) {
      sources.push({
        type: 'google',
        enabled: true,
        priority: 80,
        estimatedResults: criteria.google.length * 20,
        config: {
          queries: criteria.google,
          maxResults: 100
        }
      });
    }

    // Company websites (high quality data)
    sources.push({
      type: 'company-websites',
      enabled: true,
      priority: 90,
      estimatedResults: 200,
      config: {
        targetCriteria: criteria.companies
      }
    });

    // Industry directories
    sources.push({
      type: 'directories',
      enabled: true,
      priority: 60,
      estimatedResults: 100,
      config: {
        industries: criteria.companies.industries
      }
    });

    return sources.sort((a, b) => b.priority - a.priority);
  }

  private async generateValidationRules(parsed: ParsedGoal): Promise<ValidationRule[]> {
    return [
      {
        field: 'title',
        rule: 'must_contain_any',
        values: parsed.who.titles,
        weight: 40
      },
      {
        field: 'company',
        rule: 'industry_match',
        values: parsed.where.industries,
        weight: 30
      },
      {
        field: 'email',
        rule: 'required',
        weight: 20
      },
      {
        field: 'location',
        rule: 'in_list',
        values: parsed.where.locations,
        weight: 10
      }
    ];
  }

  private async calculateConfidence(parsed: ParsedGoal, criteria: SearchCriteria): Promise<number> {
    let confidence = 0;

    // More titles = higher confidence
    if (parsed.who.titles.length >= 3) confidence += 20;
    else if (parsed.who.titles.length >= 1) confidence += 10;

    // More industries = higher confidence
    if (parsed.where.industries.length >= 2) confidence += 20;
    else if (parsed.where.industries.length >= 1) confidence += 10;

    // Has location = higher confidence
    if (parsed.where.locations.length > 0) confidence += 15;

    // Has technologies = higher confidence
    if (parsed.what.technologies.length > 0) confidence += 15;

    // Multiple sources = higher confidence
    confidence += Math.min(criteria.linkedin.length + criteria.google.length, 20);

    return Math.min(confidence, 100);
  }
}

// Usage
const generator = new AutoScrapingSpecGenerator();

const spec = await generator.generateFromGoal(
  "Find CTOs at Series B SaaS companies in SF Bay Area using React and Node.js"
);

console.log(spec);
// Output:
// {
//   goal: "Find CTOs at Series B SaaS companies...",
//   parsedGoal: {
//     who: { titles: ["CTO", "Chief Technology Officer"], seniority: ["C-level"] },
//     where: {
//       companies: ["Series B"],
//       industries: ["SaaS", "Software"],
//       locations: ["San Francisco Bay Area"]
//     },
//     what: { technologies: ["React", "Node.js"] }
//   },
//   searchCriteria: {
//     linkedin: [
//       { title: "CTO", industry: "SaaS", location: "San Francisco Bay Area", keywords: "React OR Node.js" }
//     ],
//     google: ["CTO SaaS contact email"]
//   },
//   sources: [
//     { type: "linkedin", priority: 100, estimatedResults: 250 },
//     { type: "company-websites", priority: 90, estimatedResults: 200 }
//   ],
//   confidence: 85
// }
```

---

## UPDATED IMPLEMENTATION ROADMAP

### Phase 1: Foundation (Days 1-2)
✅ Contact data model
✅ Multi-tenant RLS
✅ OAuth flows
✅ RBAC system
✅ **Project management** (multi-project support)
✅ **Feature flag infrastructure** (God mode ready)
✅ **Microservices setup** (Docker + Kubernetes)

### Phase 2: Core Features (Days 3-4)
✅ Contact sync engine
✅ Duplicate detection
✅ Pipeline management
✅ Lead scoring
✅ **Auto/Manual toggles for ALL features**
✅ **Enterprise compliance validation**

### Phase 3: Automation & Scraping (Days 5-6)
✅ **AI-powered scraping engine**
✅ **Auto-spec generation from goals**
✅ **Manual review dashboard for scraped leads**
✅ AI email generation
✅ Campaign builder
✅ Behavioral triggers
✅ **10-phase testing integration**

### Phase 4: Polish & Deploy (Day 7)
✅ Analytics dashboard
✅ Mobile PWA
✅ **100% enterprise compliance**
✅ **Production Kubernetes deployment**
✅ **God mode feature flag control**

---

## CRITICAL SUCCESS CRITERIA (UPDATED)

1. ✅ **Auto/Manual Toggle:** Every automation aspect has user control
2. ✅ **Web Scraping:** AI-powered lead discovery with manual approval
3. ✅ **Multi-Project:** Each user can have unlimited projects
4. ✅ **Feature Flags:** God mode control for all features (user/group/tier level)
5. ✅ **Zero Technical Debt:** No hardcoded dependencies, all containerized
6. ✅ **Microservices:** Scalable, independent services
7. ✅ **Enterprise Frameworks:** SaaS, Code, and Testing protocols integrated
8. ✅ **AI/ML Leverage:** Maximum automation, minimum user friction
9. ✅ **Auto-Spec Generation:** System generates scraping specs from natural language goals
10. ✅ **100% Compliance:** All enterprise requirements met before deployment

---

**END OF CRITICAL REQUIREMENTS ADDENDUM**

**These patterns MUST be integrated into the original analysis.**
**All workers must be updated to reflect these enterprise requirements.**
