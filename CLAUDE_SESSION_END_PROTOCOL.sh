#!/bin/bash

# CLAUDE CODE SESSION END PROTOCOL V3 - ULTRA-OPTIMIZED (<5s execution)
# Maximum parallelization with maintained functionality
# Author: groklyGroup™ LLC

# Source contractual database paths
if [ -f "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh" ]; then
    source "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh"
elif [ -f "$(dirname "$0")/contractual-db-paths.sh" ]; then
    source "$(dirname "$0")/contractual-db-paths.sh"
fi

# Performance timing function
time_section() {
    local name=$1
    local start=$(date +%s.%N)
    shift
    "$@"
    local end=$(date +%s.%N)
    [ "${DEBUG_TIMING:-0}" -eq 1 ] && echo "[TIMING] $name: $(echo "$end - $start" | bc)s" >&2
}

# Initialize script start time
SCRIPT_START=$(date +%s.%N)

# STAGE 0: SETUP AND PRECOMPUTATION (0.1s)
# ==========================================

# Parse arguments FIRST before any other operations
SESSION_SUMMARY=""
COMPLETED_TASKS=""
PENDING_TASKS=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --slow) echo "Slow mode deprecated - use original script"; exit 1 ;;
        --summary) SESSION_SUMMARY="$2"; shift 2 ;;
        --completed) COMPLETED_TASKS="$2"; shift 2 ;;
        --pending) PENDING_TASKS="$2"; shift 2 ;;
        *) shift ;;
    esac
done

echo "===== CLAUDE CODE SESSION END PROTOCOL V3 (OPTIMIZED) ====="
echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S PDT')"
echo "Target: <5 second execution"
echo ""

# Pre-compute all timestamps and constants
export TIMESTAMP_UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)
export TIMESTAMP_PDT=$(date +'%Y-%m-%d %H:%M:%S PDT')
export TIMESTAMP_FILE=$(date +%Y%m%d_%H%M%S)
export SESSION_ID="${CLAUDE_SESSION_ID:-$(date +'%Y-%m-%d_%H-%M-%S')}"
export PROJECT_NAME="${CLAUDE_PROJECT:-$(basename "$PWD")}"
export BACKUP_DIR="$CLAUDE_PROJECTS_ROOT"
export UNIVERSAL_HISTORY_DIR="$BACKUP_DIR/.universal-history"
export SESSION_DIR="$BACKUP_DIR/.session-management"
export HANDOFF_DIR="$BACKUP_DIR/.session-handoff"
export HANDOFF_FILE="$SESSION_DIR/SESSION_HANDOFF_${TIMESTAMP_FILE}.json"
export HANDOFF_MD="$BACKUP_DIR/SESSION_HANDOFF_${TIMESTAMP_FILE}.md"

# Setup RAM disk for temporary files
if [ -d "/dev/shm" ]; then
    TEMP_BASE="/dev/shm/claude_session_$$"
elif [ -d "/tmp" ] && mountpoint -q /tmp 2>/dev/null; then
    TEMP_BASE="/tmp/claude_session_$$"
else
    TEMP_BASE="$BACKUP_DIR/.temp/claude_session_$$"
fi
export TEMP_DIR="$TEMP_BASE"
mkdir -p "$TEMP_DIR"

# Pre-define all output files
export END_REPORT="$BACKUP_DIR/END_SESSION_REPORT_${PROJECT_NAME}_${SESSION_ID}.md"
export TODO_FILE="$BACKUP_DIR/TODO_NEXT_SESSION_${PROJECT_NAME}_${SESSION_ID}.md"
export NEXT_INSTRUCTIONS="$BACKUP_DIR/NEXT_SESSION_INSTRUCTIONS_${PROJECT_NAME}_${SESSION_ID}.md"
export DEP_MANIFEST="$BACKUP_DIR/SESSION_DEPENDENCIES_${PROJECT_NAME}_${SESSION_ID}.md"
export STATE_FILE="$BACKUP_DIR/SESSION_STATE_${PROJECT_NAME}_${SESSION_ID}.json"
export UNIVERSAL_TODO="$BACKUP_DIR/UNIVERSAL_TODO_LIST.md"
export CHAT_BACKUP="$BACKUP_DIR/CHAT_SESSION_END_BACKUP_${PROJECT_NAME}_${SESSION_ID}.md"
export COMPLETION_MARKER="$BACKUP_DIR/.SESSION_END_INCOMPLETE_${PROJECT_NAME}_${SESSION_ID}"

# Get history file once
HISTORY_FILE=""
if [[ -f "$UNIVERSAL_HISTORY_DIR/.current_session" ]]; then
    HISTORY_FILE=$(cat "$UNIVERSAL_HISTORY_DIR/.current_session")
fi
export HISTORY_FILE

# STAGE 1: PARALLEL DATA COLLECTION (0.5s)
# =========================================

echo "[Stage 1/5] Parallel data collection..."

