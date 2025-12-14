# EXTRACTED TASKS FROM BOTH SESSIONS
**Date**: 2025-12-11 09:57:00 PST
**Source**: Database Consolidation Session (1342 lines) + Debug Session Start Script (1260 lines)
**Total Tasks Extracted**: 47 tasks

---

## DATABASE CONSOLIDATION TASKS (COMPLETED)

### Phase 1: CLAUDE_SESSION_PROTOCOL.sh Update
- ✅ Add database path sourcing to CLAUDE_SESSION_PROTOCOL.sh (line 26-33)
- ✅ Replace all 20 hardcoded references quantum-todo.db → QUANTUM_INDEX_DB
- ✅ Update file existence checks to use QUANTUM_INDEX_DB
- ✅ Verify no hardcoded paths remain (grep verification passed)

### Phase 2: Enterprise Testing Framework
- ✅ Create 10-phase testing framework script
- ✅ Implement Phase 0: Pre-flight validation
- ✅ Implement Phase 1: Test discovery (15 database operations)
- ✅ Implement Phase 2: Dependency resolution
- ✅ Implement Phase 3: Rollback snapshot creation
- ✅ Implement Phase 4: Parallel execution (5 tests)
- ✅ Implement Phase 5: 5-stage validation (deterministic, statistical, behavioral, temporal, quantum)
- ✅ Implement Phase 6: Cross-validation (3 validators)
- ✅ Implement Phase 7: Consensus verification
- ✅ Implement Phase 8: Enterprise report generation
- ✅ Implement Phase 9: Claude projects synchronization
- ✅ Execute all 10 phases - ALL PASSED

### Phase 3: Database Merge
- ✅ Stop all daemons (daemon-supervisor)
- ✅ Create comprehensive backups (.archive/pre-merge-backup-20251211_093340)
- ✅ Generate MD5 checksums for verification
- ✅ Execute column-mapped INSERT (29 common columns)
- ✅ Verify merge results (27,881 + 25,635 → 53,203 tasks, 313 duplicates removed)
- ✅ Archive old database (quantum-todo.db.archived-20251211_093513)
- ✅ Verify final database integrity

---

## SESSION PROTOCOL DEBUGGING TASKS (FROM DEBUG SESSION)

### Daemon Isolation Fix
- ✅ Identify root cause: Global PID files causing multi-session conflicts
- ✅ Implement session-isolated PID files (7 daemons modified)
- ✅ Update claude-unified-startup.sh to export CLAUDE_SESSION_ID
- ✅ Test session isolation (3/12 → 12/12 daemons running)
- ✅ Create backup (.archive/daemon-isolation-fix-20251210-232923)
- ✅ Verify all 12 daemons operational in isolated mode

### Session End Daemon Cleanup
- ✅ Add Stage 6 to CLAUDE_SESSION_END_PROTOCOL.sh
- ✅ Implement session-specific daemon shutdown
- ✅ Test cleanup (verify only session daemons killed, not others)

### Scrollback Capture Improvement (PARTIAL)
- ✅ Identify scrollback capture issue (only 24 lines)
- ✅ Modify CLAUDE_SESSION_END_PROTOCOL.sh for multi-source capture
- ✅ Add universal history session files as primary source
- ✅ Add 3 TMUX capture methods (max scrollback, full history, from start)
- ✅ Add manual emergency capture fallback
- ✅ Implement intelligent source selection (most content wins)
- ✅ Create SCROLLBACK_CAPTURE_FIX_COMPLETE_20251211.md documentation

---

## PENDING TASKS (TO BE ADDED TO QUANTUM TODO)

### Phase 3.5: Complete Scrollback Capture Fix (CRITICAL - HIGHEST PRIORITY)
1. **Run diagnostics on scrollback capture** (5 min)
   - Check TMUX history limit
   - Identify active session
   - Check persistent-capture-daemon status
   - Test all 3 capture methods
   - Status: in_progress
   - Priority: critical
   - Tags: session-protocol, scrollback, diagnostics

2. **Create absolute-fidelity-capture.sh** (10 min)
   - Implement 5 capture methods (TMUX start, TMUX limit, persistent daemon, all persistent combined, manual)
   - Select best method automatically
   - Add comprehensive logging
   - Status: pending
   - Priority: critical
   - Dependencies: Task 1
   - Tags: session-protocol, scrollback, automation

3. **Update CLAUDE_SESSION_END_PROTOCOL.sh with multi-method capture** (10 min)
   - Replace current capture with absolute-fidelity-capture.sh
   - Add verification of line counts
   - Add warning if <100 lines captured
   - Status: pending
   - Priority: critical
   - Dependencies: Task 2
   - Tags: session-protocol, scrollback

4. **Verify persistent-capture-daemon.sh functionality** (10 min)
   - Check if daemon is writing to correct location
   - Verify it's using correct TMUX session name
   - Confirm 5-minute capture frequency
   - Add verification that files are >24 lines
   - Status: pending
   - Priority: critical
   - Tags: daemon, session-protocol, scrollback

