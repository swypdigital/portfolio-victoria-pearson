#!/bin/bash
###############################################################################
# Phase 3: System Snapshot for Rollback
# Enterprise 10-Phase Testing Framework - Create Restore Point
###############################################################################

set -e

echo "📸 Phase 3: Creating System Snapshot for Rollback"
echo "=================================================="

# Create timestamped snapshot directory
SNAPSHOT_DIR="../.test-snapshots/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SNAPSHOT_DIR"

echo "✓ Snapshot directory: $SNAPSHOT_DIR"

# Backup database (if exists)
echo "✓ Backing up database..."
if [ -f ../data/gencraft-api.db ]; then
  cp ../data/gencraft-api.db "$SNAPSHOT_DIR/"
  echo "  Database backed up"
else
  echo "  No database found (first run)"
  touch "$SNAPSHOT_DIR/NO_DATABASE"
fi

# Backup logs (if exist)
echo "✓ Backing up logs..."
if [ -d ../logs ]; then
  cp -r ../logs "$SNAPSHOT_DIR/"
  echo "  Logs backed up"
else
  echo "  No logs found (first run)"
  mkdir -p "$SNAPSHOT_DIR/logs"
fi

# Save current .env
echo "✓ Backing up configuration..."
if [ -f ../.env ]; then
  cp ../.env "$SNAPSHOT_DIR/"
  echo "  .env backed up"
fi

# Record git state
echo "✓ Recording git state..."
cd ..
mkdir -p "$SNAPSHOT_DIR"
git status > "$SNAPSHOT_DIR/git-status.txt" 2>&1 || echo "Not a git repo" > "$SNAPSHOT_DIR/git-status.txt"
git diff > "$SNAPSHOT_DIR/git-diff.txt" 2>&1 || true
git log -1 --oneline > "$SNAPSHOT_DIR/git-last-commit.txt" 2>&1 || true

# Create snapshot manifest
echo "✓ Creating snapshot manifest..."
cat > "$SNAPSHOT_DIR/SNAPSHOT_MANIFEST.txt" <<EOF
GenCraft API - Rollback Snapshot
Created: $(date)
Snapshot ID: $(basename $SNAPSHOT_DIR)

Contents:
- Database: $([ -f "$SNAPSHOT_DIR/gencraft-api.db" ] && echo "YES" || echo "NO")
- Logs: $([ -d "$SNAPSHOT_DIR/logs" ] && echo "YES" || echo "NO")
- .env: $([ -f "$SNAPSHOT_DIR/.env" ] && echo "YES" || echo "NO")
- Git status: YES

Rollback Instructions:
1. Run: ./tests/rollback.sh $(basename $SNAPSHOT_DIR)
2. This will restore all backed up files
3. Database and logs will be replaced
4. Git state will be shown for manual review

DO NOT DELETE THIS DIRECTORY UNTIL TESTING COMPLETE
EOF

echo ""
echo "✅ Snapshot created successfully"
echo "   Location: $SNAPSHOT_DIR"
echo "   Rollback: ./tests/rollback.sh $(basename $SNAPSHOT_DIR)"
echo ""

exit 0
