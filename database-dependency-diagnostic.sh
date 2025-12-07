#!/bin/bash
# Database Ecosystem Diagnostic - Comprehensive Analysis
# Output: Complete dependency map for surgical consolidation planning

# Source contractual database paths
if [ -f "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh" ]; then
    source "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh"
fi

echo "📊 DATABASE ECOSYSTEM DIAGNOSTIC - COMPREHENSIVE ANALYSIS"
echo "=========================================================="
echo "Generated: $(date)"
echo ""

echo "=== PHASE 1: ACTIVE DATABASE INVENTORY ==="
echo ""
find . -name "*.db" -type f ! -path "*/.archive/*" ! -path "*/.perpetual-trash/*" ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sh -c '
  DB="$1"
  SIZE=$(du -h "$DB" | cut -f1)
  TABLES=$(sqlite3 "$DB" ".tables" 2>/dev/null | wc -w)
  MODIFIED=$(stat -c "%y" "$DB" 2>/dev/null | cut -d. -f1)
  echo "📁 $DB"
  echo "   Size: $SIZE | Tables: $TABLES | Modified: $MODIFIED"
  echo ""
' _ {} \; 2>/dev/null | head -100

echo ""
echo "=== PHASE 2: SCRIPT DEPENDENCIES (Database References) ==="
echo ""
# Find all scripts that reference databases
rg -l "\.db" --type sh --max-count 1 2>/dev/null | while read script; do
  echo "📜 $script"
  rg "\.db" "$script" --no-line-number --color never 2>/dev/null | grep -v "^#" | head -5
  echo ""
done | head -200

echo ""
echo "=== PHASE 3: ACTIVE PROCESSES USING DATABASES ==="
echo ""
ps aux | grep -E "(sqlite|\.db)" | grep -v grep

echo ""
echo "=== PHASE 4: DAEMON REGISTRY DATABASE USAGE ==="
echo ""
if [ -f .daemon-registry/active-daemons.json ]; then
  cat .daemon-registry/active-daemons.json 2>/dev/null | grep -i "db"
fi

echo ""
echo "=== PHASE 5: CRITICAL DATABASE FILES (>10MB) ==="
echo ""
find . -name "*.db" -type f -size +10M ! -path "*/.archive/*" ! -path "*/.perpetual-trash/*" -exec du -h {} + 2>/dev/null | sort -rh | head -20

echo ""
echo "=== PHASE 6: QUANTUM TODO DATABASE ANALYSIS ==="
echo ""
if [ -f "$QUANTUM_TODO_DB" ]; then
  echo "Primary Quantum TODO Database:"
  sqlite3 "$QUANTUM_TODO_DB" ".schema" 2>/dev/null | head -50
fi

echo ""
echo "=== DIAGNOSTIC COMPLETE ==="
echo "Timestamp: $(date)"
