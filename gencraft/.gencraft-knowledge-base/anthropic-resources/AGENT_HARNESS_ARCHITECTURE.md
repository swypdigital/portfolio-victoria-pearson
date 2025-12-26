# Effective Harnesses for Long-Running AI Agents

**Source**: https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
**Date Retrieved**: 2025-11-30
**Relevance**: GenCraft v3.0 agent architecture and state management

---

## Executive Summary

Anthropic's engineering team developed a **two-agent architecture** that enables long-running AI projects to maintain state across sessions and make incremental progress without losing context. This directly applies to GenCraft v3.0's autonomous generation capabilities.

---

## Core Architecture: Two-Agent System

### Agent 1: Initializer
- **Purpose**: Run ONCE on first execution
- **Responsibilities**: Establish foundational infrastructure
- **Outputs**:
  - Feature list (JSON)
  - Progress tracking file
  - Git repository initialization
  - Development environment setup

### Agent 2: Coding Agent
- **Purpose**: Execute in subsequent sessions
- **Responsibilities**: Incremental feature implementation
- **State Recovery**: Reads `claude-progress.txt` + git history
- **Constraint**: Clean state at end of each session

---

## Critical State Management Components

### 1. Feature List (JSON-based)

**Purpose**: Comprehensive feature requirements tracking

**Structure**:
```json
{
  "features": [
    {
      "id": "001",
      "description": "User authentication",
      "status": "pass|fail|pending",
      "priority": "high|medium|low",
      "dependencies": ["002", "003"]
    }
  ]
}
```

**Scale**: Over 200 discrete features in claude.ai clone example

**Critical Rule**:
> "It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality"

**GenCraft v3.0 Application**:
- Each document (00-07 + verticals) = feature list
- Each engine = feature list
- Each overlay = feature list
- Master feature list = 640+ documents × engines × overlays

### 2. Progress Tracking (`claude-progress.txt`)

**Purpose**: Execution logs for state recovery

**Contents**:
- Session timestamps
- Features attempted
- Test results
- Errors encountered
- Next steps

**Key Insight**:
> "Finding a way for agents to quickly understand the state of work when starting with a fresh context window"

**GenCraft v3.0 Application**:
- Each generation session = progress log
- State recovery after crashes
- Audit trail for quality assurance
- Training data for ML optimization

### 3. Git-Based State

**Purpose**: Clean rollback capability

**Workflow**:
1. One feature per commit
2. Descriptive commit messages
3. Mergeable code only
4. No half-implemented features

**GenCraft v3.0 Application**:
- Document versions tracked in git
- Content rollback for quality issues
- Collaboration across agents
- Historical analysis of improvements

### 4. Init Script (`init.sh`)

**Purpose**: Development server initialization

**GenCraft v3.0 Equivalent**: Auto-setup.sh pattern from Vibe Code

---

## Best Practices for Long-Running Agents

### Session Startup Protocol

**Mandatory Sequence**:
```bash
# 1. Verify working directory
pwd

# 2. Read state files
cat claude-progress.txt
git log --oneline -20

# 3. Select single highest-priority feature
# (from feature list JSON)

# 4. Run end-to-end validation BEFORE new work
npm test
# or browser automation checks
```

**GenCraft v3.0 Startup**:
```bash
# 1. Verify project context
pwd  # Should be in vertical/overlay directory

# 2. Read generation state
cat .gencraft-progress.json
git log --oneline -10

# 3. Select next document to generate
# (from 00-07 or vertical extensions)

# 4. Validate previous generation
npm run validate-document <last-generated>
```

### Incremental Progress Protocol

**Rules**:
- ✅ ONE feature per session
- ✅ Git-based state recovery
- ✅ Clean, mergeable code at session end
- ✅ No half-implemented features undocumented
- ❌ Never remove tests/features
- ❌ Never declare completion prematurely

**GenCraft v3.0 Adaptation**:
- ONE document per session (or logical chunk)
- Git commit after each document
- Validation before next document
- Progress tracking in JSON

---

## Critical Failure Modes & Solutions

### Failure Mode 1: Premature Project Completion

**Problem**: Agent declares "done" when work remains

**Anthropic Solution**: Feature list prevents false victory
- Agent must check ALL features
- JSON status must be "pass" for all
- Cannot remove features from list

**GenCraft v3.0 Solution**:
- 640+ document checklist (00-07 × verticals × overlays)
- Each document must pass validation
- Master status dashboard
- Cannot skip documents

