#!/bin/bash
# Push gencraft-v3.0 to GitHub (run after repo is created)

cd $WINDOWS_HOME/claude_projects/gencraft-v3.0

# Add GitHub remote
git remote add origin https://github.com/swypdigital/gencraft-v3.0.git 2>/dev/null || echo "Remote already exists"

# Push all commits
echo "Pushing all commits to GitHub..."
git push -u origin master

# Verify
echo ""
echo "✅ Verification:"
git remote -v
echo ""
echo "Latest commit on GitHub:"
git log --oneline -1

echo ""
echo "🎉 GenCraft v3.0 successfully pushed to GitHub!"
echo "View at: https://github.com/swypdigital/gencraft-v3.0"
