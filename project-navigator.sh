#!/bin/bash
# PROJECT NAVIGATOR - Interactive Terminal UI
# Part of Claude OS Ecosystem

# Auto-load contractual paths
if [[ -z "$CONTRACTUAL_PATHS_LOADED" ]]; then
    for dir in "$(dirname "$0")" "${CLAUDE_PROJECTS_ROOT:-${CLAUDE_PROJECTS_ROOT}}" "${CLAUDE_PROJECTS_ROOT}"; do
        [[ -f "$dir/contractual-paths-true.sh" ]] && source "$dir/contractual-paths-true.sh" && break
    done
fi

BASE_DIR="${CLAUDE_PROJECTS_ROOT}"

# Function to show main menu
show_main_menu() {
    whiptail --title "Claude OS - Project Navigator" --menu \
    "Select a project to open:" 20 78 10 \
    "1" "📁 claude_projects (Infrastructure)" \
    "2" "📁 InterviewPlus Production" \
    "3" "📁 GenCraft v3.0" \
    "4" "📁 Browse all projects" \
    "5" "🔧 Worktree Management" \
    "6" "📊 Git Status (All Projects)" \
    "7" "🚀 Start Menu" \
    "8" "❌ Exit" \
    3>&1 1>&2 2>&3
}

# Function to show project details
show_project_details() {
    local project_path="$1"
    local project_name="$2"

    cd "$project_path" 2>/dev/null || {
        whiptail --title "Error" --msgbox "Cannot access $project_path" 8 60
        return 1
    }

    # Get project info
    local branch=$(git branch --show-current 2>/dev/null || echo "Not a git repo")
    local remote=$(git remote get-url origin 2>/dev/null || echo "No remote")
    local status=$(git status --short 2>/dev/null | wc -l)

    # Show info and options
    whiptail --title "$project_name" --menu \
    "📂 Path: $project_path\n🌿 Branch: $branch\n🔗 Remote: $remote\n📝 Changes: $status file(s)\n\nWhat would you like to do?" \
    22 78 8 \
    "1" "📂 Open in this terminal (cd)" \
    "2" "📋 Show file tree" \
    "3" "📊 Git status" \
    "4" "🔍 Search files" \
    "5" "⬅️  Back to menu" \
    3>&1 1>&2 2>&3
}

# Function to show file tree
show_file_tree() {
    local project_path="$1"
    cd "$project_path"

    local tree_output=$(tree -L 2 -I 'node_modules|.git|dist|build' 2>/dev/null || find . -maxdepth 2 -type d | head -30)

    whiptail --title "File Tree" --scrolltext --msgbox "$tree_output" 20 78
}

# Function to show git status
show_git_status() {
    local project_path="$1"
    cd "$project_path"

    local status_output=$(git status 2>/dev/null || echo "Not a git repository")

    whiptail --title "Git Status" --scrolltext --msgbox "$status_output" 20 78
}

