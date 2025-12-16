# Project Navigator PowerShell Aliases
# Add this to your PowerShell profile: $PROFILE
# Or run: . C:\Users\jdh\claude_projects\project-navigator-aliases.ps1

# === PROJECT NAVIGATOR FUNCTIONS ===

# Main project navigator TUI
function pn {
    & 'C:\Users\jdh\claude_projects\project-navigator.sh'
}

function proj {
    pn
}

# Quick project navigation
function goto-cp {
    Set-Location 'C:\Users\jdh\claude_projects'
}

function goto-iv {
    Set-Location 'C:\Users\jdh\claude_projects\projects\github-repos\interviewplus-production'
}

function goto-gc {
    Set-Location 'C:\Users\jdh\claude_projects\gencraft-v3.0'
}

function goto-tc {
    Set-Location 'C:\Users\jdh\claude_projects\token-cost-calculator'
}

# Project info shortcuts
function proj-list {
    Get-ChildItem -Path 'C:\Users\jdh\claude_projects' -Recurse -Force -Directory -Filter '.git' |
    ForEach-Object { $_.Parent.FullName -replace 'C:\\Users\\jdh\\claude_projects\\', '' } |
    Sort-Object
}

function proj-status {
    Get-ChildItem -Path 'C:\Users\jdh\claude_projects\projects\github-repos\*' -Directory | ForEach-Object {
        Write-Host "=== $($_.Name) ===" -ForegroundColor Cyan
        Push-Location $_.FullName
        git status -sb
        Pop-Location
    }
}

# Worktree shortcuts
function wt {
    & 'C:\Users\jdh\claude_projects\worktree-commands.sh' @args
}

function wt-list {
    git worktree list
}

Write-Host "✅ Project Navigator aliases loaded!" -ForegroundColor Green
Write-Host "   Usage: pn, proj, goto-iv, goto-gc, goto-tc, goto-cp" -ForegroundColor Yellow
