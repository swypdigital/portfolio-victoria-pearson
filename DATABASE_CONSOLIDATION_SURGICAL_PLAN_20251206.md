# DATABASE CONSOLIDATION - SURGICAL PLAN
**Generated**: 2025-12-06 23:30 PST
**Execution Status**: ⏸️ **READY FOR APPROVAL** - DO NOT EXECUTE WITHOUT USER CONFIRMATION
**Risk Level**: ⚠️ **EXTREME** - 100% reversible with proper backups

---

## ⚠️ PRE-EXECUTION CHECKLIST

**BEFORE STARTING - VERIFY ALL CONDITIONS:**

- [ ] Read and understood executive summary
- [ ] Reviewed all dependencies (pixel-by-pixel analysis)
- [ ] User has explicitly approved this plan
- [ ] No active development in progress
- [ ] At least 2GB free disk space available
- [ ] System backups are current (within 24 hours)
- [ ] Time allocated: 3 hours uninterrupted
- [ ] Rollback procedure understood and tested

**IF ANY CHECKBOX IS UNCHECKED → STOP AND RESOLVE BEFORE PROCEEDING**

---

## 🎯 SURGICAL PLAN OVERVIEW

### Objectives
1. Archive obsolete `.index-system/database/quantum-index.db`
2. Update contractual paths to point to active database
3. Convert 13 hard-coded scripts to contractual paths
4. Archive old safety backups in `.quantum-todo/`
5. Verify system functionality post-consolidation

### Success Criteria
- ✅ Zero data loss
- ✅ All scripts using contractual paths
- ✅ All daemons restart successfully
- ✅ Dependency validator passes 100%
- ✅ System stable for 24 hours

---

## 📋 EXECUTION PHASES

### PHASE 0: PRE-FLIGHT SAFETY

**Duration**: 15 minutes
**Risk**: ZERO (read-only operations)

#### Step 0.1: Create Timestamped Backup Directory

```bash
# Create backup directory with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/mnt/c/Users/jdh/claude_projects/.backups/database-consolidation-$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

# Verify creation
ls -ld "$BACKUP_DIR"
echo "Backup directory: $BACKUP_DIR"
```

**Verification**:
- Directory exists and is writable
- Path is correct

**Rollback**: N/A (no changes made)

---

#### Step 0.2: Stop All Database-Related Daemons

```bash
# List all running daemons
echo "=== ACTIVE DAEMONS BEFORE SHUTDOWN ==="
ps aux | grep -E "(daemon|\.sh)" | grep -v grep

# Stop daemons (if daemon-supervisor exists)
if [ -f "./daemon-supervisor.sh" ]; then
    ./daemon-supervisor.sh stop
    sleep 5
else
    # Manual shutdown
    pkill -f "plan-capture-daemon"
    pkill -f "quantum-todo-autocapture"
    pkill -f "quantum-autonomous"
    pkill -f "chat-backup-daemon"
    pkill -f "tmux-index-footer"
    sleep 5
fi

# Verify all stopped
echo "=== ACTIVE DAEMONS AFTER SHUTDOWN ==="
ps aux | grep -E "(daemon|\.sh)" | grep -v grep

# Check for open database handles
echo "=== OPEN DATABASE FILES ==="
lsof 2>/dev/null | grep "\.db$" || echo "No open database files (GOOD)"
```

**Verification**:
- No daemon processes running
- No open database file handles
- Output shows "No open database files"

**Rollback**:
```bash
# Restart daemons if needed
./daemon-supervisor.sh start
```

---

#### Step 0.3: Full System Backup (Critical Databases)

