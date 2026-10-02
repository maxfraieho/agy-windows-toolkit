[CmdletBinding()]
param(
    [switch]$Raw,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

$env:EDGEE_API_KEY = "sk-edgee-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrIjoib0UwcVhmYWR6eGp3MjFTZzdHY2dsdllYVHRDaFk4S1AifQ.7IAMKo5guMeJ8aO_TxUeDO6wvuNyvQokjwF-ngNG8qE"
$env:GEMINI_API_KEY = $null
$env:GOOGLE_API_KEY = $null

try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $iar = $tcp.BeginConnect("127.0.0.1", 8080, $null, $null)
    if ($iar.AsyncWaitHandle.WaitOne(200, $false) -and $tcp.Connected) {
        $env:EDGEE_API_URL = "http://127.0.0.1:8080"
        $tcp.EndConnect($iar)
    } else {
        $env:EDGEE_API_URL = "https://antigravity-proxy.exodus.pp.ua"
    }
    $tcp.Close()
} catch {
    $env:EDGEE_API_URL = "https://antigravity-proxy.exodus.pp.ua"
}

$isRaw = $Raw -or ($Arguments -contains "--raw")
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
            if ($isRaw) {
                $filteredArgs[$i + 1] = "antigravity/$modelVal"
            } else {
                $filteredArgs[$i + 1] = "edgee/$modelVal"
            }
        }
    }
}

if ($isRaw) {
    & "C:\Users\vokov\AppData\Local\Programs\crush\crush.exe" @filteredArgs
} else {
    & edgee launch crush -- @filteredArgs
}