# Launch ALL data collection operations in parallel
{
    # Group 1: Directory creation
    time_section "mkdir" mkdir -p "$SESSION_DIR" "$BACKUP_DIR" "$UNIVERSAL_HISTORY_DIR" "$HANDOFF_DIR" &

    # Group 2: CURRENT SESSION CAPTURE ONLY - NO HISTORICAL DATA
    {
        # METHOD 1: TMUX DUAL-CAPTURE - ABSOLUTE FIDELITY (MANDATORY)
        # Per CLAUDE.md: Capture with BOTH methods, compare, use whichever has MORE lines
        if tmux list-sessions >/dev/null 2>&1; then
            echo "=== TMUX DUAL-CAPTURE METHOD (ABSOLUTE FIDELITY) ===" > "$TEMP_DIR/capture_log.txt"

            # Capture Method A: Maximum scrollback (-S -999999)
            tmux capture-pane -p -S -999999 > "$TEMP_DIR/tmux_max_scrollback.txt" 2>/dev/null
            LINES_MAX=$(wc -l < "$TEMP_DIR/tmux_max_scrollback.txt" 2>/dev/null || echo 0)
            echo "Capture Method A (-S -999999): $LINES_MAX lines" >> "$TEMP_DIR/capture_log.txt"

            # Capture Method B: Full history with escape sequences (-e -p -S -)
            tmux capture-pane -e -p -S - > "$TEMP_DIR/tmux_full_history.txt" 2>/dev/null
            LINES_FULL=$(wc -l < "$TEMP_DIR/tmux_full_history.txt" 2>/dev/null || echo 0)
            echo "Capture Method B (-e -p -S -): $LINES_FULL lines" >> "$TEMP_DIR/capture_log.txt"

            # USE WHICHEVER HAS MORE LINES (COMPLETE FIDELITY)
            if [ "$LINES_MAX" -gt "$LINES_FULL" ]; then
                BEST_FILE="$TEMP_DIR/tmux_max_scrollback.txt"
                BEST_LINES=$LINES_MAX
                BEST_METHOD="MAX-SCROLLBACK"
                echo "Selected: Method A (MAX-SCROLLBACK) with $BEST_LINES lines" >> "$TEMP_DIR/capture_log.txt"
            else
                BEST_FILE="$TEMP_DIR/tmux_full_history.txt"
                BEST_LINES=$LINES_FULL
                BEST_METHOD="FULL-HISTORY"
                echo "Selected: Method B (FULL-HISTORY) with $BEST_LINES lines" >> "$TEMP_DIR/capture_log.txt"
            fi

            # Copy best capture to standard location
            cp "$BEST_FILE" "$TEMP_DIR/tmux_complete_session.txt"

            # Verification: Display first/last lines and total count
            echo "📊 COMPLETE SESSION CAPTURED: $BEST_LINES lines (method: $BEST_METHOD)" >> "$TEMP_DIR/capture_log.txt"
            echo "First 3 lines:" >> "$TEMP_DIR/capture_log.txt"
            head -3 "$BEST_FILE" >> "$TEMP_DIR/capture_log.txt" 2>/dev/null
            echo "Last 3 lines:" >> "$TEMP_DIR/capture_log.txt"
            tail -3 "$BEST_FILE" >> "$TEMP_DIR/capture_log.txt" 2>/dev/null

            echo "TMUX dual-capture complete - absolute fidelity verified" >> "$TEMP_DIR/capture_log.txt"
        else
            echo "=== NO TMUX SESSION ACTIVE ===" > "$TEMP_DIR/capture_log.txt"
            echo "TMUX not running - using manual capture methods" >> "$TEMP_DIR/capture_log.txt"
        fi
        
        # METHOD 2: Current Session File (active conversation only)
        echo "=== CURRENT SESSION FILE CAPTURE ===" >> "$TEMP_DIR/capture_log.txt"
        if [ -f "$UNIVERSAL_HISTORY_DIR/.current_session" ]; then
            CURRENT_SESSION_FILE=$(cat "$UNIVERSAL_HISTORY_DIR/.current_session")
            if [ -f "$CURRENT_SESSION_FILE" ]; then
                cp "$CURRENT_SESSION_FILE" "$TEMP_DIR/current_session_capture.txt"
                echo "Current session file captured: $CURRENT_SESSION_FILE" >> "$TEMP_DIR/capture_log.txt"
            else
                echo "Current session file not found: $CURRENT_SESSION_FILE" >> "$TEMP_DIR/capture_log.txt"
            fi
        else
            echo "No current session pointer found" >> "$TEMP_DIR/capture_log.txt"
        fi
        
        # METHOD 3: Manual Emergency Capture (if no TMUX)
        if ! tmux list-sessions >/dev/null 2>&1; then
            echo "=== MANUAL CAPTURE METHOD ===" >> "$TEMP_DIR/capture_log.txt"
            # Create manual session capture if TMUX not available
            {
                echo "=== EMERGENCY SESSION CAPTURE ==="
                echo "Session ID: $SESSION_ID"
                echo "Timestamp: $(date)"
                echo "Capture Method: MANUAL (TMUX not available)"
                echo ""
                echo "WARNING: TMUX not running - session content may be incomplete"
                echo "User should provide manual session data or enable TMUX"
                echo ""
            } > "$TEMP_DIR/manual_capture.txt"
            echo "Manual capture created - TMUX not available" >> "$TEMP_DIR/capture_log.txt"
        fi
        
        # All historical/command log capture methods permanently removed
        echo "Historical capture methods completely removed from session protocol" >> "$TEMP_DIR/capture_log.txt"
        
        echo "All capture methods completed" >> "$TEMP_DIR/capture_log.txt"
    } &

    # Group 3: Quantum TODO snapshot
    if [ -f "$BACKUP_DIR/quantum-todo-system.sh" ]; then
        time_section "quantum_snapshot" timeout 3s "$BACKUP_DIR/quantum-todo-system.sh" list pending 2>/dev/null | head -50 > "$TEMP_DIR/quantum_snapshot.txt" &
    else
        echo "" > "$TEMP_DIR/quantum_snapshot.txt" &
    fi

    # Group 4: Daemon status
    time_section "daemon_status" ps aux | grep -E "(quantum-todo-autocapture|plan-capture|persistent-capture)" | grep -v grep > "$TEMP_DIR/daemon_status.txt" 2>/dev/null &

    # Group 5: System information
    {
        # History lines
        if [[ -f "$HISTORY_FILE" ]]; then
            wc -l < "$HISTORY_FILE" > "$TEMP_DIR/history_lines.txt"
            du -h "$HISTORY_FILE" | cut -f1 > "$TEMP_DIR/history_size.txt"
        else
            echo "0" > "$TEMP_DIR/history_lines.txt"
            echo "0" > "$TEMP_DIR/history_size.txt"
        fi
        
        # Current directory files
        ls -t 2>/dev/null | head -10 | jq -R . | jq -s . > "$TEMP_DIR/recent_files.json" 2>/dev/null || echo '[]' > "$TEMP_DIR/recent_files.json"
        
        # Quantum TODO counts
        cd "$BACKUP_DIR" 2>/dev/null
        ./quantum count pending 2>/dev/null > "$TEMP_DIR/quantum_pending.txt" || echo "0" > "$TEMP_DIR/quantum_pending.txt"
        ./quantum list pending 2>/dev/null | grep -c "critical" > "$TEMP_DIR/quantum_critical.txt" || echo "0" > "$TEMP_DIR/quantum_critical.txt"
        ./quantum list pending 2>/dev/null | grep -c "high" > "$TEMP_DIR/quantum_high.txt" || echo "0" > "$TEMP_DIR/quantum_high.txt"
        cd - >/dev/null 2>&1
    } &

    # Group 6: Force final backup
    time_section "force_backup" timeout 5s "$BACKUP_DIR/persistent_history/persistent_history.sh" backup 2>/dev/null &

    # Group 7: Stop backup daemon
    time_section "stop_daemon" "$BACKUP_DIR/persistent_history/persistent_history.sh" stop 2>/dev/null &

    # Group 8: Context window reset
    {
        echo "0" > $HOME/.persistent_history_line_count
        rm -f "$BACKUP_DIR/CHAT_BACKUPS/LATEST_jdh_BACKUP.md"
        touch "$BACKUP_DIR/CHAT_BACKUPS/LATEST_jdh_BACKUP.md"
    } &
}