### Failure Mode 2: Undocumented Progress/Bugs

**Problem**: Lost context between sessions

**Anthropic Solution**:
- Initial git repo creation
- Progress file with detailed logs
- Commit messages as documentation

**GenCraft v3.0 Solution**:
- `.gencraft-progress.json` per vertical
- Git history per vertical
- Validation reports in JSON
- Master index of all generations

### Failure Mode 3: Inadequate Testing

**Problem**: Unit tests miss integration bugs

**Anthropic Solution**:
> "Providing Claude with these kinds of testing tools dramatically improved performance"

**Tools Used**:
- Browser automation (Puppeteer MCP)
- End-to-end validation
- Visual regression testing

**GenCraft v3.0 Solution**:
- Document validation engine
- Content quality scoring
- Cross-document consistency checks
- User testing simulation

### Failure Mode 4: Setup Confusion

**Problem**: Agent wastes time on environment setup

**Anthropic Solution**: Pre-written `init.sh` script

**GenCraft v3.0 Solution**:
- Auto-setup.sh per vertical (from Vibe Code)
- Environment detection
- Dependency auto-installation
- Zero configuration required

---

## Testing Strategy

### Anthropic Approach

**Preference**: Browser automation > Unit tests

**Rationale**:
> "The agent was able to identify and fix bugs that weren't obvious from the code alone"

**Tools**:
- Puppeteer MCP (Model Context Protocol)
- End-to-end validation
- Visual inspection

**GenCraft v3.0 Application**:
- Content rendering in actual target platform
- User simulation for validation
- Quality scoring based on rendered output
- A/B testing of generated content

---

## Known Limitations

### Vision Limitations

**Problem**:
> "Vision limitations and browser automation constraints prevent detection of native alert modals"

**Impact**: Modal-dependent features prone to bugs

**GenCraft v3.0 Mitigation**:
- Avoid browser modals in generated content
- Use modern UI patterns (toast notifications, inline errors)
- Test in headless browsers with modal detection

---

## GenCraft v3.0 Integration Plan

### Architecture Mapping

| Anthropic Pattern | GenCraft v3.0 Implementation |
|-------------------|------------------------------|
| Initializer Agent | Project Setup Engine (creates vertical structure) |
| Coding Agent | Document Generation Engine (creates content) |
| Feature List JSON | 640+ Document Checklist + Validation Schema |
| claude-progress.txt | .gencraft-progress.json (per vertical) |
| Git History | Version control per vertical/overlay |
| init.sh | auto-setup.sh (from Vibe Code) |
| Browser Automation | Content Validation Engine |

### State Management Files (Per Vertical)

```
gencraft-v3.0/verticals/{vertical-name}/
├── .gencraft-progress.json         # Generation state
├── .feature-list.json               # 640+ documents status
├── .validation-reports/             # Quality scores
├── .git/                            # Version history
└── auto-setup.sh                    # Environment init
```

### Session Protocol

```bash
# 1. Start generation session
cd gencraft-v3.0/verticals/bizcraft
pwd

# 2. Load state
cat .gencraft-progress.json
git log --oneline -10

# 3. Select next document
# Returns: "00_master_instructions.md - Status: pending"

# 4. Generate document
./generate-document.sh 00_master_instructions.md

# 5. Validate
./validate-document.sh 00_master_instructions.md

# 6. Commit if valid
git add 00_master_instructions.md
git commit -m "Generated 00_master_instructions for BizCraft"

# 7. Update progress
./update-progress.sh --document 00_master_instructions.md --status pass
```

---

## Key Takeaways for GenCraft v3.0

1. **Two-Agent Architecture**: Separate initialization from incremental work
2. **JSON-based Feature Tracking**: 640+ documents = feature list
3. **Progress Persistence**: State recovery across sessions
4. **Git-based Rollback**: Clean state management
5. **End-to-End Testing**: Validate in real environment
6. **One Feature Per Session**: Incremental progress
7. **Never Remove Features**: Maintain complete checklist

---

## Status

- **Retrieved**: ✅ COMPLETE
- **Analyzed**: ✅ COMPLETE
- **Applied to GenCraft v3.0**: ✅ Architecture designed
- **Ready for Implementation**: ✅ YES

**Next**: Implement two-agent architecture in GenCraft v3.0 Phase 2
