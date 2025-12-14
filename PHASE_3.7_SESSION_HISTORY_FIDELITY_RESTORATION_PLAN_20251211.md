# PHASE 3.7: SESSION HISTORY FIDELITY RESTORATION PLAN
**Date**: 2025-12-11 10:15:00 PST
**Priority**: CRITICAL - Added to current plan (NOT branched)
**Status**: IN PROGRESS - Discovery phase

---

## EXECUTIVE SUMMARY

**Problem**: Manual session captures contain full fidelity history, but Claude ecosystem session files are incomplete/truncated
**Impact**: Loss of session context, inability to resume work accurately
**Solution**: Match manual captures to incomplete session files and restore full fidelity with ALL dependent file updates

**Critical Complexity**:
- Manual captures may contain MULTIPLE sessions (due to compaction/continuance)
- Session files scattered across Claude ecosystem (not well organized)
- Must update ALL dependent files (session end reports, handoffs, TODOs, etc.)
- Requires 10-phase enterprise testing + safety/rollback protocols

---

## SCOPE & SCALE

### Source: Manual Captures
**Location**: `C:\~ALL FILES\~ BIZ PROJECTS CURRENT\!     AI PROJECTS MSC\ELEARNING\-   GROKLY.ME\-        GROKLY  GROUP\-         MAVERICK STACK\CHAT BACKUPS FULL SCREEN CAPTURES`
**Total Files**: [DISCOVERY IN PROGRESS]
**Characteristics**:
- May contain multiple sessions per file
- Full fidelity captures (complete terminal scrollback)
- Include session date/time, project names
- Source of truth for session history

### Target: Claude Ecosystem Session Files
**Locations** (scattered):
- /mnt/c/Users/jdh/claude_projects/CHAT_SESSION_SCROLLBACK_*.txt
- /mnt/c/Users/jdh/claude_projects/.universal-history/sessions/YYYY-MM-DD/session_*.md
- /mnt/c/Users/jdh/claude_projects/.session-management/
- /mnt/c/Users/jdh/claude_projects/.completed-sessions/
- /mnt/c/Users/jdh/claude_projects/[project-specific-dirs]/
- Any other locations with session captures

**Dependent Files to Update**:
1. Session history file (primary target)
2. END_SESSION_REPORT_*.md (line count, size, method)
3. TODO_NEXT_SESSION_*.md (references)
4. NEXT_SESSION_INSTRUCTIONS_*.md (references)
5. SESSION_DEPENDENCIES_*.md (references)
6. SESSION_HANDOFF_*.json (line_count, history_file)
7. SESSION_HANDOFF_*.md (references)
8. Session start files (if they reference history)
9. Any other discovered dependencies

---

## CRITICAL CHALLENGES

### Challenge 1: Multi-Session Manual Captures
**Problem**: Single manual file may contain 2-10 sessions due to terminal continuance
**Example**: `CHAT_BACKUP-CLAUDE_CODE_2025_12_11_ DATABASE MERGE AND START AND END SESSION SCRIPTS.txt` contains:
- Session 1: Database consolidation
- Session 2: Testing session
- Session 3: Bug fixes

**Solution**:
- Parse manual files for session boundaries (look for session start markers)
- Extract each session separately
- Match each extracted session to its corresponding incomplete file

### Challenge 2: Scattered Session Files
**Problem**: Session files not centralized, spread across many directories
**Solution**: Universal workforce comprehensive search across ALL potential locations

### Challenge 3: Dependent File Updates
**Problem**: Each session has 5-10 dependent files that reference line counts
**Solution**: For each restored session, identify and update ALL dependent files

### Challenge 4: Data Loss Prevention
**Problem**: Errors during restoration could corrupt existing data
**Solution**: 10-phase enterprise testing + 4-level rollback system

---

## PHASE 3.7 EXECUTION PLAN

### Phase 3.7.1: Discovery & Inventory (10 min) - IN PROGRESS
**Objective**: Create complete inventory of manual captures and session files

**Tasks**:
1. ✅ Scan manual capture directory
2. ⏳ Create inventory with metadata (filename, line count, size, date)
3. ⏳ Parse manual files for session boundaries
4. ⏳ Extract session date/time/project from each
5. ⏳ Search Claude ecosystem for ALL session files
6. ⏳ Create ecosystem inventory (all session-related files)

**Workers**: 20 parallel scanners
**Output**:
- manual_captures_inventory.json
- claude_ecosystem_session_files.json

