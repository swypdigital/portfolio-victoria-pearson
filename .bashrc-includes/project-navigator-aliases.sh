#!/bin/bash
# Project Navigator Shell Aliases
# Auto-loaded by claude-unified-startup.sh

# === PROJECT NAVIGATOR ALIASES ===

# Main project navigator TUI
alias pn='$CLAUDE_PROJECTS_ROOT/project-navigator.sh'
alias proj='pn'  # Short version

# Quick project navigation
alias goto-cp='cd $CLAUDE_PROJECTS_ROOT'
alias goto-iv='cd $CLAUDE_PROJECTS_ROOT/projects/github-repos/interviewplus-production'
alias goto-gc='cd $CLAUDE_PROJECTS_ROOT/gencraft'
alias goto-tc='cd $CLAUDE_PROJECTS_ROOT/token-cost-calculator'

# Project info shortcuts
alias proj-status='for dir in $CLAUDE_PROJECTS_ROOT/projects/github-repos/*/; do echo "=== $(basename $dir) ===" && cd "$dir" && git status -sb && cd $CLAUDE_PROJECTS_ROOT; done'
alias proj-list='find $CLAUDE_PROJECTS_ROOT -name ".git" -type d | sed "s|/.git||" | sed "s|$CLAUDE_PROJECTS_ROOT/||" | sort'

# Worktree shortcuts
alias wt='$CLAUDE_PROJECTS_ROOT/worktree-commands.sh'
alias wt-list='git worktree list'
alias wt-status='$CLAUDE_PROJECTS_ROOT/worktree-session-mapper.sh status'
