param()

$repoUser  = "FrancescoPoluzzi"
$repoName  = "git-safe-check"
$branch    = "main"

$baseUrl   = "https://raw.githubusercontent.com/$repoUser/$repoName/$branch/windows"
$scriptUrl = "$baseUrl/git-safe-check.ps1"
$rulesUrl  = "$baseUrl/rules.ps1"

$installRoot = Join-Path $env:USERPROFILE ".git-safe-check"
$binDir      = Join-Path $installRoot "bin"

if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir -Force | Out-Null
}

$scriptDest = Join-Path $binDir "git-safe-check.ps1"
$rulesDest  = Join-Path $binDir "rules.ps1"

Write-Host "Downloading git safe check scripts for Windows..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptDest -UseBasicParsing
    Invoke-WebRequest -Uri $rulesUrl  -OutFile $rulesDest  -UseBasicParsing
} catch {
    Write-Error "Failed to download scripts from $baseUrl. $_"
    exit 1
}

Write-Host "Scripts downloaded to $binDir" -ForegroundColor Green

$profilePath = $PROFILE

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$markerStart = "# git safe check start"
$markerEnd   = "# git safe check end"

$profileContent = Get-Content $profilePath -ErrorAction SilentlyContinue

if ($profileContent -and ($profileContent -contains $markerStart)) {
    Write-Host "git safe check function already present in profile. No changes made." -ForegroundColor Yellow
} else {
    $escapedBinDir = $binDir -replace '\\', '\\'

    $functionBlock = @"
$markerStart
function git {
    & '$escapedBinDir\git-safe-check.ps1' @args
}
$markerEnd
"@

    Add-Content -Path $profilePath -Value ""
    Add-Content -Path $profilePath -Value $functionBlock

    Write-Host "Added git wrapper function to $profilePath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete." -ForegroundColor Green
Write-Host "Restart PowerShell or run:" -ForegroundColor Cyan
Write-Host "    . `"$profilePath`"" -ForegroundColor Cyan
Write-Host ""
Write-Host "After that, type 'git' as usual and the safety check will run automatically." -ForegroundColor Cyan
