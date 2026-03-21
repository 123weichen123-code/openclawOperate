#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/admin/.openclaw/workspace"
cd "$REPO_DIR"

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <openclaw cron add args...>" >&2
  exit 1
fi

OUTPUT="$(openclaw cron add "$@")"
echo "$OUTPUT"

NAME="$(printf '%s
' "$OUTPUT" | python3 - <<'PY'
import json,sys
text=sys.stdin.read().strip()
try:
    data=json.loads(text)
    print(data.get('name','unknown'))
except Exception:
    print('unknown')
PY
)"

ARGS="$*"
"$REPO_DIR/scripts/growth-log-event.sh" cron "Added cron ${NAME} with args: ${ARGS}"

echo "Logged cron add for ${NAME}"
