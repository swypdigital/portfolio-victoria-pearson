# DATABASE SPLIT-BRAIN ANALYSIS & RESOLUTION PLAN
**Date**: 2025-12-07 06:45:00 PST
**Status**: CRITICAL - Split-brain database situation discovered
**Branch**: database-consolidation-20251207 (now on GitHub)

---

## EXECUTIVE SUMMARY

**CRITICAL FINDING**: Database consolidation created a split-brain situation where writes are diverging between two databases.

**Impact**:
- quantum-index.db: 27,855 tasks (129MB, last modified 4h ago)
- quantum-todo.db: 25,612 tasks (22MB, last modified 30 min ago, ACTIVELY WRITTEN)
- **Divergence**: 2,243 tasks difference and growing

**Root Cause**: Incomplete consolidation - updated 6 scripts to use quantum-index.db but CLAUDE_SESSION_PROTOCOL.sh still uses quantum-todo.db

**Safety Status**: ✅ Work backed up on GitHub, full local backups verified (207MB)

---

## DETAILED FINDINGS

### Database 1: quantum-index.db
**Location**: `/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db`
**Size**: 134,926,336 bytes (129MB)
**Last Modified**: 2025-12-07 02:40:56 (4 hours ago)
**Record Count**: 27,855 quantum_todos
**Status**: STALE - Not receiving new writes

**Scripts Using This Database** (After Consolidation):
1. CLAUDE_SESSION_END_PROTOCOL.sh (line 343)
2. AUTO_SESSION_END_PROTOCOL.sh (line 59)
3. complete-hashing-final.sh (line 11)
4. database-dependency-diagnostic.sh (lines 57-59)
5. rollback-quantum-todo-changes.sh (line 30)
6. parallel-repair-engine.sh (lines 38-42)

**Path Variable**: `$QUANTUM_INDEX_DB` (from contractual-db-paths.sh)

---

### Database 2: quantum-todo.db
**Location**: `/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-todo.db`
**Size**: 22,147,072 bytes (22MB)
**Last Modified**: 2025-12-07 06:11:29 (30 minutes ago)
**Record Count**: 25,612 quantum_todos
**Status**: ACTIVE - Receiving ongoing writes

**Scripts Using This Database**:
1. **CLAUDE_SESSION_PROTOCOL.sh** (15+ references, lines 25-314)
   - Session startup/end reporting
   - Task status tracking
   - ML prediction monitoring
   - Database integrity checks

**Path Variable**: `$QUANTUM_DIR/quantum-todo.db` (NOT using contractual paths!)

**Active Operations on quantum-todo.db**:
- Task creation/completion tracking
- ML model predictions
- NLP pattern analysis
- Database integrity monitoring
- Session state reporting

---

## SPLIT-BRAIN ANALYSIS

### How the Split Occurred

**Phase 4-5 of Consolidation** (2025-12-07 00:00-01:00):
1. Updated contractual-db-paths.sh to point QUANTUM_INDEX_DB to `.quantum-todo/quantum-index.db`
2. Updated 6 scripts to use `$QUANTUM_INDEX_DB` variable
3. **MISSED**: CLAUDE_SESSION_PROTOCOL.sh uses hardcoded `$QUANTUM_DIR/quantum-todo.db`
4. **RESULT**: Scripts now write to quantum-index.db, session protocol writes to quantum-todo.db

### Divergence Timeline

**Before Consolidation** (Pre Dec 7 00:00):
- quantum-index.db: Primary database (all writes)
- quantum-todo.db: Unknown status (needs investigation)

**After Consolidation** (Dec 7 00:00 - 02:40):
- quantum-index.db: Received writes from 6 converted scripts (grew to 27,855 tasks)
- quantum-todo.db: Continued receiving writes from CLAUDE_SESSION_PROTOCOL.sh

**Current State** (Dec 7 06:45):
- quantum-index.db: STALE (last write 4h ago, 27,855 tasks)
- quantum-todo.db: ACTIVE (last write 30min ago, 25,612 tasks)
- **Divergence**: 2,243 tasks

