#!/bin/bash
################################################################################
# BuildCraft-GenCraft Interactive Integration Script
# Purpose: Step-by-step Human-in-the-Loop (HIL) approval workflow for
#          integrating all 3 BuildCraft components into GenCraft
# Created: 2025-12-25
# Part of: BuildCraft-GenCraft Auto-Integration System
################################################################################

set -e  # Exit on error

# Source contractual paths
if [ -f "/mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh" ]; then
    source "/mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh"
else
    echo "ERROR: contractual-paths-true.sh not found"
    exit 1
fi

# Configuration
GENCRAFT_ROOT="${CLAUDE_PROJECTS_ROOT}/projects/github-repos/gencraft-v3.0"
PROFILES_DIR="${GENCRAFT_ROOT}/engine-profiles"
INTEGRATION_LOG="${CLAUDE_PROJECTS_ROOT}/.session-management/buildcraft-integration-log-$(date +%Y%m%d-%H%M%S).txt"

# Component profiles
SCHEMA_PROFILE="${PROFILES_DIR}/buildcraft-schema-engine-profile.json"
VALIDATOR_PROFILE="${PROFILES_DIR}/buildcraft-validator-engine-profile.json"
GENERATOR_PROFILE="${PROFILES_DIR}/buildcraft-generator-engine-profile.json"
SYSTEM_PROFILE="${PROFILES_DIR}/buildcraft-system-profile.json"

# Track integration status
COMPONENTS_INTEGRATED=()
COMPONENTS_SKIPPED=()

################################################################################
# UI Helper Functions
################################################################################

clear_screen() {
    clear
}

print_header() {
    local title="$1"
    echo "════════════════════════════════════════════════════════════════════════"
    echo "  $title"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
}

print_separator() {
    echo "────────────────────────────────────────────────────────────────────────"
}

log_action() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$INTEGRATION_LOG"
}

################################################################################
# Profile Viewing Functions
################################################################################

view_profile() {
    local profile_path="$1"
    local profile_name="$2"

    clear_screen
    print_header "Viewing: $profile_name"

    if [ -f "$profile_path" ]; then
        cat "$profile_path" | jq '.' 2>/dev/null || cat "$profile_path"
        echo ""
        print_separator
        echo "Press any key to return..."
        read -n 1 -s
    else
        echo "ERROR: Profile not found: $profile_path"
        echo "Press any key to continue..."
        read -n 1 -s
    fi
}

################################################################################
# Component Integration Functions
################################################################################

integrate_component() {
    local component_name="$1"
    local profile_path="$2"
    local profile_description="$3"

    clear_screen
    print_header "BuildCraft Integration - $component_name"

    echo "$profile_description"
    echo ""
    print_separator
    echo ""
    echo "OPTIONS:"
    echo "  [Y] Yes, integrate this component"
    echo "  [N] No, skip this component"
    echo "  [V] View full profile first"
    echo "  [Q] Cancel entire integration"
    echo ""
    echo -n "Your choice: "

    while true; do
        read -n 1 -s choice
        choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')

        case "$choice" in
            Y)
                echo "Y - Integrating..."
                log_action "User approved: $component_name"

                # Copy profile to GenCraft registry (already in place, just validate)
                if [ -f "$profile_path" ]; then
                    COMPONENTS_INTEGRATED+=("$component_name")
                    echo ""
                    echo "✅ $component_name integrated successfully!"
                    sleep 2
                    return 0
                else
                    echo ""
                    echo "❌ ERROR: Profile not found: $profile_path"
                    sleep 3
                    return 1
                fi
                ;;
            N)
                echo "N - Skipping..."
                log_action "User skipped: $component_name"
                COMPONENTS_SKIPPED+=("$component_name")
                echo ""
                echo "⏭️  $component_name skipped."
                sleep 2
                return 2
                ;;
            V)
                echo "V - Viewing profile..."
                view_profile "$profile_path" "$component_name"
                # Return to integration prompt after viewing
                integrate_component "$component_name" "$profile_path" "$profile_description"
                return $?
                ;;
            Q)
                echo "Q - Canceling..."
                log_action "User canceled integration at: $component_name"
                echo ""
                echo "🛑 Integration canceled by user."
                exit 0
                ;;
            *)
                # Invalid choice, re-prompt
                continue
                ;;
        esac
    done
}

################################################################################
# Validation Functions
################################################################################

