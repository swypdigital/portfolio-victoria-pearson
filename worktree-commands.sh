#!/bin/bash
# Auto-added contractual paths support
if [[ -z "$CONTRACTUAL_PATHS_LOADED" ]]; then
    for dir in "$(dirname "$0")" "${CLAUDE_PROJECTS_ROOT:-${CLAUDE_PROJECTS_ROOT}}" "${CLAUDE_PROJECTS_ROOT}"; do
        [[ -f "$dir/contractual-paths-true.sh" ]] && source "$dir/contractual-paths-true.sh" && break
        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break
    done
fi

# WORKTREE COMMANDS - User-Friendly CLI Interface
# Author: groklyGroup™ LLC
# Purpose: Simple commands for git worktree management
# Part of: Claude OS Ecosystem

# Configuration
BASE_DIR="${CLAUDE_PROJECTS_ROOT}"
WORKTREE_SUPPORT="$BASE_DIR/projectcraft/worktree-support.sh"
MAPPER_SCRIPT="$BASE_DIR/worktree-session-mapper.sh"
AUTO_MANAGER="$BASE_DIR/worktree-auto-manager.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Helper function to show available commands
show_help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════╗
║                    GIT WORKTREE MANAGEMENT COMMANDS                       ║
║                      Part of Claude OS Ecosystem                          ║
╚══════════════════════════════════════════════════════════════════════════╝

BASIC COMMANDS:
  worktree-create [branch-name]        Create a new isolated worktree
  worktree-list                        List all active worktrees
  worktree-switch <session-id>         Switch to an existing worktree
  worktree-merge <session-id>          Merge worktree back to main branch
  worktree-remove <session-id>         Remove a worktree
  worktree-cleanup [hours]             Clean up stale worktrees (default: 24h)

ADVANCED COMMANDS:
  worktree-status                      Show detailed worktree status
  worktree-info <session-id>           Get detailed info about a worktree
  worktree-enable-auto                 Enable automatic worktree creation
  worktree-disable-auto                Disable automatic worktree creation

EXAMPLES:
  # Create a worktree for a new feature
  worktree-create feature/new-ui

  # List all your worktrees
  worktree-list

  # Switch to a worktree
  worktree-switch claude-proj-1234567

  # Clean up old worktrees
  worktree-cleanup 48

  # Enable auto-creation (for concurrent sessions)
  worktree-enable-auto

WHEN TO USE WORKTREES:
  ✅ Working on multiple branches simultaneously
  ✅ Reviewing code while continuing your feature work
  ✅ Long-running experiments without losing main work
  ✅ Comparing different implementations side-by-side

  ❌ Sequential work (use git checkout instead)
  ❌ Switching between different projects (just cd to the project)
  ❌ Daily feature development (branches are simpler)

MORE INFO:
  Read: $BASE_DIR/WORKTREE_SYSTEM_EXPLAINED.md
  Read: $BASE_DIR/GIT_CHECKOUT_EXPLAINED.md

EOF
}

# Export these as shell functions for interactive use
worktree-create() {
    local branch_name="${1:-worktree-$(date +%Y%m%d-%H%M%S)}"
    local session_id="${CLAUDE_SESSION_ID:-claude-manual-$(date +%s)}"

    echo -e "${CYAN}🔨 Creating isolated worktree...${NC}"
    echo -e "   Branch: ${BOLD}$branch_name${NC}"

    if [[ -x "$WORKTREE_SUPPORT" ]]; then
        local worktree_path=$("$WORKTREE_SUPPORT" create "$session_id" "$branch_name")

        if [[ $? -eq 0 && -n "$worktree_path" ]]; then
            echo -e "${GREEN}✅ Worktree created successfully!${NC}"
            echo -e "${CYAN}   Path: $worktree_path${NC}"
            echo -e ""
            echo -e "${YELLOW}To switch to this worktree:${NC}"
            echo -e "   cd $worktree_path"
            echo -e ""
            echo -e "${YELLOW}When done, merge changes back:${NC}"
            echo -e "   worktree-merge $session_id"
        else
            echo -e "${RED}❌ Failed to create worktree${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ Error: worktree-support.sh not found${NC}"
        return 1
    fi
}

