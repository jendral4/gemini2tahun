#!/usr/bin/env bash
# Ubuntu/Linux: install dependencies (venv) and start the console
set -e
cd "$(dirname "$0")"
if [ ! -f .venv/bin/activate ]; then
  # Buat (ulang) venv; --clear menimpa folder .venv yang rusak/setengah jadi
  python3 -m venv --clear .venv || { echo "Jalankan: sudo apt install python3-venv python3-pip"; exit 1; }
fi
. .venv/bin/activate
pip install -r requirements.txt
if ! command -v google-chrome >/dev/null && ! command -v chromium >/dev/null && ! command -v chromium-browser >/dev/null; then
  echo "[!] Google Chrome tidak ditemukan. Install:"
  echo "    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt install ./google-chrome-stable_current_amd64.deb"
fi
(sleep 2; xdg-open http://127.0.0.1:8765 >/dev/null 2>&1 || true) &
exec python app.py
