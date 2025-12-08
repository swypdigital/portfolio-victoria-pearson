# COMPLETE DATABASE DEPENDENCY MAP
**Generated**: 2025-12-07 06:00:00 PST
**Purpose**: Forensic analysis of database consolidation error - which scripts use which databases

---

## EXECUTIVE SUMMARY

**CRITICAL FINDING**: The database consolidation on 2025-12-07 incorrectly pointed 6 scripts to `quantum-index.db` when they should use `quantum-todo.db`.

**Root Cause**: Line 21 of `contractual-db-paths.sh` changed `QUANTUM_INDEX_DB` from `.index-system/database/` to `.quantum-todo/` directory, BUT the variable name remained `QUANTUM_INDEX_DB` when it should point to the TODO tracking database.

**Impact**: 
- Session protocols now write to the WRONG database (file indexing DB instead of TODO tracking DB)
- 27,855 records in quantum-index.db (legacy/file indexing)
- 25,612 records in quantum-todo.db (ACTIVE TODO tracking)
- Scripts reading from wrong database = missing TODO context

---

## DATABASE ARCHITECTURE

### quantum-index.db
- **Location**: `.quantum-todo/quantum-index.db` (consolidation moved it here)
- **Size**: 129MB
- **Record Count**: 27,855 TODOs (LEGACY)
- **Tables**: 38 total
  - **Core TODO Tables**:
    - `quantum_todos` (27,855 records) - LEGACY TODO records
    - `todo_dependencies` (relationships)
    - `dependency_counts` (dependency tracking)
  - **Enterprise Features** (WHITE-LABEL, ML, RBAC, etc.):
    - `ml_models`, `ml_predictions`, `ml_training_data` (machine learning)
    - `white_label_config`, `email_templates`, `theme_presets` (branding)
    - `api_keys`, `audit_trail`, `tenant_config`, `user_roles` (multi-tenancy)
    - `nlp_patterns`, `anomaly_detections`, `user_behavior` (AI features)
    - `file_index` (0 records - file tracking)
    - `plans_consolidated` (1 record - imported plans)
    - `audit_trail` (2 records)
  - **Search**: `quantum_fts` (full-text search)
  - **Views**: `quantum_execution_plan`, `quantum_todos_optimized`
- **Purpose**: Originally file indexing + legacy TODOs, now contains ALL enterprise features
- **Active**: NO - should be read-only/archive
- **Schema Features**:
  - Extended TODO columns (craft_framework, project_tags, ml_priority_score, composite_content, tenant_id, etc.)
  - Comprehensive enterprise tables (white-label, ML, RBAC, webhooks, alerts)
  - Hash verification and cross-reference validation tables

### quantum-todo.db
- **Location**: `.quantum-todo/quantum-todo.db`
- **Size**: 22MB  
- **Record Count**: 25,612 TODOs (ACTIVE)
- **Tables**: 19 total
  - **Core TODO Tables**:
    - `quantum_todos` (25,612 records) - ACTIVE TODO tracking
    - `todo_dependencies` (0 records currently)
    - `dependency_counts` (dependency tracking)
  - **Supporting Tables**:
    - `tenant_config`, `api_keys`, `audit_log` (73 records), `roles`, `user_roles`
    - `white_label_config`, `webhooks`, `webhook_events`
    - `alert_rules`, `alert_history`
    - `performance_metrics`
    - `csrf_tokens`, `cache_config`
  - **Search**: `quantum_fts` (full-text search)
- **Purpose**: ACTIVE TODO tracking system (current production)
- **Active**: YES - primary TODO database
- **Schema Features**:
  - Core TODO columns (id, content, status, priority, source, timestamps, etc.)
  - ML prediction columns (ml_priority_score, predicted_duration, actual_duration)
  - Dependency tracking (depends_on, blocks, dependency_status)
  - Simpler schema than quantum-index.db (fewer enterprise features)

---

## CONSOLIDATION CHANGE ANALYSIS

### contractual-db-paths.sh - LINE 21 (THE SMOKING GUN)

**BEFORE (Correct)**:
```bash
export QUANTUM_INDEX_DB="${INDEX_DB_DIR}/quantum-index.db"  # .index-system/database/
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db" # .quantum-todo/
```

