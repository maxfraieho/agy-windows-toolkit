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

$filteredArgs = @()
if ($Arguments) {
    $filteredArgs = @($Arguments | Where-Object { $_ -ne "--raw" -and -not [string]::IsNullOrWhiteSpace($_) })
}

# 1. INTERACTIVE TUI MODE: No prompt or arguments supplied
if ($filteredArgs.Count -eq 0) {
    & edgee launch crush -- --yolo
    exit $LASTEXITCODE
}

# 2. NON-INTERACTIVE / CLI MODE: Arguments provided
$knownSubcommands = @("run", "dirs", "models", "stats", "session", "projects", "logs", "update-providers", "help", "login", "logout", "completion", "server")
$firstArg = $filteredArgs[0]

if ($firstArg -notin $knownSubcommands -and $firstArg -notlike "-*") {
    $filteredArgs = @("run") + $filteredArgs
} elseif ($firstArg -like "-*" -and ($filteredArgs -contains "--model" -or $filteredArgs -contains "-m")) {
    $filteredArgs = @("run") + $filteredArgs
}

$isRun = $filteredArgs -contains "run"

if ($isRun) {
    for ($i = 0; $i -lt $filteredArgs.Count; $i++) {
        if ($filteredArgs[$i] -in @("-m", "--model") -and ($i + 1) -lt $filteredArgs.Count) {
            $modelVal = $filteredArgs[$i + 1]
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
} else {
    if (-not ($filteredArgs -contains "--yolo" -or $filteredArgs -contains "-y")) {
        $filteredArgs = @("--yolo") + $filteredArgs
    }
}

& edgee launch crush -- @filteredArgs
