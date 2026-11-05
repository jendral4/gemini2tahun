@echo off
chcp 65001 >nul
title Konsol Otomatis Google AI Pro (5 TB) Gratis Dua Tahun - Instalasi dan Peluncuran
cd /d "%~dp0"
echo ======================================================================
echo   Memeriksa dan memasang paket Python (fastapi, uvicorn, playwright)...
echo ======================================================================
python -m pip install -r requirements.txt
echo.
echo ======================================================================
echo   Menjalankan konsol web (http://127.0.0.1:8765) ...
echo ======================================================================
start "" "http://127.0.0.1:8765"
python app.py
pause
