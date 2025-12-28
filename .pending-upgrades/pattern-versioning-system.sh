#!/bin/bash
# Pattern Versioning System for Pending Upgrades
# Semantic versioning (Major.Minor.Patch) for framework patterns
# Prevents breaking deployed projects through version locking
#
# Version: 1.0.0
# Created: 2025-12-27
# Part of: Pending Upgrades System - Phase 1
#
# Usage:
#   source pattern-versioning-system.sh
#   version_parse "v2.3.1"                 # Parse semver
#   version_compare "v2.1.0" "v2.0.5"      # Compare versions
#   detect_breaking_changes "old.json" "new.json"  # Analyze changes
#   generate_lock_file "/path/to/project"  # Create .pattern-lock.json
#   check_upgrade_safety "pattern-id" "v2.0" "v3.0"  # Verify safe upgrade

# Source contractual paths
if [[ -f "/mnt/c/Users/jdh/claude_projects/.daemon-registry/contractual-paths-true.sh" ]]; then
    source "/mnt/c/Users/jdh/claude_projects/.daemon-registry/contractual-paths-true.sh"
else
    echo "❌ ERROR: contractual-paths-true.sh not found"
    exit 1
fi

# Configuration
PENDING_UPGRADES_DIR="${CLAUDE_PROJECTS_ROOT}/.pending-upgrades"
USAGE_REGISTRY_DB="${PENDING_UPGRADES_DIR}/pattern-usage-registry.json"
LOCK_FILE_NAME=".pattern-lock.json"

# Initialize usage registry if not exists
init_usage_registry() {
    if [[ ! -f "$USAGE_REGISTRY_DB" ]]; then
        cat > "$USAGE_REGISTRY_DB" <<'EOF'
{
  "schemaVersion": "1.0.0",
  "lastUpdated": null,
  "projects": {},
  "patterns": {}
}
EOF
        echo "✅ Usage registry initialized: $USAGE_REGISTRY_DB"
    fi
}

# ============================================================
# SEMANTIC VERSIONING FUNCTIONS
# ============================================================

# Parse semantic version string into components
# Usage: version_parse "v2.3.1-beta.1" → "2 3 1 beta.1"
version_parse() {
    local version="$1"

    # Strip 'v' prefix if present
    version="${version#v}"
    version="${version#V}"

    # Extract components
    local major=$(echo "$version" | cut -d'.' -f1 | grep -o '^[0-9]*')
    local minor=$(echo "$version" | cut -d'.' -f2 | grep -o '^[0-9]*')
    local patch_full=$(echo "$version" | cut -d'.' -f3)
    local patch=$(echo "$patch_full" | grep -o '^[0-9]*')
    local prerelease=""

    # Extract pre-release tag (e.g., "beta.1" from "1-beta.1")
    if [[ "$patch_full" == *-* ]]; then
        prerelease="${patch_full#*-}"
    fi

    echo "${major:-0} ${minor:-0} ${patch:-0} ${prerelease}"
}

# Compare two semantic versions
# Usage: version_compare "v2.1.0" "v2.0.5" → "1" (first is greater)
# Returns: -1 (less), 0 (equal), 1 (greater)
version_compare() {
    local v1="$1"
    local v2="$2"

    local parsed1=($(version_parse "$v1"))
    local parsed2=($(version_parse "$v2"))

    # Compare major
    if [[ ${parsed1[0]} -gt ${parsed2[0]} ]]; then
        echo "1"
        return
    elif [[ ${parsed1[0]} -lt ${parsed2[0]} ]]; then
        echo "-1"
        return
    fi

    # Compare minor
    if [[ ${parsed1[1]} -gt ${parsed2[1]} ]]; then
        echo "1"
        return
    elif [[ ${parsed1[1]} -lt ${parsed2[1]} ]]; then
        echo "-1"
        return
    fi

    # Compare patch
    if [[ ${parsed1[2]} -gt ${parsed2[2]} ]]; then
        echo "1"
        return
    elif [[ ${parsed1[2]} -lt ${parsed2[2]} ]]; then
        echo "-1"
        return
    fi

    # Equal
    echo "0"
}

