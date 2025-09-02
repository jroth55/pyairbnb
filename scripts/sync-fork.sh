#!/usr/bin/env bash
set -euo pipefail
branch="${1:-main}"
# Fetch upstream and origin
git fetch upstream origin
# Ensure we are on target branch
current=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current" != "$branch" ]]; then
  git checkout "$branch"
fi
# Update local branch from upstream
if git rev-parse --verify "refs/remotes/upstream/$branch" >/dev/null 2>&1; then
  git merge --ff-only "upstream/$branch" || {
    echo "Fast-forward failed. Consider 'git rebase upstream/$branch' manually." >&2
    exit 1
  }
else
  echo "Upstream branch upstream/$branch not found" >&2
fi
# Push to origin
git push origin "$branch"
echo "Synced '$branch' with upstream and pushed to origin."
