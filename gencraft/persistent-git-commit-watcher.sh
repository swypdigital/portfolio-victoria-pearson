#!/bin/bash
# Persistent Git Commit Watcher for GenCraft
# Waits for git lock to release, then commits and pushes to GitHub

LOCK_FILE="/mnt/c/Users/jdh/claude_projects/.git/index.lock"
COMMIT_MSG_FILE="/mnt/c/Users/jdh/claude_projects/gencraft/.git-commit-message.txt"
LOG_FILE="/tmp/gencraft-persistent-commit-watcher.log"
GENCRAFT_DIR="/mnt/c/Users/jdh/claude_projects/gencraft"

# Clear previous log
> "$LOG_FILE"

echo "╔══════════════════════════════════════════════════════════╗" | tee -a "$LOG_FILE"
echo "║     GenCraft Persistent Git Commit Watcher (ACTIVE)     ║" | tee -a "$LOG_FILE"
echo "╚══════════════════════════════════════════════════════════╝" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "🎯 Mission: Wait for git lock release → Commit → Push to GitHub" | tee -a "$LOG_FILE"
echo "📁 Lock file: $LOCK_FILE" | tee -a "$LOG_FILE"
echo "⏱️  Check interval: 30 seconds" | tee -a "$LOG_FILE"
echo "🔄 Duration: Indefinite (until success)" | tee -a "$LOG_FILE"
echo "📊 Log: $LOG_FILE" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🚀 Watcher started" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Check counter
CHECK_COUNT=0
START_TIME=$(date +%s)

while true; do
    CHECK_COUNT=$((CHECK_COUNT + 1))
    ELAPSED=$(($(date +%s) - START_TIME))
    ELAPSED_MIN=$((ELAPSED / 60))

    # Check if lock file exists
    if [ ! -f "$LOCK_FILE" ]; then
        echo "" | tee -a "$LOG_FILE"
        echo "✅ $(date '+%Y-%m-%d %H:%M:%S') - LOCK RELEASED after ${ELAPSED_MIN} minutes (${CHECK_COUNT} checks)" | tee -a "$LOG_FILE"
        echo "" | tee -a "$LOG_FILE"
        echo "🚀 Starting git commit process..." | tee -a "$LOG_FILE"
        echo "" | tee -a "$LOG_FILE"

        # Change to gencraft directory
        cd "$GENCRAFT_DIR" || {
            echo "❌ Failed to cd to $GENCRAFT_DIR" | tee -a "$LOG_FILE"
            exit 1
        }

        # Add all changes
        echo "📝 Adding all changes..." | tee -a "$LOG_FILE"
        git add -A 2>&1 | tee -a "$LOG_FILE"

        # Commit with prepared message
        echo "💾 Committing with prepared message..." | tee -a "$LOG_FILE"
        git commit -F "$COMMIT_MSG_FILE" 2>&1 | tee -a "$LOG_FILE"

        COMMIT_EXIT=$?

        if [ $COMMIT_EXIT -eq 0 ]; then
            echo "" | tee -a "$LOG_FILE"
            echo "✅ Commit successful!" | tee -a "$LOG_FILE"
            echo "" | tee -a "$LOG_FILE"
            echo "📊 Commit summary:" | tee -a "$LOG_FILE"
            git log -1 --stat | tee -a "$LOG_FILE"
            echo "" | tee -a "$LOG_FILE"

            # Push to GitHub
            echo "📤 Pushing to GitHub: https://github.com/swypdigital/gencraft-v3.0.git" | tee -a "$LOG_FILE"
            git push origin main 2>&1 | tee -a "$LOG_FILE"

            PUSH_EXIT=$?

            if [ $PUSH_EXIT -eq 0 ]; then
                echo "" | tee -a "$LOG_FILE"
                echo "╔══════════════════════════════════════════════════════════╗" | tee -a "$LOG_FILE"
                echo "║              ✅ GITHUB COMMIT COMPLETE                   ║" | tee -a "$LOG_FILE"
                echo "╚══════════════════════════════════════════════════════════╝" | tee -a "$LOG_FILE"
                echo "" | tee -a "$LOG_FILE"
                echo "📊 Summary:" | tee -a "$LOG_FILE"
                echo "  - Wait time: ${ELAPSED_MIN} minutes" | tee -a "$LOG_FILE"
                echo "  - Checks performed: ${CHECK_COUNT}" | tee -a "$LOG_FILE"
                echo "  - Files committed: 23 (GenCraft Phases 1-3)" | tee -a "$LOG_FILE"
                echo "  - Repository: https://github.com/swypdigital/gencraft-v3.0.git" | tee -a "$LOG_FILE"
                echo "" | tee -a "$LOG_FILE"
                echo "🎯 Next: Commit VIBE OS integration changes" | tee -a "$LOG_FILE"
                echo "" | tee -a "$LOG_FILE"

                # Create success marker file
                echo "SUCCESS: $(date)" > "/tmp/gencraft-commit-success.txt"

                exit 0
            else
                echo "" | tee -a "$LOG_FILE"
                echo "❌ Push failed (exit code: $PUSH_EXIT)" | tee -a "$LOG_FILE"
                echo "   Check network connection or GitHub credentials" | tee -a "$LOG_FILE"
                exit 1
            fi
        else
            echo "" | tee -a "$LOG_FILE"
            echo "❌ Commit failed (exit code: $COMMIT_EXIT)" | tee -a "$LOG_FILE"
            echo "   Check log: $LOG_FILE" | tee -a "$LOG_FILE"
            exit 1
        fi
    else
        # Lock still exists
        if [ $((CHECK_COUNT % 10)) -eq 0 ]; then
            # Every 10th check (5 minutes), show status
            echo "⏳ $(date '+%H:%M:%S') - Still locked (${ELAPSED_MIN}m elapsed, ${CHECK_COUNT} checks)" | tee -a "$LOG_FILE"
        else
            # Silent check, just log to file
            echo "⏳ $(date '+%H:%M:%S') - Check #${CHECK_COUNT} (${ELAPSED_MIN}m elapsed) - Lock present" >> "$LOG_FILE"
        fi

        # Wait 30 seconds before next check
        sleep 30
    fi
done
