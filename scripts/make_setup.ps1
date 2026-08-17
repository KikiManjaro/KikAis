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

  # --- 4. Copy screenshots used by the showcase page ---
  $repoImages = Join-Path (Split-Path -Parent $PSScriptRoot) "readme_images"
  if (Test-Path -LiteralPath $repoImages) {
    $destImages = Join-Path $AppcastDir "readme_images"
    New-Item -ItemType Directory -Path $destImages -Force | Out-Null
    Copy-Item -Path (Join-Path $repoImages "*") -Destination $destImages -Recurse -Force
    Write-Host "Screenshots: $destImages"
  }

  # --- 5. Copy i18n JSON files ---
  $repoI18n = Join-Path (Split-Path -Parent $PSScriptRoot) "docs\i18n"
  if (Test-Path -LiteralPath $repoI18n) {
    $destI18n = Join-Path $AppcastDir "i18n"
    New-Item -ItemType Directory -Path $destI18n -Force | Out-Null
    Get-ChildItem -LiteralPath $repoI18n -Filter "*.json" | Copy-Item -Destination $destI18n -Force
    Write-Host "i18n files: $destI18n"
  }

  # --- 6. Simple download page (kept for compatibility as download.html) ---
  $releaseUrl = $DownloadBaseUrl.TrimEnd('/')
  $downloadPage = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>KikAis $Version - Downloads</title>
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

  $downloadPagePath = Join-Path $AppcastDir "download.html"
  Set-Content -LiteralPath $downloadPagePath -Value $downloadPage -Encoding Utf8
  Write-Host "Download page: $downloadPagePath"

  # --- 6. Showcase landing page (index.html) ---
  $repoRoot = Split-Path -Parent $PSScriptRoot
  $logoPath = Join-Path $repoRoot "resources\FireBoat2.png"
  $logoFile = ""
  if (Test-Path -LiteralPath $logoPath) {
    $logoFile = "logo.png"
    Copy-Item -LiteralPath $logoPath -Destination (Join-Path $AppcastDir $logoFile) -Force
  }

  $showcasePage = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>KikAis - AIS data forwarding &amp; visualization hub</title>
  <meta name="description" content="KikAis est un hub de données AIS pour NMEA 0183 : réception, décodage, visualisation et retransmission.">
  <link rel="icon" type="image/png" href="$(if ($logoFile) { $logoFile } else { 'readme_images/docs.png' })">
  <style>
    :root { --bg:#0f172a; --bg2:#111c33; --card:#16233f; --card2:#1b2c4d;
            --text:#e2e8f0; --muted:#94a3b8; --accent:#0ea5e9; --accent2:#38bdf8;
            --border:#24365a; }
    * { box-sizing:border-box; margin:0; padding:0; }
    html { scroll-behavior:smooth; }
    body { font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;
           background:var(--bg); color:var(--text); line-height:1.6; }
    a { color:var(--accent2); text-decoration:none; }
    a:hover { text-decoration:underline; }
    .container { max-width:1040px; margin:0 auto; padding:0 24px; }

    /* Nav */
    nav { position:sticky; top:0; z-index:50; backdrop-filter:blur(8px);
          background:rgba(15,23,42,.85); border-bottom:1px solid var(--border); }
    nav .container { display:flex; align-items:center; justify-content:space-between;
                     height:60px; }
    nav .brand { display:flex; align-items:center; gap:10px; font-weight:700; color:var(--text); }
    nav .brand img { height:26px; width:26px; border-radius:6px; }
    nav .links { display:flex; gap:22px; font-size:14px; }
    nav .links a { color:var(--muted); }
    nav .links a:hover { color:var(--text); }

    /* Hero */
    .hero { padding:70px 0 60px; text-align:center;
            background:radial-gradient(800px 400px at 50% -10%, #0ea5e922, transparent 70%); }
    .hero .logo { width:92px; height:92px; border-radius:22px; margin-bottom:20px;
                  box-shadow:0 10px 40px #0ea5e933; }
    .hero h1 { font-size:44px; font-weight:800; letter-spacing:-.5px; }
    .hero .tagline { color:var(--muted); font-size:18px; margin:10px auto 22px; max-width:640px; }
    .badges { display:flex; flex-wrap:wrap; gap:8px; justify-content:center; margin-bottom:32px; }
    .badge { font-size:12px; padding:5px 12px; border-radius:999px;
             background:var(--card); border:1px solid var(--border); color:var(--muted); }
    .badge b { color:var(--text); font-weight:600; }
    .hero-actions { display:flex; gap:14px; justify-content:center; flex-wrap:wrap; }
    .btn { display:inline-flex; align-items:center; gap:8px; padding:14px 28px;
           border-radius:12px; font-weight:700; font-size:15px; transition:.15s; }
    .btn-primary { background:var(--accent); color:#fff; }
    .btn-primary:hover { background:#0284c7; text-decoration:none; }
    .btn-ghost { background:var(--card); color:var(--text); border:1px solid var(--border); }
    .btn-ghost:hover { background:var(--card2); text-decoration:none; }

    /* Sections */
    section { padding:52px 0; }
    section h2 { font-size:28px; font-weight:800; text-align:center; margin-bottom:8px; }
    section .sub { text-align:center; color:var(--muted); margin-bottom:36px; }

    /* Features */
    .features { display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); gap:18px; }
    .feature { background:var(--card); border:1px solid var(--border); border-radius:14px;
               padding:22px; transition:.15s; }
    .feature:hover { transform:translateY(-3px); background:var(--card2); }
    .feature .icon { font-size:26px; }
    .feature h3 { font-size:17px; margin:10px 0 8px; }
    .feature ul { list-style:none; }
    .feature li { color:var(--muted); font-size:14px; padding:3px 0 3px 20px;
                  position:relative; }
    .feature li::before { content:"▸"; position:absolute; left:0; color:var(--accent2); }

    /* Screenshots */
    .shots { display:grid; grid-template-columns:repeat(auto-fit,minmax(320px,1fr)); gap:20px; }
    .shot { background:var(--card); border:1px solid var(--border); border-radius:14px;
            overflow:hidden; }
    .shot img { width:100%; display:block; }
    .shot figcaption { padding:12px 16px; font-size:13px; color:var(--muted); }

    /* Footer */
    footer { border-top:1px solid var(--border); padding:36px 0; text-align:center;
             color:var(--muted); font-size:14px; }
    footer .social { display:flex; gap:20px; justify-content:center; margin-bottom:16px; }
    footer .social a { color:var(--muted); }
    footer .social a:hover { color:var(--text); }

    /* Lang selector */
    .lang-sel { background:var(--card); border:1px solid var(--border); color:var(--muted);
                padding:4px 8px; border-radius:6px; font-size:13px; cursor:pointer; }
    .lang-sel:hover { color:var(--text); border-color:var(--accent); }
    .lang-sel:focus { outline:none; border-color:var(--accent); }

    @media (max-width:640px) {
      .hero h1 { font-size:32px; }
      nav .links { display:none; }
    }
  </style>
</head>
<body>
  <nav>
    <div class="container">
      <a class="brand" href="#">$(if ($logoFile) { "<img src=""$logoFile"" alt=""KikAis"">" } )KikAis</a>
      <div class="links">
        <a href="#features" data-i18n="nav_fonctionnalites">Fonctionnalités</a>
        <a href="#screenshots" data-i18n="nav_captures">Captures</a>
        <a href="download.html" data-i18n="nav_telechargements">Téléchargements</a>
        <a href="https://github.com/KikiManjaro/KikAis" data-i18n="nav_github">GitHub</a>
        <select class="lang-sel" id="langSel" aria-label="Language">
          <option value="en">EN</option><option value="fr" selected>FR</option>
          <option value="es">ES</option><option value="de">DE</option>
          <option value="pt">PT</option><option value="it">IT</option>
          <option value="nl">NL</option><option value="zh">中文</option>
          <option value="ja">日本語</option><option value="ru">RU</option>
        </select>
      </div>
    </div>
  </nav>

  <header class="hero">
    <div class="container">
      <img class="logo" src="$(if ($logoFile) { $logoFile } else { "readme_images/docs.png" })" alt="KikAis">
      <h1>KikAis</h1>
      <p class="tagline" data-i18n="hero_tagline">AIS data forwarding &amp; visualization hub for NMEA 0183 — receive, decode, visualize and rebroadcast Automatic Identification System data, all in one desktop app.</p>
      <div class="badges">
        <span class="badge"><span data-i18n="hero_badge_version">Version</span> <b>$Version</b></span>
        <span class="badge" data-i18n="hero_badge_windows">Windows</span>
        <span class="badge" data-i18n="hero_badge_linux">Linux</span>
        <span class="badge" data-i18n="hero_badge_update">Update auto</span>
      </div>
      <div class="hero-actions">
        <a class="btn btn-primary" href="$releaseUrl/kikais-setup-$Version.exe"><span data-i18n="hero_btn_download">⬇ Télécharger l'installeur Windows</span></a>
        <a class="btn btn-ghost" href="download.html"><span data-i18n="hero_btn_all_files">Tous les fichiers</span></a>
      </div>
    </div>
  </header>

  <section id="features">
    <div class="container">
      <h2 data-i18n="features_title">Fonctionnalités</h2>
      <p class="sub" data-i18n="features_sub">Un hub complet pour les données AIS</p>
      <div class="features">
        <div class="feature">
          <div class="icon">📡</div>
          <h3 data-i18n="feature_reception_title">Réception</h3>
          <ul>
            <li data-i18n="feature_reception_1">Feeds réseau intégrés ou définis par l'utilisateur + replay de logs NMEA</li>
            <li data-i18n="feature_reception_2">Réception RTL-SDR (V3, V4, RTL2832U) — démodulation GMSK en interne</li>
            <li data-i18n="feature_reception_3">Console de logs avec copie / sauvegarde / effacement</li>
            <li data-i18n="feature_reception_4">Points de statut par feed et validation de checksum</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">🚀</div>
          <h3 data-i18n="feature_forwarding_title">Retransmission</h3>
          <ul>
            <li data-i18n="feature_forwarding_1">Envoi vers plusieurs destinations simultanément</li>
            <li data-i18n="feature_forwarding_2">Transports UDP / TCP (serveur et client)</li>
            <li data-i18n="feature_forwarding_3">Activation et édition indépendantes de chaque destination</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">🗺️</div>
          <h3 data-i18n="feature_map_title">Carte</h3>
          <ul>
            <li data-i18n="feature_map_1">Positions des navires sur une carte mondiale interactive</li>
            <li data-i18n="feature_map_2">Clustering de marqueurs, sillages et vecteurs de vitesse</li>
            <li data-i18n="feature_map_3">Recherche (nom / MMSI / IMO) et filtres avancés</li>
            <li data-i18n="feature_map_4">Plusieurs fonds de carte gratuits avec thème auto</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">✏️</div>
          <h3 data-i18n="feature_editor_title">Éditeur</h3>
          <ul>
            <li data-i18n="feature_editor_1">Compose et envoie les 27 types de messages AIS</li>
            <li data-i18n="feature_editor_2">Aperçu NMEA en direct avec copie et injection sur la carte</li>
            <li data-i18n="feature_editor_3">Catalogue de 148 messages ASM DAC/FID avec sélecteur de préréglages</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">🔍</div>
          <h3 data-i18n="feature_tools_title">Outils</h3>
          <ul>
            <li data-i18n="feature_tools_1">Décodeur NMEA, calcul de checksum, recherche MMSI</li>
            <li data-i18n="feature_tools_2">Convertisseur de vitesse et inspecteur binaire</li>
            <li data-i18n="feature_tools_3">Calculateur d'ETA et de portée radio VHF</li>
            <li data-i18n="feature_tools_4">Texte vers ASCII 6 bits AIS</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">📊</div>
          <h3 data-i18n="feature_stats_title">Statistiques</h3>
          <ul>
            <li data-i18n="feature_stats_1">KPI : taux reçus / décodés, checksums invalides</li>
            <li data-i18n="feature_stats_2">Graphique reçu-vs-décodé sur la dernière minute</li>
            <li data-i18n="feature_stats_3">Vue comptable et répartitions par feed / type de message</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">🧪</div>
          <h3 data-i18n="feature_simulation_title">Simulation</h3>
          <ul>
            <li data-i18n="feature_simulation_1">Génère une flotte configurable autour d'un lieu choisi</li>
            <li data-i18n="feature_simulation_2">Navires, aéronefs SAR, stations de base et aides à la navigation</li>
            <li data-i18n="feature_simulation_3">Comptes rendus, données statiques/voyage, vitesse et cadence réglables</li>
          </ul>
        </div>
        <div class="feature">
          <div class="icon">⚙️</div>
          <h3 data-i18n="feature_extras_title">En option</h3>
          <ul>
            <li data-i18n="feature_extras_1">Décodage en isolat — interface fluide même à haut débit</li>
            <li data-i18n="feature_extras_2">Thèmes clair / sombre / contraste élevé</li>
            <li data-i18n="feature_extras_3">Mises à jour automatiques Windows (WinSparkle)</li>
          </ul>
        </div>
      </div>
    </div>
  </section>

  <section id="screenshots">
    <div class="container">
      <h2 data-i18n="screenshots_title">Captures d'écran</h2>
      <p class="sub" data-i18n="screenshots_sub">Vue d'ensemble de l'application</p>
      <div class="shots">
        <figure class="shot">
          <img src="readme_images/reception.png" alt="Reception">
          <figcaption data-i18n="screenshot_reception">Réception des flux AIS</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/map_with_ship.png" alt="Map">
          <figcaption data-i18n="screenshot_map">Carte mondiale avec les navires</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/editor.png" alt="Editor">
          <figcaption data-i18n="screenshot_editor">Éditeur et composition de messages</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/map_with_selected_ship.png" alt="Selected ship">
          <figcaption data-i18n="screenshot_selected_ship">Détail du navire sélectionné</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/tools.png" alt="Tools">
          <figcaption data-i18n="screenshot_tools">Boîte à outils NMEA / AIS</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/stats.png" alt="Stats">
          <figcaption data-i18n="screenshot_stats">Statistiques et métriques</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/simulation.png" alt="Simulation">
          <figcaption data-i18n="screenshot_simulation">Simulation de flotte</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/send.png" alt="Send">
          <figcaption data-i18n="screenshot_send">Envoi et retransmission</figcaption>
        </figure>
        <figure class="shot">
          <img src="readme_images/reception_receiving.png" alt="Receiving">
          <figcaption data-i18n="screenshot_receiving">Réception en cours</figcaption>
        </figure>
      </div>
    </div>
  </section>

  <footer>
    <div class="container">
      <div class="social">
        <a href="https://github.com/KikiManjaro/KikAis">GitHub</a>
        <a href="https://github.com/KikiManjaro/KikAis/releases">Releases</a>
        <a href="https://www.buymeacoffee.com/kikimanjaro">Buy Me a Coffee</a>
        <a href="https://github.com/sponsors/KikiManjaro">GitHub Sponsors</a>
      </div>
      <p>KikAis $Version · <span data-i18n="footer_licence">Licence custom (pas de redistribution) · Système d'update auto intégré</span></p>
    </div>
  </footer>

  <script>
  (function(){
    var langs=["en","fr","es","de","pt","it","nl","zh","ja","ru"];
    var sel=document.getElementById("langSel");
    var saved=localStorage.getItem("lang");
    var def=navigator.language.slice(0,2);
    if(saved&&langs.indexOf(saved)>=0)def=saved;
    else if(langs.indexOf(def)<0)def="en";
    sel.value=def;
    function apply(t){
      document.querySelectorAll("[data-i18n]").forEach(function(el){
        var k=el.getAttribute("data-i18n");
        if(t[k]!==undefined)el.innerHTML=t[k];
      });
    }
    function load(lang){
      fetch("i18n/"+lang+".json").then(function(r){return r.json()}).then(function(t){
        apply(t);localStorage.setItem("lang",lang);
        document.documentElement.lang=lang;
      });
    }
    load(def);
    sel.addEventListener("change",function(){load(this.value)});
  })();
  </script>
</body>
</html>
"@

  $showcasePath = Join-Path $AppcastDir "index.html"
  Set-Content -LiteralPath $showcasePath -Value $showcasePage -Encoding Utf8
  Write-Host "Showcase page: $showcasePath"
}

Write-Host "Done."
