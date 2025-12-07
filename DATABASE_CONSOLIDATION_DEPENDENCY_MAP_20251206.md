# DATABASE CONSOLIDATION - COMPLETE DEPENDENCY MAP
**Generated**: 2025-12-06 22:06 PST
**Purpose**: Map ALL database dependencies before surgical consolidation
**Status**: READ-ONLY ANALYSIS - NO CHANGES MADE

---

## 🎯 EXECUTIVE SUMMARY

**CRITICAL FINDING**: Multiple `quantum-index.db` files exist in different locations with active usage.
**RISK LEVEL**: ⚠️ **EXTREME** - Any consolidation without complete dependency map will break critical systems.

---

## 📊 ACTIVE PRODUCTION DATABASES

### 1. Index System Databases
**Location**: `.index-system/database/`

```
quantum-index.db - 36M (Last Modified: Sep 12, 2025)
  - Purpose: Primary search/index database
  - Status: ACTIVE (referenced by contractual-db-paths.sh)
  - Used by: Unified indexing system, search functionality
```

**Contractual Path**:
- `$INDEX_DB_DIR/quantum-index.db`
- `$QUANTUM_INDEX_DB` (exported variable)

---

### 2. Search Index Databases
**Location**: `.search-index/`

```
metadata.db - 21M (Last Modified: Dec 6, 2025 20:11) ⚡ RECENTLY ACTIVE
  - Purpose: Search metadata storage
  - Status: ACTIVE (recently updated)
  - Used by: Search indexing, metadata queries
```

**Contractual Path**:
- `$SEARCH_INDEX_DIR/metadata.db`
- `$METADATA_DB` (exported variable)

---

### 3. Quantum TODO System Databases
**Location**: `.quantum-todo/`

```
quantum-todo.db - 22M (Last Modified: Nov 28, 2025)
  - Purpose: Primary quantum TODO task database
  - Status: ACTIVE (critical production database)
  - Used by: quantum-todo-system.sh, all TODO operations
  - Contains: 21 tables (tasks, dependencies, states, etc.)

quantum-index.db - 129M (Last Modified: Dec 6, 2025 12:31) ⚡ ACTIVE TODAY!
  - Purpose: ⚠️ DUPLICATE INDEX DATABASE (conflicts with .index-system version)
  - Status: VERY ACTIVE (largest database, recently updated)
  - Size: 3.5x larger than .index-system version (36M vs 129M)
  - Contains: Extensive indexed data
```

**⚠️ CRITICAL ISSUE IDENTIFIED**:
- TWO `quantum-index.db` files exist:
  1. `.index-system/database/quantum-index.db` (36M)
  2. `.quantum-todo/quantum-index.db` (129M) ← LARGER, MORE RECENT

**Question**: Which is the authoritative database? Are they synced? Do they contain different data?

---

### 4. Safety Backups (in .quantum-todo/)

```
MIGRATION SAFETY BACKUPS (Oct 10, 2025):
  - HOT_MIGRATION_SAFETY_20251010_031354_auto-backup.db (44M)
  - HOT_MIGRATION_SAFETY_20251010_031354_quantum-index.db (66M)
  - HOT_MIGRATION_SAFETY_20251010_031354_quantum-todo.db (22M)
  - HOT_MIGRATION_SAFETY_20251010_031354_quantum_todos.db (504K)

SAFETY BACKUPS (Oct 9, 2025):
  - SAFETY_BACKUP_20251009_235633.db (66M)
  - auto-backup-20250916-142107.db (44M)

OLD/EMPTY DATABASES:
  - quantum-test.db (0 bytes - safe to delete)
  - quantum-todos.db (0 bytes - safe to delete)
  - quantum_todos.db (504K - likely old version)
```

**Recommendation**: Archive all safety backups older than 60 days to .perpetual-trash

---

## 📜 SCRIPT DEPENDENCIES

### Scripts Referencing Databases (Top 20)

1. **contractual-db-paths.sh** ⚡ CRITICAL
   - Defines ALL database paths
   - Exports: `$QUANTUM_INDEX_DB`, `$FILE_INDEX_DB`, `$METADATA_DB`
   - Function: `get_db_path()` for dynamic path resolution

2. **claude-os-contractual-paths.sh**
   - Database path management
   - Integration with contractual system

3. **quantum-todo-system.sh**
   - Primary TODO system
   - Uses: `.quantum-todo/quantum-todo.db`

4. **unified-index-daemon.sh** (LIKELY)
   - Index management
   - Probably uses quantum-index.db (which one?)

5. **Session End/Start Scripts**
   - CLAUDE_SESSION_END_PROTOCOL.sh
   - AUTO_SESSION_END_PROTOCOL.sh
   - CLAUDE_SESSION_PROTOCOL.sh
   - All reference databases for session state

6. **Search Scripts**
   - cs-search.sh
   - content-analyzer.sh
   - Uses metadata.db, quantum-index.db

