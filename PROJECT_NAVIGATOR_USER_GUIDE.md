# 📁 Project Navigator - User Guide
**Version**: 1.0.0
**Last Updated**: 2025-12-16
**Part of**: Claude OS Ecosystem

## 🎯 Overview

The Project Navigator is a dual-mode navigation system for managing multiple projects in the Claude Projects ecosystem:

1. **TUI Mode** (Terminal User Interface) - Beautiful interactive menus
2. **Shell Aliases** - Quick command-line shortcuts

---

## 🚀 Quick Start

### Option 1: Interactive TUI (Recommended for exploration)

```bash
# Launch the navigator
pn

# Or use the long form
proj
```

### Option 2: Quick Jumps (Recommended for speed)

```bash
# Jump to InterviewPlus Production
goto-iv

# Jump to GenCraft v3.0
goto-gc

# Jump to claude_projects root
goto-cp

# Jump to Token Calculator
goto-tc
```

---

## 📋 TUI Menu Structure

```
┌────────── Claude OS - Project Navigator ───────────┐
│                                                     │
│  Select a project to open:                         │
│                                                     │
│    1  📁 claude_projects (Infrastructure)          │
│    2  📁 InterviewPlus Production                  │
│    3  📁 GenCraft v3.0                             │
│    4  📁 Browse all projects                       │
│    5  🔧 Worktree Management                       │
│    6  📊 Git Status (All Projects)                 │
│    7  🚀 Start Menu                                │
│    8  ❌ Exit                                      │
│                                                     │
│        <Ok>              <Cancel>                  │
└─────────────────────────────────────────────────────┘
```

### Navigation:
- **Arrow Keys**: Move up/down through options
- **Enter**: Select highlighted option
- **Tab**: Switch between Ok/Cancel buttons
- **Esc**: Cancel and return to shell

---

## 🛠️ Available Aliases

### Main Navigator
| Alias | Command | Description |
|-------|---------|-------------|
| `pn` | Launch TUI | Open project navigator |
| `proj` | Launch TUI | Alias for `pn` |

### Quick Navigation
| Alias | Destination | Description |
|-------|-------------|-------------|
| `goto-cp` | claude_projects | Root directory |
| `goto-iv` | InterviewPlus Production | Main app project |
| `goto-gc` | GenCraft v3.0 | Content generation system |
| `goto-tc` | Token Calculator | Cost estimation tool |

### Project Info
| Alias | Function | Description |
|-------|----------|-------------|
| `proj-list` | List all projects | Find all git repositories |
| `proj-status` | Show all statuses | Git status for each project |

### Worktree Management
| Alias | Function | Description |
|-------|----------|-------------|
| `wt` | Worktree commands | Access worktree management |
| `wt-list` | List worktrees | Show all worktrees |
| `wt-status` | Worktree status | Detailed worktree info |

---

## 🔧 Installation

### For WSL/Bash

Aliases are automatically loaded from `.bashrc-includes/project-navigator-aliases.sh`.

**Manual loading:**
```bash
source /mnt/c/Users/jdh/claude_projects/.bashrc-includes/project-navigator-aliases.sh
```

**Add to ~/.bashrc permanently:**
```bash
echo "source /mnt/c/Users/jdh/claude_projects/.bashrc-includes/project-navigator-aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

### For PowerShell

**One-time load:**
```powershell
. C:\Users\jdh\claude_projects\project-navigator-aliases.ps1
```

**Add to PowerShell profile permanently:**
```powershell
# Edit your profile
notepad $PROFILE

# Add this line:
. C:\Users\jdh\claude_projects\project-navigator-aliases.ps1

# Reload profile
. $PROFILE
```

---

## 📖 Usage Examples

### Example 1: Browse and Select

```bash
$ pn
# Interactive menu appears
# Use arrow keys to select "InterviewPlus Production"
# Press Enter
# You're now in: /mnt/c/Users/jdh/claude_projects/projects/github-repos/interviewplus-production
```

### Example 2: Quick Jump

```bash
$ goto-iv
$ pwd
/mnt/c/Users/jdh/claude_projects/projects/github-repos/interviewplus-production

$ goto-gc
$ pwd
/mnt/c/Users/jdh/claude_projects/gencraft-v3.0
```

### Example 3: Check All Project Statuses

```bash
$ proj-status
=== interviewplus-production ===
## master...origin/master [ahead 2]
 M src/components/Dashboard.tsx
 M package.json

=== gencraft-v3.0 ===
## main
nothing to commit, working tree clean

=== token-cost-calculator ===
## main...origin/main
 M README.md
```

### Example 4: List All Projects

```bash
$ proj-list
gencraft-v2.0
gencraft-v3.0
projects/github-repos/interviewplus-production
projects/github-repos/token-cost-calculator
vibesdk
```

### Example 5: Worktree Management

```bash
$ wt-list
/mnt/c/Users/jdh/claude_projects                        3daf4d3 [database-consolidation-20251207]
/mnt/c/Users/jdh/claude_projects/.worktrees/feature-1  a1b2c3d [feature-1]

