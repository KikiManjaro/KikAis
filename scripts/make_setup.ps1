<#
.SYNOPSIS
Builds a per-user Inno Setup installer for KikAis and generates the Sparkle
appcast.xml used for automatic updates.

.DESCRIPTION
Compiles installer/kikais.iss into a setup.exe and optionally writes an
appcast.xml whose enclosure points to the installer hosted on GitHub Releases.
This replaces the MSIX packaging (no code-signing certificate required).

.PARAMETER Version
The version to build, e.g. "2.0.0". Defaults to the version in pubspec.yaml.

.PARAMETER ReleaseDir
Path to the Flutter release output folder. When omitted the script runs
`flutter build windows --release` first.

.PARAMETER OutputDir
Directory where the installer is written (default: build/installer).

.PARAMETER IsccPath
Path to Inno Setup's ISCC.exe. Auto-detected from the standard locations.

.PARAMETER AppcastDir
If set, writes appcast.xml into this directory.

.PARAMETER DownloadBaseUrl
Base URL used in the appcast enclosure (the folder where the installer is
hosted). Must end with '/'.

.EXAMPLE
./scripts/make_setup.ps1 -Version 2.0.0 `
  -AppcastDir build/pages `
  -DownloadBaseUrl "https://github.com/KikiManjaro/KikAis/releases/download/v2.0.0/"
#>
param(
  [string]$Version,

  [string]$ReleaseDir,

  [string]$OutputDir = "build/installer",

  [string]$IsccPath,

  [string]$AppcastDir,

  [string]$DownloadBaseUrl
)

$ErrorActionPreference = "Stop"

if (-not $Version) {
  $pub = Get-Content -Raw -LiteralPath "pubspec.yaml"
  if ($pub -match '(?m)^version:\s*([0-9]+\.[0-9]+\.[0-9]+)') {
    $Version = $Matches[1]
  } else {
    throw "Could not read a version from pubspec.yaml. Pass -Version explicitly."
  }
}

if (-not $ReleaseDir) {
  Write-Host "Building Windows release..."
  flutter build windows --release
  if ($LASTEXITCODE -ne 0) {
    throw "flutter build windows failed"
  }
  $ReleaseDir = "build/windows/x64/runner/Release"
}

if (-not (Test-Path -LiteralPath $ReleaseDir)) {
  throw "Release directory not found: $ReleaseDir"
}

# --- 1. Locate Inno Setup ---
if (-not $IsccPath) {
  foreach ($candidate in @(
      "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
      "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
      "C:\Program Files\Inno Setup 6\ISCC.exe",
      "C:\Program Files (x86)\Inno Setup 7\ISCC.exe",
      "C:\Program Files\Inno Setup 7\ISCC.exe"
    )) {
    if (Test-Path -LiteralPath $candidate) {
      $IsccPath = $candidate
      break
    }
  }
}
if (-not $IsccPath -or -not (Test-Path -LiteralPath $IsccPath)) {
  throw "Inno Setup (ISCC.exe) not found. Install it with: choco install innosetup -y"
}

# --- 2. Compile the installer ---
Write-Host "Compiling installer (v$Version)..."
if ([System.IO.Path]::IsPathRooted($OutputDir)) {
  $outputDirFull = $OutputDir
} else {
  $outputDirFull = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $PSScriptRoot) $OutputDir))
}
& $IsccPath "installer\kikais.iss" "/DMyAppVersion=$Version" "/DMyOutputDir=$outputDirFull"
if ($LASTEXITCODE -ne 0) {
  throw "ISCC.exe failed"
}

$setup = Join-Path $OutputDir "kikais-setup-$Version.exe"
if (-not (Test-Path -LiteralPath $setup)) {
  throw "Expected installer not produced: $setup"
}

Write-Host "Installer: $setup"

# --- 3. Generate appcast.xml ---
if ($AppcastDir) {
  if (-not $DownloadBaseUrl) {
    throw "-DownloadBaseUrl is required when -AppcastDir is set"
  }
  New-Item -ItemType Directory -Path $AppcastDir -Force | Out-Null

  $size = (Get-Item -LiteralPath $setup).Length
  $pubDate = [System.DateTimeOffset]::UtcNow.ToString("r")
  $fileName = "kikais-setup-$Version.exe"
  $url = "$DownloadBaseUrl$fileName"

  $appcast = @"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
  <channel>
    <title>KikAis</title>
    <description>Most recent updates to KikAis</description>
    <language>en</language>
    <item>
      <title>Version $Version</title>
      <sparkle:version>$Version</sparkle:version>
      <sparkle:shortVersionString>$Version</sparkle:shortVersionString>
      <pubDate>$pubDate</pubDate>
      <enclosure url="$url" length="$size" type="application/octet-stream" />
    </item>
  </channel>
</rss>
"@

  $appcastPath = Join-Path $AppcastDir "appcast.xml"
  Set-Content -LiteralPath $appcastPath -Value $appcast -Encoding Utf8
  Write-Host "Appcast:   $appcastPath"

  # --- 4. Simple download page ---
  $releaseUrl = $DownloadBaseUrl.TrimEnd('/')
  $downloadPage = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>KikAis $Version</title>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 0;
           min-height: 100vh; display: flex; align-items: center; justify-content: center;
           background: #0f172a; color: #e2e8f0; }
    .card { max-width: 560px; padding: 40px; text-align: center; }
    h1 { margin: 0 0 8px; }
    p { color: #94a3b8; line-height: 1.5; }
    .btn { display: inline-block; margin-top: 20px; padding: 14px 28px; border-radius: 10px;
           background: #0ea5e9; color: #fff; text-decoration: none; font-weight: 600; }
    .btn:hover { background: #0284c7; }
    small { display: block; margin-top: 24px; color: #64748b; }
    a.link { color: #38bdf8; }
  </style>
</head>
<body>
  <div class="card">
    <h1>KikAis $Version</h1>
    <p>Installez KikAis puis l'application se met à jour toute seule.</p>
    <a class="btn" href="$releaseUrl/kikais-setup-$Version.exe">Télécharger l'installeur Windows</a>
    <p style="margin-top:12px"><a class="link" href="$releaseUrl">Autres fichiers de cette version</a></p>
    <small>Portable : <a class="link" href="$releaseUrl/kikais-windows-$Version-portable.exe">exe portable</a> ·
           Zip : <a class="link" href="$releaseUrl/kikais-windows-$Version.zip">archive zip</a></small>
  </div>
</body>
</html>
"@

  $downloadPagePath = Join-Path $AppcastDir "index.html"
  Set-Content -LiteralPath $downloadPagePath -Value $downloadPage -Encoding Utf8
  Write-Host "Download page: $downloadPagePath"
}

Write-Host "Done."
