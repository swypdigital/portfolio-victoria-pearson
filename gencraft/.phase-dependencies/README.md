# Phase Dependency Blocker System

## Purpose
**MANDATORY** dependency enforcement system that BLOCKS phase progression until all prerequisites are 100% complete.

## How It Works
1. Each phase has defined **BLOCKERS** - critical tasks that MUST complete before next phase
2. Before starting ANY work, run: `./validate-phase-dependencies.sh`
3. If blockers exist → Work ONLY on clearing blockers
4. If no blockers → Phase can proceed

## Files
- `PHASE_BLOCKER_SYSTEM.md` - Master blocker registry
- `/validate-phase-dependencies.sh` - Validation script

## Integration
This system is integrated into:
- GenCraft CLAUDE.md instructions
- Session startup protocol
- Quantum TODO system (all blockers tracked)

## Current Status
Run `./validate-phase-dependencies.sh` to see current blocker status

**This system prevents the recurring problem of starting phases before prerequisites are complete.**
