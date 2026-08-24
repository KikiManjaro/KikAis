param(
    [string]$OutputDir = "readme_images"
)

# KikAis — automated screenshot capture (Windows)
# Builds the release bundle, launches the app and captures all 8 pages
# via .NET System.Drawing + Win32 GetForegroundWindow.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# ── check flutter ─────────────────────────────────────────────────────────
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "flutter not found in PATH. Install from https://docs.flutter.dev/get-started/install/windows"
}

Write-Host "Output dir : $OutputDir"
Write-Host ""

# ── build ────────────────────────────────────────────────────────────────
Write-Host "==> Building Windows release..."
flutter build windows --release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed."
}

$exe = Join-Path $root "build\windows\x64\runner\Release\kik_ais.exe"
# Fallback: some Flutter versions use kikais.exe without underscore
if (-not (Test-Path $exe)) {
    $exe = Join-Path $root "build\windows\x64\runner\Release\kikais.exe"
}
if (-not (Test-Path $exe)) {
    Write-Error "Build output not found at $exe"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$pages  = @("reception","send","map","editor","tools","stats","simulation","docs")
$labels = @("Reception","Send","Map","Editor","Tools","Stats","Simulation","Documentation")

# ── C# screenshot helper (System.Drawing + user32.dll) ──────────────────
Add-Type -TypeDefinition @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class ScreenCapture {
    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left, Top, Right, Bottom; }

    public static Bitmap CaptureForeground() {
        IntPtr hWnd = GetForegroundWindow();
        RECT rect;
        GetWindowRect(hWnd, out rect);
        int w = rect.Right - rect.Left, h = rect.Bottom - rect.Top;
        var bmp = new Bitmap(w, h);
        using (var g = Graphics.FromImage(bmp))
            g.CopyFromScreen(rect.Left, rect.Top, 0, 0, new Size(w, h));
        return bmp;
    }
}
"@ -ReferencedAssemblies System.Drawing

# ── helper: horizontal scroll via SendInput ──────────────────────────────
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class ScrollHelper {
    [DllImport("user32.dll")]
    private static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    [StructLayout(LayoutKind.Sequential)]
    struct INPUT { public uint type; public MOUSEINPUT mi; }

    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT {
        public int dx; public int dy;
        public uint mouseData; public uint dwFlags;
        public uint time; public IntPtr dwExtraInfo;
    }

    const uint INPUT_MOUSE = 0;
    const uint WHEEL = 0x0800;
    const uint HWHEEL = 0x01000;

    public static void ScrollRight() {
        var inp = new INPUT[1];
        inp[0].type = INPUT_MOUSE;
        inp[0].mi.mouseData = 120; // WHEEL_DELTA
        inp[0].mi.dwFlags = HWHEEL;
        SendInput(1, inp, Marshal.SizeOf(typeof(INPUT)));
    }

    public static void ScrollLeft() {
        var inp = new INPUT[1];
        inp[0].type = INPUT_MOUSE;
        inp[0].mi.mouseData = unchecked((uint)-120);
        inp[0].mi.dwFlags = HWHEEL;
        SendInput(1, inp, Marshal.SizeOf(typeof(INPUT)));
    }
}
"@

Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue

# ── launch app ───────────────────────────────────────────────────────────
Write-Host "==> Launching $exe ..."
$proc = Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe) -PassThru
Start-Sleep -Seconds 2

# ── wait for window ──────────────────────────────────────────────────────
Write-Host "==> Waiting for window 'KikAis'..."
$hWnd = [IntPtr]::Zero
for ($attempt = 0; $attempt -lt 30; $attempt++) {
    $win = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue | ForEach-Object { $_.MainWindowHandle }
    # Also search by title in case MainWindowHandle is not yet set
    $byTitle = Get-Process | Where-Object { $_.MainWindowTitle -like "*KikAis*" } | Select-Object -First 1
    if ($byTitle -and $byTitle.MainWindowHandle -ne [IntPtr]::Zero) {
        $hWnd = $byTitle.MainWindowHandle
        break
    }
    if ($win -and $win -ne [IntPtr]::Zero) {
        $hWnd = $win
        break
    }
    Start-Sleep -Seconds 1
}

if ($hWnd -eq [IntPtr]::Zero) {
    Write-Host "Timed out waiting for KikAis window, trying fallback..." -ForegroundColor Yellow
    $fallback = Get-Process | Where-Object { $_.MainWindowTitle -like "*KikAis*" } | Select-Object -First 1
    if ($fallback) { $hWnd = $fallback.MainWindowHandle }
}

if ($hWnd -eq [IntPtr]::Zero) {
    Write-Error "Could not find KikAis window."
}

# Bring to foreground
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class Win32 {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
[Win32]::SetForegroundWindow($hWnd) | Out-Null
[Win32]::ShowWindow($hWnd, 9) | Out-Null  # SW_RESTORE
Start-Sleep -Seconds 1

# ── capture each page ───────────────────────────────────────────────────
Write-Host ""
Write-Host "==> Capturing pages..."

$captured = @()
$failed   = @()

for ($i = 0; $i -lt $pages.Length; $i++) {
    $page  = $pages[$i]
    $label = $labels[$i]
    $dest  = Join-Path $OutputDir "$page.png"
    $destFull = Join-Path $root $dest

    if ($i -gt 0) {
        Write-Host "  [$i] $label -> horizontal scroll + settle"
        # Ensure window is foreground before scrolling
        [Win32]::SetForegroundWindow($hWnd) | Out-Null
        Start-Sleep -Milliseconds 200
        [ScrollHelper]::ScrollRight()
        Start-Sleep -Milliseconds 1500
    } else {
        Write-Host "  [$i] $label (initial page)"
        Start-Sleep -Milliseconds 1500
    }

    # Re-ensure foreground before capture
    [Win32]::SetForegroundWindow($hWnd) | Out-Null
    Start-Sleep -Milliseconds 300

    Write-Host "      Capturing -> $dest"
    try {
        $bmp = [ScreenCapture]::CaptureForeground()
        $bmp.Save($destFull, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $captured += $dest
    } catch {
        Write-Host "      FAILED to capture $page : $_" -ForegroundColor Red
        $failed += $page
    }
}

# ── kill app ─────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "==> Stopping app..."
try { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue } catch {}
Start-Sleep -Milliseconds 500
# Fallback: kill any remaining KikAis process
Get-Process -Name "kik_ais","kikais","KikAis" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# ── summary ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================"
Write-Host " Screenshot summary"
Write-Host "========================================"
Write-Host " Output dir : $OutputDir"
Write-Host " Captured   : $($captured.Count)/$($pages.Length)"
foreach ($f in $captured) {
    $size = ""
    try { $size = " (" + ((Get-Item (Join-Path $root $f)).Length / 1KB).ToString("0") + " KB)") } catch {}
    Write-Host "   OK $f$size" -ForegroundColor Green
}
if ($failed.Count -gt 0) {
    Write-Host " Failed     : $($failed -join ', ')" -ForegroundColor Red
}
Write-Host "========================================"

if ($failed.Count -gt 0) { exit 1 }
