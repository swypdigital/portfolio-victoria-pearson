#!/bin/bash
# Auto-commit script for GenCraft Phase 1-3
# Executes when git lock is released

LOCK_FILE="/mnt/c/Users/jdh/claude_projects/.git/index.lock"
COMMIT_MSG_FILE="/mnt/c/Users/jdh/claude_projects/gencraft/.git-commit-message.txt"
LOG_FILE="/tmp/gencraft-auto-commit.log"

echo "⏳ Waiting for git lock to release..." | tee -a "$LOG_FILE"
echo "   Lock file: $LOCK_FILE" | tee -a "$LOG_FILE"
echo "   Checking every 20 seconds..." | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Wait for lock to be released (max 10 minutes)
MAX_WAIT=600
ELAPSED=0
INTERVAL=20

while [ -f "$LOCK_FILE" ] && [ $ELAPSED -lt $MAX_WAIT ]; do
    echo "   Still locked... (${ELAPSED}s elapsed)" | tee -a "$LOG_FILE"
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

if [ -f "$LOCK_FILE" ]; then
    echo "" | tee -a "$LOG_FILE"
    echo "❌ Lock still present after ${MAX_WAIT}s" | tee -a "$LOG_FILE"
    echo "   Manual intervention required" | tee -a "$LOG_FILE"
    exit 1
fi

echo "" | tee -a "$LOG_FILE"
echo "✅ Lock released after ${ELAPSED}s!" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "🚀 Starting git commit process..." | tee -a "$LOG_FILE"

# Change to gencraft directory
cd /mnt/c/Users/jdh/claude_projects/gencraft || exit 1

# Add all changes
echo "   Adding all changes..." | tee -a "$LOG_FILE"
git add -A 2>&1 | tee -a "$LOG_FILE"

# Commit with prepared message
echo "   Committing with prepared message..." | tee -a "$LOG_FILE"
git commit -F "$COMMIT_MSG_FILE" 2>&1 | tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "" | tee -a "$LOG_FILE"
    echo "✅ Commit successful!" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "📊 Commit summary:" | tee -a "$LOG_FILE"
    git log -1 --stat | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "🎯 Ready to push to GitHub: https://github.com/swypdigital/gencraft-v3.0.git" | tee -a "$LOG_FILE"
else
    echo "" | tee -a "$LOG_FILE"
    echo "❌ Commit failed!" | tee -a "$LOG_FILE"
    echo "   Check log: $LOG_FILE" | tee -a "$LOG_FILE"
    exit 1
fi
