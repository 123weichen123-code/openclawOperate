#!/usr/bin/env python3
import json
import os
import re
import subprocess
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path('/home/admin/.openclaw/workspace')
DASHBOARD = ROOT / 'status-dashboard.html'
HOST = '0.0.0.0'
PORT = 8888


def run_cmd(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True, cwd=str(ROOT))
    return result.stdout.strip(), result.stderr.strip(), result.returncode


def get_model_status():
    stdout, stderr, code = run_cmd('openclaw status')
    text = stdout or stderr
    model = 'unknown'
    context = 'unknown'
    session = 'unknown'

    for line in text.splitlines():
        if 'Model:' in line:
            m = re.search(r'Model:\s+([^·\n]+)', line)
            if m:
                model = m.group(1).strip()
        if 'Context:' in line:
            m = re.search(r'Context:\s+([^·\n]+)', line)
            if m:
                context = m.group(1).strip()
        if 'Session:' in line:
            m = re.search(r'Session:\s+([^•\n]+)', line)
            if m:
                session = m.group(1).strip()

    return {
        'model': model,
        'context': context,
        'session': session,
        'checkedAt': datetime.now().isoformat(timespec='seconds'),
        'ok': code == 0,
    }


def get_crons():
    stdout, _, _ = run_cmd('openclaw cron list --json')
    try:
        data = json.loads(stdout)
        jobs = data.get('jobs', [])
        return [
            {
                'name': job.get('name', '-'),
                'status': job.get('state', {}).get('lastStatus', 'unknown'),
                'nextRunAtMs': job.get('state', {}).get('nextRunAtMs'),
            }
            for job in jobs
        ]
    except Exception:
        return []


def get_recent_growth_events(limit=8):
    today = datetime.now().strftime('%Y-%m-%d')
    path = ROOT / 'growth-log' / f'{today}.md'
    if not path.exists():
        return []

    events = []
    current_section = None
    interesting = {
        '## Skill Installs': 'skill',
        '## Cron Changes': 'cron',
        '## Doc Archive Updates': 'doc',
        '## Model Switches': 'model',
    }

    for raw_line in path.read_text(encoding='utf-8').splitlines():
        line = raw_line.strip()
        if line in interesting:
            current_section = line
            continue
        if line.startswith('## '):
            current_section = None
            continue
        if current_section and line.startswith('- ') and line != '- None':
            events.append({
                'type': interesting[current_section],
                'text': line[2:].strip(),
            })

    return events[-limit:][::-1]


class Handler(BaseHTTPRequestHandler):
    def _send_json(self, payload, status=200):
        body = json.dumps(payload, ensure_ascii=False).encode('utf-8')
        self.send_response(status)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()
        self.wfile.write(body)

    def _send_html(self, content, status=200):
        body = content.encode('utf-8')
        self.send_response(status)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urlparse(self.path).path
        if path in ('/', '/status-dashboard.html'):
            self._send_html(DASHBOARD.read_text(encoding='utf-8'))
            return
        if path == '/api/status':
            self._send_json({
                'modelStatus': get_model_status(),
                'crons': get_crons(),
                'recentEvents': get_recent_growth_events(),
            })
            return
        self._send_json({'error': 'not found'}, status=404)

    def log_message(self, format, *args):
        return


if __name__ == '__main__':
    server = HTTPServer((HOST, PORT), Handler)
    print(f'dashboard server on http://{HOST}:{PORT}')
    server.serve_forever()
