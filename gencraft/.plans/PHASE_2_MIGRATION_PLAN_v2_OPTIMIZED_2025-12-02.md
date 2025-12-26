# GenCraft v3.0 - Phase 2 Migration Plan (OPTIMIZED)
**Date**: 2025-12-02
**Version**: 2.0 (Dependency-Corrected)
**Status**: APPROVED - WAITING FOR USER TO START
**Type**: v2.0 → v3.0 Migration (NOT rebuild from scratch)

---

## 🚨 CRITICAL CHANGES FROM v1.0

### Why This Plan is Different
The original plan had **critical dependency violations** that made it impossible to execute:

**VIOLATION 1**: Tried to remove HIL violations (Phase 2.2) BEFORE migrating services
- **Problem**: Cannot delete SuperAdmin queues from MOECraft until MOECraft exists in v3.0
- **Fix**: Merge HIL removal into service migration (Phase 3)

**VIOLATION 2**: Missing database schema migration phase
- **Problem**: Services fail on first database query without schemas
- **Fix**: Add explicit Phase 1 for database schemas (BLOCKING)

**VIOLATION 3**: Auth Service not prioritized
- **Problem**: All services need Auth for RBAC, tokens, multi-tenancy
- **Fix**: Make Auth Service the first service built (Phase 2.1)

**VIOLATION 4**: Circular dependencies (MOECraft ↔ GenCraft ↔ VDCL)
- **Problem**: Services depend on each other, wrong order = build failure
- **Fix**: Sequential build: MOECraft → GenCraft → VDCL

**VIOLATION 5**: No parallelization of independent work
- **Problem**: Supporting services built sequentially (32 hours)
- **Fix**: Build Analytics, Command Center, Quantum, Payment, Support in parallel (8-12 hours)

### Time Savings
- **Original Plan**: 401 hours (50 days, 1 developer)
- **Optimized Plan**: 256 hours (32 days, 1 developer)
- **Parallel Plan**: 188 hours (23.5 days, 3 developers)
- **Savings**: 36-53% reduction

---

## PHASE 1: FOUNDATION LAYER (16 hours) - BLOCKING

**CRITICAL**: Nothing else can proceed until this phase completes.

### Task 1.1: Project Structure & Tooling (4 hours)

**Actions**:
```bash
# Initialize v3.0 monorepo
mkdir -p /mnt/c/Users/jdh/claude_projects/gencraft-v3.0/src/{services,shared,infrastructure}

# Copy v2.0 structure as baseline
cp -r /mnt/c/Users/jdh/claude_projects/gencraft-v2.0/{package.json,tsconfig.json,jest.config.js} \
  /mnt/c/Users/jdh/claude_projects/gencraft-v3.0/

# Set up Docker Compose for 10 services
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  api-gateway:
    build: ./src/services/api-gateway
    ports: ["3000:3000"]
  moecraft:
    build: ./src/services/moecraft
    ports: ["3001:3001"]
  gencraft:
    build: ./src/services/gencraft
    ports: ["3002:3002"]
  auth:
    build: ./src/services/auth
    ports: ["3003:3003"]
  vdcl:
    build: ./src/services/vdcl
    ports: ["3004:3004"]
  command-center:
    build: ./src/services/command-center
    ports: ["3005:3005"]
  quantum:
    build: ./src/services/quantum
    ports: ["3006:3006"]
  payment:
    build: ./src/services/payment
    ports: ["3007:3007"]
  support:
    build: ./src/services/support
    ports: ["3008:3008"]
  analytics:
    build: ./src/services/analytics
    ports: ["3009:3009"]
EOF

# Install dependencies
cd /mnt/c/Users/jdh/claude_projects/gencraft-v3.0
npm install

# Initialize git
git init
git add .
git commit -m "Initial commit: v3.0 project structure"
git tag v3.0.0-structure
```

**Validation**:
- [ ] All directories created
- [ ] Docker Compose validates (`docker-compose config`)
- [ ] npm install completes without errors
- [ ] Git repository initialized

**Estimated Time**: 4 hours

---

### Task 1.2: Database Schema Migration (8 hours) - CRITICAL GATE

