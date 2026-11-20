@echo off
title Raju Gari Pindi Vantalu - local server
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1" -Port 8090
echo.
echo  The server stopped. If you saw an error above, take a screenshot and share it.
pause