**AFTER (INCORRECT - 2025-12-07)**:
```bash
# Line 21: Changed location but kept the name QUANTUM_INDEX_DB
export QUANTUM_INDEX_DB="${QUANTUM_TODO_DIR}/quantum-index.db"  # MOVED to .quantum-todo/
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db"    # Correct
```

**THE ERROR**:
- Variable name `QUANTUM_INDEX_DB` implies "file index database"
- But scripts use it for TODO operations (session protocols, TODO autocapture, etc.)
- Comment says "active production DB" - but that's `quantum-todo.db`!
- Should be: `export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db"` everywhere

---

## SCRIPT DEPENDENCY ANALYSIS

### Category: Session Management (HIGH PRIORITY - ACTIVE SYSTEM)

#### 1. CLAUDE_SESSION_END_PROTOCOL.sh
- **Purpose**: Captures session state, generates handoff files, preserves context
- **Database Variable Used**: `$QUANTUM_INDEX_DB` (line 343)
- **Database Operations**:
  - Line 343: Referenced in handoff.json as `"quantum_todo": "$QUANTUM_INDEX_DB"`
- **SHOULD Use**: `$QUANTUM_TODO_DB` (active TODO tracking)
- **DOES Use**: `$QUANTUM_INDEX_DB` (legacy/file index) 
- **Status**: ❌ **INCORRECT** - Session handoff points to WRONG database
- **Impact**: Session continuity references wrong TODO database

#### 2. AUTO_SESSION_END_PROTOCOL.sh
- **Purpose**: Auto-trigger at 9% token limit - captures scrollback, TODOs, plans
- **Database Variable Used**: `$QUANTUM_INDEX_DB` (line 59)
- **Database Operations**:
  - Line 59: `sqlite3 "$QUANTUM_INDEX_DB" "SELECT json_object(...) FROM quantum_todos;"`
- **SHOULD Use**: `$QUANTUM_TODO_DB` (active TODOs)
- **DOES Use**: `$QUANTUM_INDEX_DB` (legacy TODOs)
- **Status**: ❌ **INCORRECT** - Exports old TODO state instead of current
- **Impact**: Auto-session-end backs up WRONG TODO database (27,855 old vs 25,612 current)

#### 3. CLAUDE_SESSION_PROTOCOL.sh (Startup/Runtime)
- **Purpose**: Session startup, health checks, runtime monitoring
- **Database Variable Used**: `quantum-todo.db` (HARDCODED correctly!)
- **Database Operations**:
  - Lines 133-134, 147: Direct path `$QUANTUM_DIR/quantum-todo.db`
  - Lines 190-192: SELECT queries for stats (tasks created/completed, ML predictions)
  - Lines 214-215, 218: SELECT queries for current state
  - Line 238: Top 5 pending tasks by ML score
  - Lines 276-282: Database integrity check and recovery
  - Lines 312-317: Database stats display
- **SHOULD Use**: `quantum-todo.db` (active TODOs)
- **DOES Use**: `quantum-todo.db` (HARDCODED correctly)
- **Status**: ✅ **CORRECT** - Uses active TODO database directly
- **Impact**: NONE - this script is correct

#### 4. CLAUDE_SESSION_STARTUP_PROTOCOL.sh (WSL Startup)
- **Purpose**: WSL/bash startup - launches daemons, loads session context
- **Database Variable Used**: NONE (no direct database access)
- **Database Operations**: None - delegates to other scripts
- **SHOULD Use**: N/A
- **DOES Use**: N/A
- **Status**: ✅ **CORRECT** - Infrastructure script, no database operations
- **Impact**: NONE - launches daemons that access databases

---

### Category: Status/Display Scripts (MEDIUM PRIORITY)

#### 5. terminal_footer_enhanced.sh
- **Purpose**: Live terminal status bar (folder, time, TMUX lines, backup countdown)
- **Database Variable Used**: NONE
- **Database Operations**: None - only displays TMUX stats
- **SHOULD Use**: N/A
- **DOES Use**: N/A
- **Status**: ✅ **CORRECT** - Display script, no database access
- **Impact**: NONE