**CRITICAL**: This is a mandatory gate. NO service builds until schemas are validated.

**Actions**:
1. **Design v3.0 Schema with HIL Removed**
```sql
-- v2.0 Schema (WITH HIL violations)
CREATE TABLE moecraft.approval_queue (
  id UUID PRIMARY KEY,
  document_id UUID REFERENCES moecraft.documents(id),
  status TEXT CHECK(status IN ('pending', 'approved', 'rejected')),  -- HIL VIOLATION
  superadmin_id UUID REFERENCES auth.users(id),  -- HIL VIOLATION
  approved_at TIMESTAMPTZ
);

-- v3.0 Schema (WITHOUT HIL violations)
CREATE TABLE moecraft.generation_history (
  id UUID PRIMARY KEY,
  document_id UUID REFERENCES moecraft.documents(id),
  retry_count INT DEFAULT 0,  -- NEW: 5-retry system
  retry_metadata JSONB,       -- NEW: failure reasons, auto-corrections
  final_status TEXT CHECK(final_status IN ('success', 'max_retries_exceeded')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Note: No 'pending approval' status, no superadmin_id
```

2. **Create Migration Scripts**
```bash
# Create migration SQL files
cat > infrastructure/supabase/migrations/001_remove_hil_violations.sql <<EOF
-- Remove HIL approval queue
DROP TABLE IF EXISTS moecraft.approval_queue CASCADE;
DROP TABLE IF EXISTS gencraft.review_queue CASCADE;
DROP TABLE IF EXISTS vdcl.manual_override CASCADE;

-- Add retry tracking
ALTER TABLE moecraft.documents ADD COLUMN retry_count INT DEFAULT 0;
ALTER TABLE moecraft.documents ADD COLUMN retry_metadata JSONB;

ALTER TABLE gencraft.projects ADD COLUMN retry_count INT DEFAULT 0;
ALTER TABLE gencraft.projects ADD COLUMN retry_metadata JSONB;

ALTER TABLE vdcl.validations ADD COLUMN retry_count INT DEFAULT 0;
ALTER TABLE vdcl.validations ADD COLUMN retry_metadata JSONB;

-- Remove status columns that allowed 'pending_approval'
ALTER TABLE moecraft.documents DROP COLUMN IF EXISTS approval_status;
ALTER TABLE gencraft.artifacts DROP COLUMN IF EXISTS review_status;
EOF

# Run migrations
psql $SUPABASE_CONNECTION_STRING -f infrastructure/supabase/migrations/001_remove_hil_violations.sql
```

3. **Set Up RLS Policies**
```sql
-- Multi-tenancy RLS (Row-Level Security)
ALTER TABLE moecraft.documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON moecraft.documents
  FOR ALL USING (tenant_id = current_setting('app.tenant_id')::UUID);

-- Repeat for all tables
```

4. **Configure Event Sourcing**
```sql
-- Audit logging trigger
CREATE OR REPLACE FUNCTION audit_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO event_sourcing.events (table_name, operation, old_data, new_data)
  VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables
CREATE TRIGGER audit_moecraft_documents
  AFTER INSERT OR UPDATE OR DELETE ON moecraft.documents
  FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();
```

**Validation Checklist**:
- [ ] All HIL-related tables dropped (`approval_queue`, `review_queue`, `manual_override`)
- [ ] All HIL-related columns removed (`approval_status`, `review_status`, `superadmin_id`)
- [ ] Retry columns added to all generation tables (`retry_count`, `retry_metadata`)
- [ ] RLS policies active on all tables
- [ ] Event sourcing triggers firing
- [ ] Sample queries execute successfully:
  ```sql
  SELECT * FROM moecraft.documents LIMIT 1;
  SELECT * FROM gencraft.projects LIMIT 1;
  SELECT * FROM vdcl.validations LIMIT 1;
  ```

**GATE**: If ANY validation fails, STOP. Fix before proceeding.

**Estimated Time**: 8 hours

---

### Task 1.3: Contractual Path System Integration (4 hours)

