# CLAUDE PROJECTS MASTER INSTRUCTIONS
*Project-specific instructions for $WINDOWS_HOME/claude_projects*

## 🚨 CRITICAL: COMPREHENSIVE OUTPUT MANDATE (ENFORCED)
**NEVER create streamlined, concise, or abbreviated output unless explicitly requested by user.**

This is a BLOCKING requirement enforced via:
- Global CLAUDE.md mandate
- Project-level enforcement
- Pre-prompt hook (loads every session)
- See: `.mandatory-files/COMPREHENSIVE_OUTPUT_MANDATE.md`

**VIOLATION = CRITICAL FAILURE - Output must be regenerated in full.**

## 🔌 SMART HOOKS SYSTEM - CONTEXT-AWARE DYNAMIC LOADING
**66% Token Reduction Through On-Demand Context Loading**

The smart hooks system automatically loads detailed context based on your message keywords:

**Auto-Loaded Contexts**:
- Mention "**test**" → Loads TESTING_FRAMEWORK (10-phase framework details)
- Mention "**daemon**" → Loads DAEMON_MANAGEMENT (12 daemon specifications)
- Mention "**session**" → Loads SESSION_PROTOCOLS (capture & handoff details)
- Mention "**error/bug**" → Loads ERROR_PROTOCOL (diagnostic procedures)
- Mention "**path**" → Loads PATH_REQUIREMENTS (dynamic path rules)
- Mention "**performance/search**" → Loads PERFORMANCE_DIRECTIVES (parallel search)

**Usage** (automatic - no action needed):
- System detects keywords in your messages
- Relevant contexts loaded instantly (<100ms)
- Full specifications available on-demand only

**Manual Usage**:
```bash
source smart-hooks-init.sh
load_contexts "your message here"  # Load specific contexts
list_contexts                       # Show available contexts
```

**Files**: 6 context files in `.mandatory-files/contexts/`
**Performance**: 90ms load time for 5 contexts
**Test Suite**: `./test-smart-hooks-system.sh` (100% pass rate)

---

## 🎯 PROJECT-SPECIFIC CORE DIRECTIVES

### Quantum TODO System Integration
- **NEVER USE TodoWrite TOOL - IT IS FORBIDDEN**
- ALWAYS use quantum TODO system:
  - Add task: `./quantum-todo add "task description"`
  - List tasks: `./quantum-todo list`
  - Update task: `./quantum-todo update <id> "new description"`
- The quantum TODO system is at:
  - Command: `./quantum-todo`
  - Full path: `$CLAUDE_PROJECTS_ROOT/quantum-todo-system/quantum-todo-system.sh`
  - Database: `$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-todo.db`

### Session Management & Protocols
- **Session End Protocol**: Use `./CLAUDE_SESSION_END_PROTOCOL.sh`
- **Session Handoff**: Files stored in `.session-handoff/`
- **Chat Capture**: `CHAT_SESSION_SCROLLBACK_YYYY-MM-DD_HH-MM-SS_FULL_[LINES]_LINES.txt`
- **All session files**: Must be in claude_projects root directory

### MANDATORY: Beautiful Report Format for ALL Reports
- **ANY OUTPUT THAT IS A REPORT OR SUMMARY** must use beautiful report library format
- **What qualifies**: Summarizes work, documents findings, presents analysis, status updates, accomplishments, metrics, system state, OR ANYTHING SIMILAR
- **Examples** (illustrative, NOT exhaustive): session end, diagnostic, analysis, test, deployment, audit, progress, status, summary reports
- **FORBIDDEN**: Plain markdown/text reports without beautiful formatting
- **Recognition**: System must inherently know that ANY output in the list OR SIMILAR must use beautiful format
- See: `.mandatory-files/BEAUTIFUL_REPORT_FORMAT_MANDATORY.md`
- Library: `source .components/beautiful-report-library.sh`
- Command: `report_create_enhanced "title" "mission" "status" "completed" "pending" "files" "state" "metrics" "output_file" "report_type"`
- This is a BLOCKING requirement - failure to use beautiful format = session failure