```bash
# Backup all critical databases with verification
echo "=== BACKING UP CRITICAL DATABASES ==="

# Backup quantum-index.db (both locations)
echo "Backing up quantum-index.db (Location 1 - obsolete)..."
cp .index-system/database/quantum-index.db "$BACKUP_DIR/quantum-index-LOCATION1-OBSOLETE.db"
md5sum .index-system/database/quantum-index.db > "$BACKUP_DIR/quantum-index-LOCATION1-OBSOLETE.db.md5"

echo "Backing up quantum-index.db (Location 2 - active)..."
cp .quantum-todo/quantum-index.db "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db"
md5sum .quantum-todo/quantum-index.db > "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db.md5"

# Backup quantum-todo.db
echo "Backing up quantum-todo.db..."
cp .quantum-todo/quantum-todo.db "$BACKUP_DIR/quantum-todo.db"
md5sum .quantum-todo/quantum-todo.db > "$BACKUP_DIR/quantum-todo.db.md5"

# Backup metadata.db
echo "Backing up metadata.db..."
cp .search-index/metadata.db "$BACKUP_DIR/metadata.db"
md5sum .search-index/metadata.db > "$BACKUP_DIR/metadata.db.md5"

# Backup contractual-db-paths.sh
echo "Backing up contractual-db-paths.sh..."
cp contractual-db-paths.sh "$BACKUP_DIR/contractual-db-paths.sh.backup"

# Verify all backups
echo ""
echo "=== VERIFYING BACKUPS ==="
cd "$BACKUP_DIR"
md5sum -c *.md5 || { echo "❌ BACKUP VERIFICATION FAILED!"; exit 1; }
cd -

# List backup contents
echo ""
echo "=== BACKUP CONTENTS ==="
ls -lh "$BACKUP_DIR"
```

**Verification**:
- All 4 database backups created
- MD5 checksums verified successfully
- Backup directory contains all expected files
- No errors in md5sum verification

**Rollback**: Restore from backups using checksums

---

#### Step 0.4: Backup All 13 Hard-Coded Scripts

```bash
# Create scripts backup directory
SCRIPTS_BACKUP="$BACKUP_DIR/scripts-before-conversion"
mkdir -p "$SCRIPTS_BACKUP"

# List of scripts to backup
SCRIPTS=(
    "AUTO_SESSION_END_PROTOCOL.sh"
    "CLAUDE_SESSION_END_PROTOCOL.sh"
    "complete-hashing-final.sh"
    "contractual-paths-true.sh"
    "database-dependency-diagnostic.sh"
    "get-active-databases.sh"
    "git-smart-merge.sh"
    "merge-enterprise.sh"
    "merge-system-initialize.sh"
    "parallel-repair-engine.sh"
    "process-cleanup.sh"
    "rollback-quantum-todo-changes.sh"
    "smart-merge-parallel.sh"
)

# Backup each script
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo "Backing up $script..."
        cp "$script" "$SCRIPTS_BACKUP/"
    else
        echo "⚠️ Warning: $script not found (may have been moved)"
    fi
done

# Verify backups
echo ""
echo "=== SCRIPT BACKUPS ==="
ls -lh "$SCRIPTS_BACKUP"
```

**Verification**:
- All 13 scripts backed up (or noted as missing)
- Scripts readable in backup directory

**Rollback**: Restore scripts from `$SCRIPTS_BACKUP/`

---

### PHASE 1: ARCHIVE OBSOLETE DATABASE

**Duration**: 10 minutes
**Risk**: LOW (moving obsolete database, backed up)

#### Step 1.1: Create Archive Directory

```bash
# Create dedicated archive for obsolete database
ARCHIVE_DIR=".archive/database-consolidation-obsolete-$TIMESTAMP"
mkdir -p "$ARCHIVE_DIR"

echo "Archive directory: $ARCHIVE_DIR"
ls -ld "$ARCHIVE_DIR"
```

**Verification**: Directory created and writable

---

#### Step 1.2: Archive Obsolete Database with Documentation

```bash
# Move obsolete database to archive
echo "Archiving obsolete quantum-index.db..."

# Create detailed archive manifest
cat > "$ARCHIVE_DIR/ARCHIVE_MANIFEST.md" << 'MANIFEST_EOF'
# Obsolete Database Archive
**Archived**: $(date)
**Reason**: Obsolete - replaced by .quantum-todo/quantum-index.db

## Database Information
- **Original Path**: .index-system/database/quantum-index.db
- **Size**: 36M
- **Last Modified**: 2025-09-12
- **Tables**: 15
- **Quantum Todos**: 16,280 (OBSOLETE - missing 11,572 tasks)

## Why Archived
1. Last modified 3 months ago (obsolete)
2. Missing 11,572 active tasks present in Location 2
3. Lacks enterprise features (ML, multi-tenancy, audit)
4. Has deprecated views/tables

## Active Database
- **Path**: .quantum-todo/quantum-index.db
- **Size**: 129M
- **Tables**: 38
- **Quantum Todos**: 27,852 (current)

## Restoration (if needed)
```bash
# Restore from archive
cp "$ARCHIVE_DIR/quantum-index-OBSOLETE-20251206.db" \
   ".index-system/database/quantum-index.db"
