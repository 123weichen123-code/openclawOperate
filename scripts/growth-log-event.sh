#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/admin/.openclaw/workspace"
cd "$REPO_DIR"

EVENT_TYPE="${1:-}"
EVENT_TEXT="${2:-}"
DATE_STR="${3:-$(date +%F)}"
LOG_FILE="growth-log/${DATE_STR}.md"

if [ -z "$EVENT_TYPE" ] || [ -z "$EVENT_TEXT" ]; then
  echo "Usage: $0 <skill|cron|doc|model> <text> [YYYY-MM-DD]" >&2
  exit 1
fi

mkdir -p growth-log

if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" <<EOF
# Growth Log - ${DATE_STR}

## Summary
- Daily auto-created log file.

## What Changed
- Pending update.

## Skill Installs
- None

## Cron Changes
- None

## Doc Archive Updates
- None

## Model Switches
- None

## Lessons
- None

## Next Steps
- Pending update.
EOF
fi

case "$EVENT_TYPE" in
  skill)
    SECTION="## Skill Installs"
    ;;
  cron)
    SECTION="## Cron Changes"
    ;;
  doc)
    SECTION="## Doc Archive Updates"
    ;;
  model)
    SECTION="## Model Switches"
    ;;
  *)
    echo "Unknown event type: $EVENT_TYPE" >&2
    exit 1
    ;;
esac

python3 - "$LOG_FILE" "$SECTION" "$EVENT_TEXT" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
section = sys.argv[2]
entry = sys.argv[3]
text = path.read_text(encoding='utf-8')
lines = text.splitlines()

try:
    idx = lines.index(section)
except ValueError:
    raise SystemExit(f"section not found: {section}")

insert_at = idx + 1
while insert_at < len(lines) and not (lines[insert_at].startswith('## ') and lines[insert_at] != section):
    insert_at += 1

section_body = lines[idx + 1:insert_at]
if any(line.strip() == '- None' for line in section_body):
    section_body = [line for line in section_body if line.strip() != '- None']
    lines = lines[:idx + 1] + section_body + lines[insert_at:]
    insert_at = idx + 1 + len(section_body)

lines.insert(insert_at, f"- {entry}")
path.write_text("\n".join(lines).rstrip() + "\n", encoding='utf-8')
PY

echo "Logged $EVENT_TYPE event to $LOG_FILE"
