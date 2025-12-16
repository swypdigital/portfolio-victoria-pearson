#!/bin/bash
# Auto-added contractual paths support
if [[ -z "$CONTRACTUAL_PATHS_LOADED" ]]; then
    for dir in "$(dirname "$0")" "${CLAUDE_PROJECTS_ROOT:-${CLAUDE_PROJECTS_ROOT}}" "${CLAUDE_PROJECTS_ROOT}"; do
        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break
    done
fi

# WORKTREE AUTO-MANAGER
# Author: groklyGroup™ LLC
# Purpose: Automatic concurrent session detection and worktree creation
# Part of Phase 7: Git Worktrees Automation

# Configuration
BASE_DIR="${CLAUDE_PROJECTS_ROOT}"
WORKTREE_SUPPORT="$BASE_DIR/projectcraft/worktree-support.sh"
MAPPER_SCRIPT="$BASE_DIR/worktree-session-mapper.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
log() {
    echo -e "$1"
}

# Detect concurrent Claude Code sessions
detect_concurrent_sessions() {
    local current_session_id="${CLAUDE_SESSION_ID:-}"
    local current_tmux="${TMUX:-}"

    log "${CYAN}🔍 Detecting concurrent sessions...${NC}"

    # Method 1: Check for other TMUX sessions with claude_projects
    local tmux_sessions=$(tmux list-sessions 2>/dev/null | grep -c "claude.*claude_projects" || echo "0")

    # Method 2: Check for active git processes from other sessions
    local git_locks=$(find "$BASE_DIR/.git" -name "index.lock" 2>/dev/null | wc -l)

    # Method 3: Check registered active worktrees
    local active_worktrees=0
    if [[ -x "$MAPPER_SCRIPT" ]]; then
        active_worktrees=$(source "$MAPPER_SCRIPT" && sqlite3 "$REGISTRY_DB" "SELECT COUNT(*) FROM worktree_registry WHERE status='active';" 2>/dev/null || echo "0")
    fi

    # Method 4: Check for other daemon-supervisor instances
    local supervisor_count=$(pgrep -f "daemon-supervisor.*start" | wc -l)

    log "   TMUX sessions: $tmux_sessions"
    log "   Git locks: $git_locks"
    log "   Active worktrees: $active_worktrees"
    log "   Daemon supervisors: $supervisor_count"

    # Determine if concurrent
    local is_concurrent=false

    # If more than 1 TMUX session OR active worktrees exist, we have concurrent sessions
    if [[ $tmux_sessions -gt 1 ]] || [[ $active_worktrees -gt 0 ]]; then
        is_concurrent=true
        log "${YELLOW}⚠️  Concurrent sessions detected${NC}"
    else
        log "${GREEN}✓ No concurrent sessions detected${NC}"
    fi

    # Return result
    if [[ "$is_concurrent" == "true" ]]; then
        return 0  # Concurrent detected
    else
        return 1  # No concurrent
    fi
}

# Auto-create worktree if needed
auto_create_worktree() {
    local session_id="$1"
    local project_name="${2:-claude_projects}"

    if [[ -z "$session_id" ]]; then
        log "${RED}❌ Error: session_id required${NC}"
        return 1
    fi

    # Check if already has worktree
    if [[ -x "$MAPPER_SCRIPT" ]]; then
        source "$MAPPER_SCRIPT"
        if has_worktree "$session_id" 2>/dev/null; then
            local existing_path=$(get_worktree "$session_id")
            log "${GREEN}✓ Session already has worktree: $existing_path${NC}"
            echo "$existing_path"
            return 0
        fi
    fi

    log "${CYAN}🔨 Auto-creating worktree for session: $session_id${NC}"

    # Generate branch name
    local branch_name="worktree-$(date +%Y%m%d-%H%M%S)-${session_id##*-}"

    # Create worktree
    if [[ -x "$WORKTREE_SUPPORT" ]]; then
        local worktree_path=$("$WORKTREE_SUPPORT" create "$session_id" "$branch_name" "$project_name")

        if [[ $? -eq 0 && -n "$worktree_path" ]]; then
            log "${GREEN}✅ Auto-created worktree: $worktree_path${NC}"
            echo "$worktree_path"
            return 0
        else
            log "${RED}❌ Failed to auto-create worktree${NC}"
            return 1
        fi
    else
        log "${RED}❌ worktree-support.sh not found${NC}"
        return 1
    fi
}

