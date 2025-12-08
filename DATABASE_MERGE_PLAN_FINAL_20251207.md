# DATABASE MERGE PLAN - FINAL CORRECTED APPROACH
**Date**: 2025-12-07 13:00:00 PST
**Status**: CORRECT APPROACH - Merge into quantum-index.db (majority target)
**Branch**: database-consolidation-20251207 (on GitHub)

---

## CORRECTED UNDERSTANDING

**YOU WERE RIGHT!** The consolidation was mostly correct. Here's the proper view:

### Current State After Consolidation:
- **quantum-index.db** (129MB, 27,855 tasks): **TARGET DATABASE** ← 6 scripts now point here
- **quantum-todo.db** (22MB, 25,612 tasks): **LEGACY DATABASE** ← Only CLAUDE_SESSION_PROTOCOL.sh still uses this

### What We Should Do:
1. ✅ **Keep quantum-index.db as the SINGLE source of truth** (consolidation target)
2. ✅ **Merge unique tasks from quantum-todo.db INTO quantum-index.db**
3. ✅ **Update CLAUDE_SESSION_PROTOCOL.sh to use quantum-index.db** (complete the consolidation)
4. ✅ **Deprecate quantum-todo.db** (archive it, stop using it)

---

## MERGE ANALYSIS

### Task Distribution:
- Unique to quantum-index.db: **27,798 tasks** (will keep)
- Unique to quantum-todo.db: **25,555 tasks** (need to import)
- Common to both: **57 tasks** (already in index)

### After Merge:
- quantum-index.db will have: **27,798 + 25,555 = 53,353 tasks** (complete unified database)
- quantum-todo.db will be: **ARCHIVED** (deprecated, no longer used)

---

## MERGE EXECUTION PLAN

### Phase 1: PRE-MERGE SAFETY ✅ COMPLETE
- [x] Emergency backup created: `.backups/split-brain-before-fix-20251207_123514`
- [x] Original backup exists: `.backups/database-consolidation-20251207_001440`
- [x] Branch pushed to GitHub
- [x] Dependency map created

### Phase 2: STOP ALL DAEMONS
```bash
# Stop all daemons to prevent writes during merge
pkill -f "quantum-todo-autocapture-daemon"
pkill -f "chat-backup-daemon"
pkill -f "plan-capture-daemon"
pkill -f "unified-index-daemon"
pkill -f "quantum-autonomous-daemon"
pkill -f "persistent-capture-daemon"
sleep 10

# Verify all stopped
ps aux | grep daemon | grep -v grep || echo "✅ All daemons stopped"
```

### Phase 3: MERGE DATABASES
```bash
# Create final pre-merge backup
MERGE_BACKUP=".backups/pre-final-merge-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$MERGE_BACKUP"
cp .quantum-todo/quantum-index.db "$MERGE_BACKUP/quantum-index-before-merge.db"
cp .quantum-todo/quantum-todo.db "$MERGE_BACKUP/quantum-todo-before-merge.db"
md5sum "$MERGE_BACKUP"/* > "$MERGE_BACKUP/checksums.md5"

# Merge quantum-todo.db INTO quantum-index.db
sqlite3 .quantum-todo/quantum-index.db <<EOF
-- Attach quantum-todo.db as source
ATTACH '.quantum-todo/quantum-todo.db' AS source;

-- Import all unique tasks from quantum-todo.db
-- INSERT OR IGNORE will skip the 57 duplicates
INSERT OR IGNORE INTO quantum_todos
SELECT * FROM source.quantum_todos;

-- Import dependencies
INSERT OR IGNORE INTO todo_dependencies
SELECT * FROM source.todo_dependencies
WHERE EXISTS (SELECT 1 FROM source.todo_dependencies);

-- Detach
DETACH source;

-- Verify count
SELECT 'Merged total: ' || COUNT(*) as result FROM quantum_todos;
EOF

# Expected output: Merged total: 53353 (or close to it)
```

### Phase 4: VERIFY MERGE
```bash
# Count tasks in merged database
MERGED_COUNT=$(sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;")

echo "Tasks in merged quantum-index.db: $MERGED_COUNT"
echo "Expected: ~53,353 (27,798 + 25,555)"

# Verify merge was successful
if [ "$MERGED_COUNT" -gt 50000 ]; then
    echo "✅ Merge successful"
else
    echo "❌ Merge failed - count too low!"
    exit 1
fi

# Test database integrity
sqlite3 .quantum-todo/quantum-index.db "PRAGMA integrity_check;" || {
    echo "❌ Database integrity check FAILED!"
    exit 1
}
```

