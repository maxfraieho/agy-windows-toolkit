<#
.SYNOPSIS
    Automated turnkey setup for Antigravity CLI Multi-Account Profile Switching on Windows.
.DESCRIPTION
    Configures NTFS Directory Junctions, isolates user profiles under %USERPROFILE%\.antigravity-profiles,
    installs switching scripts to %USERPROFILE%\bin, and integrates helper aliases into PowerShell $PROFILE.
#>

$ErrorActionPreference = "Stop"

$userHome = $env:USERPROFILE
$baseConfig = "$userHome\.antigravity"
$profilesDir = "$userHome\.antigravity-profiles"
$sonDir = "$profilesDir\son"
$meDir = "$profilesDir\me"
$binDir = "$userHome\bin"

Write-Host "=== Antigravity Multi-Account Setup ===" -ForegroundColor Cyan

# 1. Create directory structure
New-Item -ItemType Directory -Force -Path $sonDir | Out-Null
New-Item -ItemType Directory -Force -Path $meDir | Out-Null
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

# 2. Preserve existing config into 'son' profile if not already junctioned
if (Test-Path $baseConfig) {
    $item = Get-Item $baseConfig
    if (-not ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        Write-Host "Preserving current session into $sonDir..." -ForegroundColor Yellow
        Copy-Item -Path "$baseConfig\*" -Destination $sonDir -Recurse -Force
        Remove-Item -Path $baseConfig -Recurse -Force
    }
}

# 3. Copy scripts from repository to %USERPROFILE%\bin
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item -Path "$scriptDir\scripts\agy-switch.ps1" -Destination "$binDir\agy-switch.ps1" -Force
Copy-Item -Path "$scriptDir\scripts\agy-me.cmd" -Destination "$binDir\agy-me.cmd" -Force
Copy-Item -Path "$scriptDir\scripts\agy-son.cmd" -Destination "$binDir\agy-son.cmd" -Force

# 4. Add binDir to User PATH permanently if missing
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($currentPath -notlike "*$binDir*") {
    Write-Host "Adding $binDir to User PATH..." -ForegroundColor Yellow
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$binDir", [EnvironmentVariableTarget]::User)
    $env:PATH += ";$binDir"
}

# 5. Integrate helper functions and aliases into PowerShell $PROFILE
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    $parentDir = Split-Path -Parent $profilePath
    if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Force -Path $parentDir | Out-Null }
    New-Item -ItemType File -Force -Path $profilePath | Out-Null
}

$profileAdditions = @"

# === Antigravity Multi-Account Switcher ===
if (`$env:PATH -notlike "*$binDir*") {
    `$env:PATH += ";$binDir"
}

function Switch-Agy {
    param([string]`$Target = "status")
    & "$binDir\agy-switch.ps1" `$Target
}

function Show-AgyMenu {
    `$choices = @(
        [System.Management.Automation.Host.ChoiceDescription]::new("&1 Me (Primary Profile)", "Switch to primary profile"),
        [System.Management.Automation.Host.ChoiceDescription]::new("&2 Son (Secondary Profile)", "Switch to secondary profile"),
        [System.Management.Automation.Host.ChoiceDescription]::new("&3 Status", "Show active profile")
    )
    `$decision = `$Host.UI.PromptForChoice("Antigravity Account Selector", "Select target profile:", `$choices, 0)
    switch (`$decision) {
        0 { Switch-Agy me }
        1 { Switch-Agy son }
        2 { Switch-Agy status }
    }
}

Set-Alias -Name agy-switch -Value Switch-Agy
Set-Alias -Name agy-sel -Value Show-AgyMenu
"@

$existingProfile = Get-Content -Path $profilePath -Raw -ErrorAction SilentlyContinue
if ($existingProfile -notlike "*Antigravity Multi-Account Switcher*") {
    Add-Content -Path $profilePath -Value $profileAdditions -Encoding UTF8
    Write-Host "Added aliases (agy-switch, agy-sel) to PowerShell profile." -ForegroundColor Green
}

# 6. Switch active junction to 'me'
& "$binDir\agy-switch.ps1" me

Write-Host "`n[SUCCESS] Setup completed successfully!" -ForegroundColor Green
Write-Host "Use 'agy-switch' or 'agy-sel' to switch profiles anytime." -ForegroundColor Cyan
