# GenCraft v3.0 - Requirements Addendum
**Date**: 2025-11-30
**Session**: Critical requirements clarifications
**Status**: MANDATORY - Must be integrated into requirements v1.3.0

---

## 🎯 CRITICAL REQUIREMENT CHANGES

### 1. Terminology Change: SuperAdmin → Control Panel + SuperAdmin Separation

**CURRENT (v2.0/early v3.0)**: "SuperAdmin" used for both observation UI and site owner role

**NEW (v3.0 Final)**:
- **Control Panel**: Observation deck with limited site management capabilities
  - **Purpose**: Site monitoring, analytics, basic management
  - **Access**: Can be granted to non-owners (delegated management)
  - **Permissions**: Read-mostly with selective write (configurable)
  - **Use Case**: Operations team, support staff, delegated admins

- **SuperAdmin (God Mode)**: Site owner with full access
  - **Purpose**: Complete system control, all functions
  - **Access**: Site owner ONLY
  - **Permissions**: Unrestricted access to ALL GenCraft functions
  - **Use Case**: System owner, ultimate authority

**Rationale**: Separation of concerns - observation vs control. Allows delegation without exposing critical system functions.

**Action Required**:
- Global find/replace "SuperAdmin" → "Control Panel" in UI references
- Create distinct "SuperAdmin" role (God Mode)
- Implement RBAC with two distinct permission levels
- Update all documentation

---

### 2. Zero Manual Approval - Enhanced Retry Logic

**REQUIREMENT**: NO manual approval ANYWHERE in the system (absolute HIL removal)

**Current Approach**: 3 retries before manual review
**NEW Approach**: Up to **5 retries** with intelligent failure analysis

**Retry Decision Logic**:
System determines retry viability based on **failure reason**:

| Failure Reason | Retry? | Max Attempts | Action |
|----------------|--------|--------------|--------|
| TOS Violation | ❌ NO | 0 | Immediate rejection + report |
| Attempted Bad Actor | ❌ NO | 0 | Security flag + report |
| Wrong LLM Choice | ✅ YES | 5 | Switch LLM, retry |
| Rate Limit Hit | ✅ YES | 5 | Exponential backoff, retry |
| Timeout | ✅ YES | 5 | Adjust timeout, retry |
| Quality Score <95% | ✅ YES | 5 | Refine prompt, retry |
| API Error (5xx) | ✅ YES | 5 | Wait + retry |
| Network Issue | ✅ YES | 5 | Retry with backoff |
| Insufficient Context | ✅ YES | 3 | Enhance context, retry |
| Cost Threshold (GenCraft tokens) | ⚠️ ADAPT | 1 | Reduce scope, retry once |
| Cost Threshold (BYOK) | ⚠️ ADAPT | ∞ | Always adapt, never reject |

**Retry Strategy**:
```typescript
interface RetryConfig {
  maxAttempts: number;        // 0-5 based on failure type
  shouldRetry: boolean;       // Determined by failure reason
  adaptStrategy?: string;     // How to modify request for retry
  escalate: boolean;          // Generate report (never manual approval)
}
```

**Reporting** (not approval):
- All failures generate detailed reports
- Reports go to Control Panel dashboard
- NO manual intervention required
- Reports are informational only
- System continues autonomously

**Enforcement**: ZERO HIL anywhere - system is fully autonomous

---

### 3. BYOK vs GenCraft Tokens - Cost Handling

**CRITICAL DISTINCTION**: Cost handling policies differ fundamentally based on who pays for the tokens

#### When Using BYOK (Bring Your Own Key):
- **Behavior**: **NEVER reject based on cost - BYOK users override ALL god settings for cost**
- **Rationale**: User pays for their own tokens, therefore NO cost limits apply
- **Override Behavior**: BYOK completely bypasses the god setting for maximum cost per output
- **Threshold**: NONE - user has unlimited budget (they pay directly)
- **System Response**: Process request fully without cost adaptation or rejection

#### When Using GenCraft Tokens:
- **Behavior**: System MUST adapt output to stay within god-set maximum cost threshold
- **Threshold**: Sitewide default set by site owner (God Mode)
- **Override**: Per-user basis (site owner can adjust individual user limits)
- **Rationale**: GenCraft pays, requires cost control and budget management
- **Adaptation Strategies** (when approaching threshold):
  1. Reduce document length
  2. Simplify complexity
  3. Use cheaper LLM tier
  4. Split into multiple smaller jobs
  5. Reduce language count
  6. Omit optional enhancements
  7. Generate summary instead of full content
  8. Reduce quality target (e.g., 90% instead of 95%)