### Phase 3.7.2: Session Boundary Detection (15 min)
**Objective**: Parse multi-session manual captures into individual sessions

**Process**:
```bash
# Session boundary markers to detect:
- "Claude Code v" (version header)
- "Starting new session"
- Timestamp discontinuities (>1 hour gap)
- Project name changes
- Session ID changes
```

**Workers**: 30 parallel parsers (1 worker per manual capture file if <30 files)
**Output**:
- Extracted individual sessions from multi-session files
- Session metadata (start time, end time, project, line count)

### Phase 3.7.3: Matching Algorithm (20 min)
**Objective**: Match extracted sessions to incomplete Claude ecosystem files

**Matching Criteria**:
1. **Primary**: Session date/time match (within 5 minutes)
2. **Secondary**: Project name match
3. **Tertiary**: Session ID match (if present)
4. **Quaternary**: Content similarity (first 100 lines hash comparison)
5. **Quintary**: Line count ratio (manual should be >2x incomplete)

**Workers**: 40 parallel matchers
**Output**: matching_pairs.json
```json
{
  "matches": [
    {
      "manual_file": "CHAT_BACKUP-2025_12_11_SESSION1.txt",
      "manual_lines": 1342,
      "incomplete_file": "CHAT_SESSION_SCROLLBACK_20251211_093839_24_LINES.txt",
      "incomplete_lines": 24,
      "confidence": 0.98,
      "match_method": "datetime+project+sessionid",
      "dependent_files": [
        "END_SESSION_REPORT_claude_projects_2025-12-11_09-38-39.md",
        "TODO_NEXT_SESSION_claude_projects_2025-12-11_09-38-39.md",
        ".session-management/SESSION_HANDOFF_20251211_093839.json"
      ]
    }
  ]
}
```

### Phase 3.7.4: Dependent File Discovery (15 min)
**Objective**: Find ALL files that depend on each session file

**Search Patterns**:
- Same timestamp in filename
- Same session ID in content
- References to session file path
- JSON files with session metadata

**Workers**: 30 parallel dependency scanners
**Output**: Enhanced matching_pairs.json with complete dependency lists

### Phase 3.7.5: Safety Backup Creation (10 min)
**Objective**: Create 4-level rollback system before ANY modifications

**Backup Levels**:
1. **Level 1**: Complete snapshot of Claude projects (.archive/pre-phase-3.7-L1-snapshot/)
2. **Level 2**: All session files (.archive/pre-phase-3.7-L2-session-files/)
3. **Level 3**: All dependent files (.archive/pre-phase-3.7-L3-dependent-files/)
4. **Level 4**: Matching pairs document (.archive/pre-phase-3.7-L4-matching-pairs.json)

**Workers**: 10 parallel backup workers
**Verification**: MD5 checksums for all backed up files

### Phase 3.7.6: 10-Phase Enterprise Testing (30 min)
**Objective**: Test restoration process on 5 sample sessions before full deployment

**Test Phases**:
0. **Pre-flight Validation**: Verify backups exist, workers ready
1. **Test Discovery**: Identify test scenarios (small/medium/large sessions, multi-session files)
2. **Dependency Resolution**: Verify all dependent files found for test sessions
3. **System Snapshot**: Create test-specific rollback point
4. **Parallel Execution**: Restore 5 test sessions simultaneously
5. **Multi-stage Validation**:
   - Stage 1: Deterministic (exact line count match)
   - Stage 2: Statistical (content hash verification)
   - Stage 3: Behavioral (dependent files updated correctly)
   - Stage 4: Temporal (timestamps consistent)
   - Stage 5: Quantum (integrity across all files)
6. **Cross-validation**: 3 validators verify test results
7. **Consensus Verification**: All validators agree results are correct
8. **Enterprise Report**: Generate test report
9. **Synchronization**: Sync test results to quantum TODO

**Success Criteria**: All 5 test sessions pass all 5 validation stages

### Phase 3.7.7: Full Restoration Execution (45 min)
**Objective**: Restore ALL matched sessions with full fidelity

**Workforce Deployment**:
- **Team 1 (50 workers)**: Session file restoration (copy manual → incomplete)
- **Team 2 (40 workers)**: END_SESSION_REPORT updates (line counts, sizes)
- **Team 3 (30 workers)**: JSON file updates (SESSION_HANDOFF_*.json)
- **Team 4 (20 workers)**: TODO/INSTRUCTIONS file updates
- **Team 5 (10 workers)**: Verification and quality control

