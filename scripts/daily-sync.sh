#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/admin/.openclaw/workspace"
cd "$REPO_DIR"

mkdir -p growth-log
TODAY="$(date +%F)"
LOG_FILE="growth-log/${TODAY}.md"

if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" <<EOF
# Growth Log - ${TODAY}

## Summary
- Daily auto-created log file.

## What Changed
- Pending update.
EOF
fi

if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  git add CHANGELOG.md growth-log scripts status-dashboard.html dashboard-server.py 2>/dev/null || true
  git add . 2>/dev/null || true
  if ! git diff --cached --quiet; then
    git commit -m "Daily sync: ${TODAY}" || true
    git push origin main || true
  fi
fi
