#!/bin/bash
# Rollback script for quantum-todo system changes
# Created: $(date)
# Purpose: Safely rollback quantum-todo changes if issues arise

# Source contractual database paths
if [ -f "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh" ]; then
    source "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh"
fi

# Safety first - exit on any error
set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROLLBACK_LOG="$SCRIPT_DIR/.rollback-quantum-todo.log"
TRASH_DIR=".perpetual-trash/quantum-todo-$(date +%Y%m%d)"

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$ROLLBACK_LOG"
}

# Check if rollback is needed
check_rollback_needed() {
    log "Checking if rollback is needed..."
    
    # Test quantum-todo-system.sh
    if ! ./quantum-todo-system.sh help >/dev/null 2>&1; then
        log "ERROR: quantum-todo-system.sh is not working!"
        return 0
    fi
    
    # Check database integrity
    if ! sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;" >/dev/null 2>&1; then
        log "ERROR: Database integrity check failed!"
        return 0
    fi
    
    log "System appears to be working correctly."
    return 1
}

# Perform rollback
perform_rollback() {
    log "Starting rollback procedure..."
    
    # Stop any running daemons
    log "Stopping daemons..."
    pkill -f "quantum-todo" || true
    
    # Restore from perpetual trash if exists
    if [[ -d "$TRASH_DIR" ]]; then
        log "Restoring files from $TRASH_DIR..."
        
        # Restore each file carefully
        for file in "$TRASH_DIR"/*; do
            if [[ -f "$file" ]]; then
                basename_file=$(basename "$file")
                log "Restoring $basename_file..."
                cp "$file" "$SCRIPT_DIR/$basename_file"
                chmod +x "$SCRIPT_DIR/$basename_file" 2>/dev/null || true
            fi
        done
    else
        log "WARNING: No perpetual trash directory found at $TRASH_DIR"
    fi
    
    # Restart daemon supervisor
    if [[ -f "./daemon-supervisor.sh" ]]; then
        log "Restarting daemon supervisor..."
        ./daemon-supervisor.sh restart || true
    fi
    
    log "Rollback completed."
}

# Rollback database consolidation merge
rollback_consolidation_merge() {
    log "Starting database consolidation merge rollback..."

    # Find most recent pre-merge backup
    local backup_dir=$(find .archive -type d -name "pre-merge-backup-*" 2>/dev/null | sort -r | head -1)

    if [[ -z "$backup_dir" ]]; then
        log "ERROR: No pre-merge backup found in .archive/"
        log "Looking for alternative backups..."

        # Try to find archived quantum-todo.db
        local archived_db=$(find .quantum-todo -name "quantum-todo.db.archived-*" 2>/dev/null | sort -r | head -1)
        if [[ -n "$archived_db" ]]; then
            log "Found archived database: $archived_db"
            log "To manually restore: cp '$archived_db' .quantum-todo/quantum-todo.db"
        fi
        return 1
    fi

    log "Found backup directory: $backup_dir"

    # Verify backup integrity
    if [[ -f "$backup_dir/checksums.md5" ]]; then
        log "Verifying backup checksums..."
        cd "$backup_dir" && md5sum -c checksums.md5 > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            log "✅ Backup integrity verified"
        else
            log "⚠️  WARNING: Checksum verification failed!"
            read -p "Continue with rollback anyway? (yes/no): " confirm
            [[ "$confirm" != "yes" ]] && return 1
        fi
        cd - > /dev/null
    fi

    # Stop all daemons and sessions
    log "Stopping all daemons and database connections..."
    ./daemon-supervisor.sh stop 2>/dev/null || true
    pkill -9 -f "daemon" 2>/dev/null || true
    sleep 2

    # Restore databases
    log "Restoring quantum-index.db from backup..."
    cp "$backup_dir/quantum-index.db" .quantum-todo/ || {
        log "ERROR: Failed to restore quantum-index.db"
        return 1
    }

    log "Restoring quantum-todo.db from backup..."
    local qt_backup="$backup_dir/quantum-todo.db.archived-"*
    if [[ -f $qt_backup ]]; then
        cp $qt_backup .quantum-todo/quantum-todo.db || {
            log "ERROR: Failed to restore quantum-todo.db"
            return 1
        }
    else
        log "WARNING: No quantum-todo.db backup found"
    fi

    # Restore CLAUDE_SESSION_PROTOCOL.sh
    log "Restoring CLAUDE_SESSION_PROTOCOL.sh..."
    local script_backup=$(find . -maxdepth 1 -name "CLAUDE_SESSION_PROTOCOL.sh.pre-consolidation-*" | sort -r | head -1)
    if [[ -n "$script_backup" ]]; then
        cp "$script_backup" CLAUDE_SESSION_PROTOCOL.sh || {
            log "ERROR: Failed to restore CLAUDE_SESSION_PROTOCOL.sh"
            return 1
        }
    else
        log "WARNING: No CLAUDE_SESSION_PROTOCOL.sh backup found"
    fi

    # Restart daemons
    log "Restarting daemons..."
    ./claude-unified-startup.sh 2>/dev/null || ./daemon-supervisor.sh start || true

    log "✅ Database consolidation merge rollback completed successfully"
    log "Backup location: $backup_dir"

    return 0
}

# Test rollback
test_rollback() {
    log "Testing rollback functionality..."

    # Create test backup
    local test_dir=".rollback-test-$(date +%s)"
    mkdir -p "$test_dir"

    # Backup current state
    cp quantum-todo-system.sh "$test_dir/" 2>/dev/null || true

    # Make harmless change
    echo "# Test comment" >> quantum-todo-system.sh

    # Test restore
    cp "$test_dir/quantum-todo-system.sh" quantum-todo-system.sh

    # Cleanup
    rm -rf "$test_dir"

    log "Rollback test completed successfully."
}

# Main execution
main() {
    log "=== Quantum TODO Rollback Script ==="

    case "${1:-check}" in
        check)
            if check_rollback_needed; then
                log "Rollback is recommended."
                exit 1
            else
                log "No rollback needed."
                exit 0
            fi
            ;;
        rollback)
            perform_rollback
            ;;
        consolidation-merge)
            rollback_consolidation_merge
            ;;
        test)
            test_rollback
            ;;
        *)
            echo "Usage: $0 {check|rollback|consolidation-merge|test}"
            echo "  check                - Check if rollback is needed"
            echo "  rollback             - Perform general rollback"
            echo "  consolidation-merge  - Rollback database consolidation merge (Dec 2025)"
            echo "  test                 - Test rollback functionality"
            exit 1
            ;;
    esac
}

main "$@"