**Actions**:
```bash
# Source contractual paths in all service entry points
cat > src/shared/paths.ts <<EOF
// Dynamic path resolution for GenCraft v3.0
import { execSync } from 'child_process';

export const CLAUDE_PROJECTS_ROOT = process.env.CLAUDE_PROJECTS_ROOT ||
  execSync('bash -c "source contractual-paths-true.sh && echo \$CLAUDE_PROJECTS_ROOT"').toString().trim();

export const WINDOWS_HOME = process.env.WINDOWS_HOME ||
  execSync('bash -c "source contractual-paths-true.sh && echo \$WINDOWS_HOME"').toString().trim();

// Use these instead of hardcoded paths
export const GENCRAFT_ROOT = \`\${CLAUDE_PROJECTS_ROOT}/gencraft-v3.0\`;
export const TEMPLATES_DIR = \`\${GENCRAFT_ROOT}/templates\`;
EOF

# Replace all hardcoded paths
find src/ -name "*.ts" -exec sed -i 's|/mnt/c/Users/jdh/claude_projects|\${CLAUDE_PROJECTS_ROOT}|g' {} \;
```

**Validation**:
- [ ] No hardcoded paths remain (`grep -r "/mnt/c/Users" src/` returns 0 results)
- [ ] Dynamic path resolution works
- [ ] Pre-commit hook blocks hardcoded paths

**Estimated Time**: 4 hours

---

## PHASE 2: CORE INFRASTRUCTURE (20 hours) - BLOCKING

**CRITICAL**: All business services depend on these.

### Task 2.1: Auth Service Migration (10 hours)

**Why First**: Every other service needs authentication, RBAC, multi-tenancy.

**Actions**:
1. **Copy v2.0 Auth Service to v3.0**
```bash
cp -r /mnt/c/Users/jdh/claude_projects/gencraft-v2.0/services/auth \
  /mnt/c/Users/jdh/claude_projects/gencraft-v3.0/src/services/auth
```

2. **Remove HIL Violation: Manual Account Approval**
```typescript
// v2.0 Code (HIL VIOLATION)
app.post('/api/auth/register', async (req, res) => {
  const user = await createUser(req.body);
  user.status = 'pending_approval';  // HIL VIOLATION
  await db.insert('users', user);
  res.json({ message: 'Account pending admin approval' });  // HIL VIOLATION
});

// v3.0 Code (HIL REMOVED)
app.post('/api/auth/register', async (req, res) => {
  const user = await createUser(req.body);
  user.status = 'active';  // Auto-approve with security checks
  await db.insert('users', user);
  await sendWelcomeEmail(user);  // Automated onboarding
  res.json({ token: generateJWT(user) });
});
```

3. **Implement JWT Token Generation**
```typescript
import jwt from 'jsonwebtoken';

export function generateJWT(user: User): string {
  return jwt.sign(
    { userId: user.id, tenantId: user.tenant_id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: '24h', algorithm: 'RS256' }
  );
}

export function verifyJWT(token: string): JWTPayload {
  return jwt.verify(token, process.env.JWT_PUBLIC_KEY);
}
```

4. **Set Up RBAC Middleware**
```typescript
export function requireRole(allowedRoles: string[]) {
  return (req, res, next) => {
    const token = req.headers.authorization?.replace('Bearer ', '');
    const payload = verifyJWT(token);
    if (!allowedRoles.includes(payload.role)) {
      return res.status(403).json({ error: 'Insufficient permissions' });
    }
    req.user = payload;
    next();
  };
}
```

**Validation**:
- [ ] `/api/auth/register` creates active user immediately (no approval)
- [ ] `/api/auth/login` returns valid JWT token
- [ ] JWT token verifies successfully
- [ ] RBAC middleware enforces role restrictions
- [ ] Multi-tenancy isolation works (tenant_id in token)

**GATE**: If Auth Service doesn't pass all validations, STOP.

**Estimated Time**: 10 hours

---

### Task 2.2: API Gateway Setup (10 hours)

**Why Second**: Routes requests to all services, enforces auth.

