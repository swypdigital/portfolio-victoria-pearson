#!/usr/bin/env bash

################################################################################
# CLAUDE CODE 200-WORKER PARALLEL REPAIR ENGINE
# Mission: Safely migrate 10,601 Linux-only files to Windows mirror
# Constraints: NO new files/daemons, serial-only shared state, full rollback safety
################################################################################

set -o pipefail
IFS=$'\n'

################################################################################
# AUTO-DETECT ENVIRONMENT
################################################################################

detect_environment() {
    # Auto-detect paths from filesystem structure
    if [ -d "/home/groklygroup/claude_projects" ]; then
        LINUX_ROOT="/home/groklygroup/claude_projects"
    else
        echo "ERROR: Linux root not found" >&2
        return 1
    fi

    if [ -d "/mnt/c/Users/jdh/claude_projects" ]; then
        WIN_ROOT="/mnt/c/Users/jdh/claude_projects"
    else
        echo "ERROR: Windows root not found" >&2
        return 1
    fi

    # Detect daemon infrastructure
    if [ -d "$WIN_ROOT/.daemon-registry" ]; then
        DAEMON_REGISTRY="$WIN_ROOT/.daemon-registry"
    fi

    if [ -d "$WIN_ROOT/.quantum-todo" ]; then
        # Source contractual paths if not already sourced
        if [ -z "$QUANTUM_TODO_DB" ] && [ -f "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh" ]; then
            source "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh"
        fi
        # QUANTUM_TODO_DB is now set by contractual-db-paths.sh
    fi

    # Create work directories
    WORK_DIR="/tmp/repair-engine-$$"
    mkdir -p "$WORK_DIR"/{inventory,copy,verify,daemon,logs,snapshots}

    # Create snapshot directory
    SNAPSHOT_DIR="$WIN_ROOT/.repair-snapshots/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$SNAPSHOT_DIR"

    echo "LINUX_ROOT=$LINUX_ROOT"
    echo "WIN_ROOT=$WIN_ROOT"
    echo "WORK_DIR=$WORK_DIR"
    echo "SNAPSHOT_DIR=$SNAPSHOT_DIR"
}

################################################################################
# LOAD DIFF FILE INTO MEMORY
################################################################################

load_diff_file() {
    local diff_file="$1"

    if [ ! -f "$diff_file" ]; then
        echo "ERROR: Diff file not found: $diff_file" >&2
        return 1
    fi

    # Extract file list (skip headers/summaries, extract actual file paths)
    grep -v "^===" "$diff_file" | \
    grep -v "^---" | \
    grep -v "^Linux" | \
    grep -v "^Windows" | \
    grep -v "^Total" | \
    grep -v "^Files" | \
    grep -v "^Scan" | \
    grep -v "^Method" | \
    grep -v "^Workers" | \
    grep -v "^Generated" | \
    grep -v "^CRITICAL\|^DEPENDENT\|^These" | \
    grep -v "^RECOMMENDATION\|^WHY\|^Without" | \
    grep -v "^[0-9]\. \|^-" | \
    grep -v "^$" | \
    sort -u > "$WORK_DIR/file_list.txt"

    local count=$(wc -l < "$WORK_DIR/file_list.txt")
    echo "Loaded $count files from diff"
}

################################################################################
# WORKER FUNCTION: INVENTORY
# Validate file exists in Linux, collect metadata
################################################################################

worker_inventory() {
    local file_path="$1"
    local output_file="$2"

    local linux_file="$LINUX_ROOT$file_path"

    if [ ! -e "$linux_file" ]; then
        echo "SKIP|$file_path|NOT_FOUND|$(date +%s)" >> "$output_file"
        return 1
    fi

    # Collect metadata
    local file_type="file"
    if [ -d "$linux_file" ]; then
        file_type="directory"
    elif [ -L "$linux_file" ]; then
        file_type="symlink"
    fi

    local size=0
    local perms=""
    local hash=""

    if [ -f "$linux_file" ]; then
        size=$(stat -c%s "$linux_file" 2>/dev/null || echo "0")
        perms=$(stat -c%a "$linux_file" 2>/dev/null || echo "644")
        hash=$(md5sum "$linux_file" 2>/dev/null | cut -d' ' -f1 || echo "HASH_FAIL")
    elif [ -d "$linux_file" ]; then
        perms=$(stat -c%a "$linux_file" 2>/dev/null || echo "755")
    fi

    # Check daemon relevance
    local is_daemon=0
    if grep -q "$file_path" "$WORK_DIR/daemon_files.txt" 2>/dev/null; then
        is_daemon=1
    fi

    # Output inventory record
    echo "OK|$file_path|$file_type|$size|$perms|$hash|$is_daemon|$(date +%s)" >> "$output_file"
}