$ wt create feature-new-nav
Creating worktree at .worktrees/feature-new-nav
Switched to branch 'feature-new-nav'
```

---

## 🎨 TUI Features

### 1. Project Details View
When you select a project, you see:
- 📂 Full path
- 🌿 Current branch
- 🔗 Remote repository URL
- 📝 Number of changed files

**Available actions:**
1. Open in terminal (cd to project)
2. Show file tree
3. Show git status
4. Search files
5. Back to menu

### 2. Browse All Projects
- Auto-discovers all git repositories
- Shows first 20 projects
- Displays relative paths
- Navigate to any project

### 3. Worktree Management
- List all worktrees
- Create new worktrees
- Show worktree status
- Cleanup stale worktrees

### 4. Git Status (All Projects)
- Shows status for up to 10 projects
- Displays:
  - Current branch
  - Number of changes
  - Number of unpushed commits

---

## 🔍 Troubleshooting

### Issue: "Command not found: pn"

**Solution:**
```bash
# Check if aliases are loaded
alias | grep pn

# If not, reload:
source /mnt/c/Users/jdh/claude_projects/.bashrc-includes/project-navigator-aliases.sh
```

### Issue: "whiptail: not found"

**Solution:**
```bash
# Install whiptail (required for TUI)
sudo apt-get update
sudo apt-get install whiptail
```

### Issue: TUI menu not displaying properly

**Solution:**
- Ensure terminal supports ANSI colors
- Try running in full-screen terminal
- Check terminal size: `echo $COLUMNS $LINES` (should be > 80x24)

### Issue: Permission denied when running pn

**Solution:**
```bash
# Make script executable
chmod +x /mnt/c/Users/jdh/claude_projects/project-navigator.sh
```

---

## 🔗 Integration

### With Start Menu

Project Navigator is integrated into `claude-unified-startup.sh`:
- Option 7 in main TUI menu
- Launches Project Navigator

### With Worktree System

- Seamless integration with worktree-commands.sh
- Access worktree features from TUI menu
- Use `wt` alias for command-line worktree management

### With Claude Code

**Current**: Manual navigation via aliases

**Future** (Phase 2): MCP server integration
- Claude can navigate projects programmatically
- Natural language commands: "go to InterviewPlus"
- Automatic project context loading

---

## 📊 Keyboard Shortcuts Cheat Sheet

```
┌─────────────────────────────────────────┐
│  PROJECT NAVIGATOR - KEYBOARD SHORTCUTS │
├─────────────────────────────────────────┤
│                                         │
│  TUI NAVIGATION:                        │
│    ↑/↓         Move selection           │
│    Enter       Select/Confirm           │
│    Esc         Cancel/Back              │
│    Tab         Switch button focus      │
│                                         │
│  SHELL ALIASES:                         │
│    pn          Launch navigator         │
│    goto-iv     → InterviewPlus          │
│    goto-gc     → GenCraft v3.0          │
│    goto-cp     → claude_projects        │
│    proj-list   Show all projects        │
│    proj-status Git status (all)         │
│                                         │
│  WORKTREE:                              │
│    wt          Worktree commands        │
│    wt-list     List worktrees           │
│                                         │
└─────────────────────────────────────────┘
```

---

## 🚀 Advanced Usage

### Custom Aliases

Add your own project shortcuts to `.bashrc-includes/project-navigator-aliases.sh`:

```bash
# Add your own projects
alias goto-myproject='cd /mnt/c/Users/jdh/claude_projects/my-project'
alias goto-work='cd /mnt/c/Users/jdh/claude_projects/work-stuff'
```

### Integrating with tmux

```bash
# Create tmux session for project
goto-iv
tmux new-session -s interviewplus

# Navigate between projects in different tmux windows
# Window 1: InterviewPlus (goto-iv)
# Window 2: GenCraft (goto-gc)
# Window 3: Infrastructure (goto-cp)
```

### Combining with Git Workflows

```bash
# Quick workflow: jump to project, create feature branch
goto-iv
git checkout -b feature/new-dashboard
git push -u origin feature/new-dashboard

# Or use worktree for parallel work
cd /mnt/c/Users/jdh/claude_projects
wt create feature/experimental-ui
cd .worktrees/feature/experimental-ui
```

---

## 📝 File Locations

| File | Path | Purpose |
|------|------|---------|
| Main script | `project-navigator.sh` | TUI navigator |
| Bash aliases | `.bashrc-includes/project-navigator-aliases.sh` | WSL/Bash shortcuts |
| PowerShell aliases | `project-navigator-aliases.ps1` | Windows shortcuts |
| Worktree manager | `worktree-auto-manager.sh` | Worktree operations |
| User guide | `PROJECT_NAVIGATOR_USER_GUIDE.md` | This document |

---

## 🎯 Tips & Best Practices

1. **Use TUI for exploration**, aliases for speed
2. **Bookmark frequently used projects** with custom aliases
3. **Check `proj-status` before starting work** to see changes across all projects
4. **Use worktrees for parallel feature development** instead of branch switching
5. **Combine with tmux** for ultimate productivity

---

## 🔮 Coming Soon (Phase 2: MCP Integration)

- **Natural language navigation**: "Claude, take me to InterviewPlus"
- **Automatic context switching**: Claude knows which project you're in
- **Programmatic project discovery**: Claude can list and analyze all projects
- **Rich project information**: Git status, recent commits, file changes

---

## 📞 Support

**Documentation**: `/mnt/c/Users/jdh/claude_projects/PROJECT_NAVIGATOR_USER_GUIDE.md`
**Issues**: Check quantum TODO system or create session handoff notes
**Updates**: Check git history for project-navigator.sh

---

**Happy Navigating! 🚀**
