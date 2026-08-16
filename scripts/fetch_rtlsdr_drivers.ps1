<#
.SYNOPSIS
Downloads the official RTL-SDR Blog Windows release and extracts the runtime
DLLs into resources/rtlsdr/windows so they are bundled with KikAis.

.DESCRIPTION
The release zip (rtlsdr-blog "Release.zip", tag V1.4.0) provides the
V4-compatible rtlsdr.dll that KikAis loads through librtlsdr FFI, plus the DLLs
it depends on. The archive's sha256 is verified before extracting the 64-bit
files.

.EXAMPLE
./scripts/fetch_rtlsdr_drivers.ps1
#>
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$dest = Join-Path $repoRoot "resources\rtlsdr\windows"
$expectedSha256 = "7ef33f1304647f65e5e0fde43637a73d54f076e91e651a3cecc4f55a17fd9815"
$url = "https://github.com/rtlsdrblog/rtl-sdr-blog/releases/download/V1.4.0/Release.zip"

New-Item -ItemType Directory -Path $dest -Force | Out-Null

$work = Join-Path $env:TEMP ("rtlsdr_blog_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $work | Out-Null

try {
  $zip = Join-Path $work "release.zip"
  Write-Host "Downloading $url"
  Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

  $sha = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLower()
  if ($sha -ne $expectedSha256) {
    throw "sha256 mismatch: expected $expectedSha256, got $sha"
  }
  Write-Host "sha256 OK"

  Write-Host "Extracting..."
  tar -xf $zip -C $work

  # The 64-bit DLLs all live under x64/ in the archive. The rtlsdr-blog build
  # talks to the dongle through the Windows WinUSB driver directly, so no
  # libusb-1.0.dll is needed.
  $files = @(
    @{ From = "x64\rtlsdr.dll";     To = "rtlsdr.dll" },
    @{ From = "x64\pthreadVC2.dll"; To = "pthreadVC2.dll" },
    @{ From = "x64\msvcr100.dll";   To = "msvcr100.dll" }
  )
  foreach ($f in $files) {
    $src = Join-Path $work $f.From
    if (-not (Test-Path -LiteralPath $src)) {
      Write-Warning "missing in release: $($f.From)"
      continue
    }
    Copy-Item -LiteralPath $src -Destination (Join-Path $dest $f.To) -Force
    Write-Host "  -> $($f.To)"
  }

  Write-Host "Done. Drivers are in $dest"
} finally {
  Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
}