# Validate semantic version format
# Usage: version_validate "v2.3.1" → returns 0 (valid) or 1 (invalid)
version_validate() {
    local version="$1"

    # Regex for semantic versioning
    local semver_regex='^[vV]?([0-9]+)\.([0-9]+)\.([0-9]+)(-[a-zA-Z0-9.-]+)?(\+[a-zA-Z0-9.-]+)?$'

    if [[ "$version" =~ $semver_regex ]]; then
        return 0
    else
        return 1
    fi
}

# Increment version component
# Usage: version_increment "v2.3.1" "minor" → "v2.4.0"
version_increment() {
    local version="$1"
    local component="${2:-patch}"  # major|minor|patch

    local parsed=($(version_parse "$version"))
    local major="${parsed[0]}"
    local minor="${parsed[1]}"
    local patch="${parsed[2]}"

    case "$component" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "❌ ERROR: Invalid component: $component" >&2
            return 1
            ;;
    esac

    echo "v${major}.${minor}.${patch}"
}

# ============================================================
# BREAKING CHANGE DETECTION
# ============================================================

# Detect breaking changes between two pattern versions
# Usage: detect_breaking_changes "old-pattern.json" "new-pattern.json"
# Returns: JSON with breaking changes detected
detect_breaking_changes() {
    local old_pattern_file="$1"
    local new_pattern_file="$2"

    if [[ ! -f "$old_pattern_file" ]] || [[ ! -f "$new_pattern_file" ]]; then
        echo '{"error": "Pattern files not found"}'
        return 1
    fi

    local breaking_changes=()
    local change_count=0

    # Check if jq is available
    if ! command -v jq &> /dev/null; then
        echo '{"error": "jq not installed"}'
        return 1
    fi

    # Extract pattern IDs from both files
    local old_ids=$(jq -r '.additions.patterns[]?.id // empty' "$old_pattern_file" 2>/dev/null | sort)
    local new_ids=$(jq -r '.additions.patterns[]?.id // empty' "$new_pattern_file" 2>/dev/null | sort)

    # Detect removed patterns (BREAKING)
    local removed_ids=$(comm -23 <(echo "$old_ids") <(echo "$new_ids"))
    if [[ -n "$removed_ids" ]]; then
        while IFS= read -r id; do
            [[ -z "$id" ]] && continue
            breaking_changes+=("Pattern removed: $id (MAJOR breaking change)")
            ((change_count++))
        done <<< "$removed_ids"
    fi

    # Check for signature changes in existing patterns
    local common_ids=$(comm -12 <(echo "$old_ids") <(echo "$new_ids"))
    while IFS= read -r id; do
        [[ -z "$id" ]] && continue

        # Compare pattern structures
        local old_pattern=$(jq ".additions.patterns[] | select(.id == \"$id\")" "$old_pattern_file" 2>/dev/null)
        local new_pattern=$(jq ".additions.patterns[] | select(.id == \"$id\")" "$new_pattern_file" 2>/dev/null)

        # Check for interface changes (simplified - real implementation would be more thorough)
        local old_category=$(echo "$old_pattern" | jq -r '.category // empty')
        local new_category=$(echo "$new_pattern" | jq -r '.category // empty')

        if [[ "$old_category" != "$new_category" ]] && [[ -n "$old_category" ]] && [[ -n "$new_category" ]]; then
            breaking_changes+=("Pattern $id: Category changed from '$old_category' to '$new_category' (MINOR breaking change)")
            ((change_count++))
        fi
    done <<< "$common_ids"

    # Generate JSON output
    local output='{"breakingChanges": ['
    local first=true
    for change in "${breaking_changes[@]}"; do
        if [[ "$first" == true ]]; then
            first=false
        else
            output+=","
        fi
        output+="\"$change\""
    done
    output+='], "changeCount": '$change_count', "hasBreakingChanges": '
    if [[ $change_count -gt 0 ]]; then
        output+='true'
    else
        output+='false'
    fi
    output+='}'

    echo "$output"
}

