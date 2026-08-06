param(
    [int]$Seconds = 10,
    [switch]$Build
)

# Launches the debug build, lets it run for a few seconds, then scans the
# console output for Flutter rendering / widget exceptions.
# Exits with code 1 if any UI error is found.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$exe = Join-Path $root 'build\windows\x64\runner\Debug\kikais.exe'
$log = Join-Path $env:TEMP 'opencode\kikais_ui_check.log'
$out = Join-Path $env:TEMP 'opencode\kikais_ui_check.out.log'

if (-not (Test-Path $exe) -or $Build) {
    Write-Host 'Building debug Windows target...'
    Push-Location $root
    try {
        & flutter build windows --debug
        if ($LASTEXITCODE -ne 0) {
            Write-Error 'Build failed.'
        }
    } finally {
        Pop-Location
    }
}

Get-Process -Name 'kikais', 'KikAis' -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500

Write-Host "Running app for ${Seconds}s... ($exe)"
$proc = Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe) `
    -RedirectStandardError $log -RedirectStandardOutput $out -PassThru
Start-Sleep -Seconds $Seconds

if (-not $proc.HasExited) {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Write-Host 'App stopped after the check window.'
} else {
    Write-Host "App exited early with code $($proc.ExitCode)."
}

if (-not (Test-Path $log)) {
    Write-Host 'OK - no error output captured.'
    exit 0
}

$patterns = @(
    'EXCEPTION CAUGHT BY RENDERING LIBRARY',
    'EXCEPTION CAUGHT BY WIDGETS LIBRARY',
    'A RenderFlex overflowed',
    'RenderFlex overflowed',
    'Failed assertion',
    'No Material widget found',
    'A RenderObject was being processed when the exception was fired',
    'overflowed by'
)

$issues = Select-String -Path $log -Pattern $patterns -ErrorAction SilentlyContinue
if ($issues) {
    Write-Host ''
    Write-Host 'UI ERRORS FOUND:'
    $issues | ForEach-Object { Write-Host ("  " + $_.Line) }
    Write-Host ''
    exit 1
}

Write-Host ''
Write-Host 'OK - no UI errors detected in the console output.'
exit 0