### Daemon Management
- **Daemon Supervisor**: `./daemon-supervisor.sh {start|stop|status|check}`
- **Critical Daemons** (9 total):
  - quantum-todo-autocapture
  - chat-backup
  - plan-capture
  - unified-index
  - quantum-autonomous
  - session-recovery
  - persistent-capture
  - health-monitor
  - tmux-index-footer

### File Organization & Naming
- **Dynamic Paths Only**: Source `contractual-paths-true.sh` in all scripts
- **Session Files**: Format `DOCUMENT_TYPE_project_YYYY-MM-DD_HH-MM-SS.extension`
- **Backups**: Store in `.archive/` with timestamps
- **Universal Components**: Extract to `UNIVERSAL_COMPONENTS.md`

### Linux-Windows Merge (COMPLETED)
- **Status**: ✅ Merge completed December 5, 2025
- **Result**: 19,546 files consolidated from Linux mount to Windows
- **Data Integrity**: 100% (zero data loss)
- **Files Merged**: 3 files with differences (99.9% identical)
- **Documentation**: `linux-windows-merge/MERGE_FINAL_DOCUMENTATION.md`
- **Repository**: swypdigital/linux-v-windows-merge
- **Single Source of Truth**: Windows environment is now canonical

### Startup & Environment
- **Startup Script**: `./claude-unified-startup.sh`
- **Auto-start**: Set `CLAUDE_AUTO_START=1` for non-interactive mode
- **Environment**: `CLAUDE_PROJECTS_ROOT`, `WINDOWS_HOME` must be set
- **TMUX Integration**: History limit 20,000 lines

### Search & Performance
- **Always use**: `cs "query"` as first search method
- **Ultra-fast parallel search**: Multiple workers, never sequential
- **Process cleanup**: Kill phantom/zombie processes after operations
- **No arbitrary maxdepth**: Find files regardless of depth

### Project Workflows
- **Continue Command**: Auto-detect project state and resume work
- **Build Standards**: Enterprise-grade, never MVP, complete implementation
- **Testing**: Implement full 10-phase testing framework with 100% pass rate requirement
- **Documentation**: Auto-extract components, maintain universal index

## 🧪 MANDATORY: 10-PHASE TESTING FRAMEWORK - 100% PASS RATE REQUIRED
**CRITICAL: ALL TESTING MUST ACHIEVE 100% PASS RATE - NO EXCEPTIONS**

### Core Requirements:
- **100% PASS RATE REQUIRED** - NO failures or warnings tolerated
- **Zero false positives** - All tests must be accurate
- **Zero warnings** - Warnings are treated as failures and MUST be fixed
- **All 5 validation stages** must pass in Phase 5
- **Consensus** from all validators in Phase 7

### Automatic Issue Tracking (MANDATORY):
Any test that does not pass (failure OR warning) MUST be:
1. **Automatically added to the current plan** as a bug fix task
2. **Automatically added to quantum TODO database** with:
   - ID: `QT-[PHASE]-[TYPE]-[NUMBER]` (e.g., QT-PHASE-3.5-WARNING-001)
   - Content: Full description of the issue
   - Status: 'pending'
   - Priority: 'critical' for failures/security, 'high' for warnings
   - Source: Reference to test that failed
   - Tags: test-failure, phase-id, component-name
3. **Linked in test report** with task ID for tracking

### Test Suite Implementation Requirements:
```bash
# All test scripts MUST include automatic issue tracking
if [[ $TEST_RESULT != "PASS" ]]; then
    # Add to quantum TODO
    TASK_ID="QT-${PHASE}-${TYPE}-$(printf '%03d' $ISSUE_NUM)"
    sqlite3 "$QUANTUM_INDEX_DB" "INSERT INTO quantum_todos (id, content, status, priority, source, tags)
        VALUES ('$TASK_ID', '$ISSUE_DESCRIPTION', 'pending', '$PRIORITY', '$TEST_NAME', 'test-failure,$PHASE,$COMPONENT');"

    # Add to current plan
    echo "- [ ] $TASK_ID: $ISSUE_DESCRIPTION" >> "$CURRENT_PLAN_FILE"
fi
```

**ENFORCEMENT**: Any non-100% pass rate = task INCOMPLETE until all issues fixed

