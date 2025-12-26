#!/bin/bash
###############################################################################
# Rollback Script
# Restore system to pre-test state from snapshot
###############################################################################

set -e

SNAPSHOT_ID="$1"

if [ -z "$SNAPSHOT_ID" ]; then
  echo "❌ Usage: ./rollback.sh <snapshot_id>"
  echo ""
  echo "Available snapshots:"
  ls -1 ../.test-snapshots/ 2>/dev/null || echo "  No snapshots found"
  exit 1
fi

SNAPSHOT_DIR="../.test-snapshots/$SNAPSHOT_ID"

if [ ! -d "$SNAPSHOT_DIR" ]; then
  echo "❌ Snapshot not found: $SNAPSHOT_DIR"
  exit 1
fi

echo "🔄 Rolling back to snapshot: $SNAPSHOT_ID"
echo "=========================================="

# Show snapshot manifest
if [ -f "$SNAPSHOT_DIR/SNAPSHOT_MANIFEST.txt" ]; then
  cat "$SNAPSHOT_DIR/SNAPSHOT_MANIFEST.txt"
  echo ""
fi

# Confirm rollback
read -p "⚠️  This will REPLACE current database and logs. Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "❌ Rollback cancelled"
  exit 0
fi

cd ..

# Restore database
echo "✓ Restoring database..."
if [ -f "$SNAPSHOT_DIR/gencraft-api.db" ]; then
  mkdir -p data
  cp "$SNAPSHOT_DIR/gencraft-api.db" data/
  echo "  Database restored"
elif [ -f "$SNAPSHOT_DIR/NO_DATABASE" ]; then
  rm -f data/gencraft-api.db
  echo "  Database removed (didn't exist before)"
fi

# Restore logs
echo "✓ Restoring logs..."
if [ -d "$SNAPSHOT_DIR/logs" ]; then
  rm -rf logs
  cp -r "$SNAPSHOT_DIR/logs" .
  echo "  Logs restored"
fi

# Restore .env
echo "✓ Restoring configuration..."
if [ -f "$SNAPSHOT_DIR/.env" ]; then
  cp "$SNAPSHOT_DIR/.env" .
  echo "  .env restored"
fi

# Show git state (manual review)
echo ""
echo "📋 Git state at snapshot time:"
echo "=============================="
if [ -f "$SNAPSHOT_DIR/git-status.txt" ]; then
  cat "$SNAPSHOT_DIR/git-status.txt"
fi

echo ""
echo "✅ Rollback complete!"
echo "   Review git changes above and restore manually if needed"
echo "   Snapshot preserved at: $SNAPSHOT_DIR"

exit 0
