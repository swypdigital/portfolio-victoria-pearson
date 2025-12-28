#!/bin/bash
# NL Upgrade Commands - Natural Language Interface for Pending Upgrades
# REUSES existing NL fuzzy matching system (DO NOT REBUILD)
#
# Version: 1.0.0
# Created: 2025-12-27
# Part of: Pending Upgrades System - Phase 1
#
# Dependencies:
#   - .index-system/nl-levenshtein.sh (MUST exist - we reuse, not rebuild)
#   - pattern-versioning-system.sh
#
# Usage:
#   upgrade_nl "test saas framwork upgrade"   # Fuzzy matches to saas-framework-v7-to-v8
#   upgrade_nl "apply pattern v8"              # Matches and applies upgrade
#   upgrade_nl "rollback migration"            # Matches and rollbacks

# Source contractual paths
if [[ -f "/mnt/c/Users/jdh/claude_projects/.daemon-registry/contractual-paths-true.sh" ]]; then
    source "/mnt/c/Users/jdh/claude_projects/.daemon-registry/contractual-paths-true.sh"
else
    echo "❌ ERROR: contractual-paths-true.sh not found"
    exit 1
fi

# ============================================================
# CRITICAL: REUSE EXISTING NL FUZZY MATCHING SYSTEM
# DO NOT REBUILD - ADAPT ONLY
# ============================================================

NL_LEVENSHTEIN_PATH="${CLAUDE_PROJECTS_ROOT}/.index-system/nl-levenshtein.sh"

# Verify NL system exists (MANDATORY)
if [[ ! -f "$NL_LEVENSHTEIN_PATH" ]]; then
    echo "❌ CRITICAL ERROR: NL fuzzy matching system not found!"
    echo "   Expected: $NL_LEVENSHTEIN_PATH"
    echo "   Cannot proceed - this system MUST reuse existing infrastructure"
    exit 1
fi

# Source the existing NL fuzzy matching system
source "$NL_LEVENSHTEIN_PATH"

# Verify required functions are available
if ! declare -f levenshtein &> /dev/null || \
   ! declare -f find_best_match &> /dev/null || \
   ! declare -f fuzzy_match_command &> /dev/null; then
    echo "❌ ERROR: NL fuzzy matching functions not available"
    echo "   Required: levenshtein, find_best_match, fuzzy_match_command"
    exit 1
fi

echo "✅ NL fuzzy matching system loaded from: $NL_LEVENSHTEIN_PATH"

# Source pattern versioning system
PATTERN_VERSION_PATH="${CLAUDE_PROJECTS_ROOT}/.pending-upgrades/pattern-versioning-system.sh"
if [[ -f "$PATTERN_VERSION_PATH" ]]; then
    source "$PATTERN_VERSION_PATH"
else
    echo "⚠️  Warning: Pattern versioning system not found"
fi

# Configuration
PENDING_UPGRADES_DIR="${CLAUDE_PROJECTS_ROOT}/.pending-upgrades"

# ============================================================
# UPGRADE-SPECIFIC TYPO CORRECTIONS
# Extends the existing NL system's typo dictionary
# ============================================================

# Additional typo corrections for upgrade commands
declare -A upgrade_typo_corrections=(
    # Framework typos
    ["saas framwork"]="saas framework"
    ["sas framework"]="saas framework"
    ["saass framework"]="saas framework"
    ["gencraft"]="gencraft"
    ["gen craft"]="gencraft"
    ["gencrat"]="gencraft"
    ["pattern libary"]="pattern library"
    ["patern library"]="pattern library"
    ["pattrn library"]="pattern library"

    # Command typos
    ["upgarde"]="upgrade"
    ["uprade"]="upgrade"
    ["upgade"]="upgrade"
    ["migraton"]="migration"
    ["migratoin"]="migration"
    ["roback"]="rollback"
    ["rolback"]="rollback"
    ["rol back"]="rollback"
    ["aplly"]="apply"
    ["aply"]="apply"
    ["tets"]="test"
    ["tesst"]="test"

    # Version typos
    ["verion"]="version"
    ["versoin"]="version"
    ["v7 to v8"]="v7-to-v8"
    ["v7 → v8"]="v7-to-v8"
    ["v7->v8"]="v7-to-v8"
)

# Apply upgrade-specific typo corrections
correct_upgrade_typos() {
    local query="$1"
    local corrected="$query"

    # Convert to lowercase for matching
    corrected=$(echo "$corrected" | tr '[:upper:]' '[:lower:]')

    # Apply corrections
    for typo in "${!upgrade_typo_corrections[@]}"; do
        corrected="${corrected//$typo/${upgrade_typo_corrections[$typo]}}"
    done

    echo "$corrected"
}

# ============================================================
# UPGRADE FILE MATCHING
# Uses existing fuzzy matching for upgrade plan files
# ============================================================

# Get list of available upgrade files
get_upgrade_files() {
    find "$PENDING_UPGRADES_DIR" -maxdepth 1 -name "*.json" -type f ! -name "UPGRADE_PLAN_SCHEMA.json" ! -name "pattern-usage-registry.json" 2>/dev/null | while read -r file; do
        basename "$file" .json
    done
}

