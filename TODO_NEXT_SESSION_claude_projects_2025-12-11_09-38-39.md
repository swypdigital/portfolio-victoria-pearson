# NEXT SESSION TODO LIST
**Created**: 2025-12-11 10:01:00 PST
**Session ID**: database-consolidation-20251207
**Total Tasks**: 12 pending tasks

## IMMEDIATE PRIORITIES (CRITICAL - DO FIRST)

### Phase 3.5: Complete Scrollback Capture Fix (45 min - CRITICAL)
1. **Run scrollback capture diagnostics** (5 min) - IN PROGRESS
   - ID: QT-SCROLLBACK-DIAG-001
   - Check TMUX history limit, identify active session, test all capture methods
   
2. **Create absolute-fidelity-capture.sh** (10 min)
   - ID: QT-SCROLLBACK-FIDELITY-002
   - Implement 5 fallback capture methods
   - Depends on: Task 1

3. **Update CLAUDE_SESSION_END_PROTOCOL.sh** (10 min)
   - ID: QT-SCROLLBACK-UPDATE-003
   - Replace with multi-method capture
   - Depends on: Task 2

4. **Verify persistent-capture-daemon.sh** (10 min)
   - ID: QT-SCROLLBACK-DAEMON-004
   - Check writing location, TMUX session, frequency

5. **Test end-to-end capture >90% fidelity** (10 min)
   - ID: QT-SCROLLBACK-E2E-005
   - Depends on: Tasks 2, 3, 4

## HIGH PRIORITY BUG FIXES (30 min)

6. **Fix populate-session-templates.sh missing** (15 min)
   - ID: QT-BUGFIX-POPULATE-TEMPLATES-012
   - Line 691 error in CLAUDE_SESSION_END_PROTOCOL.sh

7. **Fix SESSION_HANDOFF_PROTOCOL.sh missing** (15 min)
   - ID: QT-BUGFIX-SESSION-HANDOFF-013
   - Line 710 error in CLAUDE_SESSION_END_PROTOCOL.sh

## INTEGRATION TESTING - PHASE 4 (20 min)

8. **Test complete session lifecycle** (10 min)
   - ID: QT-PHASE4-LIFECYCLE-006
   - Start → work → end → verify all components

9. **Test all database-accessing scripts** (5 min)
   - ID: QT-PHASE4-DB-SCRIPTS-007
   - Verify all use quantum-index.db

10. **Path compliance verification** (5 min)
    - ID: QT-PHASE4-PATH-COMPLIANCE-008
    - Grep for hardcoded quantum-todo.db references

## DOCUMENTATION - PHASE 5 (15 min)

11. **Update rollback-quantum-todo-changes.sh** (10 min)
    - ID: QT-PHASE5-ROLLBACK-009
    - Add merge rollback function

12. **Archive test suite and document lessons** (5 min)
    - Move test suite to frameworks/
    - Create post-mortem document

---

## REFERENCES

**Integrated Plan**: INTEGRATED_PLAN_DATABASE_CONSOLIDATION_SESSION_PROTOCOLS_20251211.md
**Phase 3.5 Details**: SCROLLBACK_CAPTURE_FIX_ADDED_TO_PLAN_20251211.md
**Task Extraction**: EXTRACTED_TASKS_FROM_SESSIONS_20251211.md
**Completion Report**: DATABASE_CONSOLIDATION_COMPLETION_REPORT_20251211.md

**Session History**:
- Main session: COMPLETE_SESSION_SCROLLBACK_DATABASE_CONSOLIDATION_20251211_1342_LINES.txt
- Debug session: DEBUG_SESSION_START_SCRIPT_20251210_1260_LINES.txt

---

**Total Estimated Time**: 110 minutes (1h 50min)
**Critical Path**: Phase 3.5 → Bug Fixes → Phase 4 → Phase 5