## 🔧 CLAUDE PROJECTS SPECIFIC TOOLS

### Key Scripts & Locations
```bash
# Core session management
./claude-unified-startup.sh          # Main startup
./CLAUDE_SESSION_END_PROTOCOL.sh     # Session end
./SESSION_HANDOFF_PROTOCOL.sh        # Session handoff

# Daemon management  
./daemon-supervisor.sh               # Master daemon controller
./unified-index-daemon.sh            # Search indexing
./quantum-todo-autocapture-daemon.sh # TODO automation

# Utilities
./quantum-todo                       # Task management
./validate-dependencies.sh           # Dependency checking
./universal-search-script.sh         # Fast search
```

### Directory Structure
```
claude_projects/
├── .quantum-todo/           # Task database
├── .session-handoff/        # Session continuity  
├── .universal-history/      # Complete history
├── .daemon-registry/        # Daemon tracking
├── .microservices/          # Service architecture
├── plans/                   # Project plans
└── frameworks/              # Reusable frameworks
```

## 📋 PROJECT CONTEXT & STATE

### Current Major Initiatives
1. **InterviewPlus System**: Dynamic content generation, analytics dashboard
2. **NL System Architecture**: Production-ready with ML optimization
3. **Microservices Implementation**: 150-worker enterprise architecture
4. **Session Recovery**: 9K+ line session management
5. **Memory Optimization**: CLAUDE.md modularization (this file!)

### Active Technologies
- **Backend**: Node.js, Supabase, TypeScript
- **Frontend**: React, Next.js, Tailwind CSS
- **ML/AI**: Custom scoring models, semantic analysis
- **Infrastructure**: TMUX, WSL2, systemd services
- **Database**: SQLite (quantum-todo), PostgreSQL (InterviewPlus)

### Integration Points
- **Global Instructions**: Inherited from `$HOME/.claude/CLAUDE.md`
- **Project Root**: Inherited from `$WINDOWS_HOME/CLAUDE.md`
- **Local Overrides**: From `$WINDOWS_HOME/CLAUDE.local.md`
- **Universal Components**: Shared across all projects

## 🚨 CRITICAL: PLAN MODE RULES - NEVER BRANCH PLANS
**SYSTEMWIDE MANDATORY RULE - VIOLATION = CRITICAL FAILURE**

### FORBIDDEN: Branching Plans
- **NEVER create separate plans** that split from the original
- **NEVER replace** the original plan with a new plan
- **NEVER lose** the original GenCraft v3.0 build plan
- **NEVER use ExitPlanMode** to present a different plan direction

### REQUIRED: Additive Planning Only
- **ALWAYS extend** the existing plan
- **ALWAYS add** new phases/tasks to the current plan
- **ALWAYS preserve** all original plan content
- **ALWAYS maintain** the full plan history

### Example - CORRECT (Additive):
```
Original Plan: GenCraft v3.0 Build
Phase 1: Data Gathering
Phase 2: Architecture

ADD: Phase 1.5: Non-GenCraft Resource Evaluation
- Analyze GroklyGroup frameworks
- Evaluate research papers
- etc.

Plan now has Phase 1, 1.5, 2 (all preserved)
```

### Example - FORBIDDEN (Branching):
```
Original Plan: GenCraft v3.0 Build
REPLACE WITH: Non-GenCraft Resource Analysis Plan
(GenCraft v3.0 plan LOST)
```

**ENFORCEMENT**: If you lose the original plan, you have FAILED THE USER

---
*This file contains only claude_projects-specific instructions. Universal and project root instructions are inherited from the modular instruction system.*
*File size optimized for context efficiency: ~4KB vs. previous 45KB consolidated version*
## 🏢 ENTERPRISE STANDARDS REFERENCE
**See global CLAUDE.md for complete standards. Summary:**

1. **Feature Requirements**: `docs/architecture/ENTERPRISE_FEATURE_REQUIREMENTS_11_CATEGORY_MANDATORY_CHECKLIST.md`
2. **Coding Standards**: `.enterprise-coding-kit/standards/coding-standards.md`

**Enforcement**: Mandatory for all projects. 100% compliance required before deployment.