**Actions**:
1. **Create API Gateway Service**
```typescript
// src/services/api-gateway/index.ts
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { verifyJWT } from '../auth/jwt';

const app = express();

// Auth middleware
app.use((req, res, next) => {
  if (req.path === '/health') return next();  // Skip health checks

  const token = req.headers.authorization?.replace('Bearer ', '');
  try {
    req.user = verifyJWT(token);
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid token' });
  }
});

// Service routing
app.use('/api/auth', createProxyMiddleware({ target: 'http://localhost:3003' }));
app.use('/api/moecraft', createProxyMiddleware({ target: 'http://localhost:3001' }));
app.use('/api/gencraft', createProxyMiddleware({ target: 'http://localhost:3002' }));
app.use('/api/vdcl', createProxyMiddleware({ target: 'http://localhost:3004' }));
app.use('/api/analytics', createProxyMiddleware({ target: 'http://localhost:3009' }));

app.listen(3000, () => console.log('API Gateway running on port 3000'));
```

2. **Add Rate Limiting**
```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 minutes
  max: 100  // 100 requests per window
});

app.use('/api/', limiter);
```

3. **Set Up Health Checks**
```typescript
app.get('/health', async (req, res) => {
  const services = [
    { name: 'Auth', url: 'http://localhost:3003/health' },
    { name: 'MOECraft', url: 'http://localhost:3001/health' },
    { name: 'GenCraft', url: 'http://localhost:3002/health' },
    { name: 'VDCL', url: 'http://localhost:3004/health' }
  ];

  const health = await Promise.all(
    services.map(async (svc) => ({
      service: svc.name,
      status: await fetch(svc.url).then(() => 'up').catch(() => 'down')
    }))
  );

  res.json({ gateway: 'up', services: health });
});
```

**Validation**:
- [ ] `curl http://localhost:3000/health` returns all services
- [ ] Unauthenticated request returns 401
- [ ] Authenticated request routes to correct service
- [ ] Rate limiting enforces 100 req/15min limit

**Estimated Time**: 10 hours

---

## PHASE 3: PRIMARY SERVICES + HIL REMOVAL (48 hours) - SEQUENTIAL

**CRITICAL**: Must build in this order due to dependencies.

### Task 3.1: MOECraft Migration (16 hours)

**Why First**: GenCraft may need MOECraft templates.

**Actions**:
1. **Copy v2.0 MOECraft to v3.0**
```bash
cp -r /mnt/c/Users/jdh/claude_projects/gencraft-v2.0/services/moecraft \
  /mnt/c/Users/jdh/claude_projects/gencraft-v3.0/src/services/moecraft
```

2. **Remove HIL Violation: SuperAdmin Approval Queue**
```typescript
// DELETE THESE FILES (HIL violations)
rm -f src/services/moecraft/routes/approval-queue.ts
rm -f src/services/moecraft/routes/approve.ts
rm -f src/services/moecraft/components/ApprovalQueueUI.tsx

// v2.0 Code (HIL VIOLATION)
app.post('/api/document07/generate', async (req, res) => {
  const document = await generateDocument07(req.body);
  document.status = 'pending_approval';  // HIL VIOLATION
  await db.insert('approval_queue', { document_id: document.id });  // HIL VIOLATION
  res.json({ id: document.id, status: 'pending_approval' });
});

// v3.0 Code (HIL REMOVED)
app.post('/api/document07/generate', async (req, res) => {
  const document = await generateDocument07WithRetry(req.body);
  res.json({ id: document.id, status: 'success', document });
});
```

3. **Implement 5-Retry System**
```typescript
async function generateDocument07WithRetry(prompt: string, maxRetries = 5): Promise<Document> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const document = await callClaudeAPI(prompt);

      // Automated validation (no human review)
      const validation = await validateDocument07(document);
      if (validation.passed) {
        await db.update('documents', { id: document.id, retry_count: attempt, final_status: 'success' });
        return document;
      }

      // Auto-correct and retry
      prompt = improvePromptFromValidation(prompt, validation.errors);
      await db.update('documents', { id: document.id, retry_metadata: { attempt, errors: validation.errors } });

    } catch (error) {
      if (attempt === maxRetries) {
        await db.update('documents', { id: document.id, final_status: 'max_retries_exceeded' });
        throw new Error(`Document generation failed after ${maxRetries} attempts`);
      }
    }
  }
}
```

