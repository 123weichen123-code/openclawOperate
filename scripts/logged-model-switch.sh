#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/admin/.openclaw/workspace"
cd "$REPO_DIR"

TARGET_MODEL="${1:-}"
REASON="${2:-}"

if [ -z "$TARGET_MODEL" ]; then
  echo "Usage: $0 <model> [reason]" >&2
  exit 1
fi

BEFORE="$(python3 - <<'PY'
from pathlib import Path
p = Path('/home/admin/.openclaw/workspace/MEMORY.md')
print('unknown')
PY
)"

# This script records the intended switch for operational logging.
MSG="Switched model -> ${TARGET_MODEL}"
if [ -n "$REASON" ]; then
  MSG+=" - ${REASON}"
fi
"$REPO_DIR/scripts/growth-log-event.sh" model "$MSG"

echo "$MSG"