### Which Database is Correct?

**CRITICAL QUESTION**: Are these 2,243 extra tasks in quantum-index.db:
- **Option A**: NEWER tasks written by converted scripts after consolidation?
- **Option B**: OLDER tasks that quantum-todo.db doesn't have (consolidation pulled from stale DB)?

**Investigation Needed**: Compare task IDs and timestamps

---

## SAFETY STATUS

### GitHub Backup ✅
**Branch**: `database-consolidation-20251207`
**Remote**: https://github.com/swypdigital/linux-v-windows-merge/tree/database-consolidation-20251207
**Status**: Pushed successfully
**Commits**: 12 commits
**Can Rollback**: YES (instant via git reset)

### Local Backups ✅
**Location**: `.backups/database-consolidation-20251207_001440/`
**Size**: 207MB total
**Contents**:
1. quantum-index-LOCATION1-OBSOLETE.db (36M) + MD5 ✅
2. quantum-index-LOCATION2-ACTIVE.db (129M) + MD5 ✅
3. quantum-todo.db (22M) + MD5 ✅
4. metadata.db (21M) + MD5 ✅

**MD5 Verified**: All checksums valid
**Restoration**: Full restoration possible

### Archive Backup ✅
**Location**: `.archive/database-consolidation-obsolete-20251207_001600/`
**Contents**: quantum-index-OBSOLETE-20251207.db (36M)
**Status**: Archived safely

---

## RESOLUTION PLAN

### Phase 1: EMERGENCY BACKUP (BEFORE ANY CHANGES)
**Create new backup of CURRENT split-brain state**

```bash
# Timestamp for this specific backup
SPLIT_BRAIN_BACKUP=".backups/split-brain-before-fix-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SPLIT_BRAIN_BACKUP"

# Backup BOTH databases in current state
cp .quantum-todo/quantum-index.db "$SPLIT_BRAIN_BACKUP/quantum-index-STALE-27855.db"
cp .quantum-todo/quantum-todo.db "$SPLIT_BRAIN_BACKUP/quantum-todo-ACTIVE-25612.db"

# Calculate MD5s
md5sum "$SPLIT_BRAIN_BACKUP/quantum-index-STALE-27855.db" > "$SPLIT_BRAIN_BACKUP/quantum-index-STALE-27855.db.md5"
md5sum "$SPLIT_BRAIN_BACKUP/quantum-todo-ACTIVE-25612.db" > "$SPLIT_BRAIN_BACKUP/quantum-todo-ACTIVE-25612.db.md5"

# Save location
echo "$SPLIT_BRAIN_BACKUP" > .split-brain-backup-location.txt

# Verify backup
ls -lh "$SPLIT_BRAIN_BACKUP/"
md5sum -c "$SPLIT_BRAIN_BACKUP"/*.md5
```

**Result**: Can restore to EXACT split-brain state if merge goes wrong

---

### Phase 2: INVESTIGATE DIVERGENCE
**Determine which database has correct/newer data**

```bash
# Compare newest task IDs
echo "=== NEWEST TASK IN quantum-index.db ==="
sqlite3 .quantum-todo/quantum-index.db \
  "SELECT id, content, created_at FROM quantum_todos ORDER BY created_at DESC LIMIT 1;"

echo "=== NEWEST TASK IN quantum-todo.db ==="
sqlite3 .quantum-todo/quantum-todo.db \
  "SELECT id, content, created_at FROM quantum_todos ORDER BY created_at DESC LIMIT 1;"

# Find tasks in quantum-index.db NOT in quantum-todo.db
echo "=== TASKS IN INDEX BUT NOT TODO (sample) ==="
sqlite3 .quantum-todo/quantum-index.db \
  "SELECT id, content, created_at FROM quantum_todos
   WHERE id NOT IN (SELECT id FROM quantum_todos)
   LIMIT 10;"

# Count tasks by date
echo "=== TASKS CREATED TODAY IN INDEX ==="
sqlite3 .quantum-todo/quantum-index.db \
  "SELECT COUNT(*) FROM quantum_todos WHERE DATE(created_at) = DATE('now');"

echo "=== TASKS CREATED TODAY IN TODO ==="
sqlite3 .quantum-todo/quantum-todo.db \
  "SELECT COUNT(*) FROM quantum_todos WHERE DATE(created_at) = DATE('now');"
```