5. **Test end-to-end capture with >90% fidelity** (10 min)
   - Create test session with 1000+ lines
   - Run session end protocol
   - Verify capture has >900 lines
   - Document results
   - Status: pending
   - Priority: critical
   - Dependencies: Tasks 2, 3, 4
   - Tags: session-protocol, scrollback, testing

### Phase 4: Integration Testing (20 min)
6. **Test complete session lifecycle**
   - Start session → verify all 12 daemons
   - End session → verify handoff, summaries, daemon cleanup
   - Status: pending
   - Priority: high
   - Dependencies: Task 5
   - Tags: session-protocol, integration-testing

7. **Test all database-accessing scripts**
   - quantum list/add commands
   - All 12 daemons
   - Session end/auto-session end protocols
   - Diagnostics scripts
   - Status: pending
   - Priority: high
   - Tags: database, integration-testing

8. **Path compliance verification**
   - Run: grep -r "quantum-todo\.db" --include="*.sh"
   - Should return 0 matches (except contractual-db-paths.sh)
   - Status: pending
   - Priority: medium
   - Tags: database, consolidation, verification

### Phase 5: Documentation & Rollback (15 min)
9. **Update rollback-quantum-todo-changes.sh**
   - Add consolidation_merge rollback function
   - Test rollback procedure
   - Status: pending
   - Priority: medium
   - Tags: database, rollback, documentation

10. **Archive test suite**
    - Move CLAUDE_SESSION_PROTOCOL_DB_CONSOLIDATION_TEST_SUITE.sh to frameworks/
    - Create template for future testing
    - Status: pending
    - Priority: low
    - Tags: testing, documentation

11. **Document lessons learned**
    - Create post-mortem document
    - Document all fixes applied
    - Create troubleshooting guide
    - Status: pending
    - Priority: low
    - Tags: documentation

### BUG FIXES (ADDED TO PLAN, NOT BRANCHED)
12. **Fix populate-session-templates.sh missing error** (line 691)
    - Locate or recreate populate-session-templates.sh
    - Ensure it's called correctly in CLAUDE_SESSION_END_PROTOCOL.sh
    - Test that templates are populated
    - Status: pending
    - Priority: high
    - Tags: session-protocol, bug-fix

13. **Fix SESSION_HANDOFF_PROTOCOL.sh missing error** (line 710)
    - Locate or recreate SESSION_HANDOFF_PROTOCOL.sh
    - Ensure it's called correctly in CLAUDE_SESSION_END_PROTOCOL.sh
    - Test handoff protocol
    - Status: pending
    - Priority: high
    - Tags: session-protocol, bug-fix

14. **Investigate daemon-supervisor "not running" issue**
    - daemon-supervisor reports "Supervisor not running" but processes are active
    - Fix status reporting logic
    - Ensure supervisor properly manages all 12 daemons
    - Status: pending
    - Priority: medium
    - Tags: daemon, bug-fix

### SCHEMA ENHANCEMENT TASKS (FUTURE)
15. **Implement craft_framework column population**
    - Update all INSERT scripts to populate craft_framework
    - Backfill existing tasks with framework data
    - Status: pending
    - Priority: low
    - Tags: database, schema, enhancement

16. **Implement project_tags column population**
    - Update all INSERT scripts to populate project_tags (currently 52.3% populated)
    - Backfill remaining 47.7% from source field
    - Status: pending
    - Priority: medium
    - Tags: database, schema, enhancement

17. **Implement composite_content column population**
    - Update all INSERT scripts to populate composite_content
    - Backfill existing tasks for search optimization
    - Status: pending
    - Priority: low
    - Tags: database, schema, enhancement

---

## TASK STATISTICS

**Completed**: 39 tasks (83%)
**Pending**: 17 tasks (Phase 3.5: 5 tasks, Phase 4: 3 tasks, Phase 5: 3 tasks, Bug Fixes: 3 tasks, Schema: 3 tasks)
**Critical Priority**: 5 tasks (all Phase 3.5)
**High Priority**: 4 tasks
**Medium Priority**: 3 tasks
**Low Priority**: 5 tasks

---

## NEXT SESSION PRIORITIES (IN ORDER)

1. **CRITICAL**: Complete Phase 3.5 (scrollback capture fix) - 45 min
2. **HIGH**: Fix populate-session-templates.sh missing (Task 12) - 15 min
3. **HIGH**: Fix SESSION_HANDOFF_PROTOCOL.sh missing (Task 13) - 15 min
4. **HIGH**: Complete Phase 4 integration testing - 20 min
5. **MEDIUM**: Complete Phase 5 documentation - 15 min

**Total estimated time**: 110 minutes (1h 50min)

---

*Generated from sessions: Database Consolidation (1342 lines) + Debug Session Start Script (1260 lines)*
*Date: 2025-12-11 09:57:00 PST*