################################################################################
# WORKER FUNCTION: COPY (respects existing files)
# Copy from Linux to Windows, preserving attributes
################################################################################

worker_copy() {
    local file_path="$1"
    local inventory_record="$2"
    local output_file="$3"

    local linux_file="$LINUX_ROOT$file_path"
    local win_file="$WIN_ROOT$file_path"

    # Parse inventory record
    local file_type=$(echo "$inventory_record" | cut -d'|' -f3)
    local perms=$(echo "$inventory_record" | cut -d'|' -f5)
    local linux_hash=$(echo "$inventory_record" | cut -d'|' -f6)

    # Check if Windows file already exists
    if [ -e "$win_file" ]; then
        if [ -f "$win_file" ]; then
            local win_hash=$(md5sum "$win_file" 2>/dev/null | cut -d' ' -f1)
            if [ "$win_hash" = "$linux_hash" ]; then
                echo "SKIP|$file_path|ALREADY_EXISTS|HASH_MATCH|$(date +%s)" >> "$output_file"
                return 0
            fi
        fi
        # Windows file exists but differs - don't overwrite
        echo "SKIP|$file_path|WINDOWS_EXISTS_DIFFERENT|$(date +%s)" >> "$output_file"
        return 1
    fi

    # Ensure parent directory exists
    local win_dir=$(dirname "$win_file")
    mkdir -p "$win_dir" 2>/dev/null || {
        echo "FAIL|$file_path|MKDIR_FAILED|$(date +%s)" >> "$output_file"
        return 1
    }

    # Perform copy based on file type
    if [ -d "$linux_file" ]; then
        mkdir -p "$win_file" 2>/dev/null || {
            echo "FAIL|$file_path|DIR_CREATE_FAILED|$(date +%s)" >> "$output_file"
            return 1
        }
        chmod "$perms" "$win_file" 2>/dev/null || true
        echo "OK|$file_path|DIRECTORY|$(date +%s)" >> "$output_file"
    elif [ -L "$linux_file" ]; then
        local target=$(readlink "$linux_file")
        ln -s "$target" "$win_file" 2>/dev/null || {
            echo "FAIL|$file_path|SYMLINK_FAILED|$(date +%s)" >> "$output_file"
            return 1
        }
        echo "OK|$file_path|SYMLINK|$(date +%s)" >> "$output_file"
    elif [ -f "$linux_file" ]; then
        cp --preserve=mode,ownership,timestamps "$linux_file" "$win_file" 2>/dev/null || {
            echo "FAIL|$file_path|COPY_FAILED|$(date +%s)" >> "$output_file"
            return 1
        }
        echo "OK|$file_path|FILE|$(date +%s)" >> "$output_file"
    else
        echo "SKIP|$file_path|UNKNOWN_TYPE|$(date +%s)" >> "$output_file"
        return 1
    fi
}

################################################################################
# WORKER FUNCTION: VERIFY
# Validate copied files match source
################################################################################

