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
        test)
            test_rollback
            ;;
        *)
            echo "Usage: $0 {check|rollback|test}"
            echo "  check    - Check if rollback is needed"
            echo "  rollback - Perform rollback"
            echo "  test     - Test rollback functionality"
            exit 1
            ;;
    esac
}

main "$@"