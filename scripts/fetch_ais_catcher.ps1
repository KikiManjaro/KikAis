# fetch_ais_catcher.ps1 — Downloads the latest AIS-catcher release binary
# for Windows and places it in tools/ais-catcher/ alongside the RTL-SDR
# drivers needed for Blog V4 compatibility.
#
# Usage: .\scripts\fetch_ais_catcher.ps1
# Run from the project root (where pubspec.yaml lives).

$ErrorActionPreference = "Stop"

$targetDir = "tools\ais-catcher"
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Get the latest release tag from GitHub.
$apiUrl = "https://api.github.com/repos/jvde-github/AIS-catcher/releases/latest"
try {
    $release = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
} catch {
    Write-Error "Failed to fetch latest release info from GitHub: $_"
    exit 1
}

$tagName = $release.tag_name
Write-Host "Latest AIS-catcher release: $tagName"

# Find the Windows x64 asset.
$asset = $release.assets | Where-Object {
    $_.name -match "windows.*x64" -or $_.name -match "win.*x64"
} | Select-Object -First 1

if (-not $asset) {
    # Fallback: look for any zip asset.
    $asset = $release.assets | Where-Object {
        $_.name -match "\.zip$"
    } | Select-Object -First 1
}

if (-not $asset) {
    Write-Error "No Windows x64 asset found in release $tagName"
    Write-Host "Available assets:"
    $release.assets | ForEach-Object { Write-Host "  $($_.name)" }
    exit 1
}

Write-Host "Downloading $($asset.name)..."
$zipPath = "$env:TEMP\ais-catcher-$tagName.zip"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing

Write-Host "Extracting to $targetDir..."
Expand-Archive -Path $zipPath -DestinationPath $targetDir -Force
Remove-Item $zipPath -Force

# Verify ais-catcher.exe exists.
$exe = Get-ChildItem -Path $targetDir -Recurse -Filter "ais-catcher.exe" | Select-Object -First 1
if (-not $exe) {
    # Maybe the zip extracted to a subdirectory; move contents up.
    $subdir = Get-ChildItem -Path $targetDir -Directory | Select-Object -First 1
    if ($subdir) {
        Move-Item -Path "$($subdir.FullName)\*" -Destination $targetDir -Force
        Remove-Item -Path $subdir.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
    $exe = Get-ChildItem -Path $targetDir -Recurse -Filter "ais-catcher.exe" | Select-Object -First 1
}

if ($exe) {
    Write-Host "ais-catcher.exe found at: $($exe.FullName)"
} else {
    Write-Warning "ais-catcher.exe not found in $targetDir — check the release archive structure."
    Write-Host "Contents of $targetDir :"
    Get-ChildItem -Path $targetDir -Recurse | ForEach-Object { Write-Host "  $($_.FullName)" }
}

# Copy RTL-SDR drivers next to ais-catcher.exe for Blog V4 compatibility.
$rtlsdrDir = "resources\rtlsdr\windows"
foreach ($dll in @("rtlsdr.dll", "pthreadVC2.dll", "msvcr100.dll")) {
    $src = Join-Path $rtlsdrDir $dll
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $targetDir -Force
        Write-Host "Copied $dll to $targetDir"
    } else {
        Write-Warning "$dll not found at $src — run fetch_rtlsdr_drivers.ps1 first."
    }
}

Write-Host "Done. ais-catcher is ready at $targetDir"