worktree-list() {
    echo -e "${CYAN}📊 Active Worktrees:${NC}"
    echo ""

    if [[ -x "$MAPPER_SCRIPT" ]]; then
        "$MAPPER_SCRIPT" list
    else
        # Fallback to git worktree list
        git worktree list
    fi

    echo ""
    echo -e "${YELLOW}Tip: Use 'worktree-info <session-id>' for details${NC}"
}

worktree-switch() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        echo -e "${RED}❌ Error: session_id required${NC}"
        echo "Usage: worktree-switch <session-id>"
        return 1
    fi

    if [[ -x "$MAPPER_SCRIPT" ]]; then
        local worktree_path=$("$MAPPER_SCRIPT" get "$session_id")

        if [[ -n "$worktree_path" && -d "$worktree_path" ]]; then
            echo -e "${GREEN}✓ Switching to worktree: $worktree_path${NC}"
            cd "$worktree_path"
        else
            echo -e "${RED}❌ Worktree not found for session: $session_id${NC}"
            echo -e "${YELLOW}Use 'worktree-list' to see available worktrees${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ Error: worktree-session-mapper.sh not found${NC}"
        return 1
    fi
}

worktree-merge() {
    local session_id="$1"
    local delete_after="${2:-false}"

    if [[ -z "$session_id" ]]; then
        echo -e "${RED}❌ Error: session_id required${NC}"
        echo "Usage: worktree-merge <session-id> [delete:true/false]"
        return 1
    fi

    if [[ -x "$AUTO_MANAGER" ]]; then
        "$AUTO_MANAGER" merge-back "$session_id" "$delete_after"
    else
        echo -e "${RED}❌ Error: worktree-auto-manager.sh not found${NC}"
        return 1
    fi
}

worktree-remove() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        echo -e "${RED}❌ Error: session_id required${NC}"
        echo "Usage: worktree-remove <session-id>"
        return 1
    fi

    if [[ -x "$MAPPER_SCRIPT" ]]; then
        local worktree_path=$("$MAPPER_SCRIPT" get "$session_id")

        if [[ -n "$worktree_path" ]]; then
            echo -e "${YELLOW}⚠️  Removing worktree: $worktree_path${NC}"
            git worktree remove "$worktree_path" || git worktree remove --force "$worktree_path"

            if [[ $? -eq 0 ]]; then
                "$MAPPER_SCRIPT" archive "$session_id" "manual_removal"
                echo -e "${GREEN}✅ Worktree removed successfully${NC}"
            else
                echo -e "${RED}❌ Failed to remove worktree${NC}"
                return 1
            fi
        else
            echo -e "${RED}❌ Worktree not found for session: $session_id${NC}"
            return 1
        fi
    fi
}

worktree-cleanup() {
    local hours="${1:-24}"

    echo -e "${CYAN}🧹 Cleaning up stale worktrees (inactive > ${hours}h)...${NC}"
    echo ""

    if [[ -x "$MAPPER_SCRIPT" ]]; then
        # Dry run first
        echo -e "${YELLOW}Preview (dry run):${NC}"
        "$MAPPER_SCRIPT" cleanup "$hours" true

        echo ""
        read -p "Proceed with cleanup? (y/N): " confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            "$MAPPER_SCRIPT" cleanup "$hours" false
            echo -e "${GREEN}✅ Cleanup complete${NC}"
        else
            echo -e "${YELLOW}ℹ️  Cleanup cancelled${NC}"
        fi
    else
        echo -e "${RED}❌ Error: worktree-session-mapper.sh not found${NC}"
        return 1
    fi
}