# Analyze upgrade type based on changes
# Usage: analyze_upgrade_type "v1.0.0" "v2.0.0" "changes.json"
# Returns: "major" | "minor" | "patch"
analyze_upgrade_type() {
    local old_version="$1"
    local new_version="$2"
    local changes_json="$3"

    # Parse versions
    local old_parsed=($(version_parse "$old_version"))
    local new_parsed=($(version_parse "$new_version"))

    # Check version bump
    if [[ ${new_parsed[0]} -gt ${old_parsed[0]} ]]; then
        echo "major"
    elif [[ ${new_parsed[1]} -gt ${old_parsed[1]} ]]; then
        echo "minor"
    else
        echo "patch"
    fi
}

# ============================================================
# USAGE REGISTRY MANAGEMENT
# ============================================================

# Register pattern usage by a project
# Usage: register_pattern_usage "/path/to/project" "Pattern #73" "v2.1.0"
register_pattern_usage() {
    local project_path="$1"
    local pattern_id="$2"
    local version="$3"

    init_usage_registry

    local project_name=$(basename "$project_path")
    local timestamp=$(date -Iseconds)

    # Update registry using jq
    local temp_file=$(mktemp)
    jq --arg proj "$project_name" \
       --arg path "$project_path" \
       --arg pattern "$pattern_id" \
       --arg ver "$version" \
       --arg time "$timestamp" \
       '
       .lastUpdated = $time |
       .projects[$proj] = (.projects[$proj] // {
           "path": $path,
           "patterns": {}
       }) |
       .projects[$proj].patterns[$pattern] = {
           "version": $ver,
           "installedAt": $time
       } |
       .patterns[$pattern] = (.patterns[$pattern] // {
           "usedBy": []
       }) |
       if (.patterns[$pattern].usedBy | map(select(.project == $proj)) | length == 0) then
           .patterns[$pattern].usedBy += [{
               "project": $proj,
               "version": $ver,
               "since": $time
           }]
       else
           .patterns[$pattern].usedBy |= map(
               if .project == $proj then
                   . + {"version": $ver, "updated": $time}
               else
                   .
               end
           )
       end
       ' "$USAGE_REGISTRY_DB" > "$temp_file"

    mv "$temp_file" "$USAGE_REGISTRY_DB"
    echo "✅ Registered: $project_name uses $pattern_id@$version"
}

# Get all projects using a specific pattern
# Usage: get_pattern_users "Pattern #73" "v2.0.0"
# Returns: JSON array of projects
get_pattern_users() {
    local pattern_id="$1"
    local version="${2:-}"  # Optional version filter

    if [[ ! -f "$USAGE_REGISTRY_DB" ]]; then
        echo '[]'
        return
    fi

    if [[ -n "$version" ]]; then
        jq --arg pattern "$pattern_id" --arg ver "$version" \
           '.patterns[$pattern].usedBy // [] | map(select(.version == $ver))' \
           "$USAGE_REGISTRY_DB"
    else
        jq --arg pattern "$pattern_id" \
           '.patterns[$pattern].usedBy // []' \
           "$USAGE_REGISTRY_DB"
    fi
}

