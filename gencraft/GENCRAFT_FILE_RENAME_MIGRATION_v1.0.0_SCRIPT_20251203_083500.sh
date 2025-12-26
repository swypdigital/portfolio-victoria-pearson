#!/bin/bash
# GENCRAFT - FILE RENAME MIGRATION SCRIPT
# Version: 1.0.0
# Created: 2025-12-03 08:35:00
# Purpose: Rename all project files with appropriate GENCRAFT prefix
# Rule: V3_ prefix only for v3.0 documents (master plan, gap analysis)
#       V2.0 or V1.0 prefix for supporting documents based on maturity
# Uses: git mv to preserve history

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="GENCRAFT_RENAME_LOG_v1.0.0_${TIMESTAMP}.txt"

echo "========================================" | tee "$LOG_FILE"
echo "GENCRAFT - FILE RENAME MIGRATION" | tee -a "$LOG_FILE"
echo "Started: $(date)" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Function to rename with git mv
rename_file() {
    local old_path="$1"
    local new_path="$2"

    if [ -f "$old_path" ]; then
        echo "Renaming: $old_path" | tee -a "$LOG_FILE"
        echo "      → $new_path" | tee -a "$LOG_FILE"
        git mv "$old_path" "$new_path" 2>&1 | tee -a "$LOG_FILE"
        echo "" | tee -a "$LOG_FILE"
    else
        echo "SKIPPED (not found): $old_path" | tee -a "$LOG_FILE"
        echo "" | tee -a "$LOG_FILE"
    fi
}

echo "=== ROOT LEVEL FILES ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# BLOCKER Reports - V1.0 (initial versions)
rename_file "BLOCKER_1_1_WEB_RESEARCH_FINAL_REPORT.md" \
    "GENCRAFT_BLOCKER_1_1_WEB_RESEARCH_v1.0.0_FINAL_REPORT_20251203_024400.md"

rename_file "BLOCKER_1_4_COMPLETION_SUMMARY.txt" \
    "GENCRAFT_BLOCKER_1_4_COMPLETION_v1.0.0_SUMMARY_20251203_084500.txt"

# Master Resource Documents - V1.0
rename_file "BUILD_RESOURCES_MASTER.md" \
    "GENCRAFT_BUILD_RESOURCES_MASTER_v1.0.0_COMPLETE_20251203_083300.md"

rename_file "EXTERNAL_REPOS_MANIFEST.md" \
    "GENCRAFT_EXTERNAL_REPOS_MANIFEST_v1.0.0_COMPLETE_20251203_083300.md"

rename_file "GROKLYGROUP_FRAMEWORKS_ANALYSIS_COMPLETE.md" \
    "GENCRAFT_FRAMEWORKS_ANALYSIS_v1.0.0_COMPLETE_20251203_025800.md"

rename_file "MAVERICK_STACK_ARCHITECTURE_COMPLETE.md" \
    "GENCRAFT_MAVERICK_STACK_v1.0.0_COMPLETE_20251203_030200.md"

# Analysis Reports - V1.0
rename_file "META_REPOSITORIES_ANALYSIS.md" \
    "GENCRAFT_META_REPOS_ANALYSIS_v1.0.0_COMPLETE_20251203_083300.md"

rename_file "WEBLINKS_ANALYSIS_REPORT.md" \
    "GENCRAFT_WEBLINKS_ANALYSIS_v1.0.0_REPORT_20251203_083300.md"

rename_file "INGRESS_NGINX_RESEARCH_REPORT_2025.md" \
    "GENCRAFT_INGRESS_NGINX_RESEARCH_v1.0.0_REPORT_20251203_083300.md"

rename_file "VIBESDK_SECURITY_REPORT.md" \
    "GENCRAFT_VIBESDK_SECURITY_v1.0.0_REPORT_20251203_083300.md"

# Phase 1 Documents - V1.0
rename_file "PHASE_1_COMPLETION_REPORT.md" \
    "GENCRAFT_PHASE_1_COMPLETION_v1.0.0_REPORT_20251203_083300.md"

rename_file "PHASE_1_FINAL_SUMMARY.md" \
    "GENCRAFT_PHASE_1_FINAL_v1.0.0_SUMMARY_20251203_083300.md"

rename_file "PHASE_1_ACTIONABLE_RECOMMENDATIONS.md" \
    "GENCRAFT_PHASE_1_RECOMMENDATIONS_v1.0.0_ACTIONABLE_20251203_083300.md"

# Session Documents - V1.0
rename_file "SESSION_HANDOFF_2025_11_30_CRITICAL.md" \
    "GENCRAFT_SESSION_HANDOFF_v1.0.0_CRITICAL_20251130_235900.md"

