[CmdletBinding()]
param(
    [switch]$Raw,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

$env:EDGEE_API_KEY = "sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoiQXNMdFREYklaZzZjZVVWUnd3MEU5OGhkWGxtQVZWUmoifQ.bZ0YIyc_IXNHDeYrRqTu7vWUdnyiAjjicNJqpu6zlUU"
$env:GEMINI_API_KEY = $null
$env:GOOGLE_API_KEY = $null
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
        # Strip accidental upstream provider prefixes like google/, anthropic/, openai/
        if ($modelVal -match "^(google|anthropic|openai)/") {
            $modelVal = $modelVal -replace "^(google|anthropic|openai)/", ""
        }
        if ($modelVal -notlike "*/*") {
            $filteredArgs[$i + 1] = "edgee/$modelVal"
        } else {
            $filteredArgs[$i + 1] = $modelVal
        }
    }
}

& edgee launch crush -- @filteredArgs
