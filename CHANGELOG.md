# Changelog

All notable changes in this workspace are tracked here.

## 2026-03-21

### Added
- Added `status-dashboard.html` as an OpenClaw status panel.
- Added `dashboard-server.py` to serve the status dashboard.
- Added a Feishu-based status panel document and skill candidate document.
- Added daily cron job `skill-candidates-daily` for skill discovery and recommendation.
- Added skill capability map and auto-install workflow documentation.

### Changed
- Updated multiple cron jobs to append outputs into dedicated Feishu docs.
- Increased timeout values for several cron jobs to reduce timeout failures.
- Updated the status panel to include model info, model switch history, cron result summary, and doc links.

### Installed Skills
- `openclaw-control-center`
- `proactive-self-improving-agent`
- `openclaw-backup`
- `openclaw-self-healing`
- `feishu-doc`
- `browser-automation`
- `devops-automation`
- `openclaw-audit-watchdog`

### Infra
- Configured Git identity for commits.
- Connected local workspace to GitHub repo `openclawOperate` and pushed `main`.
- Added a growth log template and daily logging rules.
- Added `scripts/growth-log-event.sh` for immediate event appends to daily growth logs.
- Added logged operation wrappers for skill installs, cron edits, and model switches.