#### 6. tmux-auto-manager.sh
- **Purpose**: Zero-manual TMUX session management
- **Database Variable Used**: NONE
- **Database Operations**: None - TMUX operations only
- **SHOULD Use**: N/A
- **DOES Use**: N/A
- **Status**: ✅ **CORRECT** - TMUX manager, no database access
- **Impact**: NONE

---

### Category: Hash Management (MEDIUM PRIORITY - MAINTENANCE)

#### 7. complete-hashing-final.sh
- **Purpose**: Hash remaining unhashed records for 100% compliance
- **Database Variable Used**: `$QUANTUM_INDEX_DB` (line 11, assigned to `MASTER_DB`)
- **Database Operations**:
  - Line 17-18: `SELECT COUNT(*) FROM quantum_todos` (total and hashed counts)
  - Line 31-36: `UPDATE quantum_todos SET content_hash=... WHERE content_hash IS NULL`
  - Line 39: Verification query
- **SHOULD Use**: BOTH databases (hash all records everywhere)
- **DOES Use**: `$QUANTUM_INDEX_DB` only (legacy database)
- **Status**: ⚠️ **INCOMPLETE** - Should hash BOTH databases
- **Impact**: Only hashes legacy database, active database may have unhashed records

---

### Category: Diagnostic Tools (LOW PRIORITY - ANALYSIS)

#### 8. database-dependency-diagnostic.sh
- **Purpose**: Comprehensive database ecosystem analysis
- **Database Variable Used**: `$QUANTUM_TODO_DB` (line 57, in Phase 6)
- **Database Operations**:
  - Line 59: `sqlite3 "$QUANTUM_TODO_DB" ".schema"` (displays schema)
- **SHOULD Use**: `$QUANTUM_TODO_DB` (analyzing active database)
- **DOES Use**: `$QUANTUM_TODO_DB` (correct)
- **Status**: ✅ **CORRECT** - Analyzes active TODO database
- **Impact**: NONE - this script is correct

---

### Category: Rollback/Recovery (LOW PRIORITY - SAFETY)

#### 9. rollback-quantum-todo-changes.sh
- **Purpose**: Rollback quantum-todo system changes if issues arise
- **Database Variable Used**: `$QUANTUM_INDEX_DB` (line 35)
- **Database Operations**:
  - Line 35: `sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;"`
- **SHOULD Use**: `$QUANTUM_TODO_DB` (test active database integrity)
- **DOES Use**: `$QUANTUM_INDEX_DB` (tests legacy database)
- **Status**: ❌ **INCORRECT** - Tests wrong database for system health
- **Impact**: Rollback script would pass even if active database is broken

---

### Category: Infrastructure (CRITICAL - CORE SYSTEM)

#### 10. parallel-repair-engine.sh
- **Purpose**: Migrate 10,601 Linux-only files to Windows mirror
- **Database Variable Used**: Sources `contractual-db-paths.sh` (line 38-40)
- **Database Operations**:
  - Line 38-40: Sources contractual paths but doesn't directly use databases
  - Only loads paths for environment detection
- **SHOULD Use**: N/A (infrastructure script, not TODO-related)
- **DOES Use**: None (only sources paths)
- **Status**: ✅ **CORRECT** - Not a database user
- **Impact**: NONE - Infrastructure script

---

### Category: Active Daemons (CRITICAL - RUNNING PROCESSES)

#### 11. quantum-todo-autocapture-daemon-enhanced.sh
- **Purpose**: Auto-capture TODOs from chat output to quantum system
- **Database Variable Used**: Uses `get_quantum_todo_system()` function
- **Database Operations**:
  - Line 17-18: Gets quantum command via contractual paths
  - Uses quantum-todo-system.sh which then accesses database
  - Indirect database access through quantum-todo-system.sh wrapper
- **SHOULD Use**: `$QUANTUM_TODO_DB` (capture to active database)
- **DOES Use**: Through `quantum-todo-system.sh` (needs investigation)
- **Status**: ⚠️ **NEEDS INVESTIGATION** - Depends on quantum-todo-system.sh config
- **Impact**: If quantum-todo-system.sh uses wrong DB, auto-capture goes to wrong place

#### 12. unified-index-daemon.sh
- **Purpose**: File indexing system (not TODO tracking)
- **Database Variable Used**: `$METADATA_DB` (line 27)
- **Database Operations**:
  - Line 61-73: Creates `file_registry` table in metadata.db
  - File indexing operations (NOT TODO tracking)
