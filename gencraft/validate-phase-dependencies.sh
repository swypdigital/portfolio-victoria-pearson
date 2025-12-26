#!/bin/bash
# GenCraft v3.0 - Phase Dependency Validator
# Enforces phase blockers - prevents progression without prerequisites

set -euo pipefail

PHASE_NUM=${1:-"current"}
BLOCKER_FILE="$WINDOWS_HOME/claude_projects/gencraft-v3.0/.phase-dependencies/PHASE_BLOCKER_SYSTEM.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "════════════════════════════════════════════════════"
echo "  GenCraft v3.0 - Phase Dependency Validator"
echo "════════════════════════════════════════════════════"
echo ""

# Check if blocker file exists
if [[ ! -f "$BLOCKER_FILE" ]]; then
    echo -e "${RED}❌ ERROR: Blocker system file not found${NC}"
    echo "Expected: $BLOCKER_FILE"
    exit 1
fi

# Get current phase from file
CURRENT_PHASE=$(grep -A 1 "Active Phase" "$BLOCKER_FILE" | tail -1 | grep -oP 'Phase \d+' || echo "Unknown")

echo "Current Phase: $CURRENT_PHASE"
echo ""

# Count active blockers
ACTIVE_BLOCKERS=$(grep -c "❌ BLOCKER" "$BLOCKER_FILE" || echo "0")

if [[ $ACTIVE_BLOCKERS -eq 0 ]]; then
    echo -e "${GREEN}✅ GATE CHECK PASSED${NC}"
    echo "No active blockers found"
    echo "Phase can proceed"
    exit 0
else
    echo -e "${RED}❌ GATE CHECK FAILED${NC}"
    echo "Active blockers: $ACTIVE_BLOCKERS"
    echo ""
    echo "Blockers that MUST be cleared:"
    echo "─────────────────────────────────────────────"
    grep "❌ BLOCKER" "$BLOCKER_FILE" -A 5 | sed 's/^/  /'
    echo "─────────────────────────────────────────────"
    echo ""
    echo -e "${YELLOW}⚠️  CANNOT PROCEED TO NEXT PHASE${NC}"
    echo "Clear all blockers before continuing"
    echo ""
    echo "Next steps:"
    echo "1. Review blockers above"
    echo "2. Complete each blocker task"
    echo "3. Update PHASE_BLOCKER_SYSTEM.md (❌ → ✅)"
    echo "4. Re-run this validator"
    echo ""
    exit 1
fi
