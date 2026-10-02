@echo off
set "EDGEE_API_KEY=sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoib0UwcVhmYWR6eGp3MjFTZzdHY2dsdllYVHRDaFk4S1AifQ.7IAMKo5guMeJ8aO_TxUeDO6wvuNyvQokjwF-ngNG8qE"
set "GEMINI_API_KEY="
set "GOOGLE_API_KEY="
REM Do NOT set EDGEE_API_URL - let Edgee CLI use its default cloud gateway
set "EDGEE_API_URL="

powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\vokov\bin\crash-edgee.ps1" %*
