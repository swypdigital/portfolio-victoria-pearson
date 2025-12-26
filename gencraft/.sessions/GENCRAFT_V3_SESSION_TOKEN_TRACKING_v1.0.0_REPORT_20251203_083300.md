# SESSION TOKEN TRACKING

**CRITICAL REQUIREMENT**: Run session end protocol before token limit reached

**Token Budget**: 200,000 tokens
**Current Usage**: ~83,000 tokens (41.5%)
**Remaining**: ~117,000 tokens (58.5%)

**Session End Trigger**: 180,000 tokens (90% usage)

**Protocol Command**:
```bash
cd /mnt/c/Users/jdh/claude_projects
./CLAUDE_SESSION_END_PROTOCOL.sh
```

**MANDATORY**: Claude Code MUST track token usage throughout GenCraft v3.0 build and execute session end protocol at 90% token usage.