# Check which projects would be affected by upgrade
# Usage: check_affected_projects "Pattern #73" "v2.0.0" "v3.0.0"
check_affected_projects() {
    local pattern_id="$1"
    local old_version="$2"
    local new_version="$3"

    # Get all users of the old version
    local users=$(get_pattern_users "$pattern_id" "$old_version")
    local count=$(echo "$users" | jq 'length')

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 UPGRADE IMPACT ANALYSIS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Pattern: $pattern_id"
    echo "Upgrade: $old_version → $new_version"
    echo "Affected Projects: $count"
    echo ""

    if [[ $count -gt 0 ]]; then
        echo "Projects that need migration:"
        echo "$users" | jq -r '.[] | "  • \(.project) (using v\(.version))"'
    else
        echo "✅ No projects currently using this pattern version"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ============================================================
# LOCK FILE MANAGEMENT
# ============================================================

# Generate pattern lock file for a project
# Usage: generate_lock_file "/path/to/project"
generate_lock_file() {
    local project_path="$1"
    local lock_file="${project_path}/${LOCK_FILE_NAME}"

    echo "🔒 Generating pattern lock file for: $(basename "$project_path")"

    # Create lock file structure
    cat > "$lock_file" <<EOF
{
  "lockfileVersion": "1.0.0",
  "generatedAt": "$(date -Iseconds)",
  "project": "$(basename "$project_path")",
  "patterns": {},
  "metadata": {
    "generator": "pattern-versioning-system.sh",
    "autoUpdate": false,
    "strictVersioning": true
  }
}
EOF

    echo "✅ Lock file created: $lock_file"
    echo "   Projects can now pin pattern versions"
}

# Add pattern to lock file
# Usage: lock_pattern "/path/to/project" "Pattern #73" "v2.1.0"
lock_pattern() {
    local project_path="$1"
    local pattern_id="$2"
    local version="$3"

    local lock_file="${project_path}/${LOCK_FILE_NAME}"

    if [[ ! -f "$lock_file" ]]; then
        generate_lock_file "$project_path"
    fi

    # Add pattern to lock file
    local temp_file=$(mktemp)
    jq --arg pattern "$pattern_id" \
       --arg ver "$version" \
       --arg time "$(date -Iseconds)" \
       '
       .patterns[$pattern] = {
           "version": $ver,
           "lockedAt": $time,
           "integrity": "",
           "resolved": ""
       }
       ' "$lock_file" > "$temp_file"

    mv "$temp_file" "$lock_file"

    # Also register in usage registry
    register_pattern_usage "$project_path" "$pattern_id" "$version"

    echo "✅ Locked: $pattern_id@$version in $(basename "$project_path")"
}

# Read pattern version from lock file
# Usage: get_locked_version "/path/to/project" "Pattern #73"
get_locked_version() {
    local project_path="$1"
    local pattern_id="$2"
    local lock_file="${project_path}/${LOCK_FILE_NAME}"

    if [[ ! -f "$lock_file" ]]; then
        echo ""
        return 1
    fi

    jq -r --arg pattern "$pattern_id" \
       '.patterns[$pattern].version // ""' \
       "$lock_file"
}

# Check if upgrade is allowed by lock file
# Usage: check_upgrade_safety "/path/to/project" "Pattern #73" "v2.0.0" "v3.0.0"
check_upgrade_safety() {
    local project_path="$1"
    local pattern_id="$2"
    local old_version="$3"
    local new_version="$4"

    local locked_version=$(get_locked_version "$project_path" "$pattern_id")

    if [[ -z "$locked_version" ]]; then
        echo "⚠️  Pattern not locked - upgrade allowed (but will require testing)"
        return 0
    fi

    local comparison=$(version_compare "$locked_version" "$old_version")

    if [[ "$comparison" != "0" ]]; then
        echo "❌ Lock file mismatch!"
        echo "   Locked: $locked_version"
        echo "   Expected: $old_version"
        return 1
    fi

    # Analyze upgrade type
    local parsed_old=($(version_parse "$old_version"))
    local parsed_new=($(version_parse "$new_version"))

    local upgrade_type=""
    if [[ ${parsed_new[0]} -gt ${parsed_old[0]} ]]; then
        upgrade_type="MAJOR"
    elif [[ ${parsed_new[1]} -gt ${parsed_old[1]} ]]; then
        upgrade_type="MINOR"
    else
        upgrade_type="PATCH"
    fi

    echo "🔍 Upgrade Analysis:"
    echo "   Pattern: $pattern_id"
    echo "   Current: $old_version (locked)"
    echo "   Target: $new_version"
    echo "   Type: $upgrade_type upgrade"
    echo ""

    if [[ "$upgrade_type" == "MAJOR" ]]; then
        echo "⚠️  MAJOR upgrade - may contain breaking changes"
        echo "   Requires: Sandbox testing + manual approval"
        return 2
    elif [[ "$upgrade_type" == "MINOR" ]]; then
        echo "⚠️  MINOR upgrade - backward compatible but adds features"
        echo "   Requires: Sandbox testing"
        return 1
    else
        echo "✅ PATCH upgrade - bug fixes only, safe to apply"
        return 0
    fi
}

# ============================================================
# CLI INTERFACE
# ============================================================

# Main CLI function
pattern_version_cli() {
    local command="$1"
    shift

    case "$command" in
        parse)
            version_parse "$@"
            ;;
        compare)
            version_compare "$@"
            ;;
        validate)
            if version_validate "$@"; then
                echo "✅ Valid semantic version: $1"
            else
                echo "❌ Invalid semantic version: $1"
                return 1
            fi
            ;;
        increment)
            version_increment "$@"
            ;;
        detect-breaking)
            detect_breaking_changes "$@"
            ;;
        register)
            register_pattern_usage "$@"
            ;;
        users)
            get_pattern_users "$@"
            ;;
        impact)
            check_affected_projects "$@"
            ;;
        lock)
            lock_pattern "$@"
            ;;
        unlock)
            # TODO: Implement unlock pattern
            echo "⚠️  Unlock not yet implemented"
            ;;
        check-safety)
            check_upgrade_safety "$@"
            ;;
        init)
            init_usage_registry
            ;;
        help)
            cat <<'HELP'
