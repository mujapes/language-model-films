#!/usr/bin/env bash
# Publish these films to GitHub Pages.
# Usage:  ./deploy.sh <your-github-username> [repo-name]
set -euo pipefail

USER="${1:?usage: ./deploy.sh <github-username> [repo-name]}"
REPO="${2:-language-model-films}"

echo "==> creating repo $USER/$REPO"
# gh CLI path (easiest). Install: https://cli.github.com
if command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO" --public --source=. --remote=origin --push
  gh api -X POST "repos/$USER/$REPO/pages" \
    -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
else
  echo "    gh CLI not found — using plain git."
  echo "    Create an empty repo named '$REPO' at https://github.com/new first, then press enter."
  read -r _
  git remote add origin "https://github.com/$USER/$REPO.git" 2>/dev/null || \
    git remote set-url origin "https://github.com/$USER/$REPO.git"
  git push -u origin main
  echo "    Now enable Pages: Settings -> Pages -> Source: main / root"
fi

echo
echo "==> live shortly at: https://$USER.github.io/$REPO/"
echo "    (first build takes ~60s)"
