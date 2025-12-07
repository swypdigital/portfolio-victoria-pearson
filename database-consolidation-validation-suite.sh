#!/bin/bash
# DATABASE CONSOLIDATION - AUTOMATED VALIDATION SUITE
# Enterprise-grade validation for database consolidation
# Tests ALL converted scripts, scans unconverted scripts, validates backups

set -uo pipefail

# Source contractual paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/contractual-db-paths.sh"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validation results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
WARNINGS=0

# Log file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$SCRIPT_DIR/.validation-logs/db-consolidation-validation-$TIMESTAMP.log"
mkdir -p "$SCRIPT_DIR/.validation-logs"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    echo "[PASS] $1" >> "$LOG_FILE"
    ((PASSED_TESTS++))
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
    echo "[FAIL] $1" >> "$LOG_FILE"
    ((FAILED_TESTS++))
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    echo "[WARN] $1" >> "$LOG_FILE"
    ((WARNINGS++))
}

# Section header
print_section() {
    echo ""
    echo "========================================"
    echo "$1"
    echo "========================================"
    echo "" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    echo "$1" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
}

# Test counter
run_test() {
    ((TOTAL_TESTS++))
}

# Validation Suite Start
print_section "DATABASE CONSOLIDATION - VALIDATION SUITE"
log_info "Started: $(date)"
log_info "Branch: $(git branch --show-current)"
log_info "Log file: $LOG_FILE"
echo ""

#############################################
# PHASE 1: DATABASE PATH VALIDATION
#############################################
print_section "PHASE 1: DATABASE PATH VALIDATION"

run_test
if [ -n "$QUANTUM_INDEX_DB" ] && [ -n "$QUANTUM_TODO_DB" ]; then
    log_success "Contractual paths are defined"
else
    log_error "Contractual paths not defined"
fi

run_test
if [ -f "$QUANTUM_INDEX_DB" ]; then
    SIZE=$(du -h "$QUANTUM_INDEX_DB" | cut -f1)
    log_success "QUANTUM_INDEX_DB exists ($SIZE)"
else
    log_error "QUANTUM_INDEX_DB not found at: $QUANTUM_INDEX_DB"
fi

run_test
if [ -f "$QUANTUM_TODO_DB" ]; then
    SIZE=$(du -h "$QUANTUM_TODO_DB" | cut -f1)
    log_success "QUANTUM_TODO_DB exists ($SIZE)"
else
    log_error "QUANTUM_TODO_DB not found at: $QUANTUM_TODO_DB"
fi

#############################################
# PHASE 2: DATABASE ACCESSIBILITY TESTS
#############################################
print_section "PHASE 2: DATABASE ACCESSIBILITY TESTS"