rename_file "SESSION_HANDOFF_2025_12_01_CRITICAL.md" \
    "GENCRAFT_SESSION_HANDOFF_v1.0.0_CRITICAL_20251201_235900.md"

rename_file "SESSION_HANDOFF_GENCRAFT_V3_FORENSIC_ANALYSIS_COMPLETE_2025-12-02_041200.md" \
    "GENCRAFT_SESSION_HANDOFF_v1.0.0_FORENSIC_COMPLETE_20251202_041200.md"

rename_file "SESSION_PROGRESS_2025_11_30.md" \
    "GENCRAFT_SESSION_PROGRESS_v1.0.0_REPORT_20251130_235900.md"

rename_file "SESSION_TOKEN_TRACKING.md" \
    "GENCRAFT_SESSION_TOKEN_TRACKING_v1.0.0_REPORT_20251203_083300.md"

rename_file "SESSION_COMPLETE_SUMMARY_AND_TODOS_2025-12-02_052100.md" \
    "GENCRAFT_SESSION_COMPLETE_v1.0.0_SUMMARY_20251202_052100.md"

# System Documents - V1.0
rename_file "DOCUMENT_MANAGEMENT_DEPENDENCY_SYSTEM.md" \
    "GENCRAFT_DOCUMENT_MANAGEMENT_v1.0.0_DEPENDENCY_SYSTEM_20251203_083300.md"

rename_file "INTELLIGENT_SELF_HEALING_FRAMEWORK.md" \
    "GENCRAFT_SELF_HEALING_FRAMEWORK_v1.0.0_INTELLIGENT_20251203_083300.md"

rename_file "ENTERPRISE_SECURITY_VETTING_PROTOCOL.md" \
    "GENCRAFT_SECURITY_VETTING_v1.0.0_ENTERPRISE_PROTOCOL_20251203_083300.md"

rename_file "GITHUB_COLLECTIONS_INTEGRATION_PLAN.md" \
    "GENCRAFT_GITHUB_COLLECTIONS_v1.0.0_INTEGRATION_PLAN_20251203_083300.md"

rename_file "IMPLICIT_COMPONENTS_CONFIRMATION.md" \
    "GENCRAFT_IMPLICIT_COMPONENTS_v1.0.0_CONFIRMATION_20251203_083300.md"

rename_file "REQUIREMENTS_ADDENDUM_2025_11_30.md" \
    "GENCRAFT_REQUIREMENTS_ADDENDUM_v1.0.0_20251130_235900.md"

rename_file "OPTION_A_COMPLETION_REPORT.md" \
    "GENCRAFT_OPTION_A_COMPLETION_v1.0.0_REPORT_20251203_083300.md"

rename_file "PHASE_DEPENDENCY_BLOCKER_IMPLEMENTATION_COMPLETE.md" \
    "GENCRAFT_PHASE_DEPENDENCY_BLOCKER_v1.0.0_IMPLEMENTATION_COMPLETE_20251203_083300.md"

echo "" | tee -a "$LOG_FILE"
echo "=== .plans/ DIRECTORY ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Plans Directory - V1.0 for supporting documents
rename_file ".plans/BLOCKER_1_1_WEB_RESEARCH_FINAL_REPORT.md" \
    ".plans/GENCRAFT_BLOCKER_1_1_WEB_RESEARCH_v1.0.0_FINAL_REPORT_20251203_024400.md"

rename_file ".plans/BUILD_ORDER_ANALYSIS_2025-12-02.md" \
    ".plans/GENCRAFT_BUILD_ORDER_ANALYSIS_v1.0.0_REPORT_20251202_235900.md"

rename_file ".plans/COMPLETION_REPORT_v3.0.3_HIGH_PRIORITY_GAPS_2025-12-02.md" \
    ".plans/GENCRAFT_COMPLETION_REPORT_v3.0.3_HIGH_PRIORITY_GAPS_20251202_235900.md"

rename_file ".plans/GROKLYGROUP_FRAMEWORKS_ANALYSIS_COMPLETE.md" \
    ".plans/GENCRAFT_FRAMEWORKS_ANALYSIS_v1.0.0_COMPLETE_20251203_025800.md"

rename_file ".plans/MAVERICK_STACK_ARCHITECTURE_COMPLETE.md" \
    ".plans/GENCRAFT_MAVERICK_STACK_v1.0.0_COMPLETE_20251203_030200.md"

rename_file ".plans/PHASE_1_BLOCKER_STATUS.md" \
    ".plans/GENCRAFT_PHASE_1_BLOCKER_v1.0.0_STATUS_20251203_083300.md"

rename_file ".plans/PHASE_1_COMPLETION_PLAN_2025-12-02.md" \
    ".plans/GENCRAFT_PHASE_1_COMPLETION_v1.0.0_PLAN_20251202_235900.md"

