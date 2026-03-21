# Growth Log Rules

Use `growth-log/YYYY-MM-DD.md` as the daily operating journal.

## Required Sections
Every daily log should include these sections in order:
- Summary
- What Changed
- Skill Installs
- Cron Changes
- Doc Archive Updates
- Model Switches
- Lessons
- Next Steps

## Event Recording Rules
Record these events whenever they happen:

### Skill Installs
Write down:
- exact skill name
- why it was installed
- any risk notes or security flags

### Cron Changes
Write down:
- cron/job name
- timeout/schedule/message changes
- why the change was made

### Doc Archive Updates
Write down:
- Feishu doc created or updated
- what data/report was archived
- whether it was a backfill or automatic append

### Model Switches
Write down:
- old model and new model
- timestamp or rough time
- reason for switching

## Quality Bar
- Keep entries concise but specific.
- Prefer facts over vague summaries.
- If a fix failed, record the failure and the next attempt.
- If no event occurred for a section, write `- None`.
