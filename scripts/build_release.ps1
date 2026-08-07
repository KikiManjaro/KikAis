<#
.SYNOPSIS
Builds all KikAis Windows release artifacts (zip + portable + installer) in one
command.

.DESCRIPTION
Runs `flutter build windows --release` (unless -SkipBuild) and produces, in a
single folder ignored by git (build/release by default):
  - kikais-windows-<version>.zip
  - kikais-windows-<version>-portable.exe
  - kikais-setup-<version>.exe

The portable exe embeds the app icon. 7-Zip is optional (the portable build
falls back to the bundled 7zr.exe); Inno Setup is required for the installer.

.PARAMETER SkipBuild
Reuse an existing Flutter build instead of running flutter build windows
--release.

.PARAMETER Version
Version to use for the artifact names (default: the version in pubspec.yaml).

.PARAMETER OutputDir
Folder where the artifacts are written (default: build/release). Relative
paths are resolved against the repository root.

.PARAMETER ReleaseDir
Flutter Windows release output folder (default:
build/windows/x64/runner/Release).

.EXAMPLE
./scripts/build_release.ps1

.EXAMPLE
./scripts/build_release.ps1 -SkipBuild
#>
param(
  [switch]$SkipBuild,

  [string]$Version,

  [string]$OutputDir = "build/release",

  [string]$ReleaseDir = "build/windows/x64/runner/Release"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

# --- 1. Resolve the version ---
if (-not $Version) {
  $pub = Get-Content -Raw -LiteralPath "pubspec.yaml"
  if ($pub -match '(?m)^version:\s*([0-9]+\.[0-9]+\.[0-9]+)') {
    $Version = $Matches[1]
  } else {
    throw "Could not read a version from pubspec.yaml. Pass -Version explicitly."
  }
}

# --- 2. Build the Windows release ---
if (-not $SkipBuild) {
  if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw "flutter not found on PATH. Install Flutter first."
  }
  Write-Host "Building Windows release..."
  flutter build windows --release
  if ($LASTEXITCODE -ne 0) {
    throw "flutter build windows failed"
  }
}

$ReleaseDirFull = if ([System.IO.Path]::IsPathRooted($ReleaseDir)) {
  $ReleaseDir
} else {
  [System.IO.Path]::GetFullPath((Join-Path $repoRoot $ReleaseDir))
}
if (-not (Test-Path -LiteralPath (Join-Path $ReleaseDirFull "KikAis.exe"))) {
  throw "Release build not found in $ReleaseDirFull. Run without -SkipBuild first."
}

# --- 3. Output folder ---
$OutputDirFull = if ([System.IO.Path]::IsPathRooted($OutputDir)) {
  $OutputDir
} else {
  [System.IO.Path]::GetFullPath((Join-Path $repoRoot $OutputDir))
}
New-Item -ItemType Directory -Path $OutputDirFull -Force | Out-Null

# --- 4. Zip archive ---
$zip = Join-Path $OutputDirFull "kikais-windows-$Version.zip"
Write-Host "Packaging zip: ${zip}"
Compress-Archive -Path (Join-Path $ReleaseDirFull "*") -DestinationPath $zip -Force

# --- 5. Portable executable ---
Write-Host "Building portable executable..."
& "$PSScriptRoot\make_portable.ps1" `
  -ReleaseDir $ReleaseDirFull `
  -OutputExe (Join-Path $OutputDirFull "kikais-windows-$Version-portable.exe")

# --- 6. Installer ---
Write-Host "Building installer..."
& "$PSScriptRoot\make_setup.ps1" `
  -Version $Version `
  -ReleaseDir $ReleaseDirFull `
  -OutputDir $OutputDirFull

# --- 7. Summary ---
Write-Host ""
Write-Host "Release artifacts in ${OutputDirFull}:"
Get-ChildItem -LiteralPath $OutputDirFull -File | Sort-Object Name | ForEach-Object {
  Write-Host ("  {0,-42} {1,10:N0} bytes" -f $_.Name, $_.Length)
}