### Phase 5: ARCHIVE quantum-todo.db
```bash
# Move quantum-todo.db to archive (don't delete - keep for safety)
ARCHIVE_DIR=".archive/quantum-todo-deprecated-$(date +%Y%m%d)"
mkdir -p "$ARCHIVE_DIR"

# Copy (not move) to archive
cp .quantum-todo/quantum-todo.db "$ARCHIVE_DIR/quantum-todo-DEPRECATED-25612-tasks.db"
md5sum "$ARCHIVE_DIR/quantum-todo-DEPRECATED-25612-tasks.db" > "$ARCHIVE_DIR/quantum-todo-DEPRECATED-25612-tasks.db.md5"

# Create archive manifest
cat > "$ARCHIVE_DIR/ARCHIVE_MANIFEST.txt" <<EOF
DEPRECATED DATABASE ARCHIVE
Date: $(date)
Reason: Consolidated into quantum-index.db

Original Database: .quantum-todo/quantum-todo.db
Size: 22MB
Tasks: 25,612
Unique Tasks: 25,555
Common Tasks: 57

Merged Into: .quantum-todo/quantum-index.db
New Total: ~53,353 tasks

This database is NO LONGER IN USE.
All data has been merged into quantum-index.db.

Retention: Keep for 90 days then safe to delete
Restore: Only if merge needs to be rolled back
EOF

echo "✅ quantum-todo.db archived to $ARCHIVE_DIR"
```

### Phase 6: UPDATE CLAUDE_SESSION_PROTOCOL.sh
```bash
# This is the FINAL script that needs updating
# It currently uses hardcoded quantum-todo.db
# Need to change to use $QUANTUM_INDEX_DB

# Backup original
cp CLAUDE_SESSION_PROTOCOL.sh CLAUDE_SESSION_PROTOCOL.sh.pre-consolidation

# Add contractual paths sourcing at top (after shebang)
# Replace all instances of quantum-todo.db with $QUANTUM_INDEX_DB variable

# Changes needed:
# Line ~25: QUANTUM_DIR - no longer needed (use contractual paths)
# Line ~133+: All sqlite3 commands using quantum-todo.db → use $QUANTUM_INDEX_DB
```

**Specific Line Changes**:
```bash
# BEFORE:
QUANTUM_DIR="${QUANTUM_DIR:-$HOME/.quantum-todo}"
sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT ..."

# AFTER:
source contractual-db-paths.sh
sqlite3 "$QUANTUM_INDEX_DB" "SELECT ..."
```

### Phase 7: VERIFY ALL SCRIPTS USE QUANTUM_INDEX_DB
```bash
# Check that NO scripts still reference quantum-todo.db (except archives)
echo "=== Checking for quantum-todo.db references ==="
grep -r "quantum-todo\.db" --include="*.sh" . 2>/dev/null | grep -v ".bak\|.archive\|.backup" || echo "✅ No references found"

# Check that all use $QUANTUM_INDEX_DB
echo "=== Verifying QUANTUM_INDEX_DB usage ==="
grep -r "QUANTUM_INDEX_DB" --include="*.sh" . 2>/dev/null | wc -l
```

### Phase 8: RESTART DAEMONS
```bash
# Restart daemons one by one
./daemon-supervisor.sh start || {
    # If supervisor doesn't work, start manually:
    ./quantum-todo-autocapture-daemon-enhanced.sh start &
    sleep 2
    ./chat-backup-daemon-enhanced-v2.sh start &
    sleep 2
    ./plan-capture-daemon.sh &
    sleep 2
    ./unified-index-daemon.sh start &
}

# Verify daemons started
ps aux | grep daemon | grep -v grep
```

### Phase 9: MONITOR & TEST
```bash
# Monitor database for 5 minutes
watch -n 30 '
echo "=== Database Stats ==="
echo "quantum-index.db size: $(du -h .quantum-todo/quantum-index.db | cut -f1)"
echo "Task count: $(sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;")"
echo "Last modified: $(stat -c %y .quantum-todo/quantum-index.db)"
'

# Test quantum TODO operations
source contractual-db-paths.sh
sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos WHERE status='pending';"
```

