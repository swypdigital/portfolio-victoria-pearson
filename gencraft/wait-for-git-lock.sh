#!/bin/bash
###############################################################################
# Git Lock Watcher
# Waits for git lock to be released before proceeding
###############################################################################

LOCK_FILE=".git/index.lock"
MAX_WAIT=60
ELAPSED=0

echo "⏳ Waiting for git lock to be released..."
echo "   Lock file: $LOCK_FILE"

while [ -f "$LOCK_FILE" ] && [ $ELAPSED -lt $MAX_WAIT ]; do
  echo "   Still locked... (${ELAPSED}s elapsed)"
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done

if [ -f "$LOCK_FILE" ]; then
  echo "⚠️  Lock still present after ${MAX_WAIT}s"
  echo "   Another git process may be running or crashed"
  echo "   Manual intervention required"
  exit 1
else
  echo "✅ Lock released after ${ELAPSED}s"
  echo "   Safe to proceed with git operations"
  exit 0
fi
