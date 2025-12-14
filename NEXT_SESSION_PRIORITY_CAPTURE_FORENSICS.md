# NEXT SESSION PRIORITY: FORENSIC ANALYSIS OF SESSION CAPTURE
**Created**: 2025-12-11 14:53:00 PST
**Priority**: CRITICAL - MUST DO BEFORE WORKFORCE DEPLOYMENT
**Quantum TODO**: QT-CAPTURE-FORENSIC-ANALYSIS-001

---

## USER MANDATE

**The session capture WITH FIDELITY worked perfectly in June/July 2025.**

**Claude Code broke it with an update around August/September 2025.**

**We need to find the working version and understand what changed.**

---

## FORENSIC INVESTIGATION PLAN

### Step 1: Find Working Session Files from June/July 2025
Search for session capture files that have >1000 lines:

```bash
# Search universal history
find /mnt/c/Users/jdh/claude_projects/.universal-history/sessions -name "*2025-06*" -o -name "*2025-07*" | \
    while read file; do
        lines=$(wc -l < "$file" 2>/dev/null || echo 0)
        if [[ $lines -gt 1000 ]]; then
            echo "$lines lines: $file"
        fi
    done

# Search manual backups
find "/mnt/c/~ALL FILES/~ BIZ PROJECTS CURRENT/!     AI PROJECTS MSC/ELEARNING/-   GROKLY.ME/-        GROKLY  GROUP/-         MAVERICK STACK/CHAT BACKUPS FULL SCREEN CAPTURES" -name "*2025*06*" -o -name "*2025*07*"
```

### Step 2: Find Session Capture Scripts from June/July 2025
Look for backups or git history:

```bash
# Search for backed up versions
find /mnt/c/Users/jdh/claude_projects -name "*capture*.bak" -o -name "*capture*.backup" | \
    xargs ls -lt | grep -E "Jun|Jul"

# Search .archive
find /mnt/c/Users/jdh/claude_projects/.archive -name "*capture*" -name "*2025-06*" -o -name "*2025-07*"

# Check git history
cd /mnt/c/Users/jdh/claude_projects
git log --all --oneline --since="2025-06-01" --until="2025-08-01" --grep="capture"
git log --all --oneline --since="2025-06-01" --until="2025-08-01" -- "*capture*"
```

### Step 3: Find Session Plans/Logs from June/July
```bash
# Search plans directory
find /mnt/c/Users/jdh/claude_projects/plans -name "*2025-06*" -o -name "*2025-07*"

# Search session handoff files
find /mnt/c/Users/jdh/claude_projects/.session-management -name "*202506*" -o -name "*202507*"

# Search session end reports
find /mnt/c/Users/jdh/claude_projects -name "*SESSION*2025-06*" -o -name "*SESSION*2025-07*"
```

### Step 4: Compare Working vs Broken Versions
Once we find the working script:

1. **Read the working version** from June/July
2. **Compare to current broken version** (absolute-fidelity-capture.sh)
3. **Identify the differences**:
   - What changed in TMUX capture commands?
   - What changed in pane detection?
   - What changed in session handling?
   - What changed in Claude Code that broke it?

### Step 5: Restore Working Functionality
- Copy working logic from June/July version
- Adapt to current environment
- Test with current Claude Code session
- Verify >1000 line capture

---

## KNOWN FACTS

### What Worked (June/July 2025):
- ✅ Session capture with >1000 lines
- ✅ Full conversation history captured
- ✅ Automatic capture (no manual backup needed)
- ✅ Reliable and consistent

### What Broke (Aug/Sep 2025):
- ❌ Only captures 24 lines
- ❌ Captures wrong TMUX pane (command subshell vs conversation)
- ❌ Claude Code update changed something
- ❌ Requires manual backup workaround

### What We've Tried (Didn't Work):
1. ❌ Capture from current pane (gets subshell, not conversation)
2. ❌ Explicit history limit (still wrong pane)
3. ❌ Persistent daemon (not running)
4. ❌ Manual backup aggregation (only works if user saves)
5. ✅ NEW: All-pane scanning (implemented but NOT tested)

---

## TIMELINE OF CAPTURE DEGRADATION

**June/July 2025**: ✅ Working perfectly
**August 2025**: 🔄 Claude Code update
**September 2025**: ❌ Capture broken (only 24 lines)
**October-December 2025**: ❌ Still broken, manual backups required

---

## SUCCESS CRITERIA FOR FORENSIC ANALYSIS

1. ✅ Find session capture script from June/July 2025 that worked
2. ✅ Find session files from June/July showing >1000 line captures
3. ✅ Identify exact differences between working and broken versions
4. ✅ Understand what Claude Code changed that broke it
5. ✅ Restore working functionality
6. ✅ Test and verify >1000 line capture in current environment

---

## AFTER FORENSICS COMPLETE

**ONLY AFTER CAPTURE IS 100% WORKING:**
1. Deploy 50 source tracer workers (Phase 3.6 Team 1)
2. Complete Phase 3.6 (150 workers)
3. Execute Phase 3.7 (505 workers)

---

## CRITICAL REMINDER

**DO NOT PROCEED WITH WORKFORCE DEPLOYMENT UNTIL CAPTURE IS FIXED**

The user is tired of manual backups. This MUST be fixed before we continue.

---

*This investigation is the HIGHEST PRIORITY for the next session.*
*All other work is BLOCKED until this is resolved.*