**Total Workers**: 150 parallel agents
**Process per match**:
1. Verify backup exists
2. Copy manual capture content to session file
3. Update line count in filename (if embedded)
4. Update END_SESSION_REPORT with correct stats
5. Update SESSION_HANDOFF JSON with correct line_count
6. Update any other dependent files
7. Verify all updates successful
8. Log completion

### Phase 3.7.8: Post-Restoration Validation (20 min)
**Objective**: Verify ALL restorations successful and consistent

**Validation Checks**:
1. **Completeness**: All matched pairs processed
2. **Integrity**: Line counts match between session file and dependent files
3. **Consistency**: All dependent files reference correct session file
4. **Accessibility**: All restored files readable and valid
5. **Atomicity**: No partial updates (all or nothing per session)

**Workers**: 30 parallel validators
**Output**: validation_report.json

### Phase 3.7.9: Rollback Testing (10 min)
**Objective**: Verify rollback procedures work if needed

**Test**:
1. Select 3 restored sessions
2. Execute rollback from Level 3 backup
3. Verify files restored to pre-restoration state
4. Re-execute restoration on those 3 sessions
5. Verify restoration works second time

**Success**: Rollback + re-restoration both successful

### Phase 3.7.10: Cleanup & Documentation (10 min)
**Objective**: Terminate workers, generate reports, update quantum TODO

**Tasks**:
1. Terminate ALL 150 workers (verify no orphans)
2. Generate completion report
3. Archive workforce logs
4. Update quantum TODO with results
5. Update integrated plan with Phase 3.7 completion

---

## WORKFORCE ARCHITECTURE

### Worker Scripts

#### Script 1: session-boundary-detector.sh
```bash
#!/bin/bash
# Detects session boundaries in multi-session manual capture files

MANUAL_FILE=$1
OUTPUT_DIR=$2

# Detect session boundaries
SESSION_NUM=1
CURRENT_SESSION_FILE=""
IN_SESSION=false

while IFS= read -r line; do
    # Detect session start markers
    if [[ "$line" =~ "Claude Code v" ]] || [[ "$line" =~ "Starting session" ]]; then
        # New session detected
        if [ "$IN_SESSION" = true ]; then
            # Close previous session
            SESSION_NUM=$((SESSION_NUM + 1))
        fi
        CURRENT_SESSION_FILE="$OUTPUT_DIR/session_${SESSION_NUM}.txt"
        IN_SESSION=true
    fi

    # Write line to current session file
    if [ "$IN_SESSION" = true ]; then
        echo "$line" >> "$CURRENT_SESSION_FILE"
    fi
done < "$MANUAL_FILE"

echo "Extracted $SESSION_NUM sessions from $MANUAL_FILE"
```

#### Script 2: session-matcher.sh
```bash
#!/bin/bash
# Matches extracted sessions to incomplete Claude ecosystem files

EXTRACTED_SESSION=$1
ECOSYSTEM_DIR=$2

# Extract metadata from session
SESSION_DATE=$(grep -m1 "Date:" "$EXTRACTED_SESSION" | awk '{print $2}')
SESSION_TIME=$(grep -m1 "Time:" "$EXTRACTED_SESSION" | awk '{print $2}')
PROJECT_NAME=$(grep -m1 "Project:" "$EXTRACTED_SESSION" | awk '{print $2}')
SESSION_ID=$(grep -m1 "Session ID:" "$EXTRACTED_SESSION" | awk '{print $3}')

# Search for matching incomplete files
MATCHES=$(find "$ECOSYSTEM_DIR" -name "*${SESSION_DATE}*" -name "*.txt" 2>/dev/null)

# For each potential match, calculate confidence
for match in $MATCHES; do
    INCOMPLETE_LINES=$(wc -l < "$match")
    EXTRACTED_LINES=$(wc -l < "$EXTRACTED_SESSION")

    # Match criteria
    CONFIDENCE=0
    [[ "$match" =~ "$SESSION_DATE" ]] && CONFIDENCE=$((CONFIDENCE + 30))
    [[ "$match" =~ "$SESSION_ID" ]] && CONFIDENCE=$((CONFIDENCE + 40))
    [[ $EXTRACTED_LINES -gt $((INCOMPLETE_LINES * 2)) ]] && CONFIDENCE=$((CONFIDENCE + 30))

    if [ $CONFIDENCE -ge 70 ]; then
        echo "MATCH: $EXTRACTED_SESSION -> $match (confidence: $CONFIDENCE%)"
    fi
done
```

