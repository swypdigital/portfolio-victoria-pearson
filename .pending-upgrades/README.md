# Pending Upgrades System

**Auto-population system for framework improvements**

## Overview

The Pending Upgrades System automatically presents framework improvement plans when you start working on them. No need to search for notes or remember what needs to be integrated.

## How It Works

### 1. Upgrade Plans Stored as JSON

Each framework has a structured upgrade plan:
- **SAAS Framework**: `saas-framework-v7-to-v8.json`
- **GenCraft**: `gencraft-v3-templates.json`
- **Pattern Library**: `pattern-library-additions.json`

### 2. Auto-Detection on Mention

When you mention a framework in conversation:
- System detects keywords (e.g., "SAAS Framework", "GenCraft", "Pattern Library")
- Checks for pending upgrade plan
- Automatically presents the plan with summary

### 3. Plan Structure

Each plan includes:
```json
{
  "metadata": {
    "targetFramework": "Name",
    "currentVersion": "v1.0",
    "targetVersion": "v2.0",
    "source": "Where patterns came from",
    "estimatedImpact": { "developmentTimeSaved": "X hours" }
  },
  "additions": {
    "components": [ /* Fully implemented features */ ],
    "patterns": [ /* Reusable code patterns */ ],
    "templates": [ /* Code generation templates */ ]
  },
  "integrationChecklist": [ /* Step-by-step integration */ ]
}
```

## Usage

### View All Pending Upgrades

```bash
pending-upgrades
# or
check-upgrades
```

### Manual Check for Specific Framework

```bash
check_pending_upgrades "saas framework"
check_pending_upgrades "gencraft"
check_pending_upgrades "pattern library"
```

### Integration Workflow

1. **User says**: "Let's work on SAAS Framework v7.0"
2. **System checks**: `.pending-upgrades/saas-framework-v7-to-v8.json`
3. **System loads**: Presents 20 additions (12 components + 8 patterns)
4. **User reviews**: Approves integration
5. **User integrates**: Follows checklist, marks items complete

## Current Pending Upgrades

### 1. SAAS Framework v7.0 → v8.0

**Source**: Token Cost Calculator Phase 4 (Weeks 1-3)