- **SHOULD Use**: `$METADATA_DB` (file indexing)
- **DOES Use**: `$METADATA_DB` (correct)
- **Status**: ✅ **CORRECT** - File indexer uses file index database
- **Impact**: NONE - this daemon is for file indexing, not TODOs

---

### Category: System Startup (WSL/Bash)

#### 13. .bashrc (WSL Startup)
- **Purpose**: Bash initialization, loads persistent history, NL commands, indexer
- **Database Variable Used**: Hardcoded path to `file-index.db` (line 16)
- **Database Operations**:
  - Line 16: `sqlite3 /mnt/c/Users/jdh/claude_projects/.index-system/database/file-index.db "SELECT COUNT(*) FROM file_index;"`
  - Checks if unified indexer needs to run
- **SHOULD Use**: Hardcoded path to file-index.db (file indexing, not TODOs)
- **DOES Use**: Hardcoded path (correct)
- **Status**: ✅ **CORRECT** - File index check, not TODO database
- **Impact**: NONE

---

## DEPENDENCY GRAPH

```
quantum-index.db (LEGACY/FILE INDEX - 129MB, 27,855 old TODOs)
├── Scripts that SHOULD use it:
│   ├── ✅ unified-index-daemon.sh (file indexing) - USES metadata.db instead
│   └── (None - this is a legacy database)
│
└── Scripts INCORRECTLY using it:
    ├── ❌ CLAUDE_SESSION_END_PROTOCOL.sh (should use quantum-todo.db)
    ├── ❌ AUTO_SESSION_END_PROTOCOL.sh (should use quantum-todo.db)
    ├── ⚠️ complete-hashing-final.sh (should hash BOTH databases)
    └── ❌ rollback-quantum-todo-changes.sh (should test quantum-todo.db)

quantum-todo.db (ACTIVE TODO TRACKING - 22MB, 25,612 current TODOs)
├── Scripts that SHOULD use it:
│   ├── ✅ CLAUDE_SESSION_PROTOCOL.sh (hardcoded correctly)
│   ├── ❌ CLAUDE_SESSION_END_PROTOCOL.sh (uses QUANTUM_INDEX_DB instead)
│   ├── ❌ AUTO_SESSION_END_PROTOCOL.sh (uses QUANTUM_INDEX_DB instead)
│   ├── ✅ database-dependency-diagnostic.sh (uses QUANTUM_TODO_DB correctly)
│   ├── ❌ rollback-quantum-todo-changes.sh (uses QUANTUM_INDEX_DB instead)
│   ├── ⚠️ complete-hashing-final.sh (only hashes quantum-index.db)
│   └── ⚠️ quantum-todo-autocapture-daemon.sh (via quantum-todo-system.sh)
│
└── Scripts correctly using it:
    ├── ✅ CLAUDE_SESSION_PROTOCOL.sh (hardcoded path)
    └── ✅ database-dependency-diagnostic.sh (uses $QUANTUM_TODO_DB)

OTHER DATABASES (Correct Usage):
metadata.db (File Indexing)
├── ✅ unified-index-daemon.sh
└── ✅ .bashrc (checks file-index.db)
```

---

## CONSOLIDATION ERRORS SUMMARY

### Scripts Pointing to WRONG Database (HIGH PRIORITY):

1. **CLAUDE_SESSION_END_PROTOCOL.sh** - Line 343
   - Uses: `$QUANTUM_INDEX_DB` 
   - Should use: `$QUANTUM_TODO_DB`
   - Impact: Session handoff references wrong TODO database

2. **AUTO_SESSION_END_PROTOCOL.sh** - Line 59
   - Uses: `$QUANTUM_INDEX_DB`
   - Should use: `$QUANTUM_TODO_DB`
   - Impact: Auto-session backup exports old TODOs (27,855 legacy vs 25,612 current)

3. **rollback-quantum-todo-changes.sh** - Line 35
   - Uses: `$QUANTUM_INDEX_DB`
   - Should use: `$QUANTUM_TODO_DB`
   - Impact: Rollback health check tests wrong database

### Scripts Pointing to CORRECT Database:

