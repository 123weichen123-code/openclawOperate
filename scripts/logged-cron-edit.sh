#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/admin/.openclaw/workspace"
cd "$REPO_DIR"

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <job-id> <openclaw cron edit args...>" >&2
  exit 1
fi

JOB_ID="$1"
shift

openclaw cron edit "$JOB_ID" "$@"

ARGS="$*"
"$REPO_DIR/scripts/growth-log-event.sh" cron "Edited cron ${JOB_ID} with args: ${ARGS}"

echo "Edited cron ${JOB_ID}"