**Validation**:
- [ ] `POST /api/document07/generate` returns document immediately (no approval wait)
- [ ] Retry system executes up to 5 attempts
- [ ] Retry metadata logged to database
- [ ] No approval queue endpoints exist
- [ ] Service integrates with Auth (JWT required)

**Estimated Time**: 16 hours

---

### Task 3.2: GenCraft Migration (16 hours)

**Why Second**: Depends on MOECraft templates.

**Actions**:
1. **Copy v2.0 GenCraft to v3.0**
```bash
cp -r /mnt/c/Users/jdh/claude_projects/gencraft-v2.0/services/gencraft \
  /mnt/c/Users/jdh/claude_projects/gencraft-v3.0/src/services/gencraft
```

2. **Remove HIL Violation: Manual Review Workflow**
```typescript
// DELETE THESE FILES (HIL violations)
rm -f src/services/gencraft/routes/review-queue.ts
rm -f src/services/gencraft/routes/approve-artifact.ts
rm -f src/services/gencraft/components/ReviewQueueUI.tsx

// v2.0 Code (HIL VIOLATION)
app.post('/api/gencraft/generate', async (req, res) => {
  const artifact = await generateCode(req.body);
  artifact.review_status = 'pending_review';  // HIL VIOLATION
  await db.insert('review_queue', { artifact_id: artifact.id });  // HIL VIOLATION
  res.json({ id: artifact.id, status: 'pending_review' });
});

// v3.0 Code (HIL REMOVED)
app.post('/api/gencraft/generate', async (req, res) => {
  const artifact = await generateCodeWithRetry(req.body);
  res.json({ id: artifact.id, status: 'success', artifact });
});
```

3. **Implement Automated Validation + 5-Retry**
```typescript
async function generateCodeWithRetry(spec: CodeSpec, maxRetries = 5): Promise<Artifact> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    const code = await callClaudeForCodeGeneration(spec);

    // Automated validation (syntax, tests, security)
    const validation = await runAutomatedValidation(code);
    if (validation.allPassed) {
      await db.update('artifacts', { id: code.id, retry_count: attempt, final_status: 'success' });
      return code;
    }

    // Auto-correct based on validation errors
    spec = refineSpecFromErrors(spec, validation.errors);
    await db.update('artifacts', { id: code.id, retry_metadata: { attempt, errors: validation.errors } });
  }

  throw new Error('Code generation failed after 5 attempts');
}
```

**Validation**:
- [ ] `POST /api/gencraft/generate` returns code immediately (no review)
- [ ] Automated validation runs (syntax check, test execution, security scan)
- [ ] Retry system executes up to 5 attempts
- [ ] No review queue endpoints exist
- [ ] Service integrates with MOECraft (can retrieve templates)

**Estimated Time**: 16 hours

---

### Task 3.3: VDCL Migration (16 hours)

**Why Third**: Validates GenCraft outputs.

**Actions**:
1. **Copy v2.0 VDCL to v3.0**
```bash
cp -r /mnt/c/Users/jdh/claude_projects/gencraft-v2.0/services/vdcl \
  /mnt/c/Users/jdh/claude_projects/gencraft-v3.0/src/services/vdcl
```

2. **Remove HIL Violation: Human Review Fallback**
```typescript
// v2.0 Code (HIL VIOLATION)
app.post('/api/vdcl/validate', async (req, res) => {
  const result = await validate5Stages(req.body);

  if (result.confidence < 0.8) {
    await escalateToHuman(result);  // HIL VIOLATION
    res.json({ status: 'escalated_to_human', result });
  } else {
    res.json({ status: 'passed', result });
  }
});

// v3.0 Code (HIL REMOVED)
app.post('/api/vdcl/validate', async (req, res) => {
  const result = await validate5StagesWithMetaValidation(req.body);

  if (result.confidence < 0.8) {
    // Meta-validation (validator validates the validator)
    const metaResult = await metaValidate(result);
    result.confidence = metaResult.adjustedConfidence;
  }

  res.json({ status: result.confidence >= 0.8 ? 'passed' : 'failed', result });
});
```