Pattern Versioning System - Usage

VERSIONING COMMANDS:
  parse <version>                    Parse semver into components
  compare <v1> <v2>                  Compare two versions (-1, 0, 1)
  validate <version>                 Validate semver format
  increment <version> <major|minor|patch>  Increment version

BREAKING CHANGE DETECTION:
  detect-breaking <old.json> <new.json>  Detect breaking changes

USAGE REGISTRY:
  register <project> <pattern> <version>  Register pattern usage
  users <pattern> [version]               Get projects using pattern
  impact <pattern> <old-ver> <new-ver>    Analyze upgrade impact

LOCK FILE MANAGEMENT:
  lock <project> <pattern> <version>      Lock pattern version
  check-safety <project> <pattern> <old> <new>  Check upgrade safety

UTILITIES:
  init                                    Initialize usage registry
  help                                    Show this help

EXAMPLES:
  pattern_version_cli parse "v2.3.1"
  pattern_version_cli compare "v2.0.0" "v1.9.9"
  pattern_version_cli register "/project" "Pattern #73" "v2.1.0"
  pattern_version_cli impact "Pattern #73" "v2.0.0" "v3.0.0"
  pattern_version_cli check-safety "/project" "Pattern #73" "v2.0.0" "v3.0.0"
HELP
            ;;
        *)
            echo "❌ Unknown command: $command"
            echo "Run: pattern_version_cli help"
            return 1
            ;;
    esac
}

# Export functions for use in other scripts
export -f version_parse
export -f version_compare
export -f version_validate
export -f version_increment
export -f detect_breaking_changes
export -f analyze_upgrade_type
export -f register_pattern_usage
export -f get_pattern_users
export -f check_affected_projects
export -f generate_lock_file
export -f lock_pattern
export -f get_locked_version
export -f check_upgrade_safety
export -f pattern_version_cli

# Initialize registry on load
init_usage_registry

echo "✅ Pattern Versioning System loaded (v1.0.0)"
echo "   Usage: pattern_version_cli help"