# Decide if worktree should be used
should_use_worktree() {
    local session_id="$1"
    local force="${2:-false}"

    # If force enabled, always use worktree
    if [[ "$force" == "true" ]]; then
        log "${CYAN}ℹ️  Force mode: Using worktree${NC}"
        return 0
    fi

    # Detect concurrent sessions
    if detect_concurrent_sessions; then
        log "${CYAN}ℹ️  Concurrent sessions detected: Using worktree${NC}"
        return 0
    else
        log "${CYAN}ℹ️  No concurrent sessions: Using main repository${NC}"
        return 1
    fi
}

# Merge worktree back to main branch
merge_worktree_back() {
    local session_id="$1"
    local delete_after="${2:-false}"

    if [[ -z "$session_id" ]]; then
        log "${RED}❌ Error: session_id required${NC}"
        return 1
    fi

    log "${CYAN}🔀 Merging worktree back to main...${NC}"

    # Get worktree info
    if [[ ! -x "$MAPPER_SCRIPT" ]]; then
        log "${RED}❌ worktree-session-mapper.sh not found${NC}"
        return 1
    fi

    source "$MAPPER_SCRIPT"

    local worktree_path=$(get_worktree "$session_id")
    if [[ -z "$worktree_path" ]]; then
        log "${YELLOW}⚠️  No worktree found for session: $session_id${NC}"
        return 1
    fi

    # Get branch name
    local branch_name=$(sqlite3 "$REGISTRY_DB" "SELECT branch_name FROM worktree_registry WHERE session_id='$session_id' AND status='active' LIMIT 1;")

    if [[ -z "$branch_name" ]]; then
        log "${RED}❌ Failed to get branch name${NC}"
        return 1
    fi

    log "   Worktree path: $worktree_path"
    log "   Branch: $branch_name"

    # Check if worktree has commits
    cd "$worktree_path" || return 1

    local has_commits=$(git log main.."$branch_name" --oneline | wc -l)

    if [[ $has_commits -eq 0 ]]; then
        log "${YELLOW}⚠️  No commits to merge${NC}"

        if [[ "$delete_after" == "true" && -x "$WORKTREE_SUPPORT" ]]; then
            "$WORKTREE_SUPPORT" close "$session_id"
        fi

        return 0
    fi

    log "${CYAN}📝 Found $has_commits commit(s) to merge${NC}"

    # Switch to main repo
    cd "$BASE_DIR" || return 1

    # Get current branch
    local current_branch=$(git branch --show-current)

    # Checkout main (or current branch if not in worktree)
    if [[ "$current_branch" == "$branch_name" ]]; then
        log "${CYAN}📌 Switching to main branch...${NC}"
        git checkout main || {
            log "${RED}❌ Failed to checkout main${NC}"
            return 1
        }
    fi

    # Merge worktree branch
    log "${CYAN}🔀 Merging $branch_name into main...${NC}"
    git merge "$branch_name" --no-ff -m "Merge worktree session: $session_id" || {
        log "${RED}❌ Merge failed - resolve conflicts manually${NC}"
        log "${YELLOW}⚠️  Run: git merge --abort  to cancel${NC}"
        log "${YELLOW}⚠️  Or resolve conflicts and commit${NC}"
        return 1
    }

    log "${GREEN}✅ Merge successful${NC}"

    # Delete worktree if requested
    if [[ "$delete_after" == "true" && -x "$WORKTREE_SUPPORT" ]]; then
        log "${CYAN}🗑️  Deleting worktree...${NC}"
        "$WORKTREE_SUPPORT" close "$session_id" "true"

        # Delete branch
        log "${CYAN}🗑️  Deleting branch: $branch_name${NC}"
        git branch -d "$branch_name" 2>/dev/null || git branch -D "$branch_name"
    fi

    return 0
}