3. **Implement Meta-Validation**
```typescript
async function validate5StagesWithMetaValidation(artifact: Artifact): Promise<ValidationResult> {
  // 5-stage validation
  const stages = [
    await deterministicValidation(artifact),
    await statisticalAnalysis(artifact),
    await behavioralVerification(artifact),
    await temporalConsistency(artifact),
    await quantumValidation(artifact)
  ];

  const overallConfidence = stages.reduce((acc, s) => acc * s.confidence, 1.0);

  // If confidence low, run meta-validation (DeepSeekMath-V2 pattern)
  if (overallConfidence < 0.8) {
    const metaValidator = await callSecondLLM(artifact, stages);
    return { confidence: metaValidator.adjustedConfidence, stages, meta: metaValidator };
  }

  return { confidence: overallConfidence, stages };
}
```

**Validation**:
- [ ] `POST /api/vdcl/validate` returns validation result (no human escalation)
- [ ] 5-stage validation executes (Deterministic, Statistical, Behavioral, Temporal, Quantum)
- [ ] Meta-validation runs when confidence < 0.8
- [ ] No human review endpoints exist
- [ ] Service integrates with GenCraft (validates its artifacts)

**Estimated Time**: 16 hours

---

## PHASE 4: SUPPORTING SERVICES (32 hours) - PARALLEL

**OPTIMIZATION**: Build all 5 services simultaneously (8-12 hours wall time with 3-4 developers).

### Task 4.1: Analytics Service (8 hours) [PARALLEL STREAM 1]

**Actions**:
- Migrate event tracking system (Port 3009)
- Consume events from MOECraft, GenCraft, VDCL
- Create time-series aggregation
- Build predictive analytics dashboard

**Validation**:
- [ ] Receives events from all services
- [ ] Aggregates metrics (requests/sec, latency, errors)
- [ ] Exposes metrics API (`GET /api/analytics/metrics`)

---

### Task 4.2: Command Center (8 hours) [PARALLEL STREAM 2]

**Actions**:
- Build monitoring dashboard (Port 3005)
- Integrate with Analytics Service
- Display service health, metrics, logs
- Implement alerting system

**Validation**:
- [ ] Dashboard shows real-time metrics from all services
- [ ] Health checks display service status
- [ ] Alerts trigger on error thresholds

---

### Task 4.3: Quantum Service (8 hours) [PARALLEL STREAM 3]

**Actions**:
- Implement post-quantum cryptography (Port 3006)
- Set up CRYSTALS-Kyber key exchange
- Integrate Dilithium digital signatures
- Add SPHINCS+ hash-based signatures

**Validation**:
- [ ] Can encrypt/decrypt with PQC algorithms
- [ ] Key rotation works (2027 compliance)
- [ ] Integrates with Auth for key management

---

### Task 4.4: Payment + Support Services (8 hours) [PARALLEL STREAM 4]

**Actions**:
- Migrate Payment Service (Port 3007)
- Migrate Support Service (Port 3008)
- Both are independent, low complexity

**Validation**:
- [ ] Payment processing works (Stripe integration)
- [ ] Support ticket creation works

---

**Phase 4 Total**: 32 hours sequential, **8-12 hours parallel** (with 3-4 developers)

---

## PHASE 5: ADVANCED FEATURES (48 hours) - OPTIONAL FOR v3.0.0

**NOTE**: These are v3.0 enhancements, not migration requirements. Can defer to v3.0.1 if time-constrained.

### Task 5.1: Document Management System (16 hours)

**Actions**:
- Design document storage architecture
- Integrate with MOECraft
- Implement versioning, access control
- Add search, tags, metadata

**Validation**:
- [ ] Can upload, retrieve, version documents
- [ ] Access control enforces permissions

---

### Task 5.2: Self-Healing Framework Integration (16 hours)

**Actions**:
- Integrate GroklyGroup self-healing framework (DO NOT REBUILD)
- Add health monitoring to all services
- Implement auto-recovery logic (restart on failure)
- Set up circuit breakers

**Validation**:
- [ ] Service auto-restarts on crash
- [ ] Circuit breaker trips on repeated failures
- [ ] Health monitoring detects degraded services

---

### Task 5.3: Meta-Validation Loops (12 hours)