7. **Enterprise Scripts**
   - enterprise-hash-normalization-fortress.sh
   - enterprise-plans-consolidation-200.sh
   - Database integrity and consolidation

8. **Memory & Taxonomy**
   - claude-memory-hooks.sh
   - claude-memory-taxonomycraft-integration.sh
   - claude-memory-watcher.sh
   - Database-backed memory systems

---

## 🔍 CRITICAL QUESTIONS REQUIRING ANSWERS

### Before ANY Consolidation Can Proceed:

1. **Which quantum-index.db is authoritative?**
   - `.index-system/database/quantum-index.db` (36M, Sep 12)
   - `.quantum-todo/quantum-index.db` (129M, Dec 6 - TODAY!)
   - Are they synced? Do they contain different data sets?

2. **Why is quantum-index.db in .quantum-todo/?**
   - Was it moved during a migration?
   - Is it a backup that became primary?
   - Is the .index-system version obsolete?

3. **Which scripts use which database?**
   - Need to trace every script's actual database path
   - Check if they use contractual-db-paths.sh or hardcoded paths
   - Verify no scripts directly reference old locations

4. **Are there active processes using these databases?**
   - Check for daemon locks
   - Verify no write operations during consolidation
   - Identify all open file handles

5. **What data would be lost if we chose the wrong primary?**
   - Compare schemas of both quantum-index.db files
   - Check row counts in critical tables
   - Verify data freshness and completeness

---

## 📋 NEXT STEPS (Task 3: Dependency Mapping)

### Immediate Actions Required:

1. **Compare the two quantum-index.db files**
   ```bash
   # Schema comparison
   sqlite3 .index-system/database/quantum-index.db ".schema" > schema_index_system.txt
   sqlite3 .quantum-todo/quantum-index.db ".schema" > schema_quantum_todo.txt
   diff -u schema_index_system.txt schema_quantum_todo.txt

   # Table counts
   sqlite3 .index-system/database/quantum-index.db ".tables"
   sqlite3 .quantum-todo/quantum-index.db ".tables"

   # Row counts in key tables
   sqlite3 .index-system/database/quantum-index.db "SELECT COUNT(*) FROM [table];"
   sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM [table];"
   ```

2. **Trace actual script usage**
   ```bash
   # Find which scripts source contractual-db-paths.sh
   grep -r "contractual-db-paths" *.sh

   # Find hardcoded paths to either database
   grep -r "\.index-system/database/quantum-index" *.sh
   grep -r "\.quantum-todo/quantum-index" *.sh
   ```

3. **Check active daemon usage**
   ```bash
   # Check daemon registry
   cat .daemon-registry/active-daemons.json | jq '.[] | select(.database != null)'

   # Check process locks
   lsof | grep "quantum-index.db"
   ps aux | grep -E "(daemon|index)" | grep -v grep
   ```

4. **Analyze migration history**
   ```bash
   # Find migration records
   find . -name "*migration*" -type f | grep -E "(log|md|txt)"

   # Check quantum-todo migration logs
   ls -ltr .quantum-todo/ | grep -i migration
   ```

---

## ⚠️ SAFETY PROTOCOLS

### BEFORE Making ANY Changes:

1. **FULL SYSTEM BACKUP**
   - Backup ALL databases (not just the ones we're consolidating)
   - Backup all scripts referencing databases
   - Backup daemon registry
   - Create rollback snapshot

2. **STOP ALL DAEMONS**
   - `./daemon-supervisor.sh stop`
   - Verify ALL daemons stopped: `ps aux | grep daemon`
   - Wait 10 seconds for clean shutdown

3. **VERIFY NO ACTIVE CONNECTIONS**
   - `lsof | grep ".db"`
   - `fuser .quantum-todo/quantum-index.db`
   - `fuser .index-system/database/quantum-index.db`

4. **TEST ENVIRONMENT FIRST**
   - Create test copies of databases
   - Run consolidation on test copies
   - Verify scripts work with consolidated database
   - Only then apply to production

---

## 📊 CONSOLIDATION COMPLEXITY ESTIMATE

**Risk Level**: ⚠️ **EXTREME**
**Effort**: 4-6 hours of careful work
**Reversibility**: 100% (with proper backups)
**Impact Radius**: 50+ scripts, 9+ daemons, entire ecosystem

**Recommendation**:
- **DO NOT** consolidate blindly
- **DO** complete full dependency map first (this document is step 1)
- **DO** answer all critical questions above
- **DO** create surgical plan with step-by-step verification

---

## 📝 STATUS

- ✅ **Task 1 Complete**: Wait for diagnostic (partial - more analysis needed)
- 🔄 **Task 3 In Progress**: Map ALL dependencies (this document)
- ⏸️ **Task 2 Pending**: Create surgical plan (after Task 3 complete)

**Next Action**: Answer the 5 critical questions above before proceeding to surgical plan.

---

**Generated by**: Claude Code
**Date**: 2025-12-06 22:06 PST
**File**: DATABASE_CONSOLIDATION_DEPENDENCY_MAP_20251206.md