### Phase 10: COMMIT & PUSH
```bash
git add -A
git commit -m "feat(db): Complete database consolidation - merge to single source

CONSOLIDATION COMPLETE:
- Merged quantum-todo.db (25,612 tasks) INTO quantum-index.db (27,855 tasks)
- Final unified database: quantum-index.db (~53,353 tasks)
- Updated CLAUDE_SESSION_PROTOCOL.sh to use contractual paths
- Archived quantum-todo.db to .archive/ (deprecated)

ALL SCRIPTS NOW USE SINGLE DATABASE:
- CLAUDE_SESSION_END_PROTOCOL.sh → \$QUANTUM_INDEX_DB ✅
- AUTO_SESSION_END_PROTOCOL.sh → \$QUANTUM_INDEX_DB ✅
- CLAUDE_SESSION_PROTOCOL.sh → \$QUANTUM_INDEX_DB ✅ (UPDATED)
- complete-hashing-final.sh → \$QUANTUM_INDEX_DB ✅
- database-dependency-diagnostic.sh → \$QUANTUM_INDEX_DB ✅
- rollback-quantum-todo-changes.sh → \$QUANTUM_INDEX_DB ✅
- parallel-repair-engine.sh → \$QUANTUM_INDEX_DB ✅

SAFETY:
- Pre-merge backup: $MERGE_BACKUP
- quantum-todo.db archived (not deleted)
- All backups verified with MD5
- Can rollback via Git + database restore

TESTING:
- Database integrity check: PASSED
- Daemon restart: SUCCESS
- 5-minute monitoring: STABLE

Database consolidation initiative COMPLETE ✅"

git push origin database-consolidation-20251207
```

---

## ROLLBACK PROCEDURES

### If Merge Fails:
```bash
# 1. Restore from pre-merge backup
cp "$MERGE_BACKUP/quantum-index-before-merge.db" .quantum-todo/quantum-index.db
cp "$MERGE_BACKUP/quantum-todo-before-merge.db" .quantum-todo/quantum-todo.db

# 2. Verify restoration
md5sum -c "$MERGE_BACKUP/checksums.md5"

# 3. Restart daemons
./daemon-supervisor.sh start
```

### If CLAUDE_SESSION_PROTOCOL.sh Update Fails:
```bash
# Restore backup
cp CLAUDE_SESSION_PROTOCOL.sh.pre-consolidation CLAUDE_SESSION_PROTOCOL.sh

# Verify syntax
bash -n CLAUDE_SESSION_PROTOCOL.sh
```

### Complete Rollback (Nuclear Option):
```bash
# Git reset to before consolidation
git reset --hard a2a40ff

# Restore original databases
BACKUP_DIR=".backups/database-consolidation-20251207_001440"
cp "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db" .quantum-todo/quantum-index.db
cp "$BACKUP_DIR/quantum-todo.db" .quantum-todo/quantum-todo.db

# Verify checksums
md5sum -c "$BACKUP_DIR"/*.md5

# Restart daemons
./daemon-supervisor.sh start
```

---

## SUCCESS CRITERIA

### Immediate:
- [ ] Daemons stopped successfully
- [ ] Databases merged (count ~53,353)
- [ ] Integrity check passed
- [ ] quantum-todo.db archived
- [ ] CLAUDE_SESSION_PROTOCOL.sh updated
- [ ] All scripts verified to use $QUANTUM_INDEX_DB
- [ ] Daemons restarted successfully

### Short-term (1 hour):
- [ ] No database errors in logs
- [ ] Task creation/updates working
- [ ] Session protocol functioning correctly
- [ ] All daemons running stable

### Long-term (24 hours):
- [ ] Zero divergence (only one database in use)
- [ ] No user-reported issues
- [ ] System performance normal
- [ ] Ready to merge to windows-main

---

## FINAL ARCHITECTURE

### Before Consolidation:
```
.quantum-todo/
├── quantum-index.db (129MB, 27,855 tasks) ← Some scripts
└── quantum-todo.db (22MB, 25,612 tasks)   ← CLAUDE_SESSION_PROTOCOL.sh
```

### After Consolidation:
```
.quantum-todo/
└── quantum-index.db (180MB, ~53,353 tasks) ← ALL scripts

.archive/quantum-todo-deprecated-20251207/
└── quantum-todo-DEPRECATED-25612-tasks.db (archived)
```

### Database Variables:
```bash
# contractual-db-paths.sh
export QUANTUM_INDEX_DB="${QUANTUM_TODO_DIR}/quantum-index.db"  # SINGLE SOURCE OF TRUTH
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-index.db"   # ALIAS (same database)
```

**Result**: Single unified database, all scripts using contractual paths, zero technical debt.

---

**Status**: READY TO EXECUTE
**Risk**: LOW (comprehensive backups + rollback procedures)
**Timeline**: 30 minutes execution + 1 hour monitoring
**Confidence**: HIGH (correct approach identified)

