# GIT-BASED DATABASE CONSOLIDATION PLAN
**Created**: 2025-12-07
**Strategy**: Use Git for surgical precision and instant rollback

## 🎯 WHY GIT IS SUPERIOR

### Traditional Backup Approach (Old Plan):
- Manual backups in .archive/ directory
- Complex rollback scripts
- Hard to see what changed
- Manual verification needed
- Prone to human error

### Git-Based Approach (NEW - BETTER):
- **Every phase = 1 commit** with detailed message
- **Instant rollback**: `git reset --hard HEAD~1`
- **See all changes**: `git diff HEAD~1`
- **Full audit trail**: `git log --stat`
- **Branch isolation**: Work safely, merge when verified
- **Professional workflow**: Industry standard

---

## 📋 GIT WORKFLOW

### Step 1: Create Branch
```bash
git checkout -b database-consolidation-20251207
```

### Step 2: Commit Current Analysis (Baseline)
```bash
git add DATABASE_*.md
git commit -m "docs(db): Complete forensic analysis and surgical plan

- 314KB detailed forensic analysis
- Executive summary with recommendations  
- Surgical plan with 6 phases
- Identified 2 quantum-index.db files (active vs obsolete)
- Mapped 13 scripts with hard-coded paths

Ready for execution with Git-based rollback safety."
```

### Step 3: Execute Phases with Git Commits

**Phase 0: Pre-flight Safety**
```bash
# Do backup, stop daemons
git add .
git commit -m "chore(db): Phase 0 - Pre-flight safety backups complete"
```

**Phase 1: Archive Obsolete Database**
```bash
# Archive .index-system/database/quantum-index.db
git add .
git commit -m "refactor(db): Phase 1 - Archive obsolete quantum-index.db

- Moved .index-system/database/quantum-index.db to .archive/
- Database was 3 months old, missing 11,572 tasks
- Active database: .quantum-todo/quantum-index.db (129M, 38 tables)"
```

**Phase 2: Update Contractual Paths**
```bash
# Update contractual-db-paths.sh
git add contractual-db-paths.sh
git commit -m "refactor(paths): Phase 2 - Update contractual paths to active DB

- QUANTUM_INDEX_DB now points to .quantum-todo/quantum-index.db
- Removed reference to obsolete .index-system/ location
- All path resolution tests passing"
```

**Phase 3: Convert Scripts (13 commits - one per script)**
```bash
# Convert AUTO_SESSION_END_PROTOCOL.sh
git add AUTO_SESSION_END_PROTOCOL.sh
git commit -m "refactor(scripts): Convert AUTO_SESSION_END_PROTOCOL to contractual paths"

# Convert CLAUDE_SESSION_END_PROTOCOL.sh
git add CLAUDE_SESSION_END_PROTOCOL.sh  
git commit -m "refactor(scripts): Convert CLAUDE_SESSION_END_PROTOCOL to contractual paths"

# ... repeat for all 13 scripts
```

**Phase 4: Archive Old Backups**
```bash
git add .quantum-todo/ .archive/
git commit -m "chore(cleanup): Phase 4 - Archive old safety backups

- Moved Oct/Sep backups to .archive/
- Recovered ~150MB disk space
- Active DBs: quantum-index.db (129M), quantum-todo.db (22M)"
```

**Phase 5: Testing & Validation**
```bash
# Add test results
git add .
git commit -m "test(db): Phase 5 - All validation tests passing

- Dependency validator: 100% pass
- Database access: ✅ All queries successful
- Daemons: ✅ All restarted successfully
- Functional tests: ✅ Quantum TODO, session protocols working"
```

### Step 4: Merge to Main (After 24hr Monitoring)
```bash
git checkout windows-main
git merge database-consolidation-20251207 --no-ff
git push
```

---

## 🚨 INSTANT ROLLBACK OPTIONS

### Rollback Last Phase
```bash
git reset --hard HEAD~1
```

### Rollback to Specific Commit
```bash
git log --oneline  # Find commit hash
git reset --hard <commit-hash>
```

### Rollback Entire Consolidation
```bash
git checkout windows-main
git branch -D database-consolidation-20251207
```

### View What Changed
```bash
git diff HEAD~5  # See last 5 commits of changes
git show HEAD    # See latest commit details
```

---

## ✅ ADVANTAGES OVER BACKUP APPROACH

| Aspect | Backup Approach | Git Approach |
|--------|-----------------|--------------|
| **Rollback Speed** | 5-10 min (restore files) | <1 second (`git reset`) |
| **Audit Trail** | Manual logs | Complete with `git log` |
| **See Changes** | Manual diff | `git diff` instant |
| **Verify Before Merge** | Complex | `git diff main...branch` |
| **Safety** | Backup files can corrupt | Git hashes guarantee integrity |
| **Storage** | Duplicates files | Git compression ~50% smaller |
| **Professional** | Custom solution | Industry standard |

---

## 📊 COMMIT MESSAGE CONVENTION

Using semantic commits for clarity:

- `refactor(db):` - Database structure changes
- `refactor(paths):` - Path updates
- `refactor(scripts):` - Script conversions
- `chore(cleanup):` - Cleanup/archive operations
- `test(db):` - Testing and validation
- `docs(db):` - Documentation updates

---

## 🎯 EXECUTION AUTHORIZATION

**Ready to proceed with Git-based approach?**

User confirms:
- [ ] Create branch: database-consolidation-20251207
- [ ] Commit current analysis files (baseline)
- [ ] Execute phases with Git commits at each step
- [ ] Full rollback capability via Git
- [ ] Merge to main after 24hr validation

**This is the ENTERPRISE-GRADE approach!**
