#!/bin/bash
# Auto-added contractual paths support
if [[ -z "$CONTRACTUAL_PATHS_LOADED" ]]; then
    for dir in "$(dirname "$0")" "${CLAUDE_PROJECTS_ROOT:-${CLAUDE_PROJECTS_ROOT}}" "${CLAUDE_PROJECTS_ROOT}"; do
        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break
    done
fi

# WORKTREE SESSION MAPPER
# Author: groklyGroup™ LLC
# Purpose: SQLite database for session→worktree mapping and tracking
# Part of Phase 7: Git Worktrees Automation

# Configuration
BASE_DIR="${CLAUDE_PROJECTS_ROOT}"
WORKTREE_DIR="$BASE_DIR/.worktrees"
REGISTRY_DB="$WORKTREE_DIR/registry.db"
ACTIVE_DIR="$WORKTREE_DIR/active"
ARCHIVE_DIR="$WORKTREE_DIR/archive"
LOG_FILE="$WORKTREE_DIR/mapper.log"

# Ensure directories exist
mkdir -p "$ACTIVE_DIR" "$ARCHIVE_DIR"

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Initialize database schema
init_database() {
    sqlite3 "$REGISTRY_DB" <<'SQL'
CREATE TABLE IF NOT EXISTS worktree_registry (
    session_id TEXT PRIMARY KEY,
    worktree_path TEXT NOT NULL,
    branch_name TEXT NOT NULL,
    created_at TEXT NOT NULL,
    last_active TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    project_name TEXT,
    tmux_session TEXT,
    pid INTEGER,
    metadata TEXT
);

CREATE TABLE IF NOT EXISTS worktree_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    event_type TEXT NOT NULL,
    event_data TEXT,
    timestamp TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_session_id ON worktree_registry(session_id);
CREATE INDEX IF NOT EXISTS idx_status ON worktree_registry(status);
CREATE INDEX IF NOT EXISTS idx_created_at ON worktree_registry(created_at);
SQL

    if [[ $? -eq 0 ]]; then
        log "✅ Database initialized: $REGISTRY_DB"
        return 0
    else
        log "❌ Failed to initialize database"
        return 1
    fi
}

# Register a new worktree
register_worktree() {
    local session_id="$1"
    local worktree_path="$2"
    local branch_name="$3"
    local project_name="${4:-unknown}"
    local tmux_session="${5:-}"

    if [[ -z "$session_id" || -z "$worktree_path" || -z "$branch_name" ]]; then
        log "❌ register_worktree: Missing required parameters"
        echo "Usage: register_worktree <session_id> <worktree_path> <branch_name> [project_name] [tmux_session]"
        return 1
    fi

    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

    # Insert into database
    sqlite3 "$REGISTRY_DB" <<SQL
INSERT OR REPLACE INTO worktree_registry
(session_id, worktree_path, branch_name, created_at, last_active, status, project_name, tmux_session, pid)
VALUES
('$session_id', '$worktree_path', '$branch_name', '$timestamp', '$timestamp', 'active', '$project_name', '$tmux_session', $$);

INSERT INTO worktree_history (session_id, event_type, event_data, timestamp)
VALUES ('$session_id', 'created', 'worktree=$worktree_path branch=$branch_name', '$timestamp');
SQL

    if [[ $? -eq 0 ]]; then
        # Create marker file
        cat > "$ACTIVE_DIR/$session_id" <<MARKER
SESSION_ID=$session_id
WORKTREE_PATH=$worktree_path
BRANCH_NAME=$branch_name
CREATED_AT=$timestamp
PROJECT_NAME=$project_name
TMUX_SESSION=$tmux_session
PID=$$
MARKER

        log "✅ Registered worktree: $session_id → $worktree_path"
        return 0
    else
        log "❌ Failed to register worktree: $session_id"
        return 1
    fi
}

# Get worktree path for a session
get_worktree() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        log "❌ get_worktree: Missing session_id"
        return 1
    fi

    local worktree_path=$(sqlite3 "$REGISTRY_DB" "SELECT worktree_path FROM worktree_registry WHERE session_id='$session_id' AND status='active' LIMIT 1;")

    if [[ -n "$worktree_path" ]]; then
        echo "$worktree_path"
        return 0
    else
        log "⚠️  No active worktree found for session: $session_id"
        return 1
    fi
}

# List all active worktrees
list_active_worktrees() {
    local format="${1:-table}"  # table, json, or simple

    if [[ "$format" == "json" ]]; then
        sqlite3 "$REGISTRY_DB" <<'SQL'
.mode json
SELECT session_id, worktree_path, branch_name, created_at, last_active, tmux_session
FROM worktree_registry
WHERE status='active'
ORDER BY created_at DESC;
SQL
    elif [[ "$format" == "simple" ]]; then
        sqlite3 "$REGISTRY_DB" <<'SQL'
.mode list
SELECT session_id || '|' || worktree_path || '|' || branch_name
FROM worktree_registry
WHERE status='active'
ORDER BY created_at DESC;
SQL
    else
        echo ""
        echo "📊 ACTIVE WORKTREES:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        sqlite3 "$REGISTRY_DB" <<'SQL'
.mode column
.headers on
.width 40 50 30 25
SELECT
    session_id as "Session ID",
    worktree_path as "Worktree Path",
    branch_name as "Branch",
    created_at as "Created At"
FROM worktree_registry
WHERE status='active'
ORDER BY created_at DESC;
SQL
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    fi
}