#### Script 3: session-restorer.sh
```bash
#!/bin/bash
# Restores session file and updates all dependent files

MANUAL_SESSION=$1
INCOMPLETE_FILE=$2
DEPENDENT_FILES_JSON=$3

# Backup incomplete file
cp "$INCOMPLETE_FILE" "${INCOMPLETE_FILE}.backup-$(date +%s)"

# Restore full content
cp "$MANUAL_SESSION" "$INCOMPLETE_FILE"

# Update line count in filename if embedded
NEW_LINES=$(wc -l < "$INCOMPLETE_FILE")
NEW_FILENAME=$(echo "$INCOMPLETE_FILE" | sed "s/_[0-9]*_LINES/_${NEW_LINES}_LINES/")
if [ "$NEW_FILENAME" != "$INCOMPLETE_FILE" ]; then
    mv "$INCOMPLETE_FILE" "$NEW_FILENAME"
    INCOMPLETE_FILE="$NEW_FILENAME"
fi

# Update dependent files
while IFS= read -r dep_file; do
    # Update line count references
    sed -i "s/Total Lines Captured\*\*: [0-9]*/Total Lines Captured**: $NEW_LINES/" "$dep_file"
    sed -i "s/chat_capture_lines\": [0-9]*/chat_capture_lines\": $NEW_LINES/" "$dep_file"
done < <(jq -r '.[]' "$DEPENDENT_FILES_JSON")

echo "✅ Restored $INCOMPLETE_FILE with $NEW_LINES lines and updated $(wc -l < $DEPENDENT_FILES_JSON) dependent files"
```

#### Script 4: workforce-orchestrator.sh
```bash
#!/bin/bash
# Orchestrates all 150 workers across 5 teams

MATCHING_PAIRS_JSON=$1
TOTAL_WORKERS=150

# Team 1: Session restoration (50 workers)
TEAM1_SIZE=50
MATCHES_PER_WORKER=$(($(jq '.matches | length' $MATCHING_PAIRS_JSON) / TEAM1_SIZE))

for worker_id in $(seq 1 $TEAM1_SIZE); do
    START_IDX=$(( (worker_id - 1) * MATCHES_PER_WORKER ))
    END_IDX=$(( worker_id * MATCHES_PER_WORKER - 1 ))

    ./session-restorer-worker.sh "$worker_id" "$START_IDX" "$END_IDX" "$MATCHING_PAIRS_JSON" &
done

# Team 2: END_SESSION_REPORT updates (40 workers)
# ... similar pattern ...

# Wait for all workers
wait

echo "✅ All $TOTAL_WORKERS workers completed"
```

---

## ERROR HANDLING & ROLLBACK

### Rollback Procedures

#### Level 1: Complete Rollback (Emergency)
```bash
# Restore ENTIRE Claude projects from snapshot
rm -rf /mnt/c/Users/jdh/claude_projects/*
cp -r .archive/pre-phase-3.7-L1-snapshot/* /mnt/c/Users/jdh/claude_projects/
```

#### Level 2: Session Files Only
```bash
# Restore only session files
cp -r .archive/pre-phase-3.7-L2-session-files/* /mnt/c/Users/jdh/claude_projects/
```

#### Level 3: Dependent Files Only
```bash
# Restore only dependent files (END_SESSION_REPORT, etc.)
cp -r .archive/pre-phase-3.7-L3-dependent-files/* /mnt/c/Users/jdh/claude_projects/
```

#### Level 4: Selective Rollback
```bash
# Rollback specific session using matching_pairs.json
SESSION_ID=$1
jq -r ".matches[] | select(.incomplete_file | contains(\"$SESSION_ID\"))" \
    .archive/pre-phase-3.7-L4-matching-pairs.json | \
    jq -r '.incomplete_file, .dependent_files[]' | \
    while read file; do
        cp ".archive/pre-phase-3.7-L2-session-files/$file" "$file"
    done
```

### Error Scenarios & Recovery

1. **Worker Crash Mid-Restoration**
   - Detection: Monitor worker logs for incomplete entries
   - Recovery: Re-run specific worker with same batch

2. **Partial File Update**
   - Detection: Validation phase catches inconsistent line counts
   - Recovery: Rollback that specific session, re-restore

3. **Matching Errors** (false positives)
   - Detection: Manual review of low-confidence matches
   - Recovery: Exclude from restoration, manual review

