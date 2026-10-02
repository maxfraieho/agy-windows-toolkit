@echo off
set "EDGEE_API_KEY=sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoib0UwcVhmYWR6eGp3MjFTZzdHY2dsdllYVHRDaFk4S1AifQ.7IAMKo5guMeJ8aO_TxUeDO6wvuNyvQokjwF-ngNG8qE"
set "GEMINI_API_KEY="
set "GOOGLE_API_KEY="
set "EDGEE_API_URL="

if "%1"=="--raw" (
    shift
    "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" %*
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash.ps1" %*
)