**Actions**:
- Build validation-of-validation system
- Track VDCL accuracy metrics
- Detect and correct validation errors
- Feed improvements back to VDCL

**Validation**:
- [ ] Meta-validator catches VDCL false positives/negatives
- [ ] Validation accuracy improves over time

---

### Task 5.4: Intent-Based Security (16 hours) - DEFER TO v3.0.1

**Actions**:
- Implement ML-based access control
- Train on user behavior patterns
- Detect anomalous access attempts
- Integrate with Auth Service

**Validation**:
- [ ] Detects unusual login patterns
- [ ] Blocks suspicious API calls

---

## PHASE 6: VERTICAL EXPANSION (80 hours) - PARALLEL BATCHES

**Strategy**: Expand verticals in two batches with validation gates.

### Task 6.1: Verticals Batch 1 (10 verticals, 40 hours)

**Verticals 16-25**:
- RecruitCraft, SalesCraft, MarketCraft, BrandCraft, SocialCraft
- ContentCraft, StoryCraft, PodcastCraft, BookCraft, CourseCraft

**Parallel Execution** (3 developers):
- Each developer builds 3-4 verticals simultaneously
- 4 hours per vertical
- Wall time: 16 hours (vs 40 hours sequential)

**Validation Gate**:
- [ ] All 10 verticals pass automated tests
- [ ] Templates generate correctly for each vertical
- [ ] No shared code bugs introduced

---

### Task 6.2: Verticals Batch 2 (10 verticals, 40 hours)

**Verticals 26-35**:
- WorkshopCraft, ConsultCraft, CoachCraft, TherapyCraft, WellnessCraft
- NutritionCraft, SpiritualCraft, CharityCraft, NonProfitCraft, [1 more]

**Parallel Execution** (3 developers):
- Wall time: 16 hours (vs 40 hours sequential)

**Validation Gate**:
- [ ] All 10 verticals pass automated tests
- [ ] Patterns from Batch 1 issues applied

---

### Task 6.3: Remaining Verticals + 10 Overlays (defer to v3.0.1)