**Decision Point**: Based on investigation:
- **If quantum-index.db has newer data**: It's the source of truth
- **If quantum-todo.db has newer data**: It's the source of truth
- **If both have unique data**: Need to MERGE

---

### Phase 3: DETERMINE MERGE STRATEGY

**Strategy A: quantum-index.db is Source of Truth**
- Scenario: Index DB has the 2,243 newer tasks written after consolidation
- Action: Copy quantum-index.db over quantum-todo.db
- Risk: Lose any writes that went to quantum-todo.db since consolidation

**Strategy B: quantum-todo.db is Source of Truth**
- Scenario: TODO DB has been actively written, Index DB is stale
- Action: Copy quantum-todo.db over quantum-index.db
- Risk: Lose the 2,243 extra tasks in quantum-index.db

**Strategy C: MERGE Both Databases**
- Scenario: Both have unique data we need to preserve
- Action: Export all tasks from both, merge by ID, import to single DB
- Risk: Complex, potential for duplicate IDs or conflicts

**RECOMMENDED**: Strategy C (MERGE) - Safest, preserves all data

---

### Phase 4: MERGE DATABASES (Recommended Strategy)

```bash
# Export all tasks from both databases
sqlite3 .quantum-todo/quantum-index.db \
  "SELECT * FROM quantum_todos;" > /tmp/index-tasks.csv

sqlite3 .quantum-todo/quantum-todo.db \
  "SELECT * FROM quantum_todos;" > /tmp/todo-tasks.csv

# Analyze for duplicates and unique tasks
# Find tasks in INDEX not in TODO
comm -23 <(cut -d'|' -f1 /tmp/index-tasks.csv | sort) \
         <(cut -d'|' -f1 /tmp/todo-tasks.csv | sort) \
         > /tmp/unique-to-index.txt

# Find tasks in TODO not in INDEX
comm -13 <(cut -d'|' -f1 /tmp/index-tasks.csv | sort) \
         <(cut -d'|' -f1 /tmp/todo-tasks.csv | sort) \
         > /tmp/unique-to-todo.txt

# Count unique tasks in each
UNIQUE_INDEX=$(wc -l < /tmp/unique-to-index.txt)
UNIQUE_TODO=$(wc -l < /tmp/unique-to-todo.txt)

echo "Unique to quantum-index.db: $UNIQUE_INDEX tasks"
echo "Unique to quantum-todo.db: $UNIQUE_TODO tasks"

# Create merged database
cp .quantum-todo/quantum-todo.db /tmp/quantum-merged.db

# Import unique tasks from quantum-index.db
sqlite3 /tmp/quantum-merged.db <<EOF
ATTACH '.quantum-todo/quantum-index.db' AS source;
INSERT OR IGNORE INTO quantum_todos
  SELECT * FROM source.quantum_todos;
DETACH source;
EOF

# Verify merged count
MERGED_COUNT=$(sqlite3 /tmp/quantum-merged.db "SELECT COUNT(*) FROM quantum_todos;")
echo "Merged database contains: $MERGED_COUNT tasks"
echo "Expected: ~$((27855 + UNIQUE_TODO)) tasks"
```

---

### Phase 5: STOP DAEMONS (Before Database Swap)

```bash
# Stop all daemons to prevent writes during merge
echo "Stopping all daemons..."
pkill -f "quantum-todo-autocapture-daemon"
pkill -f "chat-backup-daemon"
pkill -f "plan-capture-daemon"
pkill -f "unified-index-daemon"
pkill -f "quantum-autonomous-daemon"
pkill -f "persistent-capture-daemon"

# Wait for graceful shutdown
sleep 10

# Verify all stopped
if pgrep -f "daemon" > /dev/null; then
    echo "WARNING: Some daemons still running"
    ps aux | grep daemon | grep -v grep
else
    echo "✅ All daemons stopped"
fi
```

