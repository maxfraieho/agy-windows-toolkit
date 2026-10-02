[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)
$env:GEMINI_API_KEY = $null
$env:GOOGLE_API_KEY = $null

$filteredArgs = @($Arguments)

# If no model is specified, default to antigravity/claude-sonnet-4-6 for raw local mode
if (-not ($filteredArgs -contains "-m" -or $filteredArgs -contains "--model")) {
    $filteredArgs = @("-m", "antigravity/claude-sonnet-4-6") + $filteredArgs
} else {
    for ($i = 0; $i -lt $filteredArgs.Count; $i++) {
        if ($filteredArgs[$i] -in @("-m", "--model") -and ($i + 1) -lt $filteredArgs.Count) {
            $modelVal = $filteredArgs[$i + 1]
            if ($modelVal -match "^(google|anthropic|openai|edgee)/") {
                $modelVal = $modelVal -replace "^(google|anthropic|openai|edgee)/", ""
            }
            if ($modelVal -notlike "*/*") {
                $filteredArgs[$i + 1] = "antigravity/$modelVal"
            }
        }
    }
}

& "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" @filteredArgs