**Implementation**:
```typescript
interface CostPolicy {
  tokenSource: 'gencraft' | 'byok';
  behavior: 'unlimited' | 'adapt';  // BYOK = unlimited, GenCraft = adapt
  thresholdUSD?: number;             // Only for GenCraft tokens
  adaptationStrategy?: AdaptationConfig;
  sitewide: boolean;
  userOverride?: number;             // Site owner can set per-user (GenCraft tokens only)
}

// Sitewide default
const sitewidePolicy = {
  byok: {
    behavior: 'unlimited',           // NO cost limits
    threshold: null,                 // No threshold enforced
    overridesGodMode: true           // Bypasses all god settings
  },
  gencraft: {
    behavior: 'adapt',               // Adapt within threshold
    threshold: 10.00,                // God-set maximum (default $10)
    adaptRequired: true              // Must adapt, never reject
  }
};

// Cost decision logic
function determineCostBehavior(userId: string, estimatedCost: number): CostDecision {
  const tokenSource = getUserTokenSource(userId);

  if (tokenSource === 'byok') {
    // BYOK users: NO cost limits, process fully
    return {
      proceed: true,
      adapt: false,
      reason: 'BYOK user - unlimited budget (user pays)'
    };
  }

  // GenCraft tokens: Check against god-set threshold
  const threshold = getUserCostThreshold(userId) || getSitewideGodThreshold();

  if (estimatedCost <= threshold) {
    return { proceed: true, adapt: false };
  }

  // Cost exceeds threshold - ADAPT output (never reject)
  return {
    proceed: true,
    adapt: true,
    targetCost: threshold,
    adaptationStrategies: selectAdaptationStrategies(estimatedCost, threshold)
  };
}
```

**Configuration UI** (Control Panel):
- View sitewide cost policies (read-only for Control Panel)
- View per-user overrides (read-only for Control Panel)

**Configuration UI** (SuperAdmin - God Mode):
- Edit sitewide cost policies
- Set per-user cost overrides
- View cost analytics
- Emergency cost controls

---

### 4. SOS System Implementation (Decision Required)

**Question**: Should GenCraft implement an SOS system like InterviewPlus for user safety?

**InterviewPlus SOS System** (Reference):
- Emergency user safety mechanism
- Allows users to flag problematic content/interactions
- Immediate escalation to support
- System response triggers
- Safety net for edge cases

**Arguments FOR SOS in GenCraft**:
1. **User Safety**: Content generation can produce harmful output
2. **TOS Violations**: Users may unknowingly violate policies
3. **Quality Issues**: Critical bugs need immediate reporting
4. **Bad Actor Detection**: Users can report suspicious behavior
5. **Emergency Stop**: Users can halt runaway generation jobs
6. **Trust Building**: Demonstrates commitment to user safety

**Arguments AGAINST**:
1. **Complexity**: Additional system to build/maintain
2. **Scope Creep**: GenCraft is content generation, not social platform
3. **Redundancy**: Support channels already exist
4. **Abuse Potential**: False reports, system gaming

**Recommendation**: **YES - Implement SOS System**

**Proposed SOS Features for GenCraft**:
1. **Emergency Stop Button**: Halt current generation immediately
2. **Report Problematic Output**: Flag content for review (automated analysis, not manual)
3. **Safety Escalation**: Critical issues trigger automated safety checks
4. **Abuse Prevention**: SOS includes anti-bad-actor detection
5. **Audit Trail**: All SOS events logged for system improvement

**Implementation Scope**:
- Phase 3 (Post-MVP) feature
- Integrated into Control Panel monitoring
- Automated response (NOT manual intervention)
- ML-powered safety classification
- Emergency response protocols

**Decision**: Add to quantum TODO as Phase 3 feature, pending user confirmation

---

## 📊 REQUIREMENTS COMPARISON TABLE

