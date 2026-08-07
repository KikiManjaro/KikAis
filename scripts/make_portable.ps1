<#
.SYNOPSIS
Builds a single-file portable Windows executable for KikAis using a
7-Zip self-extracting archive (no external GUI tools required).

.DESCRIPTION
Takes a Flutter Windows release folder (build/windows/x64/runner/Release)
and produces one .exe that self-extracts the whole bundle into a temporary
directory at launch and runs KikAis.exe. This replaces the manual
Enigma Virtual Box step.

The 7zS.sfx self-extracting stub ships only in the official 7-Zip 9.20
"extra" package (it was dropped from newer packages). Archiving uses the
system-installed 7-Zip, or falls back to the standalone 7zr.exe bundled in
the same 9.20 package.

.PARAMETER ReleaseDir
Path to the Flutter release output folder (contains KikAis.exe, DLLs, data/).

.PARAMETER OutputExe
Path of the portable executable to produce.

.PARAMETER AppName
Name of the launcher executable inside the bundle (default: KikAis.exe).

.PARAMETER Icon
Path to the .ico file to embed as the portable executable's icon. Defaults
to the app icon used by the Flutter runner and the installer
(windows/runner/resources/app_icon.ico).

.PARAMETER SevenZipSfxUrl
URL of the 7-Zip 9.20 "extra" package (provides 7zS.sfx and 7zr.exe).

.PARAMETER RceditUrl
URL of rcedit-x64.exe, used to replace the SFX stub's icon resource.

.EXAMPLE
./scripts/make_portable.ps1 `
  -ReleaseDir build/windows/x64/runner/Release `
  -OutputExe KikAis-portable.exe
#>
param(
  [Parameter(Mandatory = $true)]
  [string]$ReleaseDir,

  [Parameter(Mandatory = $true)]
  [string]$OutputExe,

  [string]$AppName = "KikAis.exe",

  [string]$Icon = (Join-Path (Split-Path -Parent $PSScriptRoot) "windows\runner\resources\app_icon.ico"),

  [string]$SevenZipSfxUrl = "https://www.7-zip.org/a/7z920_extra.7z",

  [string]$RceditUrl = "https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ReleaseDir)) {
  throw "Release directory not found: $ReleaseDir"
}
if (-not (Test-Path -LiteralPath (Join-Path $ReleaseDir $AppName))) {
  throw "Executable '$AppName' not found in $ReleaseDir"
}

$work = Join-Path $env:TEMP ("kikais_portable_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $work | Out-Null

try {
  # --- 1. Find a 7-Zip binary able to create archives ---
  $sevenZip = $null
  foreach ($candidate in @(
      "C:\Program Files\7-Zip\7z.exe",
      "C:\Program Files (x86)\7-Zip\7z.exe"
    )) {
    if (Test-Path -LiteralPath $candidate) {
      $sevenZip = $candidate
      break
    }
  }

  # --- 2. Fetch the 9.20 extra package (7zS.sfx stub + 7zr.exe) ---
  Write-Host "Downloading 7zS.sfx stub..."
  $sfxDir = Join-Path $work "sfx"
  New-Item -ItemType Directory -Path $sfxDir | Out-Null
  $sfxArchive = Join-Path $work "sfx-extra.7z"
  Invoke-WebRequest -Uri $SevenZipSfxUrl -OutFile $sfxArchive -UseBasicParsing

  if ($sevenZip) {
    Write-Host "Extracting with system 7-Zip..."
    & $sevenZip x $sfxArchive "-o$sfxDir" -y | Out-Null
    if ($LASTEXITCODE -ne 0) {
      throw "Failed to extract the SFX stub package"
    }
  } else {
    # Fallback: use Windows' built-in bsdtar to read the .7z package.
    Write-Host "7-Zip not found, extracting with tar (bsdtar)..."
    tar -xf $sfxArchive -C $sfxDir
    if ($LASTEXITCODE -ne 0) {
      throw "Failed to extract the SFX stub package (no 7-Zip available)"
    }
  }

  $sfxStub = Get-ChildItem -Path $sfxDir -Filter "7zS.sfx" -Recurse -ErrorAction SilentlyContinue |
    Select-Object -First 1
  if (-not $sfxStub) {
    throw "7zS.sfx not found in the 7-Zip SFX package"
  }

  # Archiver: system 7-Zip if present, otherwise 7zr.exe from the package.
  $archiver = $sevenZip
  if (-not $archiver) {
    $sevenZr = Get-ChildItem -Path $sfxDir -Filter "7zr.exe" -Recurse -ErrorAction SilentlyContinue |
      Select-Object -First 1
    if (-not $sevenZr) {
      throw "7zr.exe not found and no system 7-Zip available"
    }
    $archiver = $sevenZr.FullName
  }

  # --- 3. Replace the stub's icon with the application icon ---
  if ($Icon -and (Test-Path -LiteralPath $Icon)) {
    Write-Host "Applying app icon to SFX stub..."
    $rcedit = Join-Path $work "rcedit-x64.exe"
    Invoke-WebRequest -Uri $RceditUrl -OutFile $rcedit -UseBasicParsing
    & $rcedit $sfxStub.FullName "--set-icon" $Icon
    if ($LASTEXITCODE -ne 0) {
      throw "rcedit failed to set the icon"
    }
  } else {
    Write-Warning "Icon not found, skipping icon embedding: $Icon"
  }

  # --- 4. Compress the release bundle (contents at archive root) ---
  Write-Host "Compressing release bundle..."
  $archive = Join-Path $work "app.7z"
  Push-Location -LiteralPath $ReleaseDir
  try {
    & $archiver a $archive * -mx9 | Out-Null
  } finally {
    Pop-Location
  }
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to create the 7z archive"
  }

  # --- 5. Assemble: stub + config + archive ---
  Write-Host "Building portable executable..."
  $config = Join-Path $work "config.txt"
  # The config block must be UTF-8 (no BOM), delimited by
  # ";!@Install@!UTF-8!" ... ";!@InstallEnd@!" and use quoted values
  # (ID_String="Value") as documented by 7-Zip 9.20.
  $configLines = @(
    ";!@Install@!UTF-8!",
    'GUIMode="1"',
    "RunProgram=`"$AppName`"",
    ";!@InstallEnd@!"
  ) -join "`r`n"
  [System.IO.File]::WriteAllText($config, $configLines, (New-Object System.Text.UTF8Encoding($false)))

  $OutputExe = [System.IO.Path]::GetFullPath($OutputExe)
  Copy-Item -LiteralPath $sfxStub.FullName -Destination $OutputExe
  cmd /c "copy /b `"$OutputExe`"+`"$config`"+`"$archive`" `"$OutputExe`" >nul"
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to assemble the self-extracting archive"
  }

  Write-Host "Done: $OutputExe"
} finally {
  Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
}
