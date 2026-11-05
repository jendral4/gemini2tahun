#!/usr/bin/env bash
cd "$(dirname "$0")"
[ -f .venv/bin/activate ] && . .venv/bin/activate
(sleep 2; xdg-open http://127.0.0.1:8765 >/dev/null 2>&1 || true) &
exec python app.py
