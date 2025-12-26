#!/bin/bash
################################################################################
# GenCraft Completion Watcher Daemon
# Purpose: Monitor GenCraft development progress and notify when ready for
#          BuildCraft integration via TMUX popup notifications
# Created: 2025-12-25
# Part of: BuildCraft-GenCraft Auto-Integration System
################################################################################

# Source contractual paths for dynamic path resolution
if [ -f "/mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh" ]; then
    source "/mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh"
else
    echo "ERROR: contractual-paths-true.sh not found"
    exit 1
fi

# Configuration
DAEMON_NAME="gencraft-completion-watcher"
PID_FILE="/tmp/${DAEMON_NAME}.pid"
LOG_FILE="${CLAUDE_PROJECTS_ROOT}/.daemon-registry/logs/${DAEMON_NAME}.log"
CHECK_INTERVAL=300  # 5 minutes (300 seconds)

# GenCraft detection paths
GENCRAFT_ROOT="${CLAUDE_PROJECTS_ROOT}/projects/github-repos/gencraft-v3.0"
TOOL_SPEC_ENGINE="${GENCRAFT_ROOT}/engines/tool-specification-engine.js"
READY_FLAG="${GENCRAFT_ROOT}/.gencraft-ready"
ENGINE_PROFILES_DIR="${GENCRAFT_ROOT}/engine-profiles"

# Integration script location
INTEGRATION_SCRIPT="${CLAUDE_PROJECTS_ROOT}/auto-integrate-buildcraft-system.sh"

# Quantum TODO command
QUANTUM_TODO="${CLAUDE_PROJECTS_ROOT}/quantum-todo"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

################################################################################
# Logging Functions
################################################################################

log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

log_error() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $message" | tee -a "$LOG_FILE" >&2
}

################################################################################
# TMUX Notification Functions
################################################################################

broadcast_tmux_notification() {
    local title="$1"
    local message="$2"
    local duration="${3:-10000}"  # Default 10 seconds

    # Method 1: Display message to all sessions (visible in all panes)
    tmux display-message -d "$duration" "🚨 $title: $message" 2>/dev/null

    # Method 2: Send notification to each pane individually
    # Get all TMUX sessions
    local sessions=$(tmux list-sessions -F '#S' 2>/dev/null)

    if [ -z "$sessions" ]; then
        log "No TMUX sessions found for broadcast"
        return 1
    fi

    for session in $sessions; do
        # Get all windows in this session
        local windows=$(tmux list-windows -t "$session" -F '#I' 2>/dev/null)

        for window in $windows; do
            # Get all panes in this window
            local panes=$(tmux list-panes -t "$session:$window" -F '#P' 2>/dev/null)

            for pane in $panes; do
                # Display notification in each pane
                tmux display-message -t "$session:$window.$pane" -d "$duration" \
                    "🚨 $title" 2>/dev/null
                tmux display-message -t "$session:$window.$pane" -d "$duration" \
                    "$message" 2>/dev/null
            done
        done
    done

    log "TMUX notification broadcast: $title"
    return 0
}

send_integration_ready_notification() {
    local title="GenCraft READY - BuildCraft Integration Available"
    local message="GenCraft Tool Specification Engine is complete!

Navigate to: $CLAUDE_PROJECTS_ROOT
Run: ./auto-integrate-buildcraft-system.sh

This will start the interactive BuildCraft integration with step-by-step approvals."

    # Broadcast to all TMUX sessions
    broadcast_tmux_notification "$title" "$message" 15000

    # Also create quantum TODO task as backup notification
    if [ -x "$QUANTUM_TODO" ]; then
        "$QUANTUM_TODO" add "URGENT: GenCraft ready for BuildCraft integration - Run ./auto-integrate-buildcraft-system.sh" \
            --project "buildcraft,gencraft" \
            --priority "critical" 2>&1 | tee -a "$LOG_FILE"
    fi

    log "Integration ready notification sent successfully"
}

################################################################################
# GenCraft Detection Functions
################################################################################

