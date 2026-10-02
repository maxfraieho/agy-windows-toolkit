[CmdletBinding()]
param(
    [switch]$Raw,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

$env:EDGEE_API_KEY = "sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoib0UwcVhmYWR6eGp3MjFTZzdHY2dsdllYVHRDaFk4S1AifQ.7IAMKo5guMeJ8aO_TxUeDO6wvuNyvQokjwF-ngNG8qE"
$env:GEMINI_API_KEY = $null
$env:GOOGLE_API_KEY = $null
# Do NOT set EDGEE_API_URL — let Edgee CLI use its default cloud gateway (api.edgee.ai).
# The whole point of crash-edgee is to ALWAYS route through Edgee Cloud for compression & logging.
$env:EDGEE_API_URL = $null

$filteredArgs = @($Arguments | Where-Object { $_ -ne "--raw" })

if ($filteredArgs.Count -gt 0) {
    $firstArg = $filteredArgs[0]
    if ($firstArg -like "-*" -and ($filteredArgs -contains "--model" -or $filteredArgs -contains "-m")) {
        $filteredArgs = @("run") + $filteredArgs
    }
}

for ($i = 0; $i -lt $filteredArgs.Count; $i++) {
    if ($filteredArgs[$i] -in @("-m", "--model") -and ($i + 1) -lt $filteredArgs.Count) {
        $modelVal = $filteredArgs[$i + 1]
        if ($modelVal -notlike "*/*") {
            $filteredArgs[$i + 1] = "edgee/$modelVal"
        }
    }
}

& edgee launch crush -- @filteredArgs
