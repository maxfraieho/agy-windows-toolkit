@echo off
set "EDGEE_API_KEY=sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoiQXNMdFREYklaZzZjZVVWUnd3MEU5OGhkWGxtQVZWUmoifQ.bZ0YIyc_IXNHDeYrRqTu7vWUdnyiAjjicNJqpu6zlUU"
set "GEMINI_API_KEY="
set "GOOGLE_API_KEY="
set "EDGEE_API_URL="

if "%~1"=="" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash.ps1"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash.ps1" %*
)
