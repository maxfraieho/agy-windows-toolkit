[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)
$env:GEMINI_API_KEY = $null
$env:GOOGLE_API_KEY = $null
& "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" @Arguments
