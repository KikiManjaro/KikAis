<#
.SYNOPSIS
Builds an MSIX installer and an App Installer publish folder for KikAis.

.DESCRIPTION
Runs the Flutter Windows release build, creates a signed MSIX package from the
build output and generates the .appinstaller manifest + versioned package used
for automatic updates when hosted on an HTTPS URL.

The MSIX configuration (display name, identity, capabilities, app_installer
settings) lives in the msix_config section of pubspec.yaml.

.PARAMETER ReleaseDir
Path to the Flutter release output folder (contains kikais.exe). When omitted,
the script runs `flutter build windows --release` first.

.PARAMETER OutputDir
Directory where the MSIX and publish folder are written (default: build/msix).

.PARAMETER CertificatePath
Path to the .pfx used to sign the package. All releases MUST be signed with
the same certificate so in-place updates are recognized.

.PARAMETER CertificatePassword
Password of the certificate.

.PARAMETER InstallCertificate
Whether to install the certificate into the local machine store after signing
(default: false, only relevant for self-signed certificates).

.EXAMPLE
./scripts/make_msix.ps1 `
  -CertificatePath C:\secrets\kikais-msix.pfx `
  -CertificatePassword "s3cret"
#>
param(
  [string]$ReleaseDir,

  [string]$OutputDir = "build/msix",

  [string]$CertificatePath,

  [string]$CertificatePassword,

  [bool]$InstallCertificate = $false
)

$ErrorActionPreference = "Stop"

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

$createArgs = @("msix:publish", "--build-windows", "false")

if ($CertificatePath) {
  if (-not (Test-Path -LiteralPath $CertificatePath)) {
    throw "Certificate not found: $CertificatePath"
  }
  $createArgs += @("--certificate-path", $CertificatePath)
  if ($CertificatePassword) {
    $createArgs += @("--certificate-password", $CertificatePassword)
  }
}

if (-not $InstallCertificate) {
  $createArgs += "--install-certificate", "false"
}

$publishDir = Join-Path $OutputDir "publish"
New-Item -ItemType Directory -Path $publishDir -Force | Out-Null

if ($CertificatePath) {
  $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertificatePath, $CertificatePassword)
  $cer = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($cert2.RawData)
  [IO.File]::WriteAllBytes((Join-Path $publishDir "KikAis.cer"), $cer.RawData)
}

Write-Host "Creating MSIX package and App Installer manifest..."
dart run $createArgs
if ($LASTEXITCODE -ne 0) {
  throw "dart run msix:publish failed"
}

Write-Host ""
Write-Host "Done:"
Write-Host "  MSIX:        $OutputDir"
Write-Host "  Publish dir: $publishDir (host this folder on HTTPS for auto-updates)"