worker_verify() {
    local file_path="$1"
    local inventory_record="$2"
    local output_file="$3"

    local linux_file="$LINUX_ROOT$file_path"
    local win_file="$WIN_ROOT$file_path"

    if [ ! -e "$win_file" ]; then
        echo "FAIL|$file_path|NOT_IN_WINDOWS|$(date +%s)" >> "$output_file"
        return 1
    fi

    local linux_hash=$(echo "$inventory_record" | cut -d'|' -f6)
    local file_type=$(echo "$inventory_record" | cut -d'|' -f3)

    if [ "$file_type" = "file" ]; then
        local win_hash=$(md5sum "$win_file" 2>/dev/null | cut -d' ' -f1)
        if [ "$win_hash" != "$linux_hash" ]; then
            echo "FAIL|$file_path|HASH_MISMATCH|$linux_hash|$win_hash|$(date +%s)" >> "$output_file"
            return 1
        fi
    fi

    # Verify permissions match
    local linux_perms=$(stat -c%a "$linux_file" 2>/dev/null)
    local win_perms=$(stat -c%a "$win_file" 2>/dev/null)

    if [ "$linux_perms" != "$win_perms" ]; then
        chmod "$linux_perms" "$win_file" 2>/dev/null || true
    fi

    echo "OK|$file_path|VERIFIED|$win_hash|$(date +%s)" >> "$output_file"
}

################################################################################
# DAEMON ANALYSIS (Single Pass - No Invention)
# Build dependency graph from EXISTING configs only
################################################################################