rename_file ".plans/PHASE_2_MIGRATION_PLAN_2025-12-02.md" \
    ".plans/GENCRAFT_PHASE_2_MIGRATION_v1.0.0_PLAN_20251202_235900.md"

rename_file ".plans/PHASE_2_MIGRATION_PLAN_v2_OPTIMIZED_2025-12-02.md" \
    ".plans/GENCRAFT_PHASE_2_MIGRATION_v2.0.0_OPTIMIZED_PLAN_20251202_235900.md"

rename_file ".plans/PHASE_DEPENDENCY_BLOCKER_IMPLEMENTATION_COMPLETE.md" \
    ".plans/GENCRAFT_PHASE_DEPENDENCY_BLOCKER_v1.0.0_IMPLEMENTATION_COMPLETE_20251203_083300.md"

rename_file ".plans/PLAN_UPDATES_FROM_2025_12_01_SESSION.md" \
    ".plans/GENCRAFT_PLAN_UPDATES_v1.0.0_FROM_SESSION_20251201_235900.md"

rename_file ".plans/QUANTUM_TODO_TASKS_2025-12-02.md" \
    ".plans/GENCRAFT_QUANTUM_TODO_TASKS_v1.0.0_LIST_20251202_235900.md"

rename_file ".plans/SUMMARY_v3.0.3_FIXES_2025-12-02.md" \
    ".plans/GENCRAFT_SUMMARY_v3.0.3_FIXES_20251202_235900.md"

rename_file ".plans/VALIDATION_EXECUTIVE_SUMMARY.md" \
    ".plans/GENCRAFT_VALIDATION_EXECUTIVE_v1.0.0_SUMMARY_20251203_083300.md"

rename_file ".plans/VALIDATION_REPORT_V3_MASTER_PLAN.md" \
    ".plans/GENCRAFT_VALIDATION_REPORT_v1.0.0_MASTER_PLAN_20251203_083300.md"

rename_file ".plans/VERSION_HISTORY.md" \
    ".plans/GENCRAFT_VERSION_HISTORY_v1.0.0_TRACKING_20251203_083300.md"

echo "" | tee -a "$LOG_FILE"
echo "=== .analysis-reports/ DIRECTORY ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Analysis Reports Directory - V1.0
rename_file ".analysis-reports/EXECUTIVE_SUMMARY.md" \
    ".analysis-reports/GENCRAFT_EXECUTIVE_SUMMARY_v1.0.0_ANALYSIS_20251203_083300.md"

rename_file ".analysis-reports/PROJECTCRAFT_ANALYSIS_RAW_DATA.json" \
    ".analysis-reports/GENCRAFT_PROJECTCRAFT_ANALYSIS_v1.0.0_RAW_DATA_20251203_060000.json"

rename_file ".analysis-reports/PROJECTCRAFT_COMPLETE_ANALYSIS_WITH_DROP_FOLDER_VISION.md" \
    ".analysis-reports/GENCRAFT_PROJECTCRAFT_COMPLETE_ANALYSIS_v1.0.0_DROP_FOLDER_VISION_20251203_060000.md"

rename_file ".analysis-reports/README.md" \
    ".analysis-reports/GENCRAFT_ANALYSIS_REPORTS_README_v1.0.0_INDEX_20251203_083300.md"

rename_file ".analysis-reports/VIBECODE_OS_ANALYSIS_INDEX.md" \
    ".analysis-reports/GENCRAFT_VIBECODE_OS_ANALYSIS_v1.0.0_INDEX_20251203_050000.md"

rename_file ".analysis-reports/VIBECODE_OS_ANALYSIS_RAW_DATA.json" \
    ".analysis-reports/GENCRAFT_VIBECODE_OS_ANALYSIS_v1.0.0_RAW_DATA_20251203_050000.json"

rename_file ".analysis-reports/VIBECODE_OS_COMPLETE_ANALYSIS.md" \
    ".analysis-reports/GENCRAFT_VIBECODE_OS_COMPLETE_ANALYSIS_v1.0.0_REPORT_20251203_050000.md"

rename_file ".analysis-reports/VIBECODE_OS_INTEGRATION_EXECUTIVE_BRIEF.txt" \
    ".analysis-reports/GENCRAFT_VIBECODE_OS_INTEGRATION_v1.0.0_EXECUTIVE_BRIEF_20251203_050000.txt"

echo "" | tee -a "$LOG_FILE"
echo "=== .gencraft-knowledge-base/ DIRECTORY ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Knowledge Base Directory - V1.0
rename_file ".gencraft-knowledge-base/INDEX.md" \
    ".gencraft-knowledge-base/GENCRAFT_KNOWLEDGE_BASE_v1.0.0_INDEX_20251203_083300.md"