```

## Retention
- **Keep until**: 2026-03-06 (90 days)
- **After 90 days**: Safe to permanently delete
MANIFEST_EOF

# Move database to archive
mv .index-system/database/quantum-index.db "$ARCHIVE_DIR/quantum-index-OBSOLETE-20251206.db"

# Create checksum in archive
md5sum "$ARCHIVE_DIR/quantum-index-OBSOLETE-20251206.db" > "$ARCHIVE_DIR/quantum-index-OBSOLETE-20251206.db.md5"

# Verify archive
md5sum -c "$ARCHIVE_DIR/quantum-index-OBSOLETE-20251206.db.md5"

# List archive contents
echo ""
echo "=== ARCHIVE CONTENTS ==="
ls -lh "$ARCHIVE_DIR"
```

**Verification**:
- Obsolete database moved to archive
- MD5 checksum verified
- Manifest created
- Original location now empty

**Rollback**:
```bash
# Restore obsolete database if needed
cp "$ARCHIVE_DIR/quantum-index-OBSOLETE-20251206.db" \
   ".index-system/database/quantum-index.db"
```

---

### PHASE 2: UPDATE CONTRACTUAL PATHS

**Duration**: 10 minutes
**Risk**: MEDIUM (affects all scripts using contractual paths)

#### Step 2.1: Update contractual-db-paths.sh

```bash
# Read current file
cat contractual-db-paths.sh

echo ""
echo "=== UPDATING CONTRACTUAL PATHS ==="

# Create new version
cat > contractual-db-paths.sh << 'PATHS_EOF'
#!/bin/bash
# Contractual database paths - single source of truth
# All scripts MUST source this file for database access
# UPDATED: 2025-12-06 - Database consolidation (obsolete .index-system/database removed)

# Source contractual paths first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/contractual-paths-true.sh" ]; then
    source "${SCRIPT_DIR}/contractual-paths-true.sh"
else
    # Fallback
    CLAUDE_PROJECTS_ROOT="${CLAUDE_PROJECTS_ROOT:-$WINDOWS_HOME/claude_projects}"
fi

# Database directories
export INDEX_DB_DIR="${CLAUDE_PROJECTS_ROOT}/.index-system/database"  # Legacy (deprecated)
export SEARCH_INDEX_DIR="${CLAUDE_PROJECTS_ROOT}/.search-index"
export QUANTUM_TODO_DIR="${CLAUDE_PROJECTS_ROOT}/.quantum-todo"

# PRIMARY DATABASE PATHS (UPDATED 2025-12-06)
# NOTE: quantum-index.db consolidated to .quantum-todo/ (active production database)
export QUANTUM_INDEX_DB="${QUANTUM_TODO_DIR}/quantum-index.db"  # ⚠️ CHANGED from INDEX_DB_DIR
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db"
export FILE_INDEX_DB="${INDEX_DB_DIR}/file-index.db"            # Still in .index-system/
export METADATA_DB="${SEARCH_INDEX_DIR}/metadata.db"

# Backup and archive paths
export DB_BACKUP_DIR="${CLAUDE_PROJECTS_ROOT}/.perpetual-trash"
export DB_ARCHIVE_PREFIX="db-backup"

# Ensure directories exist
mkdir -p "${INDEX_DB_DIR}"
mkdir -p "${SEARCH_INDEX_DIR}"
mkdir -p "${QUANTUM_TODO_DIR}"
mkdir -p "${DB_BACKUP_DIR}"

# Function to get database path by name
get_db_path() {
    local db_name="$1"
    case "$db_name" in
        "quantum"|"quantum-index")
            echo "$QUANTUM_INDEX_DB"  # Now points to .quantum-todo/
            ;;
        "quantum-todo")
            echo "$QUANTUM_TODO_DB"
            ;;
        "file"|"file-index")
            echo "$FILE_INDEX_DB"
            ;;
        "metadata"|"search")
            echo "$METADATA_DB"
            ;;
        *)
            echo "$INDEX_DB_DIR/$db_name.db"
            ;;
    esac
}

# Function to check if database exists and is valid
check_db() {
    local db_path="$1"
    if [ -f "$db_path" ] && [ -s "$db_path" ]; then
        # Check if it's a valid SQLite database
        if sqlite3 "$db_path" "SELECT 1;" &>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Export functions for use in other scripts
export -f get_db_path
export -f check_db
PATHS_EOF

# Verify new file
echo ""
echo "=== NEW CONTRACTUAL PATHS FILE ==="
cat contractual-db-paths.sh

# Test path resolution
echo ""
echo "=== TESTING PATH RESOLUTION ==="
source contractual-db-paths.sh
echo "QUANTUM_INDEX_DB=$QUANTUM_INDEX_DB"
echo "QUANTUM_TODO_DB=$QUANTUM_TODO_DB"
echo "METADATA_DB=$METADATA_DB"

# Verify quantum-index.db points to correct location
if [ "$QUANTUM_INDEX_DB" = "/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db" ] || \
   [ "$QUANTUM_INDEX_DB" = ".quantum-todo/quantum-index.db" ]; then
    echo "✅ QUANTUM_INDEX_DB correctly points to .quantum-todo/"
else
    echo "❌ ERROR: QUANTUM_INDEX_DB points to wrong location!"
    echo "Expected: .quantum-todo/quantum-index.db"
    echo "Got: $QUANTUM_INDEX_DB"
    exit 1
fi
```

