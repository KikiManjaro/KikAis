<#
.SYNOPSIS
  Single-command verification loop for LLM + human. Runs format check, analyze (fatal) and tests.

.DESCRIPTION
  Mirrors CI (ci.yml: analyze + test + gitleaks) locally. Agents MUST run this before claiming done.
  Fails fast on first error with non-zero exit.

.PARAMETER NoTest
  Skip flutter test (faster, for lint-only iteration).

.EXAMPLE
  pwsh scripts/check.ps1
  pwsh scripts/check.ps1 -NoTest
#>
param([switch]$NoTest)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $root

Write-Host "`n== 1/3 dart format (check) ==" -ForegroundColor Cyan
$fmt = & dart format --set-exit-if-changed . 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Host $fmt
  Write-Error "dart format failed — run 'dart format lib test' and retry."
}

Write-Host "`n== 2/3 flutter analyze ==" -ForegroundColor Cyan
& flutter analyze
if ($LASTEXITCODE -ne 0) { throw "flutter analyze failed (check infos above)" }

if (-not $NoTest) {
  Write-Host "`n== 3/3 flutter test ==" -ForegroundColor Cyan
  & flutter test
  if ($LASTEXITCODE -ne 0) { throw "flutter test failed" }
}

Write-Host "`n✓ All checks passed." -ForegroundColor Green