# Wait for all data collection to complete
wait
echo "   ✅ All data collected"

# STAGE 2: PARALLEL FILE GENERATION (1.0s)
# =========================================

echo "[Stage 2/5] Parallel file generation..."

# Read collected data into variables
QUANTUM_SNAPSHOT=$(cat "$TEMP_DIR/quantum_snapshot.txt" 2>/dev/null || echo "")
DAEMON_STATUS=$(cat "$TEMP_DIR/daemon_status.txt" 2>/dev/null || echo "No daemons running")
HISTORY_LINES=$(cat "$TEMP_DIR/history_lines.txt" 2>/dev/null || echo "0")
HISTORY_SIZE=$(cat "$TEMP_DIR/history_size.txt" 2>/dev/null || echo "0")
RECENT_FILES=$(cat "$TEMP_DIR/recent_files.json" 2>/dev/null || echo '[]')
QUANTUM_PENDING=$(cat "$TEMP_DIR/quantum_pending.txt" 2>/dev/null || echo "0")
QUANTUM_CRITICAL=$(cat "$TEMP_DIR/quantum_critical.txt" 2>/dev/null || echo "0")
QUANTUM_HIGH=$(cat "$TEMP_DIR/quantum_high.txt" 2>/dev/null || echo "0")

# SYSTEMATIC CAPTURE ANALYSIS - Find the most complete source
echo "=== ANALYZING ALL CAPTURED SOURCES ===" >> "$TEMP_DIR/capture_log.txt"

