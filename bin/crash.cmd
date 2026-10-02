@echo off
set "EDGEE_API_KEY=sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoiQXNMdFREYklaZzZjZVVWUnd3MEU5OGhkWGxtQVZWUmoifQ.bZ0YIyc_IXNHDeYrRqTu7vWUdnyiAjjicNJqpu6zlUU"
set "GEMINI_API_KEY="
set "GOOGLE_API_KEY="
set "EDGEE_API_URL="

if "%1"=="--raw" (
    shift
    "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" %*
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash.ps1" %*
)
