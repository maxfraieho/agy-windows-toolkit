@echo off
set "GEMINI_API_KEY="
set "GOOGLE_API_KEY="
if "%~1"=="" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash-raw.ps1"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash-raw.ps1" %*
)
