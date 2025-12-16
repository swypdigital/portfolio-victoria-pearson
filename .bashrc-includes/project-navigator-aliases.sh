#!/bin/bash
# Project Navigator Shell Aliases
# Auto-loaded by claude-unified-startup.sh

# === PROJECT NAVIGATOR ALIASES ===

# Main project navigator TUI
alias pn='/mnt/c/Users/jdh/claude_projects/project-navigator.sh'
alias proj='pn'  # Short version

# Quick project navigation
alias goto-cp='cd /mnt/c/Users/jdh/claude_projects'
alias goto-iv='cd /mnt/c/Users/jdh/claude_projects/projects/github-repos/interviewplus-production'
alias goto-gc='cd /mnt/c/Users/jdh/claude_projects/gencraft-v3.0'
alias goto-tc='cd /mnt/c/Users/jdh/claude_projects/token-cost-calculator'

# Project info shortcuts
alias proj-status='for dir in /mnt/c/Users/jdh/claude_projects/projects/github-repos/*/; do echo "=== $(basename $dir) ===" && cd "$dir" && git status -sb && cd /mnt/c/Users/jdh/claude_projects; done'
alias proj-list='find /mnt/c/Users/jdh/claude_projects -name ".git" -type d | sed "s|/.git||" | sed "s|/mnt/c/Users/jdh/claude_projects/||" | sort'

# Worktree shortcuts
alias wt='/mnt/c/Users/jdh/claude_projects/worktree-commands.sh'
alias wt-list='git worktree list'
alias wt-status='/mnt/c/Users/jdh/claude_projects/worktree-session-mapper.sh status'