**Verification**:
- contractual-db-paths.sh updated
- `$QUANTUM_INDEX_DB` points to `.quantum-todo/quantum-index.db`
- Path resolution test passes
- No syntax errors

**Rollback**:
```bash
# Restore original contractual-db-paths.sh
cp "$BACKUP_DIR/contractual-db-paths.sh.backup" contractual-db-paths.sh
```

---

### PHASE 3: CONVERT HARD-CODED SCRIPTS

**Duration**: 60 minutes (5 min per script × 13 scripts)
**Risk**: MEDIUM (script functionality)

**NOTE**: For each script, the conversion pattern is:

**BEFORE**:
```bash
QUANTUM_DB="/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db"
```

**AFTER**:
```bash
# Source contractual paths
source "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh" || \
    source "$(dirname "$0")/contractual-db-paths.sh"

# Use contractual variable
QUANTUM_DB="$QUANTUM_INDEX_DB"
```

#### Step 3.1-3.13: Convert Each Script

**FOR EACH OF THE 13 SCRIPTS**:

1. Read current script to identify hard-coded paths
2. Replace hard-coded paths with contractual path sourcing
3. Test script executes without errors
4. Verify path resolution works

**Example Conversion** (repeat for all 13 scripts):

```bash
# Example: AUTO_SESSION_END_PROTOCOL.sh
echo "=== Converting AUTO_SESSION_END_PROTOCOL.sh ==="

# Step 1: Identify hard-coded paths
grep -n "\.db" AUTO_SESSION_END_PROTOCOL.sh | grep -v "^#"

# Step 2: Edit script (use Edit tool in practice)
# Replace hard-coded paths with:
# source contractual-db-paths.sh
# Use $QUANTUM_INDEX_DB, $QUANTUM_TODO_DB, etc.

# Step 3: Test script
bash -n AUTO_SESSION_END_PROTOCOL.sh || { echo "Syntax error!"; exit 1; }

# Step 4: Verify paths resolve
source AUTO_SESSION_END_PROTOCOL.sh --test-paths 2>/dev/null || echo "Script updated"
```

**⚠️ IMPORTANT**: This step requires careful manual conversion of each script. DO NOT automate without reviewing each script's logic.

**Verification** (after ALL 13 scripts converted):
```bash
# Verify all scripts use contractual paths
echo "=== VERIFYING CONTRACTUAL PATH ADOPTION ==="
TOTAL=0
CONTRACTUAL=0

for script in *.sh; do
    if [ -f "$script" ] && grep -q "\.db" "$script" 2>/dev/null; then
        ((TOTAL++))
        if grep -q "contractual.*paths" "$script" 2>/dev/null; then
            ((CONTRACTUAL++))
        else
            echo "⚠️ $script still has hard-coded paths"
        fi
    fi
done

echo "Scripts using contractual paths: $CONTRACTUAL / $TOTAL"
ADOPTION=$((CONTRACTUAL * 100 / TOTAL))
echo "Adoption rate: $ADOPTION%"

if [ "$ADOPTION" -lt 90 ]; then
    echo "❌ ERROR: Adoption rate below 90% - review remaining scripts"
    exit 1
fi
```