rename_file ".gencraft-knowledge-base/PHASE_1_COMPLETE_REPORT.md" \
    ".gencraft-knowledge-base/GENCRAFT_PHASE_1_COMPLETE_v1.0.0_REPORT_20251203_083300.md"

rename_file ".gencraft-knowledge-base/PHASE_1_PROGRESS_TRACKER.md" \
    ".gencraft-knowledge-base/GENCRAFT_PHASE_1_PROGRESS_v1.0.0_TRACKER_20251203_083300.md"

rename_file ".gencraft-knowledge-base/PHASE_1_SESSION_SUMMARY_2025-12-02.md" \
    ".gencraft-knowledge-base/GENCRAFT_PHASE_1_SESSION_SUMMARY_v1.0.0_20251202_235900.md"

rename_file ".gencraft-knowledge-base/QUICK_REFERENCE_V3.0.4.md" \
    ".gencraft-knowledge-base/GENCRAFT_QUICK_REFERENCE_v3.0.4_GUIDE_20251203_083300.md"

rename_file ".gencraft-knowledge-base/V3.0.4_PLAN_GENERATION_SUMMARY.md" \
    ".gencraft-knowledge-base/GENCRAFT_PLAN_GENERATION_SUMMARY_v3.0.4_REPORT_20251203_083300.md"

rename_file ".gencraft-knowledge-base/V3.0.4_VALIDATION_REPORT.md" \
    ".gencraft-knowledge-base/GENCRAFT_VALIDATION_REPORT_v3.0.4_COMPLETE_20251203_083300.md"

echo "" | tee -a "$LOG_FILE"
echo "=== .phase-dependencies/ DIRECTORY ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Phase Dependencies Directory - V1.0
rename_file ".phase-dependencies/PHASE_BLOCKER_SYSTEM.md" \
    ".phase-dependencies/GENCRAFT_PHASE_BLOCKER_SYSTEM_v1.0.0_DOCUMENTATION_20251203_083300.md"

rename_file ".phase-dependencies/README.md" \
    ".phase-dependencies/GENCRAFT_PHASE_DEPENDENCIES_README_v1.0.0_INDEX_20251203_083300.md"

echo "" | tee -a "$LOG_FILE"
echo "=== .forensic-analysis/ DIRECTORY ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Forensic Analysis Directory - V1.0
rename_file ".forensic-analysis/ANALYSIS_COMPLETE_SUMMARY.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_ANALYSIS_v1.0.0_COMPLETE_SUMMARY_20251202_041200.md"

rename_file ".forensic-analysis/FINAL_VERIFICATION.txt" \
    ".forensic-analysis/GENCRAFT_FORENSIC_FINAL_v1.0.0_VERIFICATION_20251202_041200.txt"

rename_file ".forensic-analysis/PRELIMINARY_FINDINGS_FROM_SCREENSHOTS.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_PRELIMINARY_v1.0.0_FINDINGS_20251202_040000.md"

rename_file ".forensic-analysis/READ_ME_FIRST.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_README_v1.0.0_READ_ME_FIRST_20251202_040000.md"

rename_file ".forensic-analysis/SECURITY_FINDINGS.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_SECURITY_v1.0.0_FINDINGS_20251202_040000.md"

rename_file ".forensic-analysis/consolidated_dec01.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_DEC01_20251201_235900.md"

rename_file ".forensic-analysis/consolidated_dec02.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_DEC02_20251202_235900.md"

rename_file ".forensic-analysis/consolidated_nov25.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_NOV25_20251125_235900.md"

rename_file ".forensic-analysis/consolidated_nov26.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_NOV26_20251126_235900.md"

rename_file ".forensic-analysis/consolidated_nov27.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_NOV27_20251127_235900.md"

rename_file ".forensic-analysis/consolidated_nov28.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_NOV28_20251128_235900.md"

rename_file ".forensic-analysis/consolidated_nov29.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_NOV29_20251129_235900.md"

rename_file ".forensic-analysis/consolidated_nov30.md" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CONSOLIDATED_v1.0.0_NOV30_20251130_235900.md"

rename_file ".forensic-analysis/critical_screenshots.txt" \
    ".forensic-analysis/GENCRAFT_FORENSIC_CRITICAL_v1.0.0_SCREENSHOTS_20251202_040000.txt"

rename_file ".forensic-analysis/statistics_report.json" \
    ".forensic-analysis/GENCRAFT_FORENSIC_STATISTICS_v1.0.0_REPORT_20251202_041200.json"

echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "RENAME MIGRATION COMPLETE" | tee -a "$LOG_FILE"
echo "Completed: $(date)" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
