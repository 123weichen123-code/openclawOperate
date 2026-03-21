#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/admin/.openclaw/workspace"
cd "$REPO_DIR"

SKILL_REF="${1:-}"
NOTE="${2:-}"

if [ -z "$SKILL_REF" ]; then
  echo "Usage: $0 <owner/repo@skill> [reason]" >&2
  exit 1
fi

npx skills add "$SKILL_REF" -g -y

MSG="Installed ${SKILL_REF}"
if [ -n "$NOTE" ]; then
  MSG+=" - ${NOTE}"
fi
"$REPO_DIR/scripts/growth-log-event.sh" skill "$MSG"

echo "$MSG"
