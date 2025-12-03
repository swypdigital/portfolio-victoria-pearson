# CLAUDE PROJECTS MASTER INSTRUCTIONS
*Project-specific instructions for /mnt/c/Users/jdh/claude_projects*

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
- **Testing**: Implement full 10-phase testing framework
- **Documentation**: Auto-extract components, maintain universal index

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
- **Global Instructions**: Inherited from `/home/groklygroup/.claude/CLAUDE.md`
- **Project Root**: Inherited from `/mnt/c/Users/jdh/CLAUDE.md`
- **Local Overrides**: From `/mnt/c/Users/jdh/CLAUDE.local.md`
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