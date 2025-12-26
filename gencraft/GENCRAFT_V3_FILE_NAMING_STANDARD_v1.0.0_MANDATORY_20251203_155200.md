# GENCRAFT V3.0 - FILE NAMING STANDARD
**Version**: 1.0.0
**Created**: 2025-12-03 15:52:00
**Status**: MANDATORY - ALL FILES MUST FOLLOW THIS STANDARD

---

## 🎯 MANDATORY FILE NAMING FORMAT

**Format**: `GENCRAFT_V3_[DOCUMENT_TYPE]_v[X.Y.Z]_[DESCRIPTION]_[YYYYMMDD]_[HHMMSS].ext`

### Components (in order):

1. **Project Prefix**: `GENCRAFT_V3_` (ALWAYS)
2. **Document Type**: `MASTER_REBUILD_PLAN` | `COMPLETE_GAP_ANALYSIS` | `BLOCKER_1_X` | etc.
3. **Version**: `v[X.Y.Z]` (semantic versioning)
4. **Description**: `FINAL_REPORT` | `FULL_IMPLEMENTATION_SCOPE` | `PHASE_1_COMPLETE` | etc.
5. **Date**: `YYYYMMDD` (ISO 8601 format)
6. **Time**: `HHMMSS` (24-hour format)
7. **Extension**: `.md` | `.txt` | `.json` | etc.

---

## ✅ CORRECT EXAMPLES

```
GENCRAFT_V3_MASTER_REBUILD_PLAN_v3.0.5_CORRECTED_SCOPE_20251203_155200.md
GENCRAFT_V3_COMPLETE_GAP_ANALYSIS_v2.0.0_FULL_IMPLEMENTATION_SCOPE_20251203_154700.md
GENCRAFT_V3_BLOCKER_1_1_WEB_RESEARCH_v1.0.0_FINAL_REPORT_20251203_024400.md
GENCRAFT_V3_FRAMEWORKS_ANALYSIS_v1.0.0_COMPLETE_20251203_025800.md
GENCRAFT_V3_SESSION_HANDOFF_v1.0.0_PHASE_1_COMPLETE_20251203_155300.md
```

---

## ❌ INCORRECT EXAMPLES (DO NOT USE)

```
BLOCKER_1_1_WEB_RESEARCH_FINAL_REPORT.md ❌ (missing GENCRAFT_V3_ prefix)
BUILD_RESOURCES_MASTER.md ❌ (missing prefix, version, timestamp)
GENCRAFT_V3_GAP_ANALYSIS_2025-12-03.md ❌ (missing version, description)
gap_analysis_v1.md ❌ (wrong prefix, wrong format)
GENCRAFT_V3_PLAN_20251203_155200_DESCRIPTION.md ❌ (description after timestamp)
```

---

## 📋 DOCUMENT TYPE STANDARDS

### Master Planning Documents
- `GENCRAFT_V3_MASTER_REBUILD_PLAN_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`
- `GENCRAFT_V3_PHASE_[N]_PLAN_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`

### Analysis Documents
- `GENCRAFT_V3_COMPLETE_GAP_ANALYSIS_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`
- `GENCRAFT_V3_[SYSTEM]_ANALYSIS_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`

### Blocker Reports
- `GENCRAFT_V3_BLOCKER_[N]_[N]_[NAME]_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`

### Session Documents
- `GENCRAFT_V3_SESSION_HANDOFF_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`
- `GENCRAFT_V3_SESSION_END_REPORT_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`

### Resource Documents
- `GENCRAFT_V3_BUILD_RESOURCES_MASTER_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`
- `GENCRAFT_V3_EXTERNAL_REPOS_MANIFEST_v[X.Y.Z]_[DESC]_[DATE]_[TIME].md`

---

## 🔄 VERSION NUMBERING

### Semantic Versioning (MAJOR.MINOR.PATCH)

- **MAJOR (X)**: Breaking changes, complete rewrites, major scope changes
- **MINOR (Y)**: New sections added, significant updates, feature additions
- **PATCH (Z)**: Bug fixes, typos, minor clarifications

**Examples:**
- `v1.0.0` → Initial version
- `v1.0.1` → Fixed typos
- `v1.1.0` → Added new section
- `v2.0.0` → Complete rewrite with new scope

---

## 📅 TIMESTAMP FORMAT

**Date**: `YYYYMMDD` (8 digits, no separators)
- Example: `20251203` = December 3, 2025

**Time**: `HHMMSS` (6 digits, 24-hour format, no separators)
- Example: `155200` = 3:52:00 PM

**Combined**: `20251203_155200`

---

## 🚨 ENFORCEMENT

### Rules:
1. **NEVER overwrite files** - always create new version
2. **ALWAYS include GENCRAFT_V3_ prefix** - for cross-project identification
3. **ALWAYS include version number** - for tracking changes
4. **ALWAYS include description** - for human readability
5. **ALWAYS include timestamp** - for chronological sorting
6. **Description BEFORE timestamp** - for readability

### Consequences of Non-Compliance:
- Files without `GENCRAFT_V3_` prefix cannot be tracked across projects
- Files without versions create confusion about which is latest
- Files without timestamps cannot be chronologically sorted
- Files without descriptions are not human-readable

---

## 📁 FILE ORGANIZATION

### Directory Structure:
```
gencraft-v3.0/
├── GENCRAFT_V3_*_v*_*_YYYYMMDD_HHMMSS.md (root level documents)
├── .plans/
│   └── GENCRAFT_V3_*_PLAN_v*_*_YYYYMMDD_HHMMSS.md
├── .analysis-reports/
│   └── GENCRAFT_V3_*_ANALYSIS_v*_*_YYYYMMDD_HHMMSS.md
└── .phase-dependencies/
    └── GENCRAFT_V3_PHASE_*_v*_*_YYYYMMDD_HHMMSS.md
```

---

## ✅ VALIDATION CHECKLIST

Before saving ANY file, verify:
- [ ] Starts with `GENCRAFT_V3_`
- [ ] Includes version `v[X.Y.Z]`
- [ ] Includes description (before timestamp)
- [ ] Includes date `YYYYMMDD`
- [ ] Includes time `HHMMSS`
- [ ] Appropriate extension (`.md`, `.txt`, `.json`)
- [ ] NO SPACES in filename (use underscores)
- [ ] Description is descriptive and clear

---

## 🔄 MIGRATION PLAN

**Next Session**: Rename ALL existing files to follow this standard

**Files Requiring Renaming** (estimated 50+ files):
- All BLOCKER reports
- All analysis documents
- All resource documents
- All session documents
- All phase documents

**Process**:
1. List all files not following standard
2. Generate rename commands
3. Execute renames with git mv (preserves history)
4. Verify no broken references
5. Update any hardcoded references

---

**Status**: MANDATORY
**Enforcement**: IMMEDIATE (all new files)
**Migration**: NEXT SESSION (all existing files)

**Author**: Claude Code AI
**Project**: GenCraft v3.0
**Date**: 2025-12-03 15:52:00