# Cleanup stale worktrees
cleanup_stale_worktrees() {
    local hours_threshold="${1:-24}"
    local auto_delete="${2:-false}"

    log "${CYAN}🧹 Cleaning up stale worktrees...${NC}"

    # Use worktree-support cleanup
    if [[ -x "$WORKTREE_SUPPORT" ]]; then
        if [[ "$auto_delete" == "true" ]]; then
            "$WORKTREE_SUPPORT" cleanup "$hours_threshold" "false"
        else
            "$WORKTREE_SUPPORT" cleanup "$hours_threshold" "true"
        fi
    else
        log "${RED}❌ worktree-support.sh not found${NC}"
        return 1
    fi
}

# Get recommended action for session
get_recommendation() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        log "${RED}❌ Error: session_id required${NC}"
        return 1
    fi

    log "${CYAN}💡 WORKTREE RECOMMENDATION:${NC}"
    log ""

    # Check if already has worktree
    if [[ -x "$MAPPER_SCRIPT" ]]; then
        source "$MAPPER_SCRIPT"
        if has_worktree "$session_id" 2>/dev/null; then
            local worktree_path=$(get_worktree "$session_id")
            log "${GREEN}✓ Already using worktree: $worktree_path${NC}"
            log "${CYAN}  Action: Continue in worktree${NC}"
            return 0
        fi
    fi

    # Detect concurrent
    if detect_concurrent_sessions; then
        log "${YELLOW}⚠️  Concurrent sessions detected${NC}"
        log "${CYAN}  Recommendation: CREATE worktree${NC}"
        log "${CYAN}  Reason: Prevents conflicts with other active sessions${NC}"
        return 0
    else
        log "${GREEN}✓ No concurrent sessions${NC}"
        log "${CYAN}  Recommendation: Use main repository${NC}"
        log "${CYAN}  Reason: No isolation needed${NC}"
        return 0
    fi
}

# Main command dispatcher
main() {
    local command="$1"
    shift

    case "$command" in
        detect)
            detect_concurrent_sessions
            ;;
        auto-create)
            auto_create_worktree "$@"
            ;;
        should-use)
            should_use_worktree "$@"
            ;;
        merge-back)
            merge_worktree_back "$@"
            ;;
        cleanup)
            cleanup_stale_worktrees "$@"
            ;;
        recommend)
            get_recommendation "$@"
            ;;
        *)
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  WORKTREE AUTO-MANAGER - Automatic Concurrent Session Management"
            echo "  Part of Phase 7: Git Worktrees Automation"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "Usage: $0 <command> [arguments]"
            echo ""
            echo "Commands:"
            echo "  detect                                  Detect concurrent sessions"
            echo "  auto-create <session_id> [project]      Auto-create worktree if needed"
            echo "  should-use <session_id> [force]         Check if worktree should be used"
            echo "  merge-back <session_id> [delete]        Merge worktree back to main"
            echo "  cleanup [hours] [auto_delete]           Cleanup stale worktrees"
            echo "  recommend <session_id>                  Get worktree recommendation"
            echo ""
            echo "Examples:"
            echo "  $0 detect"
            echo "  $0 auto-create claude-proj-123"
            echo "  $0 should-use claude-proj-123"
            echo "  $0 merge-back claude-proj-123 true"
            echo "  $0 recommend claude-proj-123"
            echo ""
            exit 1
            ;;
    esac
}

# Export functions for sourcing
export -f detect_concurrent_sessions
export -f auto_create_worktree
export -f should_use_worktree
export -f merge_worktree_back
export -f cleanup_stale_worktrees

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