---

### Phase 6: DEPLOY MERGED DATABASE

```bash
# CRITICAL: Create final safety backup before swap
FINAL_BACKUP=".backups/pre-merge-swap-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$FINAL_BACKUP"
cp .quantum-todo/quantum-index.db "$FINAL_BACKUP/"
cp .quantum-todo/quantum-todo.db "$FINAL_BACKUP/"
md5sum "$FINAL_BACKUP"/* > "$FINAL_BACKUP/checksums.md5"

# Deploy merged database to BOTH locations
cp /tmp/quantum-merged.db .quantum-todo/quantum-index.db
cp /tmp/quantum-merged.db .quantum-todo/quantum-todo.db

# Verify deployment
INDEX_COUNT=$(sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;")
TODO_COUNT=$(sqlite3 .quantum-todo/quantum-todo.db "SELECT COUNT(*) FROM quantum_todos;")

echo "quantum-index.db: $INDEX_COUNT tasks"
echo "quantum-todo.db: $TODO_COUNT tasks"

if [ "$INDEX_COUNT" = "$TODO_COUNT" ]; then
    echo "✅ Databases synchronized: $INDEX_COUNT tasks in each"
else
    echo "❌ SYNC FAILED: Counts don't match!"
    exit 1
fi
```

---

### Phase 7: UPDATE CLAUDE_SESSION_PROTOCOL.sh

**Change from hardcoded path to contractual path**

```bash
# Before (15+ occurrences):
$QUANTUM_DIR/quantum-todo.db

# After:
source contractual-db-paths.sh
$QUANTUM_TODO_DB
```

**Script Updates**:
1. Add contractual-db-paths.sh sourcing at top
2. Replace all `$QUANTUM_DIR/quantum-todo.db` with `$QUANTUM_TODO_DB`
3. Verify syntax: `bash -n CLAUDE_SESSION_PROTOCOL.sh`

---

### Phase 8: RESTART DAEMONS & MONITOR

```bash
# Restart daemons one by one
./quantum-todo-autocapture-daemon-enhanced.sh start &
sleep 2
./chat-backup-daemon-enhanced-v2.sh start &
sleep 2
./plan-capture-daemon.sh &
sleep 2
./unified-index-daemon.sh start &
sleep 2

# Verify all started
ps aux | grep -E "(daemon|capture)" | grep -v grep

# Monitor database writes for 5 minutes
watch -n 10 'stat -c "%y %s" .quantum-todo/quantum-index.db .quantum-todo/quantum-todo.db'

# Verify both databases stay synchronized
watch -n 30 'echo "INDEX:" && sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;" && echo "TODO:" && sqlite3 .quantum-todo/quantum-todo.db "SELECT COUNT(*) FROM quantum_todos;"'
```

---

### Phase 9: COMMIT & PUSH FIX

```bash
# Stage all changes
git add -A

# Commit with detailed message
git commit -m "fix(db): Resolve split-brain - merge databases and update session protocol

PROBLEM:
- quantum-index.db and quantum-todo.db diverged (2,243 task difference)
- Consolidation updated 6 scripts to use quantum-index.db
- CLAUDE_SESSION_PROTOCOL.sh still used quantum-todo.db (hardcoded path)
- Result: Split-brain writes to different databases

SOLUTION:
- Merged both databases preserving all unique tasks
- Updated CLAUDE_SESSION_PROTOCOL.sh to use contractual paths
- Deployed merged database to both locations
- Verified synchronization

SAFETY:
- Full backup before merge: $SPLIT_BRAIN_BACKUP
- Can rollback via Git: git reset --hard HEAD~1
- Database backups verified with MD5

RESULT:
- Both databases now contain same data (synchronized)
- All scripts use contractual paths
- No more split-brain writes
- $(sqlite3 .quantum-todo/quantum-index.db 'SELECT COUNT(*) FROM quantum_todos;') tasks in unified database"

# Push to GitHub
git push origin database-consolidation-20251207
```