1. **CLAUDE_SESSION_PROTOCOL.sh** - Lines 133, 147, 190-192, 214-215, 276-282, 312-317
   - Uses: Hardcoded `$QUANTUM_DIR/quantum-todo.db`
   - Status: ✅ CORRECT

2. **database-dependency-diagnostic.sh** - Line 57
   - Uses: `$QUANTUM_TODO_DB`
   - Status: ✅ CORRECT

3. **unified-index-daemon.sh** - Line 27
   - Uses: `$METADATA_DB` (file indexing)
   - Status: ✅ CORRECT (not a TODO database)

4. **terminal_footer_enhanced.sh**
   - Uses: NONE (display only)
   - Status: ✅ CORRECT

5. **tmux-auto-manager.sh**
   - Uses: NONE (TMUX only)
   - Status: ✅ CORRECT

6. **.bashrc**
   - Uses: Hardcoded path to file-index.db
   - Status: ✅ CORRECT (file indexing check)

7. **CLAUDE_SESSION_STARTUP_PROTOCOL.sh**
   - Uses: NONE (infrastructure only)
   - Status: ✅ CORRECT

### Scripts with INCOMPLETE Coverage:

1. **complete-hashing-final.sh** - Line 11
   - Uses: `$QUANTUM_INDEX_DB` only
   - Should: Hash BOTH `quantum-index.db` AND `quantum-todo.db`
   - Impact: Active database may have unhashed records

---

## CORRECTIVE ACTIONS REQUIRED

### PHASE 1: Fix contractual-db-paths.sh (ROOT CAUSE)

**File**: `contractual-db-paths.sh`

**Current (INCORRECT)**:
```bash
# Line 20-22
# UPDATED 2025-12-07: quantum-index.db consolidated to .quantum-todo/ (active production DB)
export QUANTUM_INDEX_DB="${QUANTUM_TODO_DIR}/quantum-index.db"  # Changed from INDEX_DB_DIR
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db"    # Added for completeness
```

**Corrected**:
```bash
# Primary TODO tracking database (ACTIVE PRODUCTION)
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db"

# Legacy TODO/file index database (READ-ONLY ARCHIVE)
export QUANTUM_INDEX_DB="${QUANTUM_TODO_DIR}/quantum-index.db"

# IMPORTANT: Most scripts should use $QUANTUM_TODO_DB for TODO operations
# QUANTUM_INDEX_DB is for legacy/archive access only
```

**CRITICAL**: Add comment clarifying which variable is for active TODO tracking!

---

### PHASE 2: Fix Session Management Scripts (HIGH PRIORITY)

#### Fix 1: CLAUDE_SESSION_END_PROTOCOL.sh
**Line 343**: Change handoff.json reference
```bash
# BEFORE:
    "quantum_todo": "$QUANTUM_INDEX_DB",

# AFTER:
    "quantum_todo": "$QUANTUM_TODO_DB",
```

#### Fix 2: AUTO_SESSION_END_PROTOCOL.sh
**Line 59**: Change TODO export query
```bash
# BEFORE:
    sqlite3 "$QUANTUM_INDEX_DB" \

# AFTER:
    sqlite3 "$QUANTUM_TODO_DB" \
```

#### Fix 3: rollback-quantum-todo-changes.sh
**Line 35**: Change database integrity check
```bash
# BEFORE:
    if ! sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;" >/dev/null 2>&1; then

# AFTER:
    if ! sqlite3 "$QUANTUM_TODO_DB" "SELECT COUNT(*) FROM quantum_todos;" >/dev/null 2>&1; then
```

---

### PHASE 3: Enhance Hash Management (MEDIUM PRIORITY)

#### Fix 4: complete-hashing-final.sh
**Enhancement**: Hash BOTH databases
```bash
# Add after line 11:
MASTER_DB="$QUANTUM_INDEX_DB"
ACTIVE_DB="$QUANTUM_TODO_DB"

# Then hash both databases in sequence
echo "🔒 HASHING BOTH DATABASES FOR 100% COMPLIANCE"
hash_database "$MASTER_DB" "Legacy Database"
hash_database "$ACTIVE_DB" "Active Database"
```

---

### PHASE 4: Investigate Daemon Dependencies (MEDIUM PRIORITY)

