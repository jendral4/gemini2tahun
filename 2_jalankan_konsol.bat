@echo off
chcp 65001 >nul
title Konsol Otomatis Google AI Pro (5 TB) Gratis Dua Tahun
cd /d "%~dp0"
echo ======================================================================
echo   Menjalankan konsol otomatis Google AI Pro (5 TB) gratis dua tahun...
echo   Alamat konsol: http://127.0.0.1:8765
echo ======================================================================
start "" "http://127.0.0.1:8765"
python app.py
pause