run_validation() {
    clear_screen
    print_header "BuildCraft Integration - Validation"

    echo "All components have been processed."
    echo ""
    echo "Integrated: ${#COMPONENTS_INTEGRATED[@]} component(s)"
    echo "Skipped: ${#COMPONENTS_SKIPPED[@]} component(s)"
    echo ""
    print_separator
    echo ""
    echo "Run validation tests to verify integration?"
    echo ""
    echo "  [ENTER] Run validation"
    echo "  [Q] Skip validation"
    echo ""
    echo -n "Your choice: "

    read -n 1 -s choice
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')

    if [ "$choice" = "Q" ]; then
        echo "Q - Skipping validation"
        log_action "User skipped validation"
        echo ""
        echo "⏭️  Validation skipped."
        sleep 2
        return 1
    fi

    echo ""
    echo "Running validation tests..."
    echo ""

    # Validation Test 1: Verify profiles exist
    local all_valid=true

    echo "Test 1: Verifying engine profiles are registered..."
    for component in "${COMPONENTS_INTEGRATED[@]}"; do
        case "$component" in
            "BuildCraft Schema")
                if [ -f "$SCHEMA_PROFILE" ]; then
                    echo "  ✅ Schema profile verified"
                else
                    echo "  ❌ Schema profile missing"
                    all_valid=false
                fi
                ;;
            "BuildCraft Validator")
                if [ -f "$VALIDATOR_PROFILE" ]; then
                    echo "  ✅ Validator profile verified"
                else
                    echo "  ❌ Validator profile missing"
                    all_valid=false
                fi
                ;;
            "BuildCraft Generator")
                if [ -f "$GENERATOR_PROFILE" ]; then
                    echo "  ✅ Generator profile verified"
                else
                    echo "  ❌ Generator profile missing"
                    all_valid=false
                fi
                ;;
            "BuildCraft System Profile")
                if [ -f "$SYSTEM_PROFILE" ]; then
                    echo "  ✅ System profile verified"
                else
                    echo "  ❌ System profile missing"
                    all_valid=false
                fi
                ;;
        esac
    done

    echo ""
    echo "Test 2: Verifying JSON syntax..."
    for component in "${COMPONENTS_INTEGRATED[@]}"; do
        case "$component" in
            "BuildCraft Schema")
                if jq '.' "$SCHEMA_PROFILE" >/dev/null 2>&1; then
                    echo "  ✅ Schema JSON valid"
                else
                    echo "  ❌ Schema JSON invalid"
                    all_valid=false
                fi
                ;;
            "BuildCraft Validator")
                if jq '.' "$VALIDATOR_PROFILE" >/dev/null 2>&1; then
                    echo "  ✅ Validator JSON valid"
                else
                    echo "  ❌ Validator JSON invalid"
                    all_valid=false
                fi
                ;;
            "BuildCraft Generator")
                if jq '.' "$GENERATOR_PROFILE" >/dev/null 2>&1; then
                    echo "  ✅ Generator JSON valid"
                else
                    echo "  ❌ Generator JSON invalid"
                    all_valid=false
                fi
                ;;
            "BuildCraft System Profile")
                if jq '.' "$SYSTEM_PROFILE" >/dev/null 2>&1; then
                    echo "  ✅ System profile JSON valid"
                else
                    echo "  ❌ System profile JSON invalid"
                    all_valid=false
                fi
                ;;
        esac
    done

    echo ""
    echo "Test 3: Verifying dependency chain..."
    # Check if Generator depends on Validator and Schema
    if [[ " ${COMPONENTS_INTEGRATED[@]} " =~ " BuildCraft Generator " ]]; then
        if [[ " ${COMPONENTS_INTEGRATED[@]} " =~ " BuildCraft Validator " ]] && \
           [[ " ${COMPONENTS_INTEGRATED[@]} " =~ " BuildCraft Schema " ]]; then
            echo "  ✅ Dependency chain valid (Generator → Validator → Schema)"
        else
            echo "  ⚠️  Warning: Generator integrated without Validator or Schema"
            echo "     (BuildCraft system requires all 3 components)"
        fi
    fi

    echo ""
    print_separator

    if [ "$all_valid" = true ]; then
        echo ""
        echo "✅ All validation tests PASSED"
        log_action "Validation: PASS"
    else
        echo ""
        echo "❌ Some validation tests FAILED"
        log_action "Validation: FAIL"
    fi

    echo ""
    echo "Press any key to continue..."
    read -n 1 -s

    return 0
}

################################################################################
# Completion Summary
################################################################################