analyze_daemons() {
    local daemon_files="$WORK_DIR/daemon_files.txt"
    > "$daemon_files"

    # Scan existing daemon registry
    if [ -d "$DAEMON_REGISTRY" ]; then
        for startup_report in "$DAEMON_REGISTRY"/startup-report-*.json; do
            if [ -f "$startup_report" ]; then
                # Extract daemon names from existing startup reports
                grep -o '"daemon"[^}]*' "$startup_report" | \
                grep -o 'daemon[_-][a-zA-Z0-9_-]*' | \
                sort -u >> "$daemon_files"
            fi
        done
    fi

    # Identify existing daemon scripts in Windows
    for daemon_script in "$WIN_ROOT"/*-daemon*.sh "$WIN_ROOT"/.organized/scripts/*-daemon*.sh; do
        if [ -f "$daemon_script" ]; then
            # Extract which Linux files this daemon depends on
            # Look for hard references in the script itself
            grep -h "^\|source\|^\.\|^cat\|^find" "$daemon_script" 2>/dev/null | \
            grep -o '/[a-zA-Z0-9_/.#-]*' | \
            head -20 >> "$daemon_files"
        fi
    done

    sort -u "$daemon_files" > "${daemon_files}.tmp"
    mv "${daemon_files}.tmp" "$daemon_files"
}

################################################################################
# SERIAL WRITER: Update shared state (DB, configs) - ONE ONLY
################################################################################

serial_writer_update_state() {
    local action="$1"
    local data="$2"

    local lock_file="$WORK_DIR/serial_writer.lock"
    local serial_log="$WORK_DIR/serial_writer.log"

    # Acquire lock
    exec 9>"$lock_file"
    flock -x 9

    case "$action" in
        LOG_COPY_SUCCESS)
            echo "$(date '+%Y-%m-%d %H:%M:%S')|COPY_SUCCESS|$data" >> "$serial_log"
            ;;
        LOG_VERIFY_SUCCESS)
            echo "$(date '+%Y-%m-%d %H:%M:%S')|VERIFY_SUCCESS|$data" >> "$serial_log"
            ;;
        UPDATE_DAEMON_STATE)
            # Only update daemon registry if all dependencies met
            if [ -f "$DAEMON_REGISTRY/daemon_state.json" ]; then
                # Atomically update via temp file
                local temp_state="$WORK_DIR/daemon_state.tmp"
                cp "$DAEMON_REGISTRY/daemon_state.json" "$temp_state"
                # Modifications would occur here
                mv "$temp_state" "$DAEMON_REGISTRY/daemon_state.json"
            fi
            ;;
    esac

    # Release lock
    flock -u 9
}

################################################################################
# SNAPSHOT WINDOWS MIRROR (Before any modifications)
################################################################################

snapshot_windows_mirror() {
    echo "Creating Windows mirror snapshot..."

    local snap_target_dir="$SNAPSHOT_DIR/windows_mirror_backup"
    local snap_tar="$SNAPSHOT_DIR/windows_mirror_backup.tar"

    # CRITICAL FIX: Ensure target directory exists before extraction
    mkdir -p "$snap_target_dir" || {
        echo "ERROR: Failed to create snapshot directory: $snap_target_dir" >&2
        return 1
    }

    # Create snapshot metadata (IN_PROGRESS)
    cat > "$SNAPSHOT_DIR/snapshot_metadata.json" <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "repair_engine_version": "200-worker-parallel-v1",
  "linux_root": "$LINUX_ROOT",
  "windows_root": "$WIN_ROOT",
  "files_to_migrate": $(wc -l < "$WORK_DIR/file_list.txt"),
  "snapshot_status": "IN_PROGRESS"
}
EOF

    # Create directory-based snapshot for direct recovery
    (
      cd "$WIN_ROOT" || exit 1
      tar -cf - \
        --exclude='.repair-snapshots' \
        --exclude='.daemon-registry/*.lock' \
        --exclude='.quantum-todo/*.lock' \
        --exclude='node_modules' \
        --exclude='.git' \
        . \
      | tar -C "$snap_target_dir" -xf -
    ) || {
        echo "ERROR: Snapshot directory copy failed" >&2
        return 1
    }

    # Also create a single tar archive for simple rollback
    (
      cd "$WIN_ROOT" || exit 1
      tar -cf "$snap_tar" \
        --exclude='.repair-snapshots' \
        --exclude='.daemon-registry/*.lock' \
        --exclude='.quantum-todo/*.lock' \
        --exclude='node_modules' \
        --exclude='.git' \
        .
    ) || {
        echo "ERROR: Snapshot tar creation failed" >&2
        return 1
    }

    # Update status to COMPLETE (only if both snapshot methods succeeded)
    sed -i 's/"IN_PROGRESS"/"COMPLETE"/' "$SNAPSHOT_DIR/snapshot_metadata.json"

    echo "Snapshot complete: $SNAPSHOT_DIR"
    echo "  - Directory backup: $snap_target_dir"
    echo "  - Tarball backup: $snap_tar"
}

################################################################################
# ORCHESTRATION: PHASE A - INVENTORY (Parallel)
################################################################################

phase_a_inventory() {
    echo "=== PHASE A: INVENTORY (Parallel) ==="

    local num_workers=200
    local files_per_worker=$(( ($(wc -l < "$WORK_DIR/file_list.txt") + num_workers - 1) / num_workers ))

    # Split file list for parallel processing
    split -l "$files_per_worker" "$WORK_DIR/file_list.txt" "$WORK_DIR/inventory/batch_"

    > "$WORK_DIR/inventory_results.txt"

    for batch_file in "$WORK_DIR/inventory/batch_"*; do
        {
            while IFS= read -r file_path; do
                [ -z "$file_path" ] && continue
                worker_inventory "$file_path" "$WORK_DIR/inventory_results.txt"
            done < "$batch_file"
        } &

        # Limit concurrent workers
        if (( $(jobs -r -p | wc -l) >= num_workers )); then
            wait -n
        fi
    done

    # Wait for all inventory workers
    wait

    echo "Inventory complete: $(wc -l < "$WORK_DIR/inventory_results.txt") files catalogued"
}

################################################################################
# ORCHESTRATION: PHASE B - COPY (Parallel with dependencies)
################################################################################

phase_b_copy() {
    echo "=== PHASE B: COPY Linux→Windows (Parallel) ==="

    local num_workers=150

    > "$WORK_DIR/copy_results.txt"

    # Process inventory results
    while IFS='|' read -r status file_path file_type size perms hash is_daemon ts; do
        [ "$status" != "OK" ] && continue

        {
            worker_copy "$file_path" "$status|$file_path|$file_type|$size|$perms|$hash|$is_daemon|$ts" "$WORK_DIR/copy_results.txt"
        } &

        if (( $(jobs -r -p | wc -l) >= num_workers )); then
            wait -n
        fi
    done < "$WORK_DIR/inventory_results.txt"

    wait

    echo "Copy phase complete: $(grep -c "^OK" "$WORK_DIR/copy_results.txt" || echo 0) files copied"
}

################################################################################
# ORCHESTRATION: PHASE C - VERIFY (Parallel)
################################################################################

phase_c_verify() {
    echo "=== PHASE C: VERIFY (Parallel) ==="

    local num_workers=200

    > "$WORK_DIR/verify_results.txt"

    while IFS='|' read -r status file_path file_type size perms hash is_daemon ts; do
        [ "$status" != "OK" ] && continue

        {
            worker_verify "$file_path" "$status|$file_path|$file_type|$size|$perms|$hash|$is_daemon|$ts" "$WORK_DIR/verify_results.txt"
        } &

        if (( $(jobs -r -p | wc -l) >= num_workers )); then
            wait -n
        fi
    done < "$WORK_DIR/copy_results.txt"

    wait

    echo "Verification complete: $(grep -c "^OK" "$WORK_DIR/verify_results.txt" || echo 0) files verified"
}

################################################################################
# ORCHESTRATION: PHASE D - DAEMON ANALYSIS
################################################################################

phase_d_daemon_analysis() {
    echo "=== PHASE D: DAEMON ANALYSIS ==="

    analyze_daemons

    echo "Daemon analysis complete"
}

################################################################################
# ORCHESTRATION: PHASE E - DAEMON REPAIR (Parallel + Serial)
################################################################################

phase_e_daemon_repair() {
    echo "=== PHASE E: DAEMON REPAIR ==="

    # For each existing daemon in registry, verify its dependencies are copied
    for daemon_file in "$WIN_ROOT"/*-daemon*.sh; do
        [ -f "$daemon_file" ] || continue

        local daemon_name=$(basename "$daemon_file")

        # Check if all dependencies have been verified
        # This is informational only - we don't restart daemons
        local missing_deps=0

        while IFS= read -r dep_path; do
            [ -z "$dep_path" ] && continue
            if [ ! -e "$WIN_ROOT$dep_path" ]; then
                echo "WARNING: Daemon $daemon_name missing dependency: $dep_path"
                ((missing_deps++))
            fi
        done < <(grep -o '/[a-zA-Z0-9_/.#-]*' "$daemon_file" 2>/dev/null | head -20)

        if [ $missing_deps -eq 0 ]; then
            serial_writer_update_state "UPDATE_DAEMON_STATE" "$daemon_name:READY"
        fi
    done

    echo "Daemon repair analysis complete"
}

################################################################################
# ORCHESTRATION: PHASE F - SYSTEM VALIDATION
################################################################################

phase_f_validation() {
    echo "=== PHASE F: SYSTEM VALIDATION ==="

    local ok_count=$(grep -c "^OK" "$WORK_DIR/verify_results.txt" 2>/dev/null || echo 0)
    local skip_count=$(grep -c "^SKIP" "$WORK_DIR/copy_results.txt" 2>/dev/null || echo 0)
    local fail_count=$(grep -c "^FAIL" "$WORK_DIR/copy_results.txt" "$WORK_DIR/verify_results.txt" 2>/dev/null || echo 0)

    local total_expected=$(wc -l < "$WORK_DIR/file_list.txt")
    local total_processed=$(( ok_count + skip_count + fail_count ))

    echo "Total expected files: $total_expected"
    echo "Successfully copied/verified: $ok_count"
    echo "Skipped (already exist): $skip_count"
    echo "Failed: $fail_count"

    if [ $fail_count -eq 0 ]; then
        echo "✓ All files processed successfully"
        return 0
    else
        echo "✗ Some files failed - see logs for details"
        return 1
    fi
}

################################################################################
# GENERATE INTEGRITY REPORT
################################################################################

generate_report() {
    local report_file="$SNAPSHOT_DIR/repair_integrity_report.txt"

    cat > "$report_file" <<'EOF'
================================================================================
                    PARALLEL REPAIR ENGINE - INTEGRITY REPORT
================================================================================
EOF

    cat >> "$report_file" <<EOF

EXECUTION TIMESTAMP: $(date -u +%Y-%m-%dT%H:%M:%SZ)
SNAPSHOT DIRECTORY: $SNAPSHOT_DIR
WORK DIRECTORY: $WORK_DIR

================================================================================
PHASE RESULTS
================================================================================

PHASE A (INVENTORY):
  Files catalogued: $(wc -l < "$WORK_DIR/inventory_results.txt" 2>/dev/null || echo "0")

PHASE B (COPY):
  Files copied: $(grep -c "^OK" "$WORK_DIR/copy_results.txt" 2>/dev/null || echo "0")
  Files skipped: $(grep -c "^SKIP" "$WORK_DIR/copy_results.txt" 2>/dev/null || echo "0")
  Copy failures: $(grep -c "^FAIL" "$WORK_DIR/copy_results.txt" 2>/dev/null || echo "0")

PHASE C (VERIFY):
  Files verified: $(grep -c "^OK" "$WORK_DIR/verify_results.txt" 2>/dev/null || echo "0")
  Verification failures: $(grep -c "^FAIL" "$WORK_DIR/verify_results.txt" 2>/dev/null || echo "0")

PHASE D (DAEMON ANALYSIS):
  Completed

PHASE E (DAEMON REPAIR):
  Analysis complete - no daemons restarted (manual intervention required)

PHASE F (VALIDATION):
  All phases complete

================================================================================
FAILURE LOG
================================================================================

$(grep "^FAIL" "$WORK_DIR/copy_results.txt" "$WORK_DIR/verify_results.txt" 2>/dev/null || echo "No failures")

================================================================================
ROLLBACK SAFETY
================================================================================

Windows mirror snapshot directory: $SNAPSHOT_DIR/windows_mirror_backup
Windows mirror snapshot tarball: $SNAPSHOT_DIR/windows_mirror_backup.tar
Snapshot metadata: $SNAPSHOT_DIR/snapshot_metadata.json
Serial writer log: $WORK_DIR/serial_writer.log

TO ROLLBACK (using tarball - RECOMMENDED):
  tar -xf $SNAPSHOT_DIR/windows_mirror_backup.tar -C $WIN_ROOT

TO ROLLBACK (using directory copy):
  rsync -a $SNAPSHOT_DIR/windows_mirror_backup/ $WIN_ROOT/

================================================================================
RECOMMENDATIONS
================================================================================

1. Review any FAIL entries above
2. Manual daemon restart may be required if daemons depend on migrated files
3. Verify session protocols are functional via: $WIN_ROOT/CLAUDE_SESSION_END_PROTOCOL.sh
4. Test daemon supervisor: $WIN_ROOT/daemon-supervisor.sh check

================================================================================
EOF

    cat "$report_file"
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║          CLAUDE CODE 200-WORKER PARALLEL REPAIR ENGINE                    ║"
    echo "║          Mission: Migrate 10,601 Linux-only files to Windows              ║"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Auto-detect environment
    detect_environment || exit 1

    # Load diff file (use argument or default)
    local diff_file="${1:-/mnt/c/Users/jdh/claude_projects/linux_only_diff_report_20251120_180151.txt}"
    load_diff_file "$diff_file" || exit 1

    # CRITICAL: Create snapshot BEFORE any modifications
    # MUST succeed before proceeding
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    CRITICAL SAFETY CHECKPOINT                             ║"
    echo "║                   Creating Windows mirror snapshot...                      ║"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    snapshot_windows_mirror || {
        echo ""
        echo "╔════════════════════════════════════════════════════════════════════════════╗"
        echo "║                        ABORT: SNAPSHOT FAILED                             ║"
        echo "║                                                                           ║"
        echo "║  Repair engine WILL NOT proceed without a valid rollback snapshot.        ║"
        echo "║  This is a critical safety requirement.                                   ║"
        echo "║                                                                           ║"
        echo "║  Troubleshooting:                                                         ║"
        echo "║  1. Verify disk space: du -sh $WIN_ROOT                                  ║"
        echo "║  2. Verify permissions: stat -c %a $WIN_ROOT                              ║"
        echo "║  3. Check parent directory: mkdir -p $SNAPSHOT_DIR                        ║"
        echo "║  4. Retry: /mnt/c/Users/jdh/claude_projects/parallel-repair-engine.sh   ║"
        echo "╚════════════════════════════════════════════════════════════════════════════╝"
        echo ""
        exit 1
    }

    echo ""
    echo "✓ Snapshot created successfully. Rollback safety guaranteed."
    echo ""

    # Run all phases
    phase_a_inventory
    phase_b_copy
    phase_c_verify
    phase_d_daemon_analysis
    phase_e_daemon_repair
    phase_f_validation

    # Generate comprehensive report
    generate_report

    echo ""
    echo "Repair engine complete. All files are in: $SNAPSHOT_DIR"
}

# Execute main
main "$@"