check_gencraft_ready() {
    local checks_passed=0
    local checks_failed=0
    local status_message=""

    # Check 1: Tool Specification Engine exists
    if [ -f "$TOOL_SPEC_ENGINE" ]; then
        status_message+="✅ Tool Specification Engine exists\n"
        ((checks_passed++))
    else
        status_message+="❌ Tool Specification Engine not found\n"
        ((checks_failed++))
    fi

    # Check 2: .gencraft-ready flag exists
    if [ -f "$READY_FLAG" ]; then
        status_message+="✅ .gencraft-ready flag set\n"
        ((checks_passed++))
    else
        status_message+="❌ .gencraft-ready flag not set\n"
        ((checks_failed++))
    fi

    # Check 3: Engine profiles directory exists
    if [ -d "$ENGINE_PROFILES_DIR" ]; then
        status_message+="✅ Engine profiles directory exists\n"
        ((checks_passed++))
    else
        status_message+="❌ Engine profiles directory not found\n"
        ((checks_failed++))
    fi

    # Check 4: Integration script exists
    if [ -f "$INTEGRATION_SCRIPT" ]; then
        status_message+="✅ Integration script ready\n"
        ((checks_passed++))
    else
        status_message+="❌ Integration script not found\n"
        ((checks_failed++))
    fi

    # Log status
    log "GenCraft readiness check: $checks_passed passed, $checks_failed failed"

    # Return success if at least 2 critical checks pass (Tool Engine + Ready Flag)
    if [ -f "$TOOL_SPEC_ENGINE" ] && [ -f "$READY_FLAG" ]; then
        return 0
    else
        return 1
    fi
}

################################################################################
# Daemon Control Functions
################################################################################

start_daemon() {
    # Check if already running
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            log_error "Daemon already running with PID $pid"
            return 1
        else
            # Stale PID file, remove it
            rm -f "$PID_FILE"
        fi
    fi

    # Start monitoring loop in background
    log "Starting $DAEMON_NAME daemon"

    # Daemonize
    (
        # Save PID
        echo $$ > "$PID_FILE"

        # Main monitoring loop
        local notification_sent=false

        while true; do
            # Check if GenCraft is ready
            if check_gencraft_ready; then
                if [ "$notification_sent" = false ]; then
                    log "GenCraft detected as READY for BuildCraft integration!"
                    send_integration_ready_notification
                    notification_sent=true

                    # Continue monitoring but don't send duplicate notifications
                    log "Notification sent. Continuing to monitor (no duplicate notifications)."
                fi
            else
                # Reset notification flag if GenCraft becomes not ready again
                if [ "$notification_sent" = true ]; then
                    log "GenCraft no longer ready. Resetting notification flag."
                    notification_sent=false
                fi
            fi

            # Sleep for check interval
            sleep "$CHECK_INTERVAL"
        done
    ) &

    local daemon_pid=$!
    echo "$daemon_pid" > "$PID_FILE"
    log "Daemon started with PID $daemon_pid"

    return 0
}

stop_daemon() {
    if [ ! -f "$PID_FILE" ]; then
        log_error "Daemon not running (no PID file found)"
        return 1
    fi

    local pid=$(cat "$PID_FILE")

    if kill -0 "$pid" 2>/dev/null; then
        log "Stopping daemon (PID $pid)"
        kill "$pid"
        rm -f "$PID_FILE"
        log "Daemon stopped successfully"
        return 0
    else
        log_error "Daemon not running (PID $pid not found)"
        rm -f "$PID_FILE"
        return 1
    fi
}

status_daemon() {
    if [ ! -f "$PID_FILE" ]; then
        echo "Daemon is NOT running"
        return 1
    fi

    local pid=$(cat "$PID_FILE")

    if kill -0 "$pid" 2>/dev/null; then
        echo "Daemon is running (PID $pid)"
        echo "Last check: $(tail -1 "$LOG_FILE")"
        check_gencraft_ready
        return 0
    else
        echo "Daemon is NOT running (stale PID file)"
        rm -f "$PID_FILE"
        return 1
    fi
}

check_now() {
    log "Manual check requested"
    if check_gencraft_ready; then
        echo "✅ GenCraft is READY for BuildCraft integration!"
        echo ""
        echo "Run the following command to start integration:"
        echo "  cd $CLAUDE_PROJECTS_ROOT"
        echo "  ./auto-integrate-buildcraft-system.sh"
        return 0
    else
        echo "❌ GenCraft is NOT yet ready for BuildCraft integration"
        echo ""
        echo "Missing components will be detected when available."
        return 1
    fi
}

################################################################################
# Main Command Handler
################################################################################

case "${1:-}" in
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    restart)
        stop_daemon
        sleep 2
        start_daemon
        ;;
    status)
        status_daemon
        ;;
    check)
        check_now
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|check}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the watcher daemon"
        echo "  stop    - Stop the watcher daemon"
        echo "  restart - Restart the watcher daemon"
        echo "  status  - Check daemon status"
        echo "  check   - Manually check GenCraft readiness (one-time)"
        exit 1
        ;;
esac

exit $?