| Requirement | v2.0 | v3.0 (Previous) | v3.0 (Final - This Addendum) |
|-------------|------|-----------------|------------------------------|
| **Manual Approval** | Required for all | Removed | ✅ ZERO HIL - fully autonomous |
| **Retry Attempts** | 3 attempts | 3 attempts | **5 attempts** (intelligent) |
| **Retry Logic** | Fixed count | Fixed count | **Failure-reason-based** |
| **SuperAdmin UI** | Observation + God Mode | Observation + God Mode | **Separate**: Control Panel (observation) + SuperAdmin (God Mode) |
| **BYOK Cost Rejection** | Yes (reject) | Yes (reject) | **NO - adapt output instead** |
| **GenCraft Token Cost Rejection** | Yes | Yes | **YES - but with per-user override** |
| **Cost Threshold Config** | Global only | Global only | **Global + per-user override (SuperAdmin)** |
| **SOS System** | No | No | **YES - Phase 3 feature** |
| **Failure Reports** | Manual review queue | Automated reports | **Automated reports (NO manual review)** |

---

## 🚨 BREAKING CHANGES FROM v2.0

### 1. Database Schema Changes
- Remove: `approval_queue` table
- Remove: `manual_review_required` field
- Remove: `tier2_review` table
- Add: `retry_history` table (failure reason, attempt count, adaptation strategy)
- Add: `cost_policy_overrides` table (per-user cost settings)
- Add: `control_panel_permissions` table (RBAC for Control Panel vs SuperAdmin)

### 2. Service Changes
- Remove: Manual Approval Service
- Remove: Tier-2 Review Service
- Modify: Validation Service (autonomous retry logic)
- Add: Intelligent Retry Service (failure analysis + adaptation)
- Add: Cost Adaptation Service (BYOK output modification)
- Add: RBAC Service (Control Panel vs SuperAdmin)

### 3. UI Changes
- Rename: "SuperAdmin" → "Control Panel" (observation UI)
- Add: "SuperAdmin (God Mode)" (distinct from Control Panel)
- Remove: Approval Queue UI
- Remove: Manual Review Dashboard
- Add: Retry Analytics Dashboard (informational only)
- Add: Cost Policy Configuration (SuperAdmin only)
- Add: Per-User Cost Override UI (SuperAdmin only)

---

## ✅ ACTION ITEMS

### Immediate (Phase 1 - Data Gathering)
- [x] Capture requirements to quantum TODO
- [ ] Update requirements document (gencraft_requirements_v_1_3_0.md → v_1_4_0.md)
- [ ] Find/replace all "SuperAdmin" references → "Control Panel" (except God Mode)
- [ ] Document RBAC model (Control Panel vs SuperAdmin)

### Phase 2 (Architecture)
- [ ] Design intelligent retry system (failure reason → retry strategy)
- [ ] Design cost adaptation engine (BYOK output modification)
- [ ] Design RBAC system (two-tier: Control Panel + SuperAdmin)
- [ ] Design SOS system architecture (Phase 3 preview)

### Phase 3 (Implementation)
- [ ] Implement retry logic with 5 attempts
- [ ] Implement failure reason analysis
- [ ] Implement cost adaptation for BYOK
- [ ] Implement per-user cost overrides
- [ ] Separate Control Panel from SuperAdmin God Mode
- [ ] Implement RBAC enforcement

### Phase 4 (Testing)
- [ ] Test all retry scenarios (11 failure types)
- [ ] Test cost adaptation strategies (6 methods)
- [ ] Test RBAC (Control Panel vs SuperAdmin permissions)
- [ ] Test per-user cost overrides
- [ ] Verify ZERO manual approval paths exist

---

## 🎯 SUCCESS CRITERIA

**v3.0 is ONLY complete when**:
1. ✅ ZERO manual approval anywhere in system
2. ✅ All retries use intelligent failure analysis
3. ✅ BYOK users NEVER experience cost rejection (only adaptation)
4. ✅ SuperAdmin clearly separated from Control Panel
5. ✅ Per-user cost overrides functional
6. ✅ All retry failures generate informational reports (not approval requests)
7. ✅ 5-attempt retry maximum implemented
8. ✅ SOS system architecture documented (Phase 3 ready)

---

**Last Updated**: 2025-11-30 23:15 PST
**Author**: User requirements + Claude analysis
**Status**: MANDATORY for v3.0
**Next Review**: Before Phase 2 architecture begins
