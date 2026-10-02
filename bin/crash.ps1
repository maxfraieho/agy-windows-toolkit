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

$isRaw = $Raw -or ($Arguments -contains "--raw")
$filteredArgs = @($Arguments | Where-Object { $_ -ne "--raw" })

$knownSubcommands = @("run", "dirs", "models", "stats", "session", "projects", "logs", "update-providers", "help", "login", "logout", "completion", "server")

if ($filteredArgs.Count -gt 0) {
    $firstArg = $filteredArgs[0]
    if ($firstArg -notin $knownSubcommands -and $firstArg -notlike "-*") {
        $filteredArgs = @("run") + $filteredArgs
    } elseif ($firstArg -like "-*" -and ($filteredArgs -contains "--model" -or $filteredArgs -contains "-m")) {
        $filteredArgs = @("run") + $filteredArgs
    }
}

$isRun = $filteredArgs -contains "run"

if ($isRun) {
    if ($isRaw -and (-not ($filteredArgs -contains "-m" -or $filteredArgs -contains "--model"))) {
        # Default raw non-interactive mode to local antigravity gemini-3.8-flash-tiered
        $runIndex = [array]::IndexOf($filteredArgs, "run")
        $filteredArgs = @($filteredArgs[0..$runIndex]) + @("-m", "antigravity/gemini-3.8-flash-tiered") + @($filteredArgs[($runIndex + 1)..($filteredArgs.Count - 1)])
    } else {
        for ($i = 0; $i -lt $filteredArgs.Count; $i++) {
            if ($filteredArgs[$i] -in @("-m", "--model") -and ($i + 1) -lt $filteredArgs.Count) {
                $modelVal = $filteredArgs[$i + 1]
                # Strip accidental upstream provider prefixes
                if ($modelVal -match "^(google|anthropic|openai)/") {
                    $modelVal = $modelVal -replace "^(google|anthropic|openai)/", ""
                }
                if ($modelVal -notlike "*/*") {
                    if ($isRaw) {
                        $filteredArgs[$i + 1] = "antigravity/$modelVal"
                    } else {
                        $filteredArgs[$i + 1] = "edgee/$modelVal"
                    }
                } else {
                    $filteredArgs[$i + 1] = $modelVal
                }
            }
        }
    }
} else {
    # Interactive Crush TUI: Ensure --yolo is active for autonomous execution
    if (-not ($filteredArgs -contains "--yolo" -or $filteredArgs -contains "-y")) {
        $filteredArgs = @("--yolo") + $filteredArgs
    }
}

if ($isRaw) {
    & "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" @filteredArgs
} else {
    & edgee launch crush -- @filteredArgs
    if ($LASTEXITCODE -ne 0 -and $isRun) {
        Write-Warning "Edgee gateway call failed (exit code $LASTEXITCODE). Falling back to local Antigravity proxy..."
        $fallbackArgs = @($filteredArgs)
        # Replace edgee/ model with antigravity/ model if present
        for ($i = 0; $i -lt $fallbackArgs.Count; $i++) {
            if ($fallbackArgs[$i] -in @("-m", "--model") -and ($i + 1) -lt $fallbackArgs.Count) {
                $fallbackArgs[$i + 1] = $fallbackArgs[$i + 1] -replace "^edgee/", "antigravity/"
            }
        }
        # If no explicit model was passed, inject antigravity/gemini-3.8-flash-tiered
        if (-not ($fallbackArgs -contains "-m" -or $fallbackArgs -contains "--model")) {
            $runIdx = [array]::IndexOf($fallbackArgs, "run")
            $fallbackArgs = @($fallbackArgs[0..$runIdx]) + @("-m", "antigravity/gemini-3.8-flash-tiered") + @($fallbackArgs[($runIdx + 1)..($fallbackArgs.Count - 1)])
        }
        & "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" @fallbackArgs
    }
}