# Match user query to upgrade file using fuzzy matching
# Usage: match_upgrade_file "test saas framwork"
# Returns: "saas-framework-v7-to-v8" or empty if no match
match_upgrade_file() {
    local query="$1"
    local threshold="${2:-5}"  # More lenient for upgrade names

    # First, correct typos
    local corrected=$(correct_upgrade_typos "$query")

    # Get all upgrade files
    local upgrade_files=($(get_upgrade_files))

    if [[ ${#upgrade_files[@]} -eq 0 ]]; then
        echo ""
        return 1
    fi

    # Direct substring match first (fastest)
    for file in "${upgrade_files[@]}"; do
        # Remove hyphens and normalize for easier matching
        local file_normalized=$(echo "$file" | tr '-' ' ' | tr '[:upper:]' '[:lower:]')
        local query_normalized=$(echo "$corrected" | tr '-' ' ' | tr '[:upper:]' '[:lower:]')

        # Check if query contains key parts of filename
        if [[ "$file_normalized" == *"$query_normalized"* ]]; then
            echo "$file"
            return 0
        fi

        # Check individual words (e.g., "saas" in "saas framework")
        local query_words=($query_normalized)
        local file_words=($file_normalized)
        local match_count=0
        local required_matches=2  # Need at least 2 word matches

        for qword in "${query_words[@]}"; do
            for fword in "${file_words[@]}"; do
                # Match if words start the same way (fuzzy)
                if [[ "$fword" == "$qword"* ]] || [[ "$qword" == "$fword"* ]]; then
                    ((match_count++))
                    break
                fi
            done
        done

        if [[ $match_count -ge $required_matches ]]; then
            echo "$file"
            return 0
        fi
    done

    # Fuzzy match using Levenshtein distance (REUSES existing function)
    local result=$(find_best_match "$corrected" "${upgrade_files[@]}")
    local matched_file="${result%:*}"
    local score="${result#*:}"

    if [[ $score -le $threshold ]]; then
        echo "$matched_file"
        return 0
    fi

    # No match found
    echo ""
    return 1
}

# ============================================================
# UPGRADE COMMAND DETECTION
# Identifies user intent from natural language
# ============================================================

# Extract upgrade intent from query
# Usage: extract_upgrade_intent "test saas upgrade before applying"
# Returns: "test" | "apply" | "rollback" | "check" | "list" | "unknown"
extract_upgrade_intent() {
    local query="$1"
    local corrected=$(correct_upgrade_typos "$query")

    # Convert to lowercase
    corrected=$(echo "$corrected" | tr '[:upper:]' '[:lower:]')

    # Intent detection patterns (order matters - most specific first)
    if [[ "$corrected" =~ (test|validate|check|verify|sandbox).*upgrade ]] || \
       [[ "$corrected" =~ upgrade.*(test|validate|check|verify|sandbox) ]]; then
        echo "test"
    elif [[ "$corrected" =~ rollback|revert|undo ]]; then
        echo "rollback"
    elif [[ "$corrected" =~ (apply|install|execute|run|deploy).*upgrade ]] || \
         [[ "$corrected" =~ upgrade.*(apply|install|execute|run|deploy) ]]; then
        echo "apply"
    elif [[ "$corrected" =~ (list|show|display).*upgrade ]] || \
         [[ "$corrected" =~ what.*upgrade.*available ]]; then
        echo "list"
    elif [[ "$corrected" =~ (status|progress|state).*upgrade ]] || \
         [[ "$corrected" =~ upgrade.*(status|progress|state) ]]; then
        echo "status"
    elif [[ "$corrected" =~ impact|affect|change ]]; then
        echo "impact"
    else
        echo "unknown"
    fi
}

# ============================================================
# UPGRADE OPERATIONS
# Execute upgrade commands
# ============================================================

# List all pending upgrades
list_pending_upgrades_nl() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 PENDING UPGRADES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local count=0
    local upgrade_files=($(get_upgrade_files))

    for file in "${upgrade_files[@]}"; do
        ((count++))
        local json_file="${PENDING_UPGRADES_DIR}/${file}.json"

        if command -v jq &> /dev/null && [[ -f "$json_file" ]]; then
            local framework=$(jq -r '.metadata.targetFramework' "$json_file" 2>/dev/null)
            local current_ver=$(jq -r '.metadata.currentVersion' "$json_file" 2>/dev/null)
            local target_ver=$(jq -r '.metadata.targetVersion' "$json_file" 2>/dev/null)
            local component_count=$(jq '.additions.components // [] | length' "$json_file" 2>/dev/null)
            local pattern_count=$(jq '.additions.patterns // [] | length' "$json_file" 2>/dev/null)
            local template_count=$(jq '.additions.templates // [] | length' "$json_file" 2>/dev/null)

            echo "  $count. $framework ($current_ver → $target_ver)"
            echo "     File: $file"
            [[ "$component_count" != "0" ]] && echo "     ✅ $component_count components"
            [[ "$pattern_count" != "0" ]] && echo "     ✅ $pattern_count patterns"
            [[ "$template_count" != "0" ]] && echo "     ✅ $template_count templates"
            echo ""
        else
            echo "  $count. $file"
            echo ""
        fi
    done

    if [[ $count -eq 0 ]]; then
        echo "  No pending upgrades found."
        echo ""
    else
        echo "  Total: $count pending upgrade(s)"
        echo ""
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Show upgrade details
show_upgrade_details() {
    local upgrade_file="$1"
    local json_file="${PENDING_UPGRADES_DIR}/${upgrade_file}.json"

    if [[ ! -f "$json_file" ]]; then
        echo "❌ Upgrade file not found: $upgrade_file"
        return 1
    fi

    if ! command -v jq &> /dev/null; then
        echo "⚠️  jq not installed - cannot parse upgrade details"
        cat "$json_file"
        return 0
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 UPGRADE DETAILS: $upgrade_file"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local framework=$(jq -r '.metadata.targetFramework' "$json_file")
    local current_ver=$(jq -r '.metadata.currentVersion' "$json_file")
    local target_ver=$(jq -r '.metadata.targetVersion' "$json_file")
    local source=$(jq -r '.metadata.source' "$json_file")
    local time_saved=$(jq -r '.metadata.estimatedImpact.developmentTimeSaved' "$json_file")

    echo "  Framework: $framework"
    echo "  Upgrade: $current_ver → $target_ver"
    echo "  Source: $source"
    echo "  Time Saved: $time_saved"
    echo ""

    local component_count=$(jq '.additions.components // [] | length' "$json_file")
    local pattern_count=$(jq '.additions.patterns // [] | length' "$json_file")
    local template_count=$(jq '.additions.templates // [] | length' "$json_file")

    [[ "$component_count" != "0" ]] && echo "  ✅ $component_count components to add"
    [[ "$pattern_count" != "0" ]] && echo "  ✅ $pattern_count patterns to add"
    [[ "$template_count" != "0" ]] && echo "  ✅ $template_count templates to add"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# ============================================================
# MAIN NL INTERFACE
# Process natural language upgrade commands
# ============================================================

# Main function for processing upgrade commands
# Usage: upgrade_nl "test saas framwork upgrade"
upgrade_nl() {
    local query="$*"

    # Extract intent
    local intent=$(extract_upgrade_intent "$query")

    # Match upgrade file if query contains framework name
    local matched_file=$(match_upgrade_file "$query")

    echo "🔍 NL Analysis:"
    echo "   Query: $query"
    echo "   Intent: $intent"
    [[ -n "$matched_file" ]] && echo "   Matched: $matched_file"
    echo ""

    # Execute based on intent
    case "$intent" in
        test)
            if [[ -z "$matched_file" ]]; then
                echo "❌ Could not match upgrade file from query"
                echo "   Available upgrades:"
                list_pending_upgrades_nl
                return 1
            fi

            echo "🧪 TEST MODE: Would test upgrade '$matched_file' in sandbox"
            echo "   (Sandbox testing engine not yet implemented - Phase 2)"
            show_upgrade_details "$matched_file"
            ;;

        apply)
            if [[ -z "$matched_file" ]]; then
                echo "❌ Could not match upgrade file from query"
                echo "   Available upgrades:"
                list_pending_upgrades_nl
                return 1
            fi

            echo "⚠️  APPLY MODE: Would apply upgrade '$matched_file'"
            echo "   (Migration script generator not yet implemented - Phase 3)"
            show_upgrade_details "$matched_file"
            ;;

        rollback)
            echo "🔄 ROLLBACK MODE: Would rollback last migration"
            echo "   (Rollback safety system not yet implemented - Phase 2)"
            ;;

        list)
            list_pending_upgrades_nl
            ;;

        status)
            echo "📊 STATUS: Showing upgrade status"
            echo "   (Status tracking not yet implemented)"
            list_pending_upgrades_nl
            ;;

        impact)
            if [[ -z "$matched_file" ]]; then
                echo "❌ Could not match upgrade file from query"
                return 1
            fi

            echo "📊 IMPACT ANALYSIS: $matched_file"
            echo "   (Impact analysis not yet implemented - Phase 1/2)"
            show_upgrade_details "$matched_file"
            ;;

        unknown)
            echo "❓ Could not determine intent from query"
            echo "   Showing available upgrades..."
            list_pending_upgrades_nl
            ;;
    esac
}

# Export functions
export -f correct_upgrade_typos
export -f get_upgrade_files
export -f match_upgrade_file
export -f extract_upgrade_intent
export -f list_pending_upgrades_nl
export -f show_upgrade_details
export -f upgrade_nl

# Verify integration
echo "✅ NL Upgrade Commands loaded (v1.0.0)"
echo "   Reusing: $(basename "$NL_LEVENSHTEIN_PATH")"
echo "   Usage: upgrade_nl \"test saas upgrade\""
echo ""
echo "   Available intents:"
echo "   • test/validate/check - Test upgrade in sandbox"
echo "   • apply/install - Apply upgrade to production"
echo "   • rollback/revert - Rollback last migration"
echo "   • list/show - Show pending upgrades"
echo "   • impact - Analyze upgrade impact"
