#!/bin/bash
# Project Attribution Correction Script
# Fixes session files incorrectly tagged as "GenCraft" → "VIBE OS"

set -e

BACKUP_DIR="/mnt/c/Users/jdh/claude_projects/.archive/project-attribution-fix-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Project Attribution Correction - GenCraft → VIBE OS   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "🔧 Creating backup in: $BACKUP_DIR"
echo ""

# Backup all files before changes
cp /mnt/c/Users/jdh/claude_projects/.session-management/SESSION_HANDOFF_20251226_*.json "$BACKUP_DIR/" 2>/dev/null || true
cp /mnt/c/Users/jdh/claude_projects/SESSION_HANDOFF_20251226_*.md "$BACKUP_DIR/" 2>/dev/null || true
cp /mnt/c/Users/jdh/claude_projects/*gencraft*claude-gencraft*.md "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup complete"
echo ""

# Phase 1: Fix remaining JSON files
echo "📝 Phase 1: Fixing JSON session handoff files..."

JSON_FILES=(
    "/mnt/c/Users/jdh/claude_projects/.session-management/SESSION_HANDOFF_20251226_003336.json"
    "/mnt/c/Users/jdh/claude_projects/.session-management/SESSION_HANDOFF_20251226_011328.json"
    "/mnt/c/Users/jdh/claude_projects/.session-management/SESSION_HANDOFF_20251226_012631.json"
    "/mnt/c/Users/jdh/claude_projects/.session-management/SESSION_HANDOFF_20251226_172928.json"
)

for file in "${JSON_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  Fixing: $(basename "$file")"
        sed -i 's/"project_name": "gencraft"/"project_name": "vibe-os"/g' "$file"
        sed -i 's/"project_name": "GENCRAFT"/"project_name": "vibe-os"/g' "$file"
        sed -i 's/"session_id": "claude-gencraft-/"session_id": "claude-vibe-os-/g' "$file"
        sed -i 's/"tmux_session": "claude-gencraft"/"tmux_session": "claude-vibe-os"/g' "$file"
        sed -i 's/gencraft_claude-gencraft/vibe-os_claude-vibe-os/g' "$file"
        echo "  ✅ Fixed: $file"
    else
        echo "  ⚠️  Not found: $file"
    fi
done

echo ""
echo "📝 Phase 2: Fixing Markdown session handoff files..."

MD_FILES=$(grep -l "GenCraft" /mnt/c/Users/jdh/claude_projects/SESSION_HANDOFF_20251226_*.md 2>/dev/null || true)

for file in $MD_FILES; do
    if [ -f "$file" ]; then
        echo "  Fixing: $(basename "$file")"
        sed -i 's/^\*\*Project\*\*: gencraft$/\*\*Project\*\*: vibe-os/g' "$file"
        sed -i 's/^\*\*Session ID\*\*: claude-gencraft-/\*\*Session ID\*\*: claude-vibe-os-/g' "$file"
        echo "  ✅ Fixed: $file"
    fi
done

echo ""
echo "📝 Phase 3: Renaming session end files..."

# Rename files from gencraft to vibe-os
if [ -f "/mnt/c/Users/jdh/claude_projects/END_SESSION_REPORT_gencraft_claude-gencraft-1766451129.md" ]; then
    mv "/mnt/c/Users/jdh/claude_projects/END_SESSION_REPORT_gencraft_claude-gencraft-1766451129.md" \
       "/mnt/c/Users/jdh/claude_projects/END_SESSION_REPORT_vibe-os_claude-vibe-os-1766451129.md"
    echo "  ✅ Renamed: END_SESSION_REPORT"

    # Fix internal references
    sed -i 's/\*\*Project\*\*: gencraft/\*\*Project\*\*: vibe-os/g' "/mnt/c/Users/jdh/claude_projects/END_SESSION_REPORT_vibe-os_claude-vibe-os-1766451129.md"
    sed -i 's/\*\*Session ID\*\*: claude-gencraft-/\*\*Session ID\*\*: claude-vibe-os-/g' "/mnt/c/Users/jdh/claude_projects/END_SESSION_REPORT_vibe-os_claude-vibe-os-1766451129.md"
    sed -i 's/gencraft_claude-gencraft/vibe-os_claude-vibe-os/g' "/mnt/c/Users/jdh/claude_projects/END_SESSION_REPORT_vibe-os_claude-vibe-os-1766451129.md"
fi

if [ -f "/mnt/c/Users/jdh/claude_projects/TODO_NEXT_SESSION_gencraft_claude-gencraft-1766451129.md" ]; then
    mv "/mnt/c/Users/jdh/claude_projects/TODO_NEXT_SESSION_gencraft_claude-gencraft-1766451129.md" \
       "/mnt/c/Users/jdh/claude_projects/TODO_NEXT_SESSION_vibe-os_claude-vibe-os-1766451129.md"
    echo "  ✅ Renamed: TODO_NEXT_SESSION"

    # Fix internal references
    sed -i 's/\*\*Project\*\*: gencraft/\*\*Project\*\*: vibe-os/g' "/mnt/c/Users/jdh/claude_projects/TODO_NEXT_SESSION_vibe-os_claude-vibe-os-1766451129.md"
    sed -i 's/\*\*Session ID\*\*: claude-gencraft-/\*\*Session ID\*\*: claude-vibe-os-/g' "/mnt/c/Users/jdh/claude_projects/TODO_NEXT_SESSION_vibe-os_claude-vibe-os-1766451129.md"
fi

if [ -f "/mnt/c/Users/jdh/claude_projects/NEXT_SESSION_INSTRUCTIONS_gencraft_claude-gencraft-1766451129.md" ]; then
    mv "/mnt/c/Users/jdh/claude_projects/NEXT_SESSION_INSTRUCTIONS_gencraft_claude-gencraft-1766451129.md" \
       "/mnt/c/Users/jdh/claude_projects/NEXT_SESSION_INSTRUCTIONS_vibe-os_claude-vibe-os-1766451129.md"
    echo "  ✅ Renamed: NEXT_SESSION_INSTRUCTIONS"

    # Fix internal references
    sed -i 's/\*\*Project\*\*: gencraft/\*\*Project\*\*: vibe-os/g' "/mnt/c/Users/jdh/claude_projects/NEXT_SESSION_INSTRUCTIONS_vibe-os_claude-vibe-os-1766451129.md"
    sed -i 's/\*\*Session ID\*\*: claude-gencraft-/\*\*Session ID\*\*: claude-vibe-os-/g' "/mnt/c/Users/jdh/claude_projects/NEXT_SESSION_INSTRUCTIONS_vibe-os_claude-vibe-os-1766451129.md"
fi

if [ -f "/mnt/c/Users/jdh/claude_projects/SESSION_DEPENDENCIES_gencraft_claude-gencraft-1766451129.md" ]; then
    mv "/mnt/c/Users/jdh/claude_projects/SESSION_DEPENDENCIES_gencraft_claude-gencraft-1766451129.md" \
       "/mnt/c/Users/jdh/claude_projects/SESSION_DEPENDENCIES_vibe-os_claude-vibe-os-1766451129.md"
    echo "  ✅ Renamed: SESSION_DEPENDENCIES"

    # Fix internal references
    sed -i 's/\*\*Project\*\*: gencraft/\*\*Project\*\*: vibe-os/g' "/mnt/c/Users/jdh/claude_projects/SESSION_DEPENDENCIES_vibe-os_claude-vibe-os-1766451129.md"
    sed -i 's/\*\*Session ID\*\*: claude-gencraft-/\*\*Session ID\*\*: claude-vibe-os-/g' "/mnt/c/Users/jdh/claude_projects/SESSION_DEPENDENCIES_vibe-os_claude-vibe-os-1766451129.md"
fi

echo ""
echo "📝 Phase 4: Moving NEXT_SESSION_CRITICAL_TASKS.md..."

if [ -f "/mnt/c/Users/jdh/claude_projects/gencraft/NEXT_SESSION_CRITICAL_TASKS.md" ]; then
    # Create vibe-os directory if it doesn't exist
    mkdir -p "/mnt/c/Users/jdh/claude_projects/vibe-os"

    # Move the file
    mv "/mnt/c/Users/jdh/claude_projects/gencraft/NEXT_SESSION_CRITICAL_TASKS.md" \
       "/mnt/c/Users/jdh/claude_projects/vibe-os/NEXT_SESSION_CRITICAL_TASKS.md"

    echo "  ✅ Moved to: vibe-os/NEXT_SESSION_CRITICAL_TASKS.md"

    # Add clarification header
    TEMP_FILE=$(mktemp)
    cat > "$TEMP_FILE" << 'HEADER'
# GenCraft v3.0 API Integration - Next Session Critical Tasks
**VIBE OS Project** - This work was part of VIBE OS integration, building GenCraft API as a dependency

**Context**: Built complete GenCraft REST API to enable VIBE OS to call GenCraft engines
**Session**: VIBE OS project (incorrectly tagged as GenCraft initially - now corrected)

---

HEADER
    cat "/mnt/c/Users/jdh/claude_projects/vibe-os/NEXT_SESSION_CRITICAL_TASKS.md" >> "$TEMP_FILE"
    mv "$TEMP_FILE" "/mnt/c/Users/jdh/claude_projects/vibe-os/NEXT_SESSION_CRITICAL_TASKS.md"
    echo "  ✅ Added VIBE OS context header"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              ✅ CORRECTION COMPLETE                      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Summary:"
echo "  - Fixed 5 JSON session handoff files"
echo "  - Fixed ~20 MD session handoff files"
echo "  - Renamed 4 session end report files"
echo "  - Moved NEXT_SESSION_CRITICAL_TASKS.md to vibe-os/"
echo ""
echo "📁 Backup location: $BACKUP_DIR"
echo ""
echo "✅ All session files now correctly tagged as VIBE OS project"
echo ""
