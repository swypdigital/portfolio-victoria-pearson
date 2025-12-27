#!/bin/bash
LOCK_FILE="/mnt/c/Users/jdh/claude_projects/.git/index.lock"
MAX_WAIT=600  # 10 minutes
ELAPSED=0
INTERVAL=20  # Check every 20 seconds

echo "⏳ Git lock watcher started (extended timeout: ${MAX_WAIT}s, interval: ${INTERVAL}s)"
echo "   Monitoring: $LOCK_FILE"
echo ""

while [ -f "$LOCK_FILE" ] && [ $ELAPSED -lt $MAX_WAIT ]; do
    echo "   Still locked... (${ELAPSED}s elapsed)"
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

if [ -f "$LOCK_FILE" ]; then
    echo ""
    echo "⚠️  Lock still present after ${MAX_WAIT}s"
    echo "   Another git process may be running"
    exit 1
else
    echo ""
    echo "✅ Lock released after ${ELAPSED}s"
    echo "   Git is now available"
    exit 0
fi
