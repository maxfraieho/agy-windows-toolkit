@echo off
set "GEMINI_API_KEY="
set "GOOGLE_API_KEY="
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash-raw.ps1" %*
