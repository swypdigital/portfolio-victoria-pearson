#!/bin/bash
# Contractual database paths - single source of truth
# All scripts MUST source this file for database access

# Source contractual paths first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/contractual-paths-true.sh" ]; then
    source "${SCRIPT_DIR}/contractual-paths-true.sh"
else
    # Fallback
    CLAUDE_PROJECTS_ROOT="${CLAUDE_PROJECTS_ROOT:-$WINDOWS_HOME/claude_projects}"
fi

# Database directories
export INDEX_DB_DIR="${CLAUDE_PROJECTS_ROOT}/.index-system/database"
export SEARCH_INDEX_DIR="${CLAUDE_PROJECTS_ROOT}/.search-index"
export QUANTUM_TODO_DIR="${CLAUDE_PROJECTS_ROOT}/.quantum-todo"

# Primary database paths
# UPDATED 2025-12-07: quantum-index.db consolidated to .quantum-todo/ (active production DB)
export QUANTUM_INDEX_DB="${QUANTUM_TODO_DIR}/quantum-index.db"  # Changed from INDEX_DB_DIR
export QUANTUM_TODO_DB="${QUANTUM_TODO_DIR}/quantum-todo.db"    # Added for completeness
export FILE_INDEX_DB="${INDEX_DB_DIR}/file-index.db"
export METADATA_DB="${SEARCH_INDEX_DIR}/metadata.db"

# Backup and archive paths
export DB_BACKUP_DIR="${CLAUDE_PROJECTS_ROOT}/.perpetual-trash"
export DB_ARCHIVE_PREFIX="db-backup"

# Ensure directories exist
mkdir -p "${INDEX_DB_DIR}"
mkdir -p "${SEARCH_INDEX_DIR}"
mkdir -p "${QUANTUM_TODO_DIR}"
mkdir -p "${DB_BACKUP_DIR}"

# Function to get database path by name
get_db_path() {
    local db_name="$1"
    case "$db_name" in
        "quantum"|"quantum-index")
            echo "$QUANTUM_INDEX_DB"
            ;;
        "file"|"file-index")
            echo "$FILE_INDEX_DB"
            ;;
        "metadata"|"search")
            echo "$METADATA_DB"
            ;;
        *)
            echo "$INDEX_DB_DIR/$db_name.db"
            ;;
    esac
}

# Function to check if database exists and is valid
check_db() {
    local db_path="$1"
    if [ -f "$db_path" ] && [ -s "$db_path" ]; then
        # Check if it's a valid SQLite database
        if sqlite3 "$db_path" "SELECT 1;" &>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Export functions for use in other scripts
export -f get_db_path
export -f check_db