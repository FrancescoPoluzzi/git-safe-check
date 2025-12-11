param()

$realGitCmd = Get-Command git.exe -CommandType Application -ErrorAction SilentlyContinue |
    Where-Object { $_.Source -notlike "*\.git-safe-check*" } |
    Select-Object -First 1

if (-not $realGitCmd) {
    Write-Error "git.exe not found on PATH. Please install Git for Windows first."
    exit 1
}

$realGitPath = $realGitCmd.Source

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rulesPath = Join-Path $scriptDir "rules.ps1"

if (Test-Path $rulesPath) {
    . $rulesPath
}

function Find-GscMatchingRule {
    param (
        [string]$Command,
        [string[]]$Arguments
    )

    if (-not $GscRulesByCommand.ContainsKey($Command)) {
        return $null
    }

    $argJoined = ' ' + ($Arguments -join ' ') + ' '

    foreach ($ruleId in $GscRulesByCommand[$Command]) {
        $patterns = $GscRuleMatches[$ruleId]

        if (-not $patterns -or $patterns.Count -eq 0) {
            return $ruleId
        }

        foreach ($pattern in $patterns) {
            if ($argJoined -like "* $pattern *") {
                return $ruleId
            }
        }
    }

    return $null
}

if ($args.Count -eq 0) {
    & $realGitPath
    exit $LASTEXITCODE
}

$gitCommand = $args[0]
$commandArgs = @()
if ($args.Count -gt 1) {
    $commandArgs = $args[1..($args.Count - 1)]
}

$aliasExpansion = & $realGitPath config --get ("alias.$gitCommand") 2>$null
$checkCommand = $gitCommand

if ($aliasExpansion) {
    $parts = $aliasExpansion -split '\s+'
    if ($parts.Count -gt 0 -and $parts[0]) {
        $checkCommand = $parts[0]
    }
}

$ruleId = $null
if ($GscRulesByCommand -and $GscRulesByCommand.ContainsKey($checkCommand)) {
    $ruleId = Find-GscMatchingRule -Command $checkCommand -Arguments $commandArgs
}

if ($ruleId) {
    $warningMsg = $GscRuleMessage[$ruleId]

    if ($warningMsg) {
        Write-Host ""
        Write-Host "-------------------------------------------------------------" -ForegroundColor Yellow
        Write-Host "✋  GIT SAFETY CHECK" -ForegroundColor Yellow
        Write-Host "-------------------------------------------------------------" -ForegroundColor Yellow
        Write-Host ""
        Write-Host $warningMsg
        Write-Host ""
        $answer = Read-Host "Do you want to proceed? [y/N]"

        $answerLower = $answer.ToLowerInvariant()
        if ($answerLower -ne "y" -and $answerLower -ne "yes") {
            Write-Host ""
            Write-Host "Aborted." -ForegroundColor Red
            exit 1
        }

        Write-Host "Proceeding..." -ForegroundColor Green
        Write-Host ""
    }
}

& $realGitPath @args
exit $LASTEXITCODE