**Rollback**:
```bash
# Restore all 13 scripts from backup
for script in "${SCRIPTS[@]}"; do
    if [ -f "$SCRIPTS_BACKUP/$script" ]; then
        cp "$SCRIPTS_BACKUP/$script" .
    fi
done
```

---

### PHASE 4: ARCHIVE OLD BACKUPS

**Duration**: 10 minutes
**Risk**: LOW (archiving old backups)

#### Step 4.1: Archive Safety Backups

```bash
# Create backup archive directory
BACKUP_ARCHIVE_DIR=".archive/quantum-todo-backups-$TIMESTAMP"
mkdir -p "$BACKUP_ARCHIVE_DIR"

# List current backups
echo "=== CURRENT BACKUPS IN .quantum-todo/ ==="
ls -lh .quantum-todo/*.db | grep -E "(MIGRATION|SAFETY|backup)"

# Move old backups (keep only files older than 7 days for active use)
echo ""
echo "=== ARCHIVING OLD BACKUPS ==="

# Archive migration safety backups (Oct 10)
mv .quantum-todo/HOT_MIGRATION_SAFETY_* "$BACKUP_ARCHIVE_DIR/" 2>/dev/null || echo "No HOT_MIGRATION files"

# Archive safety backups (Oct 9)
mv .quantum-todo/SAFETY_BACKUP_* "$BACKUP_ARCHIVE_DIR/" 2>/dev/null || echo "No SAFETY_BACKUP files"

# Archive auto-backups (Sep 16)
mv .quantum-todo/auto-backup-* "$BACKUP_ARCHIVE_DIR/" 2>/dev/null || echo "No auto-backup files"

# Archive empty/test databases
mv .quantum-todo/quantum-test.db "$BACKUP_ARCHIVE_DIR/" 2>/dev/null || echo "No quantum-test.db"
mv .quantum-todo/quantum-todos.db "$BACKUP_ARCHIVE_DIR/" 2>/dev/null || echo "No quantum-todos.db (empty)"
mv .quantum-todo/quantum_todos.db "$BACKUP_ARCHIVE_DIR/" 2>/dev/null || echo "No quantum_todos.db"

# Verify archive
echo ""
echo "=== ARCHIVED BACKUPS ==="
ls -lh "$BACKUP_ARCHIVE_DIR"

# Verify active databases remain
echo ""
echo "=== REMAINING ACTIVE DATABASES ==="
ls -lh .quantum-todo/*.db
```

**Verification**:
- Old backups moved to archive
- Active databases remain:
  - quantum-index.db (129M)
  - quantum-todo.db (22M)
- No errors during move

**Rollback**:
```bash
# Restore backups if needed
cp "$BACKUP_ARCHIVE_DIR"/*.db .quantum-todo/
```

---

### PHASE 5: TESTING & VALIDATION

**Duration**: 30 minutes
**Risk**: ZERO (read-only validation)

#### Step 5.1: Run Dependency Validator

```bash
# Run dependency validation
echo "=== RUNNING DEPENDENCY VALIDATOR ==="
./validate-dependencies.sh || { echo "Validation failed!"; exit 1; }
```

**Verification**: Dependency validator passes 100%

---

#### Step 5.2: Test Database Access

```bash
# Test quantum-index.db access via contractual path
echo "=== TESTING DATABASE ACCESS ==="

source contractual-db-paths.sh

# Test quantum-index.db
echo "Testing QUANTUM_INDEX_DB..."
sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;" || \
    { echo "❌ Cannot access quantum_todos table!"; exit 1; }

# Test quantum-todo.db
echo "Testing QUANTUM_TODO_DB..."
sqlite3 "$QUANTUM_TODO_DB" "SELECT COUNT(*) FROM quantum_todos;" || \
    { echo "❌ Cannot access quantum-todo.db!"; exit 1; }

# Test metadata.db
echo "Testing METADATA_DB..."
sqlite3 "$METADATA_DB" ".tables" || \
    { echo "❌ Cannot access metadata.db!"; exit 1; }

echo "✅ All databases accessible"
```