**Additions**:
- 12 fully implemented components to document
- 8 new patterns (#71-#78)

**Impact**: 120-180 hours saved per project

**Details**:
- Multi-tenant teams collaboration
- Forensic PDF watermarking (architecture)
- Multi-layer cache orchestrator
- God mode bypass system
- Automatic audit logging
- Rate limiting
- Security events
- RBAC with role hierarchy

### 2. GenCraft v3.0 → v3.1

**Source**: Token Cost Calculator Phase 4 (Weeks 1-3)

**Additions**:
- 15 code generation templates

**Impact**: 60-90 hours saved per project with multi-tenancy

**Templates**:
- multi-tenant-teams.template.ts
- cache-orchestrator.template.ts
- rate-limiter.template.sql
- audit-logger.template.sql
- rbac-policies.template.sql
- god-mode-bypass.template.sql
- owner-protection.template.sql
- security-events.template.sql
- api-routes-teams.template.ts
- cascade-invalidation.template.ts
- forensic-watermarking.template.ts (architecture)
- database-migrations.template.ts
- rls-policies.template.sql
- fingerprint-detection.template.ts
- admin-actions.template.sql

### 3. Pattern Library v1.0 → v1.1

**Source**: Token Cost Calculator Phase 4 (Weeks 1-3)

**Additions**:
- 20 reusable code patterns

**Impact**: 40-60 hours saved per project

**Categories**:
- TypeScript (5 patterns): Multi-layer cache, fingerprint data, rate limit types, audit log types, god mode context
- SQL (5 patterns): JSONB diff, cascade delete, RLS bypass, incremental counters, permission checks
- API (5 patterns): Rate limit middleware, god mode middleware, RBAC middleware, pagination helper, error formatter
- React (3 patterns): Rate limit hook, audit log hook, permission hook
- Security (2 patterns): Input sanitization, password validation

## File Locations

```
.pending-upgrades/
├── README.md                              # This file
├── UPGRADE_PLAN_SCHEMA.json               # JSON schema for all plans
├── saas-framework-v7-to-v8.json           # SAAS upgrade plan
├── gencraft-v3-templates.json             # GenCraft upgrade plan
└── pattern-library-additions.json         # Pattern Library upgrade plan

.bashrc-includes/
└── pending-upgrades-hook.sh               # Auto-detection hook
```

## Integration Checklist Format

Each plan includes a checklist:

```json
{
  "integrationChecklist": [
    {
      "step": "Document Component #3",
      "description": "Add Multi-Tenant Teams to SAAS v8.0",
      "completed": false
    }
  ]
}
```

Mark items `true` as you complete them.

## Benefits

✅ Never forget framework improvements
✅ Structured upgrade process
✅ Version-controlled pending changes
✅ Auto-loads when you're ready
✅ No manual note-searching
✅ Full extraction analysis preserved
✅ Time-saved estimates included
✅ Step-by-step integration guidance

## Maintenance

### Adding New Upgrade Plans

1. Create JSON file following schema: `UPGRADE_PLAN_SCHEMA.json`
2. Place in `.pending-upgrades/`
3. Update `pending-upgrades-hook.sh` with keyword detection

### Marking Upgrades Complete

1. Open upgrade plan JSON
2. Mark `integrationChecklist` items as `completed: true`
3. When all complete, move file to `.pending-upgrades/completed/`

### Updating Hook

Edit `.bashrc-includes/pending-upgrades-hook.sh` to add new frameworks or change keywords.

## Schema Documentation

See `UPGRADE_PLAN_SCHEMA.json` for complete schema documentation with:
- Required fields
- Optional fields
- Field descriptions
- Example values
- Validation rules

## NEW: Pattern Versioning & NL Interface (Phase 1)

### Pattern Versioning System

**File**: `pattern-versioning-system.sh`

Semantic versioning (Major.Minor.Patch) for framework patterns prevents breaking deployed projects:

```bash
# Source the system
source .pending-upgrades/pattern-versioning-system.sh

# Check version comparison
pattern_version_cli compare "v2.1.0" "v2.0.5"  # Returns: 1 (greater)

# Detect breaking changes
pattern_version_cli detect-breaking "old.json" "new.json"

# Check upgrade safety
pattern_version_cli check-safety "/project" "Pattern #73" "v2.0.0" "v3.0.0"

# Lock pattern version (like package-lock.json)
pattern_version_cli lock "/project" "Pattern #73" "v2.1.0"

# Analyze upgrade impact
pattern_version_cli impact "Pattern #73" "v2.0.0" "v3.0.0"
```

**Features**:
- ✅ Semantic versioning validation
- ✅ Breaking change detector (analyzes function signatures, interfaces)
- ✅ Usage registry (tracks which projects use which pattern versions)
- ✅ Lock files (`.pattern-lock.json` per project)
- ✅ Upgrade safety checker (MAJOR/MINOR/PATCH analysis)

### Natural Language Interface

**File**: `nl-upgrade-commands.sh`

**REUSES existing NL fuzzy matching system** (does not rebuild):

```bash
# Source the system
source .pending-upgrades/nl-upgrade-commands.sh

# Natural language commands (with typo correction)
upgrade_nl "test saas framwork upgrade"      # Fuzzy matches + typo correction
upgrade_nl "apply pattern library v1.1"       # Apply upgrade
upgrade_nl "list pending upgrades"            # Show all pending
upgrade_nl "rollback migration"               # Rollback (Phase 2)
upgrade_nl "show impact of gencraft upgrade"  # Impact analysis
```

**Intents Detected**:
- `test/validate/check` - Test upgrade in sandbox (Phase 2)
- `apply/install` - Apply upgrade to production (Phase 3)
- `rollback/revert` - Rollback last migration (Phase 2)
- `list/show` - Show pending upgrades
- `impact` - Analyze upgrade impact

**Typo Corrections**:
- "saas framwork" → "saas framework"
- "gen craft" → "gencraft"
- "upgarde" → "upgrade"
- "migraton" → "migration"
- "rolback" → "rollback"

---

**Version**: 1.1.0
**Updated**: 2025-12-27
**Phase**: 1 of 4 (Pattern Versioning & NL Interface) - COMPLETE
**Source**: Token Cost Calculator Phase 4 analysis
