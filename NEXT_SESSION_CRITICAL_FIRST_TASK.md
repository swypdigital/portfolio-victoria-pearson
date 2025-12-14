# ⚠️ CRITICAL: NEXT SESSION FIRST TASK ⚠️

**BEFORE DOING ANYTHING ELSE IN NEXT SESSION**:

1. Read: `CRITICAL_PHASE_3.7_500_WORKER_SAFETY_PROTOCOL_20251211.md`
2. Create: Worker assignment matrix (`/tmp/worker_assignment_matrix.json`)
3. Verify: Zero database conflicts in worker assignments
4. Only then: Proceed with Phase 3.5, 3.6, 3.7 execution

**Why Critical**:
- 500 workers accessing database = GUARANTEED CORRUPTION
- Must organize workers: Teams 1-5 (file-system only), Worker 501 (database only)
- Wave deployment prevents system overload
- Isolation monitoring prevents conflicts

**Failure to do this first = Database corruption = All work lost**

📋 See: `plans/database-consolidation-20251211/CRITICAL_PHASE_3.7_500_WORKER_SAFETY_PROTOCOL_20251211.md`