4. **Multi-Session Parse Errors**
   - Detection: Extracted session has discontinuous content
   - Recovery: Re-parse with different boundary markers

---

## SUCCESS METRICS

### Quantitative Targets
- **Match Rate**: >80% of manual captures matched to incomplete files
- **Restoration Rate**: >95% of matches successfully restored
- **Fidelity**: Restored files have >95% of manual capture content
- **Dependent Update Rate**: 100% of dependent files updated correctly
- **Error Rate**: <1% (max 5 sessions with errors if 500 total)

### Qualitative Targets
- Session history files contain complete context
- Dependent files consistently reference correct line counts
- No data loss during restoration
- All workers terminated cleanly

### Validation Queries
```bash
# Check restoration completeness
find . -name "CHAT_SESSION_SCROLLBACK_*_24_LINES.txt" | wc -l
# Should be 0 (all 24-line files replaced)

# Check dependent file consistency
grep -r "Total Lines Captured.*: 24" END_SESSION_REPORT_*.md | wc -l
# Should be 0 (all updated with correct counts)
```

---

## INTEGRATION WITH CURRENT PLAN (NOT BRANCHED)

**This is Phase 3.7 - ADDED TO CURRENT PLAN**

### Updated Plan Order:
- ✅ Phase 1: Database Reference Updates (COMPLETE)
- ✅ Phase 2: Enterprise Testing (COMPLETE)
- ✅ Phase 3: Database Merge (COMPLETE)
- 🔄 Phase 3.5: Scrollback Capture Fix (IN PROGRESS)
- ⏳ Phase 3.6: Database Dependency Completion (PLANNED)
- **🔄 Phase 3.7: Session History Fidelity Restoration (IN PROGRESS - THIS PLAN)**
- ⏳ Phase 4: Integration Testing (PENDING)
- ⏳ Phase 5: Documentation & Rollback Updates (PENDING)

### Dependencies:
- **Can Run In Parallel With**: Phase 3.5, Phase 3.6 (independent operations)
- **Blocks**: Phase 4 (need complete session history for testing)
- **Critical Path**: Must complete before declaring database consolidation done

### Timeline:
- **Phase 3.7 Total**: 185 minutes (3h 5min)
- **Can Run Parallel**: Yes, with Phases 3.5 (45 min) and 3.6 (65 min)
- **Net Additional Time**: 120 minutes if parallel execution

---

## QUANTUM TODO TASKS

**Add to Database**:
1. QT-PHASE-3.7-DISCOVERY-001: Discovery & inventory (IN PROGRESS, HIGH)
2. QT-PHASE-3.7-BOUNDARY-002: Session boundary detection (PENDING, HIGH)
3. QT-PHASE-3.7-MATCHING-003: Matching algorithm (PENDING, CRITICAL)
4. QT-PHASE-3.7-DEPENDENT-004: Dependent file discovery (PENDING, HIGH)
5. QT-PHASE-3.7-BACKUP-005: Safety backup creation (PENDING, CRITICAL)
6. QT-PHASE-3.7-TESTING-006: 10-phase enterprise testing (PENDING, CRITICAL)
7. QT-PHASE-3.7-RESTORATION-007: Full restoration execution (PENDING, CRITICAL)
8. QT-PHASE-3.7-VALIDATION-008: Post-restoration validation (PENDING, HIGH)
9. QT-PHASE-3.7-ROLLBACK-TEST-009: Rollback testing (PENDING, MEDIUM)
10. QT-PHASE-3.7-CLEANUP-010: Cleanup & documentation (PENDING, MEDIUM)

**Total Phase 3.7 Tasks**: 10 tasks (185 minutes total)

---

## NEXT STEPS (IMMEDIATE)

1. ✅ Complete manual capture inventory
2. ⏳ Search Claude ecosystem for ALL session files
3. ⏳ Parse multi-session manual captures
4. ⏳ Run matching algorithm
5. ⏳ Create comprehensive matching pairs document
6. ⏳ Execute 10-phase enterprise testing
7. ⏳ Deploy universal workforce for restoration
8. ⏳ Terminate all workers
9. ⏳ Generate completion report

---

*Phase 3.7 added to plan: 2025-12-11 10:15:00 PST*
*Priority: CRITICAL - Restoring session history fidelity*
*Status: IN PROGRESS - Discovery phase*
*Safety: 4-level rollback + 10-phase testing required*