run_test
QUANTUM_INDEX_COUNT=$(sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;" 2>&1)
if [[ "$QUANTUM_INDEX_COUNT" =~ ^[0-9]+$ ]]; then
    log_success "quantum-index.db query successful ($QUANTUM_INDEX_COUNT tasks)"
else
    log_error "quantum-index.db query failed: $QUANTUM_INDEX_COUNT"
fi

run_test
QUANTUM_TODO_COUNT=$(sqlite3 "$QUANTUM_TODO_DB" "SELECT COUNT(*) FROM quantum_todos;" 2>&1)
if [[ "$QUANTUM_TODO_COUNT" =~ ^[0-9]+$ ]]; then
    log_success "quantum-todo.db query successful ($QUANTUM_TODO_COUNT tasks)"
else
    log_error "quantum-todo.db query failed: $QUANTUM_TODO_COUNT"
fi

run_test
START_TIME=$(date +%s%N)
sqlite3 "$QUANTUM_INDEX_DB" "SELECT COUNT(*) FROM quantum_todos;" > /dev/null
END_TIME=$(date +%s%N)
QUERY_TIME_MS=$(( (END_TIME - START_TIME) / 1000000 ))
if [ "$QUERY_TIME_MS" -lt 1000 ]; then
    log_success "Query response time: ${QUERY_TIME_MS}ms (< 1000ms)"
else
    log_warning "Query response time: ${QUERY_TIME_MS}ms (slow)"
fi

#############################################
# PHASE 3: CONVERTED SCRIPTS VALIDATION
#############################################
print_section "PHASE 3: CONVERTED SCRIPTS VALIDATION (6 scripts)"

CONVERTED_SCRIPTS=(
    "CLAUDE_SESSION_END_PROTOCOL.sh"
    "AUTO_SESSION_END_PROTOCOL.sh"
    "complete-hashing-final.sh"
    "database-dependency-diagnostic.sh"
    "rollback-quantum-todo-changes.sh"
    "parallel-repair-engine.sh"
)

for script in "${CONVERTED_SCRIPTS[@]}"; do
    run_test
    if [ ! -f "$SCRIPT_DIR/$script" ]; then
        log_error "$script: NOT FOUND"
        continue
    fi

    # Check syntax
    if bash -n "$SCRIPT_DIR/$script" 2>/dev/null; then
        log_success "$script: Syntax valid"
    else
        log_error "$script: Syntax error"
        continue
    fi

    run_test
    # Check if sources contractual paths
    if grep -q "source.*contractual-db-paths" "$SCRIPT_DIR/$script"; then
        log_success "$script: Sources contractual-db-paths.sh"
    else
        log_error "$script: Does NOT source contractual-db-paths.sh"
    fi

    run_test
    # Check if uses contractual variables
    if grep -q "\$QUANTUM_INDEX_DB\|\$QUANTUM_TODO_DB" "$SCRIPT_DIR/$script"; then
        log_success "$script: Uses contractual variables"
    else
        log_warning "$script: May not use contractual variables"
    fi

    run_test
    # Check for hard-coded paths
    if grep -E "/mnt/c/Users/jdh|/home/groklygroup" "$SCRIPT_DIR/$script" | grep -v "^#" | grep -q "claude_projects"; then
        log_error "$script: Contains hard-coded paths"
    else
        log_success "$script: No hard-coded paths detected"
    fi
done

#############################################
# PHASE 4: UNCONVERTED SCRIPTS SCAN
#############################################
print_section "PHASE 4: UNCONVERTED SCRIPTS SCAN"

UNCONVERTED_SCRIPTS=(
    "FORENSIC_DATABASE_ANALYSIS.sh"
    "capture-baseline-metrics.sh"
    "claude-os-compliance-functions.sh"
    "map-dependencies-pause-daemons.sh"
    "parallel-db-writer.sh"
    "enterprise-hash-normalization-fortress.sh"
    "enterprise-plans-consolidation-200.sh"
    "enterprise-plans-consolidation-optimized.sh"
    "quantum-compliance-enterprise-200.sh"
    "quantum-compliance-final-100.sh"
    "quantum-migration-enterprise.sh"
    "setup-rollback-checkpoints.sh"
)

NEEDS_CONVERSION=()

for script in "${UNCONVERTED_SCRIPTS[@]}"; do
    run_test
    if [ ! -f "$SCRIPT_DIR/$script" ]; then
        log_info "$script: Not found (may be OK)"
        continue
    fi

    # Check if already sources contractual paths
    if grep -q "source.*contractual-db-paths" "$SCRIPT_DIR/$script"; then
        log_success "$script: Already sources contractual-db-paths.sh"
        continue
    fi

    # Check if references quantum databases
    if grep -q "quantum.*index.*db\|quantum.*todo.*db" "$SCRIPT_DIR/$script"; then
        log_warning "$script: References quantum databases but not using contractual paths"
        NEEDS_CONVERSION+=("$script")
    else
        log_info "$script: No database references (safe)"
    fi
done

if [ ${#NEEDS_CONVERSION[@]} -gt 0 ]; then
    log_warning "Scripts needing conversion: ${#NEEDS_CONVERSION[@]}"
    for script in "${NEEDS_CONVERSION[@]}"; do
        log_warning "  - $script"
    done
fi

#############################################
# PHASE 5: BACKUP VALIDATION
#############################################
print_section "PHASE 5: BACKUP VALIDATION"

BACKUP_DIR="$SCRIPT_DIR/.backups/database-consolidation-20251207_001440"

run_test
if [ -d "$BACKUP_DIR" ]; then
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    log_success "Backup directory exists ($BACKUP_SIZE)"
else
    log_error "Backup directory not found: $BACKUP_DIR"
fi

run_test
if [ -f "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db" ]; then
    SIZE=$(du -h "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db" | cut -f1)
    log_success "Active database backup exists ($SIZE)"
else
    log_error "Active database backup not found"
fi

run_test
if [ -f "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db.md5" ]; then
    log_success "MD5 checksum file exists"
else
    log_error "MD5 checksum file not found"
fi

# Test restore in isolated location
run_test
TEST_RESTORE_DIR="/tmp/db-consolidation-restore-test-$$"
mkdir -p "$TEST_RESTORE_DIR"

if [ -f "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db" ]; then
    cp "$BACKUP_DIR/quantum-index-LOCATION2-ACTIVE.db" "$TEST_RESTORE_DIR/quantum-index.db"

    # Try to query restored database
    RESTORE_COUNT=$(sqlite3 "$TEST_RESTORE_DIR/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>&1)
    if [[ "$RESTORE_COUNT" =~ ^[0-9]+$ ]]; then
        log_success "Backup restore test successful ($RESTORE_COUNT tasks)"
    else
        log_error "Backup restore test failed: $RESTORE_COUNT"
    fi

    rm -rf "$TEST_RESTORE_DIR"
else
    log_error "Cannot test restore - backup file not found"
fi

#############################################
# PHASE 6: DAEMON STATUS CHECK
#############################################
print_section "PHASE 6: DAEMON STATUS CHECK"

REQUIRED_DAEMONS=(
    "chat-backup"
    "quantum-todo-autocapture"
    "quantum-autonomous"
    "plan-capture"
    "unified-index"
    "health-monitor"
    "persistent-capture"
    "tmux-index-footer"
)

RUNNING_DAEMONS=0

for daemon in "${REQUIRED_DAEMONS[@]}"; do
    run_test
    if ps aux | grep -v grep | grep -q "$daemon"; then
        log_success "$daemon: Running"
        ((RUNNING_DAEMONS++))
    else
        log_error "$daemon: NOT running"
    fi
done

log_info "Daemons running: $RUNNING_DAEMONS/${#REQUIRED_DAEMONS[@]}"

#############################################
# PHASE 7: GIT BRANCH VALIDATION
#############################################
print_section "PHASE 7: GIT BRANCH VALIDATION"

run_test
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "database-consolidation-20251207" ]; then
    log_success "On correct branch: $CURRENT_BRANCH"
else
    log_error "Wrong branch: $CURRENT_BRANCH (expected: database-consolidation-20251207)"
fi

run_test
COMMIT_COUNT=$(git log --oneline database-consolidation-20251207 | wc -l)
if [ "$COMMIT_COUNT" -ge 11 ]; then
    log_success "Commit count: $COMMIT_COUNT (>= 11 expected)"
else
    log_warning "Commit count: $COMMIT_COUNT (< 11 expected)"
fi

run_test
if git diff-index --quiet HEAD --; then
    log_success "No uncommitted changes"
else
    log_warning "Uncommitted changes detected"
fi

#############################################
# PHASE 8: DEPENDENCY VALIDATION
#############################################
print_section "PHASE 8: DEPENDENCY VALIDATION"

run_test
if [ -f "$SCRIPT_DIR/validate-dependencies.sh" ]; then
    log_info "Running dependency validator..."

    # Run in background with timeout
    timeout 60s "$SCRIPT_DIR/validate-dependencies.sh" > /tmp/dep-validation-$$.log 2>&1 &
    DEP_PID=$!

    if wait $DEP_PID 2>/dev/null; then
        log_success "Dependency validator completed"
        # Check for errors in output
        if grep -qi "error\|fail" /tmp/dep-validation-$$.log; then
            log_warning "Dependency validator reported issues (check log)"
        fi
    else
        log_warning "Dependency validator timed out or failed"
    fi

    rm -f /tmp/dep-validation-$$.log
else
    log_warning "validate-dependencies.sh not found"
fi

#############################################
# PHASE 9: DISK SPACE CHECK
#############################################
print_section "PHASE 9: DISK SPACE CHECK"

run_test
AVAILABLE_SPACE=$(df -BG "$SCRIPT_DIR" | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -gt 10 ]; then
    log_success "Disk space: ${AVAILABLE_SPACE}GB available"
else
    log_error "Disk space: ${AVAILABLE_SPACE}GB (< 10GB minimum)"
fi

#############################################
# PHASE 10: DATABASE INTEGRITY CHECK
#############################################
print_section "PHASE 10: DATABASE INTEGRITY CHECK"

run_test
INTEGRITY_CHECK=$(sqlite3 "$QUANTUM_INDEX_DB" "PRAGMA integrity_check;" 2>&1)
if [ "$INTEGRITY_CHECK" = "ok" ]; then
    log_success "quantum-index.db: Integrity check passed"
else
    log_error "quantum-index.db: Integrity check failed: $INTEGRITY_CHECK"
fi

run_test
INTEGRITY_CHECK=$(sqlite3 "$QUANTUM_TODO_DB" "PRAGMA integrity_check;" 2>&1)
if [ "$INTEGRITY_CHECK" = "ok" ]; then
    log_success "quantum-todo.db: Integrity check passed"
else
    log_error "quantum-todo.db: Integrity check failed: $INTEGRITY_CHECK"
fi

#############################################
# FINAL REPORT
#############################################
print_section "VALIDATION SUITE - FINAL REPORT"

echo ""
echo "Total Tests:    $TOTAL_TESTS"
echo "Passed:         $PASSED_TESTS"
echo "Failed:         $FAILED_TESTS"
echo "Warnings:       $WARNINGS"
echo ""

echo "" >> "$LOG_FILE"
echo "Total Tests:    $TOTAL_TESTS" >> "$LOG_FILE"
echo "Passed:         $PASSED_TESTS" >> "$LOG_FILE"
echo "Failed:         $FAILED_TESTS" >> "$LOG_FILE"
echo "Warnings:       $WARNINGS" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
echo "Pass Rate:      $PASS_RATE%"
echo "Pass Rate:      $PASS_RATE%" >> "$LOG_FILE"
echo ""
echo "" >> "$LOG_FILE"

if [ "$FAILED_TESTS" -eq 0 ]; then
    if [ "$WARNINGS" -eq 0 ]; then
        echo -e "${GREEN}✅ ALL VALIDATION TESTS PASSED - READY FOR MERGE${NC}"
        echo "✅ ALL VALIDATION TESTS PASSED - READY FOR MERGE" >> "$LOG_FILE"
        EXIT_CODE=0
    else
        echo -e "${YELLOW}⚠️  VALIDATION PASSED WITH WARNINGS - REVIEW RECOMMENDED${NC}"
        echo "⚠️  VALIDATION PASSED WITH WARNINGS - REVIEW RECOMMENDED" >> "$LOG_FILE"
        EXIT_CODE=1
    fi
else
    echo -e "${RED}❌ VALIDATION FAILED - DO NOT MERGE${NC}"
    echo "❌ VALIDATION FAILED - DO NOT MERGE" >> "$LOG_FILE"
    EXIT_CODE=2
fi

echo ""
log_info "Completed: $(date)"
log_info "Full log: $LOG_FILE"

exit $EXIT_CODE