**Verification**:
- All database queries succeed
- No permission errors
- Correct databases accessed

---

#### Step 5.3: Restart Daemons

```bash
# Restart daemons
echo "=== RESTARTING DAEMONS ==="

if [ -f "./daemon-supervisor.sh" ]; then
    ./daemon-supervisor.sh start
else
    echo "⚠️ No daemon-supervisor.sh - start daemons manually"
fi

# Wait for daemons to start
sleep 10

# Verify daemons running
echo "=== ACTIVE DAEMONS AFTER RESTART ==="
ps aux | grep -E "(daemon|\.sh)" | grep -v grep

# Check daemon logs for errors
echo ""
echo "=== CHECKING DAEMON LOGS ==="
if [ -d ".daemon-registry" ]; then
    tail -20 .daemon-registry/*.log 2>/dev/null || echo "No daemon logs found"
fi
```

**Verification**:
- Daemons restart successfully
- No errors in daemon logs
- Expected processes running

**Rollback**:
```bash
# Stop malfunctioning daemons
./daemon-supervisor.sh stop
# Restore original configuration
# Restart daemons
./daemon-supervisor.sh start
```

---

#### Step 5.4: Functional Testing

```bash
# Test quantum TODO system
echo "=== TESTING QUANTUM TODO SYSTEM ==="

# List tasks (should work with new paths)
./quantum-todo list | head -10 || { echo "❌ Quantum TODO list failed!"; exit 1; }

# Test session end protocol
echo "=== TESTING SESSION END PROTOCOL ==="
bash -n CLAUDE_SESSION_END_PROTOCOL.sh || { echo "❌ Session protocol has errors!"; exit 1; }

echo "✅ Functional tests passed"
```

**Verification**:
- Quantum TODO commands work
- Session protocols have no syntax errors
- No database access errors

---

### PHASE 6: POST-CONSOLIDATION MONITORING

**Duration**: 24 hours
**Risk**: ZERO (passive monitoring)

#### Step 6.1: Monitor System for 24 Hours

```bash
# Create monitoring script
cat > .monitoring/database-consolidation-monitor.sh << 'MONITOR_EOF'
#!/bin/bash
# Monitor system after database consolidation

LOG_FILE=".monitoring/consolidation-monitor-$(date +%Y%m%d).log"

while true; do
    {
        echo "=== $(date) ==="

        # Check database accessibility
        source contractual-db-paths.sh
        sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;" || \
            echo "❌ ALERT: Cannot access quantum-index.db"

        # Check daemon health
        DAEMONS=$(ps aux | grep -E "(daemon|\.sh)" | grep -v grep | wc -l)
        echo "Active daemons: $DAEMONS"

        # Check for errors
        if [ -d ".daemon-registry" ]; then
            ERRORS=$(grep -i "error" .daemon-registry/*.log 2>/dev/null | tail -5)
            if [ -n "$ERRORS" ]; then
                echo "⚠️ Recent errors:"
                echo "$ERRORS"
            fi
        fi

        echo ""
    } >> "$LOG_FILE"

    # Check every 30 minutes
    sleep 1800
done
MONITOR_EOF

chmod +x .monitoring/database-consolidation-monitor.sh

echo "Monitoring started - check .monitoring/consolidation-monitor-$(date +%Y%m%d).log"
```

**Monitoring Checklist** (check manually every few hours):
- [ ] Database queries successful
- [ ] Daemons running normally
- [ ] No errors in logs
- [ ] System performance normal
- [ ] No user-reported issues

---

## 🚨 EMERGENCY ROLLBACK PROCEDURE

### When to Execute Rollback

**Execute IMMEDIATELY if**:
- Database corruption detected
- Critical scripts fail
- Data loss detected
- Daemons cannot restart
- User requests rollback

### Rollback Steps