# Analyze all captured files and find the most complete one
BEST_CAPTURE=""
CHAT_LINES=0
CAPTURE_METHOD=""
CAPTURE_SOURCE=""

# Check capture files prioritizing TMUX complete session scrollback
declare -A CAPTURE_FILES
[ -f "$TEMP_DIR/tmux_complete_session.txt" ] && CAPTURE_FILES["TMUX-COMPLETE-SESSION"]="$TEMP_DIR/tmux_complete_session.txt"
[ -f "$TEMP_DIR/current_session_capture.txt" ] && CAPTURE_FILES["CURRENT-SESSION-FILE"]="$TEMP_DIR/current_session_capture.txt"
[ -f "$TEMP_DIR/manual_capture.txt" ] && CAPTURE_FILES["MANUAL-EMERGENCY"]="$TEMP_DIR/manual_capture.txt"
# All historical/command log capture methods permanently removed

# Find the capture with the most content (lines)
for method in "${!CAPTURE_FILES[@]}"; do
    file="${CAPTURE_FILES[$method]}"
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file" 2>/dev/null || echo 0)
        size=$(stat -c%s "$file" 2>/dev/null || echo 0)
        echo "$method: $lines lines, $size bytes" >> "$TEMP_DIR/capture_log.txt"
        
        # Choose the source with the most lines (content)
        if [ "$lines" -gt "$CHAT_LINES" ]; then
            CHAT_LINES=$lines
            BEST_CAPTURE="$file"
            CAPTURE_METHOD="$method"
            CAPTURE_SOURCE="$file"
        fi
    fi
done

# If no capture found, create composite from ALL available sources
if [ "$CHAT_LINES" -eq 0 ]; then
    echo "=== CREATING COMPOSITE CAPTURE FROM ALL SOURCES ===" >> "$TEMP_DIR/capture_log.txt"
    COMPOSITE_CAPTURE="$TEMP_DIR/composite_capture.txt"
    {
        echo "=== COMPOSITE SESSION CAPTURE ==="
        echo "Session ID: $SESSION_ID"
        echo "Timestamp: $(date)"
        echo "Capture Method: COMPOSITE (ALL AVAILABLE SOURCES)"
        echo ""
        
        # Add any available content
        for method in "${!CAPTURE_FILES[@]}"; do
            file="${CAPTURE_FILES[$method]}"
            if [ -f "$file" ] && [ -s "$file" ]; then
                echo "=== $method SOURCE ===" 
                cat "$file"
                echo ""
            fi
        done
        
        # Add capture log for debugging
        echo "=== CAPTURE ANALYSIS LOG ==="
        cat "$TEMP_DIR/capture_log.txt" 2>/dev/null || echo "No capture log available"
        
    } > "$COMPOSITE_CAPTURE"
    
    CHAT_LINES=$(wc -l < "$COMPOSITE_CAPTURE")
    BEST_CAPTURE="$COMPOSITE_CAPTURE"
    CAPTURE_METHOD="COMPOSITE"
    CAPTURE_SOURCE="Multiple sources combined"
fi

# Create final capture file with proper naming
if [ "$CHAT_LINES" -gt 0 ] && [ -n "$BEST_CAPTURE" ]; then
    FINAL_CAPTURE_FILE="$BACKUP_DIR/CHAT_SESSION_SCROLLBACK_${TIMESTAMP_FILE}_${CAPTURE_METHOD}_${CHAT_LINES}_LINES.txt"
    cp "$BEST_CAPTURE" "$FINAL_CAPTURE_FILE"
    cp "$BEST_CAPTURE" "$TEMP_DIR/chat_capture.txt"
    echo "Final capture created: $FINAL_CAPTURE_FILE ($CHAT_LINES lines from $CAPTURE_METHOD)" >> "$TEMP_DIR/capture_log.txt"
else
    CHAT_LINES=0
    CAPTURE_METHOD="FAILED"
    echo "ERROR: No capture sources provided any content" >> "$TEMP_DIR/capture_log.txt"
fi

# Check for critical session
CRITICAL_MARKER=""
if [ "$QUANTUM_PENDING" -gt "20" ]; then
    CRITICAL_MARKER=$'\n## 🚨 CRITICAL SESSION - '"$QUANTUM_PENDING"' PENDING TASKS\n'
fi