---

### Phase 10: 24-HOUR MONITORING

**Monitor for database synchronization**:
```bash
# Every hour, verify counts match
*/60 * * * * cd /mnt/c/Users/jdh/claude_projects && \
  INDEX=$(sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;") && \
  TODO=$(sqlite3 .quantum-todo/quantum-todo.db "SELECT COUNT(*) FROM quantum_todos;") && \
  if [ "$INDEX" != "$TODO" ]; then \
    echo "ALERT: Database divergence detected! INDEX=$INDEX TODO=$TODO" >> .database-sync-alerts.log; \
  fi
```

**Success Criteria for Merge to Main**:
- ✅ Both databases maintain identical counts for 24 hours
- ✅ All daemons running normally
- ✅ No database errors in logs
- ✅ Task creation/completion works correctly
- ✅ No user-reported issues

---

## ROLLBACK PROCEDURES

### Rollback 1: Undo Merged Database (if merge fails)
```bash
# Restore from pre-merge backup
FINAL_BACKUP=$(cat .split-brain-backup-location.txt)
cp "$FINAL_BACKUP/quantum-index-STALE-27855.db" .quantum-todo/quantum-index.db
cp "$FINAL_BACKUP/quantum-todo-ACTIVE-25612.db" .quantum-todo/quantum-todo.db

# Verify restoration
md5sum -c "$FINAL_BACKUP"/*.md5

# Restart daemons
./daemon-supervisor.sh start
```

### Rollback 2: Undo All Consolidation (if fundamentally broken)
```bash
# 1. Stop daemons
pkill -f "daemon" && sleep 5

# 2. Reset Git branch
git reset --hard a2a40ff  # Before consolidation started

# 3. Restore original databases
BACKUP_DIR=".backups/database-consolidation-20251207_001440"
cp "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db" .quantum-todo/quantum-index.db
cp "$BACKUP_DIR/quantum-todo.db" .quantum-todo/quantum-todo.db

# 4. Verify checksums
md5sum -c "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db.md5"
md5sum -c "$BACKUP_DIR/quantum-todo.db.md5"

# 5. Restart daemons
./daemon-supervisor.sh start
```

### Rollback 3: From GitHub (if local corrupted)
```bash
# Fresh clone from GitHub
cd /tmp
git clone https://github.com/swypdigital/linux-v-windows-merge.git
cd linux-v-windows-merge
git checkout database-consolidation-20251207

# Review state before consolidation
git log --oneline
```

---

## DAEMON SUPERVISOR FIX (Separate Task)

**Issue**: daemon-supervisor.sh reports "not running" when daemons exist

**Investigation Needed**:
1. Check PID file locations
2. Verify PID tracking logic
3. Test daemon start/stop/status commands
4. Fix process detection

**Timeline**: Address AFTER database merge is stable

---

## SUCCESS METRICS

### Immediate (Phase 1-6):
- [x] GitHub backup created
- [x] Split-brain documented
- [ ] Emergency backup of current state
- [ ] Databases merged successfully
- [ ] Both DBs contain same count
- [ ] No data loss

### Short-term (Phase 7-9):
- [ ] CLAUDE_SESSION_PROTOCOL.sh updated
- [ ] All daemons restarted
- [ ] Monitoring shows synchronization
- [ ] Fix committed and pushed

### Long-term (Phase 10):
- [ ] 24 hours of stable synchronization
- [ ] No divergence detected
- [ ] Merge to windows-main approved
- [ ] Daemon supervisor fixed

---

**Analysis Complete**: 2025-12-07 06:45:00 PST
**Next Action**: Execute Phase 1 (Emergency Backup)
**Confidence**: HIGH (comprehensive safety measures in place)
**Risk**: LOW (multiple rollback points available)