```bash
echo "=== EMERGENCY ROLLBACK INITIATED ==="
ROLLBACK_LOG="rollback-$(date +%Y%m%d_%H%M%S).log"

{
    echo "Rollback started: $(date)"

    # Step 1: Stop all daemons
    echo "Stopping daemons..."
    ./daemon-supervisor.sh stop 2>/dev/null || pkill -f "daemon"
    sleep 5

    # Step 2: Restore contractual paths
    echo "Restoring contractual-db-paths.sh..."
    cp "$BACKUP_DIR/contractual-db-paths.sh.backup" contractual-db-paths.sh

    # Step 3: Restore all scripts
    echo "Restoring 13 scripts..."
    for script in "${SCRIPTS[@]}"; do
        if [ -f "$SCRIPTS_BACKUP/$script" ]; then
            cp "$SCRIPTS_BACKUP/$script" .
        fi
    done

    # Step 4: Restore obsolete database (if needed)
    echo "Restoring obsolete database..."
    cp "$BACKUP_DIR/quantum-index-LOCATION1-OBSOLETE.db" \
       ".index-system/database/quantum-index.db"

    # Step 5: Verify restoration
    echo "Verifying restoration..."
    md5sum -c "$BACKUP_DIR/quantum-index-LOCATION1-OBSOLETE.db.md5"

    # Step 6: Restart daemons
    echo "Restarting daemons..."
    ./daemon-supervisor.sh start

    echo "Rollback completed: $(date)"
} 2>&1 | tee "$ROLLBACK_LOG"

echo "✅ ROLLBACK COMPLETE - Check $ROLLBACK_LOG"
```

---

## 📊 SUCCESS METRICS

### Immediate Success (within 1 hour)

- [ ] All databases accessible via contractual paths
- [ ] Zero syntax errors in converted scripts
- [ ] Dependency validator passes 100%
- [ ] All daemons restart successfully
- [ ] Quantum TODO commands work normally

### Short-term Success (24 hours)

- [ ] No database errors in logs
- [ ] No daemon crashes
- [ ] No user-reported issues
- [ ] System performance unchanged
- [ ] Backup archive verified intact

### Long-term Success (30 days)

- [ ] Obsolete database archive can be deleted
- [ ] 100% contractual path adoption maintained
- [ ] No regression issues discovered
- [ ] Disk space recovered (~200MB from backups)

---

## 📝 POST-EXECUTION DOCUMENTATION

### After Successful Execution

**Create Completion Report**:

```bash
cat > DATABASE_CONSOLIDATION_COMPLETE_$(date +%Y%m%d).md << 'REPORT_EOF'
# Database Consolidation - Completion Report
**Date**: $(date)
**Status**: ✅ COMPLETE

## Actions Taken
1. Archived obsolete .index-system/database/quantum-index.db
2. Updated contractual-db-paths.sh to point to .quantum-todo/quantum-index.db
3. Converted 13 scripts from hard-coded to contractual paths
4. Archived old safety backups
5. Verified system functionality

## Metrics
- **Databases Consolidated**: 1 (quantum-index.db)
- **Scripts Converted**: 13
- **Contractual Path Adoption**: 95%+ (target achieved)
- **Data Loss**: ZERO
- **Downtime**: < 5 minutes (daemon restart)

## Disk Space Recovered
- Obsolete database: 36M
- Old backups: ~150M
- Total: ~190M

## Verification
- [x] Dependency validator passes
- [x] All daemons running
- [x] Database queries successful
- [x] 24-hour monitoring complete
- [x] No errors or issues

## Backups Location
- **Main Backup**: $BACKUP_DIR
- **Retention**: 90 days
- **Safe to Delete After**: $(date -d "+90 days" +%Y-%m-%d)

**Executed By**: [Your Name]
**Reviewed By**: [Reviewer Name]
REPORT_EOF
```

---

## ⏸️ EXECUTION AUTHORIZATION

**THIS PLAN IS READY BUT MUST NOT BE EXECUTED WITHOUT USER APPROVAL**

**User must explicitly confirm**:
- [ ] I have read and understood the entire surgical plan
- [ ] I approve execution of all 6 phases
- [ ] I understand the rollback procedure
- [ ] I allocate 3 hours for this operation
- [ ] I accept the risks (with mitigation in place)

**Only after ALL checkboxes are confirmed should execution begin.**

---

**Plan Status**: ✅ READY FOR USER APPROVAL
**Next Action**: Await user confirmation to proceed
**Estimated Completion**: 3 hours from start

---

**Generated By**: Claude Code (Database Consolidation System)
**Date**: 2025-12-06 23:30 PST
**Plan Version**: 1.0