#### Investigation 1: quantum-todo-autocapture-daemon-enhanced.sh
**Action**: Check which database `quantum-todo-system.sh` uses
```bash
# Read quantum-todo-system.sh to find database path
grep -n "QUANTUM.*DB\|\.db" quantum-todo-system.sh | head -20
```

**Expected**: Should use `$QUANTUM_TODO_DB` for active captures

---

## VERIFICATION CHECKLIST

After making corrections, verify:

- [ ] `contractual-db-paths.sh` has clear comments explaining each variable
- [ ] `CLAUDE_SESSION_END_PROTOCOL.sh` references `$QUANTUM_TODO_DB`
- [ ] `AUTO_SESSION_END_PROTOCOL.sh` exports from `$QUANTUM_TODO_DB`
- [ ] `rollback-quantum-todo-changes.sh` tests `$QUANTUM_TODO_DB`
- [ ] `complete-hashing-final.sh` hashes BOTH databases
- [ ] All session protocols point to active database (25,612 records)
- [ ] Session handoff files reference correct database
- [ ] Daemon autocapture writes to active database
- [ ] No scripts accidentally use legacy database for active operations

---

## TESTING PLAN

### Test 1: Session End Protocol
```bash
# Run session end and check which database is referenced
./CLAUDE_SESSION_END_PROTOCOL.sh
cat SESSION_HANDOFF_*.json | grep quantum_todo
# Should show: .quantum-todo/quantum-todo.db (NOT quantum-index.db)
```

### Test 2: Auto Session End
```bash
# Trigger auto-session-end and verify TODO export
./AUTO_SESSION_END_PROTOCOL.sh
cat .session-handoff/AUTO_SESSION_HANDOFF_*.json | grep todo_backup
# Verify backup file has 25,612 records (active), not 27,855 (legacy)
```

### Test 3: Database Counts
```bash
# Verify active database has current TODOs
sqlite3 .quantum-todo/quantum-todo.db "SELECT COUNT(*) FROM quantum_todos;"
# Should show: 25,612

# Verify legacy database has old TODOs  
sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;"
# Should show: 27,855
```

---

## COMPLETE SCRIPT INVENTORY

**Total Scripts Analyzed**: 13
- ❌ **INCORRECT** (3): CLAUDE_SESSION_END_PROTOCOL.sh, AUTO_SESSION_END_PROTOCOL.sh, rollback-quantum-todo-changes.sh
- ✅ **CORRECT** (8): CLAUDE_SESSION_PROTOCOL.sh, database-dependency-diagnostic.sh, unified-index-daemon.sh, terminal_footer_enhanced.sh, tmux-auto-manager.sh, .bashrc, CLAUDE_SESSION_STARTUP_PROTOCOL.sh, parallel-repair-engine.sh
- ⚠️ **INCOMPLETE** (1): complete-hashing-final.sh
- ⚠️ **NEEDS INVESTIGATION** (1): quantum-todo-autocapture-daemon-enhanced.sh

---

## CONCLUSION

**Root Cause**: Line 21 of `contractual-db-paths.sh` moved `quantum-index.db` to `.quantum-todo/` directory but kept the variable name `QUANTUM_INDEX_DB`, creating confusion about which database is "active".

**Impact**: 3 critical scripts (session protocols) now reference the WRONG database:
- Session end protocol exports legacy TODOs instead of current TODOs
- Auto-session-end backs up 27,855 old records instead of 25,612 current records
- Rollback script tests legacy database health instead of active database

**Fix Priority**:
1. **HIGH**: Fix session management scripts (immediate user impact)
2. **MEDIUM**: Fix hash management (data integrity)
3. **LOW**: Add comments to contractual-db-paths.sh (prevent future errors)

**Success Criteria**:
- All session protocols reference `quantum-todo.db` (25,612 active records)
- No scripts accidentally use `quantum-index.db` for TODO operations
- Clear documentation of which database is active vs archive

---

**Generated by**: Database Dependency Forensic Analysis
**Date**: 2025-12-07 06:00:00 PST
**Analysis Method**: Script content reading + schema analysis + record counting
**Files Analyzed**: 13 scripts + 2 databases + 1 configuration file + 1 .bashrc
**Databases**: quantum-index.db (129MB, 27,855 records), quantum-todo.db (22MB, 25,612 records)