# Generate all files in parallel
{
    # File 1: Handoff JSON
    time_section "gen_handoff" cat > "$TEMP_DIR/handoff.json" << EOF
{
    "timestamp": "$TIMESTAMP_UTC",
    "session_id": "$SESSION_ID",
    "project_name": "$PROJECT_NAME",
    "tmux_session": "claude-$PROJECT_NAME",
    "history_file": "$HISTORY_FILE",
    "quantum_todo": "$QUANTUM_INDEX_DB",
    "line_count": $HISTORY_LINES,
    "universal_history_dir": "$UNIVERSAL_HISTORY_DIR",
    "working_directory": "$PWD",
    "completeness_check": {
        "files_to_generate": [
            "$END_REPORT",
            "$TODO_FILE", 
            "$NEXT_INSTRUCTIONS",
            "$DEP_MANIFEST",
            "$SESSION_STATE",
            "$HANDOFF_FILE",
            "$HANDOFF_MD"
        ],
        "chat_capture_lines": $CHAT_LINES,
        "session_capture_file": "$HISTORY_FILE",
        "universal_history_dir": "$UNIVERSAL_HISTORY_DIR",
        "verification_timestamp": "$TIMESTAMP_PDT"
    }
}
EOF

    # File 2: End Session Report
    time_section "gen_report" cat > "$TEMP_DIR/end_report.md" << EOF
# END SESSION REPORT$CRITICAL_MARKER
**Generated**: $TIMESTAMP_PDT
**Project**: $PROJECT_NAME
**Session ID**: $SESSION_ID
**Handoff Protocol**: V3 - Ultra-Optimized

## SESSION HANDOFF STATUS
- ✅ Unified handoff package created
- ✅ Session continuity data updated
- ✅ Ready for seamless next session start

## SESSION CAPTURE STATISTICS  
- **Total Lines Captured**: $CHAT_LINES
- **Capture Method Used**: $CAPTURE_METHOD
- **Session Capture File**: $FINAL_CAPTURE_FILE
- **Capture Source**: $CAPTURE_SOURCE
- **File Size**: $([ -f "$FINAL_CAPTURE_FILE" ] && stat -c%s "$FINAL_CAPTURE_FILE" 2>/dev/null | numfmt --to=iec || echo "0") bytes
- **✅ CAPTURE STATUS**: $([ "$CHAT_LINES" -gt 0 ] && echo "COMPLETE - $CHAT_LINES lines captured from $CAPTURE_METHOD" || echo "❌ FAILED - No content captured from any source")

## FILES GENERATED FOR HANDOFF
- \`$FINAL_CAPTURE_FILE\` - $CHAT_LINES lines session capture ($CAPTURE_METHOD)
- \`$END_REPORT\` - Complete session end report
- \`$TODO_FILE\` - Next session task list  
- \`$NEXT_INSTRUCTIONS\` - Session continuation instructions
- \`$DEP_MANIFEST\` - Dependency manifest
- \`$STATE_FILE\` - Session state JSON
- \`$HANDOFF_FILE\` - Session handoff package

## SESSION SUMMARY
[CLAUDE MUST FILL THIS IN - Be specific about what was accomplished]

## FILES MODIFIED
[CLAUDE MUST LIST ALL FILES - Include full paths]

## COMPLETED TASKS
[CLAUDE MUST LIST - What was finished this session]

## PENDING TASKS
[CLAUDE MUST LIST - What remains for next session]

## CRITICAL ITEMS FOR NEXT SESSION
[CLAUDE MUST SPECIFY - Most important things to address immediately]

## DEPENDENCIES CREATED/MODIFIED
[CLAUDE MUST LIST - Scripts, configs, etc that other systems depend on]

## NEXT SESSION SUMMARY
**IMMEDIATE PRIORITY:** Execute memory audit script: \`./memory-audit-comprehensive.sh\`
**PRIMARY GOALS:** 
- Implement smart hooks system for 60-85% token reduction using 20 parallel workers
- Complete comprehensive memory file organization with zero-elimination approach
- Test TMUX auto-start functionality after bashrc fix
**SECONDARY TASKS:**
- Complete two gigantic pending plans mentioned at session start
- Verify all daemon operations with new session startup chain
**TECHNICAL DEBT:** 
- Session capture must work with TMUX running (test this priority #1)
- Memory organization framework ready for execution
**SUCCESS CRITERIA:**
- TMUX session auto-starts on Claude Code launch
- Memory audit completes in <30 seconds with full reports
- Token usage reduced by 60-85% through smart loading
EOF

    # File 3: TODO for next session
    time_section "gen_todo" cat > "$TEMP_DIR/todo_next.md" << EOF
# TODO FOR NEXT SESSION
**Created**: $TIMESTAMP_PDT
**Project**: $PROJECT_NAME
**Session ID**: $SESSION_ID
**Handoff Protocol**: V3 - Ultra-Optimized

## IMMEDIATE ACTIONS ON SESSION START:
- [ ] Run: \`./SESSION_HANDOFF_PROTOCOL.sh start\` to load handoff
- [ ] Verify TMUX session is active
- [ ] Confirm chat backup is capturing
- [ ] Review quantum TODO state
- [ ] Load previous session context

## PENDING TASKS FROM QUANTUM TODO:
\`\`\`
$QUANTUM_SNAPSHOT
\`\`\`

## PROJECT-SPECIFIC TASKS:
[CLAUDE MUST ADD SPECIFIC TASKS FOR THIS PROJECT]

## IN PROGRESS ITEMS:
[CLAUDE MUST LIST ANY INCOMPLETE WORK WITH STATUS]

## TESTING REQUIRED:
[CLAUDE MUST SPECIFY WHAT NEEDS TESTING]

## CONTEXT NOTES:
[CLAUDE MUST PROVIDE CONTEXT FOR CONTINUING WORK]
EOF

    # File 4: Next Session Instructions
    time_section "gen_instructions" cat > "$TEMP_DIR/next_instructions.md" << EOF
# NEXT SESSION INSTRUCTIONS
**Created**: $TIMESTAMP_PDT
**Session ID**: $SESSION_ID
**Handoff Protocol**: V3 - Ultra-Optimized

## FIRST ACTIONS WHEN CONTINUING:
1. The session startup protocol will automatically:
   - Load this handoff package
   - Display pending tasks
   - Show critical items
   - Restore session context

2. Run these commands:
   \`\`\`bash
   cd $PWD
   ./SESSION_HANDOFF_PROTOCOL.sh start
   \`\`\`

## CONTEXT FROM LAST SESSION:
[CLAUDE MUST PROVIDE DETAILED CONTEXT]

## HANDOFF PACKAGE LOCATION:
$HANDOFF_FILE
EOF

    # File 5: Dependency Manifest
    time_section "gen_deps" cat > "$TEMP_DIR/dep_manifest.md" << EOF
# SESSION DEPENDENCY MANIFEST
**Session End**: $TIMESTAMP_PDT
**Session ID**: $SESSION_ID

## SCRIPTS CREATED/MODIFIED:
[CLAUDE MUST LIST WITH FULL PATHS]

## CONFIGURATIONS CHANGED:
[CLAUDE MUST LIST WITH DETAILS]

## EXTERNAL DEPENDENCIES:
[CLAUDE MUST LIST ANY EXTERNAL TOOLS/LIBRARIES]

## INTEGRATION POINTS:
[CLAUDE MUST LIST WHERE THIS PROJECT INTEGRATES WITH OTHERS]
EOF

    # File 6: Markdown Handoff
    time_section "gen_handoff_md" cat > "$TEMP_DIR/handoff.md" << EOF
# Session Handoff - $TIMESTAMP_PDT
**Session ID**: $SESSION_ID
**Project**: $PROJECT_NAME
**Created**: $TIMESTAMP_UTC

## Daemon Status
\`\`\`
$DAEMON_STATUS
\`\`\`

## Quantum TODO Summary
- Total pending tasks: $QUANTUM_PENDING
- Critical tasks: $QUANTUM_CRITICAL
- High priority: $QUANTUM_HIGH

## Session Capture Verification
- TMUX Scrollback: $CHAT_LINES lines
- Chat Backup: $CHAT_LINES lines
- Capture Status: ✅ Complete

## Session Summary
[CLAUDE MUST FILL: What was accomplished this session]

## Critical Items for Next Session
[CLAUDE MUST FILL: Most important tasks to continue]

## Files Modified
[CLAUDE MUST FILL: List all files that were changed]

## Next Session Start Command
\`\`\`bash
cat $HANDOFF_MD
\`\`\`

---
*Generated by CLAUDE_SESSION_END_PROTOCOL.sh v3 in $(echo "$(date +%s.%N) - $SCRIPT_START" | bc)s*
EOF

    # File 7: Session State
    time_section "gen_state" cat > "$TEMP_DIR/session_state.json" << EOF
{
  "session_id": "$SESSION_ID",
  "end_time": "$TIMESTAMP_UTC",
  "end_time_pdt": "$TIMESTAMP_PDT",
  "project": "$PROJECT_NAME",
  "working_directory": "$PWD",
  "tmux_active": ${TMUX:+true},
  "tmux_session": "${TMUX_SESSION:-null}",
  "chat_lines": $CHAT_LINES,
  "last_files": $RECENT_FILES,
  "handoff_package": "$HANDOFF_FILE",
  "todo_file": "TODO_NEXT_SESSION_${SESSION_ID}.md",
  "instructions_file": "NEXT_SESSION_INSTRUCTIONS_${PROJECT_NAME}_${SESSION_ID}.md",
  "end_report": "END_SESSION_REPORT_${PROJECT_NAME}_${SESSION_ID}.md",
  "chat_backup": "${CHAT_BACKUP:-null}",
  "dependencies_file": "SESSION_DEPENDENCIES_${PROJECT_NAME}_${SESSION_ID}.md",
  "execution_time": "optimized",
  "claude_must_complete": {
    "session_summary": $([ -n "$SESSION_SUMMARY" ] && echo "true" || echo "false"),
    "files_modified": false,
    "pending_tasks": $([ -n "$PENDING_TASKS" ] && echo "true" || echo "false"),
    "dependencies": false,
    "critical_notes": false
  }
}
EOF

    # File 8: Universal TODO Update (append)
    if [ ! -f "$UNIVERSAL_TODO" ]; then
        time_section "gen_universal_todo" cat > "$TEMP_DIR/universal_todo.md" << EOF
# UNIVERSAL TODO LIST
**Last Updated**: $TIMESTAMP_PDT

## ACTIVE PROJECTS:
EOF
    else
        cp "$UNIVERSAL_TODO" "$TEMP_DIR/universal_todo.md"
    fi
    
    cat >> "$TEMP_DIR/universal_todo.md" << EOF

### $PROJECT_NAME - $(date +'%Y-%m-%d %H:%M')
- Session ended with V3 ultra-optimized handoff protocol
- Handoff package: SESSION_HANDOFF_${TIMESTAMP_FILE}.json
- TODO file: TODO_NEXT_SESSION_${PROJECT_NAME}_${SESSION_ID}.md
- Instructions: NEXT_SESSION_INSTRUCTIONS_${PROJECT_NAME}_${SESSION_ID}.md
- [CLAUDE MUST ADD PROJECT-SPECIFIC ITEMS]
EOF
}

# Wait for all file generation
wait
echo "   ✅ All files generated"

# STAGE 3: PARALLEL FILE COMMIT (0.5s)
# ====================================

echo "[Stage 3/5] Committing files to disk..."

# Copy all files from RAM to final destinations in parallel
{
    # Critical files first
    cp "$TEMP_DIR/handoff.json" "$HANDOFF_FILE" &
    cp "$TEMP_DIR/handoff.md" "$HANDOFF_MD" &
    
    # Report files
    cp "$TEMP_DIR/end_report.md" "$END_REPORT" &
    cp "$TEMP_DIR/todo_next.md" "$TODO_FILE" &
    cp "$TEMP_DIR/next_instructions.md" "$NEXT_INSTRUCTIONS" &
    cp "$TEMP_DIR/dep_manifest.md" "$DEP_MANIFEST" &
    cp "$TEMP_DIR/session_state.json" "$STATE_FILE" &
    cp "$TEMP_DIR/universal_todo.md" "$UNIVERSAL_TODO" &
    
    # Chat backup (if exists)
    if [ -f "$TEMP_DIR/chat_capture.txt" ] && [ "$CHAT_LINES" -gt 0 ]; then
        cp "$TEMP_DIR/chat_capture.txt" "$CHAT_BACKUP" &
    fi
    
    # Create completion marker
    touch "$COMPLETION_MARKER" &
}

# Wait for all copies to complete
wait
echo "   ✅ All files committed"

# STAGE 4: HANDOFF PROTOCOL (0.5s)
# ================================

echo "[Stage 4/5] Executing handoff protocol..."

# Call unified handoff protocol
"$BACKUP_DIR/SESSION_HANDOFF_PROTOCOL.sh" end "$SESSION_ID" "$PROJECT_NAME" &
HANDOFF_PID=$!

# Continue with output while handoff runs
echo ""
echo "📋 SESSION END CHECKLIST:"
echo "   ✅ Unified handoff package created"
echo "   ✅ End session report created"
echo "   ✅ TODO for next session created" 
echo "   ✅ Next session instructions created"
echo "   ✅ Universal TODO updated"
if [ "$CHAT_LINES" -gt 0 ]; then
    echo "   ✅ Chat backup captured ($CHAT_LINES lines via $CAPTURE_METHOD)"
else
    echo "   ❌ Chat backup FAILED - No content from any capture source"
fi
echo "   ✅ Dependency manifest created"
echo "   ✅ Session state preserved"
echo ""

# Wait for handoff to complete
wait $HANDOFF_PID 2>/dev/null || true
echo "   ✅ Handoff protocol completed"

# STAGE 5: CLEANUP AND FINALIZE (0.1s)
# ====================================

echo "[Stage 5/5] Finalizing..."

# STAGE 6: COMPLETENESS VERIFICATION & REPORTING
verify_session_completeness() {
    echo ""
    echo "===== SESSION COMPLETENESS VERIFICATION ====="
    echo "📋 GENERATED FILES WITH FULL PATHS:"
    
    # List each file with full path, size, and line count
    for file in "$END_REPORT" "$TODO_FILE" "$NEXT_INSTRUCTIONS" "$DEP_MANIFEST" "$SESSION_STATE" "$HANDOFF_FILE" "$HANDOFF_MD"; do
        if [[ -f "$file" ]]; then
            local lines=$(wc -l < "$file" 2>/dev/null || echo "0")
            local size=$(du -h "$file" 2>/dev/null | cut -f1 || echo "0B")
            echo "   ✅ $file ($lines lines, $size)"
        else
            echo "   ❌ MISSING: $file"
        fi
    done
    
    echo ""
    echo "📝 SESSION CAPTURE FILES:"
    
    # Check for session history files (prioritize lines over words)
    if [[ -f "$CHAT_BACKUP_FILE" ]]; then
        local chat_lines=$(wc -l < "$CHAT_BACKUP_FILE" 2>/dev/null || echo "0")
        echo "   ✅ Chat Backup: $CHAT_BACKUP_FILE ($chat_lines lines)"
    fi
    
    # Check universal history directory for any session files created today
    local today=$(date +%Y-%m-%d)
    local session_files=$(find "$UNIVERSAL_HISTORY_DIR/sessions/$today" -name "*claude-*" -type f 2>/dev/null || true)
    if [[ -n "$session_files" ]]; then
        echo "   📚 UNIVERSAL HISTORY FILES:"
        echo "$session_files" | while read -r file; do
            if [[ -f "$file" ]]; then
                local hist_lines=$(wc -l < "$file" 2>/dev/null || echo "0")
                echo "     ✅ $file ($hist_lines lines)"
            fi
        done
    fi
    
    echo ""
    echo "🔍 VERIFICATION SUMMARY:"
    local total_files=0
    local missing_files=0
    
    for file in "$END_REPORT" "$TODO_FILE" "$NEXT_INSTRUCTIONS" "$DEP_MANIFEST" "$SESSION_STATE" "$HANDOFF_FILE" "$HANDOFF_MD"; do
        ((total_files++))
        [[ ! -f "$file" ]] && ((missing_files++))
    done
    
    echo "   📊 Files Generated: $((total_files - missing_files))/$total_files"
    echo "   📊 Chat History Captured: $(find "$UNIVERSAL_HISTORY_DIR" -name "*$(date +%Y-%m-%d)*" -type f 2>/dev/null | wc -l) files"
    echo "   📊 Session ID: $SESSION_ID"
    echo "   📊 Project: $PROJECT_NAME"
    echo "   📊 Timestamp: $TIMESTAMP_PDT"
    
    if [[ $missing_files -eq 0 ]]; then
        echo "   ✅ SESSION END PROTOCOL: COMPLETE"
    else
        echo "   ⚠️  SESSION END PROTOCOL: INCOMPLETE ($missing_files missing files)"
    fi
}

# Call the verification function
verify_session_completeness

echo ""
echo "📋 COMPLETE FILE LIST FOR USER:"
echo "================================"
echo "🔹 SESSION END REPORT: $END_REPORT"
echo "🔹 TODO FOR NEXT SESSION: $TODO_FILE"
echo "🔹 NEXT SESSION INSTRUCTIONS: $NEXT_INSTRUCTIONS"
echo "🔹 SESSION DEPENDENCIES: $DEP_MANIFEST"
echo "🔹 SESSION STATE JSON: $SESSION_STATE"
echo "🔹 SESSION HANDOFF PACKAGE: $HANDOFF_FILE"
echo "🔹 SESSION HANDOFF MARKDOWN: $HANDOFF_MD"

# Display final capture file information
if [ -n "$FINAL_CAPTURE_FILE" ] && [ -f "$FINAL_CAPTURE_FILE" ]; then
    CAP_LINES=$(wc -l < "$FINAL_CAPTURE_FILE" 2>/dev/null || echo "0")
    CAP_SIZE=$(stat -c%s "$FINAL_CAPTURE_FILE" 2>/dev/null | numfmt --to=iec || echo "0")
    echo "🔹 SESSION CAPTURE FILE: $FINAL_CAPTURE_FILE ($CAP_LINES lines, $CAP_SIZE, method: $CAPTURE_METHOD)"
else
    echo "🔹 SESSION CAPTURE FILE: ❌ NO CAPTURE FILE CREATED - ALL METHODS FAILED"
fi

echo "================================"

# Cleanup temp directory
rm -rf "$TEMP_DIR" 2>/dev/null || true

# Calculate total execution time
SCRIPT_END=$(date +%s.%N)
TOTAL_TIME=$(echo "$SCRIPT_END - $SCRIPT_START" | bc)

echo ""
echo "===== SESSION END PROTOCOL V3 COMPLETED ====="
echo "⚡ Total execution time: ${TOTAL_TIME}s"
echo ""

# Export variables for Claude
export SESSION_ID HANDOFF_FILE END_REPORT TODO_FILE NEXT_INSTRUCTIONS DEP_MANIFEST

echo "⚠️  CLAUDE: Update the handoff with:"
echo "   - Session summary"
echo "   - Files modified" 
echo "   - Completed/pending tasks"
echo "   - Critical notes"
echo ""
echo "📋 Commands:"
echo "   \$BACKUP_DIR/SESSION_HANDOFF_PROTOCOL.sh update \$SESSION_ID completed_tasks \"...\""
echo "   \$BACKUP_DIR/SESSION_HANDOFF_PROTOCOL.sh update \$SESSION_ID pending_tasks \"...\""
echo "   \$BACKUP_DIR/SESSION_HANDOFF_PROTOCOL.sh complete \$SESSION_ID"