worktree-status() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                         WORKTREE SYSTEM STATUS                           ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Auto-detection status
    if [[ "${WORKTREE_AUTO_DETECT:-0}" == "1" ]]; then
        echo -e "${GREEN}✓ Auto-detection: ENABLED${NC}"
    else
        echo -e "${YELLOW}○ Auto-detection: DISABLED${NC}"
    fi

    echo ""

    # Current worktree
    if [[ "${CLAUDE_USING_WORKTREE}" == "true" ]]; then
        echo -e "${GREEN}✓ Currently in worktree:${NC}"
        echo -e "  ${CYAN}$CLAUDE_WORKTREE${NC}"
    else
        echo -e "${GREEN}✓ Currently in main repository${NC}"
    fi

    echo ""
    echo -e "${CYAN}Active Worktrees:${NC}"
    git worktree list

    echo ""
    if [[ -x "$MAPPER_SCRIPT" ]]; then
        local active_count=$("$MAPPER_SCRIPT" list simple 2>/dev/null | wc -l)
        echo -e "Total active worktrees in database: ${BOLD}$active_count${NC}"
    fi

    echo ""
}

worktree-info() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        echo -e "${RED}❌ Error: session_id required${NC}"
        echo "Usage: worktree-info <session-id>"
        return 1
    fi

    if [[ -x "$MAPPER_SCRIPT" ]]; then
        "$MAPPER_SCRIPT" info "$session_id"
    else
        echo -e "${RED}❌ Error: worktree-session-mapper.sh not found${NC}"
        return 1
    fi
}

worktree-enable-auto() {
    echo -e "${CYAN}🔧 Enabling automatic worktree creation...${NC}"
    export WORKTREE_AUTO_DETECT=1

    # Add to .bashrc for persistence
    if ! grep -q "WORKTREE_AUTO_DETECT=1" ~/.bashrc 2>/dev/null; then
        echo "" >> ~/.bashrc
        echo "# Enable automatic worktree creation for concurrent sessions" >> ~/.bashrc
        echo "export WORKTREE_AUTO_DETECT=1" >> ~/.bashrc
        echo -e "${GREEN}✅ Auto-detection enabled and saved to ~/.bashrc${NC}"
    else
        echo -e "${GREEN}✅ Auto-detection enabled (already in ~/.bashrc)${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Note: This will create worktrees automatically when concurrent sessions are detected.${NC}"
    echo -e "${YELLOW}To disable: worktree-disable-auto${NC}"
}

worktree-disable-auto() {
    echo -e "${CYAN}🔧 Disabling automatic worktree creation...${NC}"
    export WORKTREE_AUTO_DETECT=0

    # Remove from .bashrc
    if grep -q "WORKTREE_AUTO_DETECT=1" ~/.bashrc 2>/dev/null; then
        sed -i '/WORKTREE_AUTO_DETECT=1/d' ~/.bashrc
        sed -i '/Enable automatic worktree creation/d' ~/.bashrc
        echo -e "${GREEN}✅ Auto-detection disabled and removed from ~/.bashrc${NC}"
    else
        echo -e "${GREEN}✅ Auto-detection disabled${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Note: You can still use worktrees manually with 'worktree-create'${NC}"
}

# Export functions for interactive shell use
export -f worktree-create
export -f worktree-list
export -f worktree-switch
export -f worktree-merge
export -f worktree-remove
export -f worktree-cleanup
export -f worktree-status
export -f worktree-info
export -f worktree-enable-auto
export -f worktree-disable-auto

# Main command dispatcher (when script is executed directly)
main() {
    local command="$1"
    shift

    case "$command" in
        create)
            worktree-create "$@"
            ;;
        list)
            worktree-list "$@"
            ;;
        switch)
            worktree-switch "$@"
            ;;
        merge)
            worktree-merge "$@"
            ;;
        remove)
            worktree-remove "$@"
            ;;
        cleanup)
            worktree-cleanup "$@"
            ;;
        status)
            worktree-status "$@"
            ;;
        info)
            worktree-info "$@"
            ;;
        enable-auto)
            worktree-enable-auto
            ;;
        disable-auto)
            worktree-disable-auto
            ;;
        help|--help|-h|"")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Unknown command: $command${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