# Function to browse all projects
browse_all_projects() {
    local projects=()
    local index=1

    # Find all git repositories
    while IFS= read -r git_dir; do
        local proj_dir=$(dirname "$git_dir")
        local proj_name=$(basename "$proj_dir")
        projects+=("$index" "$proj_name ($proj_dir)")
        ((index++))
    done < <(find "$BASE_DIR" -name ".git" -type d 2>/dev/null | head -20)

    if [ ${#projects[@]} -eq 0 ]; then
        whiptail --title "No Projects" --msgbox "No git repositories found" 8 60
        return
    fi

    local choice=$(whiptail --title "All Projects" --menu \
    "Select a project:" 20 78 10 \
    "${projects[@]}" \
    3>&1 1>&2 2>&3)

    if [ -n "$choice" ]; then
        local selected_index=$((choice - 1))
        local selected_proj="${projects[$((selected_index * 2 + 1))]}"
        local proj_path=$(echo "$selected_proj" | sed 's/.*(\(.*\))/\1/')
        show_project_details "$proj_path" "$(basename $proj_path)"
    fi
}

# Function to show worktree management
show_worktree_menu() {
    local choice=$(whiptail --title "Worktree Management" --menu \
    "Git Worktree Operations:" 18 78 8 \
    "1" "📋 List all worktrees" \
    "2" "➕ Create new worktree" \
    "3" "📊 Worktree status" \
    "4" "🧹 Cleanup stale worktrees" \
    "5" "⬅️  Back to menu" \
    3>&1 1>&2 2>&3)

    case $choice in
        1)
            local wt_list=$(git worktree list 2>/dev/null || echo "No worktrees")
            whiptail --title "Worktrees" --scrolltext --msgbox "$wt_list" 15 78
            ;;
        2)
            local branch=$(whiptail --inputbox "Enter branch name for new worktree:" 8 60 "feature/new-feature" 3>&1 1>&2 2>&3)
            if [ -n "$branch" ]; then
                worktree-create "$branch" 2>&1 | whiptail --title "Creating Worktree" --scrolltext --msgbox "$(cat)" 15 78
            fi
            ;;
        3)
            local status=$(worktree-status 2>&1)
            whiptail --title "Worktree Status" --scrolltext --msgbox "$status" 20 78
            ;;
        4)
            local cleanup=$(worktree-cleanup 24 2>&1)
            whiptail --title "Cleanup Results" --scrolltext --msgbox "$cleanup" 15 78
            ;;
    esac
}

# Function to show git status for all projects
show_all_git_status() {
    local output=""

    output+="╔══════════════════════════════════════════════════════════════╗\n"
    output+="║              GIT STATUS - ALL PROJECTS                       ║\n"
    output+="╚══════════════════════════════════════════════════════════════╝\n\n"

    while IFS= read -r git_dir; do
        local proj_dir=$(dirname "$git_dir")
        local proj_name=$(basename "$proj_dir")

        cd "$proj_dir"
        local branch=$(git branch --show-current 2>/dev/null)
        local changes=$(git status --short 2>/dev/null | wc -l)
        local unpushed=$(git log --branches --not --remotes --oneline 2>/dev/null | wc -l)

        output+="📁 $proj_name\n"
        output+="   Branch: $branch\n"
        output+="   Changes: $changes file(s)\n"
        output+="   Unpushed: $unpushed commit(s)\n\n"
    done < <(find "$BASE_DIR" -name ".git" -type d 2>/dev/null | head -10)

    echo -e "$output" | whiptail --title "Git Status - All Projects" --scrolltext --msgbox "$(cat)" 20 78
}

# Main loop
main() {
    while true; do
        choice=$(show_main_menu)

        case $choice in
            1)
                result=$(show_project_details "$BASE_DIR" "claude_projects")
                if [ "$result" = "1" ]; then
                    cd "$BASE_DIR"
                    break
                fi
                ;;
            2)
                result=$(show_project_details "$BASE_DIR/projects/github-repos/interviewplus-production" "InterviewPlus Production")
                if [ "$result" = "1" ]; then
                    cd "$BASE_DIR/projects/github-repos/interviewplus-production"
                    break
                fi
                ;;
            3)
                result=$(show_project_details "$BASE_DIR/gencraft-v2.0" "GenCraft v3.0")
                if [ "$result" = "1" ]; then
                    cd "$BASE_DIR/gencraft-v2.0"
                    break
                fi
                ;;
            4)
                browse_all_projects
                ;;
            5)
                show_worktree_menu
                ;;
            6)
                show_all_git_status
                ;;
            7)
                if [ -f "$BASE_DIR/claude-unified-startup.sh" ]; then
                    "$BASE_DIR/claude-unified-startup.sh"
                else
                    whiptail --title "Error" --msgbox "Start menu not found" 8 60
                fi
                ;;
            8|"")
                whiptail --title "Goodbye" --msgbox "Thanks for using Claude OS Project Navigator!" 8 60
                break
                ;;
        esac
    done
}

# Run
main

# Export current directory for the calling shell
echo "export NAVIGATOR_CHOICE_DIR='$(pwd)'"