# List all worktrees (including archived)
list_all_worktrees() {
    echo ""
    echo "📊 ALL WORKTREES (ACTIVE + ARCHIVED):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sqlite3 "$REGISTRY_DB" <<'SQL'
.mode column
.headers on
.width 40 50 30 10 25
SELECT
    session_id as "Session ID",
    worktree_path as "Worktree Path",
    branch_name as "Branch",
    status as "Status",
    last_active as "Last Active"
FROM worktree_registry
ORDER BY last_active DESC;
SQL
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Update last active timestamp
touch_worktree() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        log "❌ touch_worktree: Missing session_id"
        return 1
    fi

    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

    sqlite3 "$REGISTRY_DB" "UPDATE worktree_registry SET last_active='$timestamp' WHERE session_id='$session_id';"

    if [[ $? -eq 0 ]]; then
        log "✅ Updated last_active for session: $session_id"
        return 0
    else
        log "❌ Failed to update last_active for session: $session_id"
        return 1
    fi
}

# Mark worktree as archived
archive_worktree() {
    local session_id="$1"
    local reason="${2:-manual_cleanup}"

    if [[ -z "$session_id" ]]; then
        log "❌ archive_worktree: Missing session_id"
        return 1
    fi

    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

    # Update database
    sqlite3 "$REGISTRY_DB" <<SQL
UPDATE worktree_registry SET status='archived' WHERE session_id='$session_id';
INSERT INTO worktree_history (session_id, event_type, event_data, timestamp)
VALUES ('$session_id', 'archived', '$reason', '$timestamp');
SQL

    # Move marker file
    if [[ -f "$ACTIVE_DIR/$session_id" ]]; then
        mv "$ACTIVE_DIR/$session_id" "$ARCHIVE_DIR/$session_id.$(date +%s)"
    fi

    log "✅ Archived worktree: $session_id (reason: $reason)"
    return 0
}

# Clean up stale worktrees (not active for >24 hours)
cleanup_stale_worktrees() {
    local hours_threshold="${1:-24}"
    local dry_run="${2:-false}"

    log "🔍 Scanning for stale worktrees (inactive > ${hours_threshold}h)..."

    # Find stale worktrees
    local cutoff_time=$(date -u -d "$hours_threshold hours ago" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v-${hours_threshold}H '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)

    local stale_sessions=$(sqlite3 "$REGISTRY_DB" "SELECT session_id FROM worktree_registry WHERE status='active' AND last_active < '$cutoff_time';")

    if [[ -z "$stale_sessions" ]]; then
        log "✅ No stale worktrees found"
        return 0
    fi

    local count=0
    while IFS= read -r session_id; do
        if [[ "$dry_run" == "true" ]]; then
            log "🔍 Would archive: $session_id"
        else
            archive_worktree "$session_id" "stale_cleanup_${hours_threshold}h"
        fi
        ((count++))
    done <<< "$stale_sessions"

    if [[ "$dry_run" == "true" ]]; then
        log "🔍 Dry run: Would archive $count stale worktree(s)"
    else
        log "✅ Archived $count stale worktree(s)"
    fi

    return 0
}

# Get worktree info
get_worktree_info() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        log "❌ get_worktree_info: Missing session_id"
        return 1
    fi

    sqlite3 "$REGISTRY_DB" <<SQL
.mode column
.headers on
SELECT * FROM worktree_registry WHERE session_id='$session_id';
SQL
}

# Check if session has a worktree
has_worktree() {
    local session_id="$1"

    if [[ -z "$session_id" ]]; then
        return 1
    fi

    local count=$(sqlite3 "$REGISTRY_DB" "SELECT COUNT(*) FROM worktree_registry WHERE session_id='$session_id' AND status='active';")

    if [[ "$count" -gt 0 ]]; then
        return 0  # Has worktree
    else
        return 1  # No worktree
    fi
}

# Main command dispatcher
main() {
    local command="$1"
    shift

    # Initialize database if it doesn't exist
    if [[ ! -f "$REGISTRY_DB" ]]; then
        init_database || exit 1
    fi

    case "$command" in
        init)
            init_database
            ;;
        register)
            register_worktree "$@"
            ;;
        get)
            get_worktree "$@"
            ;;
        list)
            list_active_worktrees "$@"
            ;;
        list-all)
            list_all_worktrees
            ;;
        touch)
            touch_worktree "$@"
            ;;
        archive)
            archive_worktree "$@"
            ;;
        cleanup)
            cleanup_stale_worktrees "$@"
            ;;
        info)
            get_worktree_info "$@"
            ;;
        has)
            has_worktree "$@"
            ;;
        *)
            echo "WORKTREE SESSION MAPPER"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "Usage: $0 <command> [arguments]"
            echo ""
            echo "Commands:"
            echo "  init                                    Initialize database"
            echo "  register <session_id> <path> <branch>   Register new worktree"
            echo "  get <session_id>                        Get worktree path for session"
            echo "  list [format]                           List active worktrees (table/json/simple)"
            echo "  list-all                                List all worktrees (active + archived)"
            echo "  touch <session_id>                      Update last active timestamp"
            echo "  archive <session_id> [reason]           Archive worktree"
            echo "  cleanup [hours] [dry_run]               Clean up stale worktrees"
            echo "  info <session_id>                       Get detailed worktree info"
            echo "  has <session_id>                        Check if session has worktree (exit code)"
            echo ""
            echo "Examples:"
            echo "  $0 register 'claude-proj-123' '/path/to/worktree' 'feature-branch'"
            echo "  $0 get 'claude-proj-123'"
            echo "  $0 list"
            echo "  $0 cleanup 24 true  # Dry run: show what would be cleaned"
            echo ""
            exit 1
            ;;
    esac
}

# Export functions for sourcing
export -f init_database
export -f register_worktree
export -f get_worktree
export -f list_active_worktrees
export -f touch_worktree
export -f archive_worktree
export -f cleanup_stale_worktrees
export -f has_worktree

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