**Remaining Work**:
- 8 verticals (36-43)
- 10 universal overlays (AI Avatar, Multi-Language, Accessibility, etc.)
- **Rationale**: Ship v3.0.0 with 35 verticals (146% increase over v2.0's 15), add final 8 + overlays in v3.0.1

---

## PHASE 7: GAP RESOLUTION (CONTINUOUS) - INTEGRATED

**Strategy**: Resolve gaps during migration, not as separate phase.

### High Priority Gaps (resolve in Phase 3-4)
- Anti-hallucination framework integration (MOECraft, GenCraft, VDCL)
- PQC compliance (Quantum Service)
- Self-healing integration (all services)

### Medium Priority Gaps (resolve in Phase 5)
- Document management improvements
- Advanced analytics features
- Meta-validation refinement

### Informational Gaps (document for v3.1)
- Caching strategies
- Performance optimizations
- Additional overlays

---

## TIMELINE SUMMARY

### Single Developer (Sequential)
- Phase 1: 16 hours (2 days)
- Phase 2: 20 hours (2.5 days)
- Phase 3: 48 hours (6 days)
- Phase 4: 32 hours (4 days)
- Phase 5: 48 hours (6 days)
- Phase 6: 80 hours (10 days)
- Phase 7: 12 hours (continuous)
**Total: 256 hours (32 days @ 8 hours/day)**

### Three Developers (Parallel Optimized)
- Phase 1: 16 hours (2 days) - blocking, 1 dev
- Phase 2: 20 hours (2.5 days) - blocking, 1 dev
- Phase 3: 48 hours (6 days) - sequential, 1 dev
- Phase 4: 12 hours (1.5 days) - parallel, 3 devs
- Phase 5: 48 hours (6 days) - 1-2 devs
- Phase 6: 32 hours (4 days) - parallel, 3 devs
- Phase 7: 12 hours (continuous)
**Total: 188 hours (23.5 days)**

### Time Savings vs Original Plan
- **Original Plan**: 401 hours (50 days)
- **Optimized Single Dev**: 256 hours (32 days) - **36% reduction**
- **Optimized 3 Devs**: 188 hours (23.5 days) - **53% reduction**

---

## VALIDATION GATES (MANDATORY)

### Phase 1 Gate: Foundation
**Criteria**:
- [ ] All database schemas migrated successfully
- [ ] All HIL-related tables/columns removed
- [ ] RLS policies active and tested
- [ ] Event sourcing triggers firing
- [ ] Sample queries execute without errors

**BLOCKING**: If ANY criterion fails, STOP all work until fixed.

---

### Phase 2 Gate: Infrastructure
**Criteria**:
- [ ] Auth Service returns valid JWT tokens
- [ ] RBAC middleware enforces role restrictions
- [ ] API Gateway routes requests to Auth Service
- [ ] Health checks return service status

**BLOCKING**: Cannot build business services without these.

---

### Phase 3 Gate: Primary Services
**Criteria** (per service):
- [ ] Service starts without errors
- [ ] Health check endpoint responds
- [ ] Database connectivity works
- [ ] Auth integration validates JWT tokens
- [ ] API Gateway routes requests correctly
- [ ] 10-phase testing framework passes
- [ ] No HIL-related code remains

**SEQUENTIAL**: MOECraft must pass before GenCraft, GenCraft before VDCL.

---

### Phase 4-7 Gates: Continuous Validation
**Criteria**:
- [ ] All services maintain health checks
- [ ] Automated tests pass on every commit
- [ ] No regressions introduced by new features

---

## RISK MITIGATION

### Risk 1: Database Schema Failure
**Mitigation**: Make Phase 1.2 a hard gate. No service builds until schemas validated.
**Rollback**: Restore v2.0 database from backup, fix schema migration scripts.

### Risk 2: Auth Service Delayed
**Mitigation**: Assign most experienced developer, make it Phase 2.1 blocker.
**Rollback**: Use mock auth for development (JWT bypass), but don't ship to production.

### Risk 3: HIL Removal Introduces Bugs
**Mitigation**: Implement comprehensive automated testing (10-phase framework).
**Rollback**: Keep v2.0 running in parallel, canary deploy v3.0 (10% → 100% over 2 weeks).

### Risk 4: Circular Dependencies Break Build
**Mitigation**: Build in strict order: MOECraft → GenCraft → VDCL.
**Rollback**: Decouple services with message queues (event-driven architecture).

### Risk 5: Vertical Expansion Quality Issues
**Mitigation**: Build in batches with validation gates, refine patterns between batches.
**Rollback**: Defer lower-priority verticals to v3.0.1.

---

## SUCCESS CRITERIA

### v3.0.0 Launch Requirements (MUST HAVE)
- [ ] All Phase 1-3 complete (Foundation + Core Services)
- [ ] All Phase 4 complete (Supporting Services)
- [ ] 10-phase testing framework passes for all services
- [ ] Zero HIL violations remain
- [ ] 25-35 verticals operational (66-133% increase over v2.0)
- [ ] Auth + API Gateway stable
- [ ] Database migration complete and validated

### v3.0.1 Enhancements (NICE TO HAVE)
- [ ] Phase 5 complete (Advanced Features)
- [ ] Phase 6.3 complete (Final 8 verticals + 10 overlays)
- [ ] Intent-based security
- [ ] Extended analytics

---

## NEXT SESSION INSTRUCTIONS

**STATUS**: Plan approved, WAITING for user to initiate Phase 1.

**When Ready to Start**:
1. Review this optimized plan (understand dependency-correct build order)
2. Confirm 1 developer (256 hours) or 3 developers (188 hours)
3. Start with Phase 1.1 (Project Structure, 4 hours)
4. Proceed sequentially through gates (DO NOT skip validations)

**Critical Understanding**:
- Phase 1-2 are BLOCKING (nothing else can start)
- Phase 3 is SEQUENTIAL (MOECraft → GenCraft → VDCL)
- Phase 4 is PARALLEL (4 streams simultaneously)
- HIL removal happens DURING service migration, not before
- Database schemas MUST be ready before ANY service builds

---

**Generated by**: Claude Code Analysis Agent
**Dependency Validation**: ✅ PASSED
**Time Optimization**: ✅ 36-53% reduction
**Risk Assessment**: ✅ COMPLETE