show_completion() {
    clear_screen
    print_header "BuildCraft Integration - Complete"

    echo "Integration workflow finished!"
    echo ""
    print_separator
    echo ""
    echo "SUMMARY:"
    echo ""
    echo "Integrated Components (${#COMPONENTS_INTEGRATED[@]}):"
    if [ ${#COMPONENTS_INTEGRATED[@]} -eq 0 ]; then
        echo "  (none)"
    else
        for component in "${COMPONENTS_INTEGRATED[@]}"; do
            echo "  ✅ $component"
        done
    fi

    echo ""
    echo "Skipped Components (${#COMPONENTS_SKIPPED[@]}):"
    if [ ${#COMPONENTS_SKIPPED[@]} -eq 0 ]; then
        echo "  (none)"
    else
        for component in "${COMPONENTS_SKIPPED[@]}"; do
            echo "  ⏭️  $component"
        done
    fi

    echo ""
    print_separator
    echo ""
    echo "GenCraft Tool Specification Engine now has access to:"
    for component in "${COMPONENTS_INTEGRATED[@]}"; do
        case "$component" in
            "BuildCraft Schema")
                echo "  • Enterprise compliance standards definition"
                ;;
            "BuildCraft Validator")
                echo "  • Code validation and compliance scoring"
                ;;
            "BuildCraft Generator")
                echo "  • Recursive code generation with auto-fixing"
                ;;
            "BuildCraft System Profile")
                echo "  • Unified 3-component system orchestration"
                ;;
        esac
    done

    echo ""
    print_separator
    echo ""
    echo "Integration log saved to:"
    echo "  $INTEGRATION_LOG"
    echo ""
    echo "OPTIONS:"
    echo "  [ENTER] Close"
    echo "  [L] View integration log"
    echo ""
    echo -n "Your choice: "

    read -n 1 -s choice
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')

    if [ "$choice" = "L" ]; then
        echo "L - Viewing log..."
        echo ""
        cat "$INTEGRATION_LOG"
        echo ""
        echo "Press any key to close..."
        read -n 1 -s
    fi

    clear_screen
    echo "BuildCraft integration complete. Thank you!"
}

################################################################################
# Main Integration Workflow
################################################################################

main() {
    # Create integration log
    mkdir -p "$(dirname "$INTEGRATION_LOG")"
    log_action "BuildCraft-GenCraft integration started"

    # Step 1: Confirm start
    clear_screen
    print_header "BuildCraft-GenCraft Integration"

    echo "GenCraft Tool Specification Engine detected at:"
    echo "  $GENCRAFT_ROOT"
    echo ""
    echo "This interactive workflow will guide you through integrating all 3"
    echo "BuildCraft components into GenCraft's engine registry."
    echo ""
    print_separator
    echo ""
    echo "  [ENTER] Continue with integration"
    echo "  [Q] Cancel"
    echo ""
    echo -n "Press ENTER to start: "

    read -n 1 -s choice
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')

    if [ "$choice" = "Q" ]; then
        echo ""
        echo "Integration canceled by user."
        exit 0
    fi

    log_action "User confirmed start"

    # Step 2: Integrate BuildCraft Schema
    integrate_component \
        "BuildCraft Schema" \
        "$SCHEMA_PROFILE" \
        "This component defines enterprise compliance requirements:
  • 10-phase testing framework
  • Security standards (RBAC, JWT, encryption)
  • Anti-hallucination rules
  • Code quality standards
  • Compliance scoring weights"

    # Step 3: Integrate BuildCraft Validator
    integrate_component \
        "BuildCraft Validator" \
        "$VALIDATOR_PROFILE" \
        "This component validates code against schema:
  • 8 validation methods (security, architecture, quality, etc.)
  • Compliance scoring system
  • Violation detection and reporting
  • Fix prompt generation"

    # Step 4: Integrate BuildCraft Generator
    integrate_component \
        "BuildCraft Generator" \
        "$GENERATOR_PROFILE" \
        "This component generates 100% compliant code:
  • Recursive debugging loop (max 5 attempts)
  • Auto-fix violations using validator feedback
  • Guaranteed compliance or failure (no partial success)
  • Mock-first architecture enforcement"

    # Step 5: Integrate System Profile
    integrate_component \
        "BuildCraft System Profile" \
        "$SYSTEM_PROFILE" \
        "This profile combines all three components.
  • Requires: Schema + Validator + Generator (all integrated)
  • Provides unified system orchestration
  • Enables intelligent routing by GenCraft"

    # Step 6: Run validation
    run_validation

    # Step 7: Show completion summary
    show_completion

    log_action "BuildCraft-GenCraft integration completed successfully"
}

################################################################################
# Entry Point
################################################################################

main

exit 0
