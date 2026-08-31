#!/usr/bin/env bash
set -euo pipefail

# KikAis — automated screenshot capture (Linux)
# Builds the release bundle, runs it under Xvfb and captures all 8 pages
# via xdotool + ImageMagick import.
#
# Usage:
#   ./scripts/take_screenshots.sh [--output DIR] [--click|--scroll]
#
# Dependencies: flutter, Xvfb, xdotool, ImageMagick (import)

OUTPUT_DIR="readme_images"
USE_CLICK=1  # click is more reliable than horizontal scroll

# ── arg parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --click)
      USE_CLICK=1
      shift
      ;;
    --scroll|--no-click)
      USE_CLICK=0
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--output DIR] [--click|--scroll]"
      echo ""
      echo "  --output DIR   Output directory (default: readme_images)"
      echo "  --click        Navigate via NavigationBar clicks (default, reliable)"
      echo "  --scroll       Navigate via horizontal scroll (xdotool button 7)"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Try --help" >&2
      exit 1
      ;;
  esac
done

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ── dependency checks ────────────────────────────────────────────────────
MISSING=()
for cmd in flutter Xvfb xdotool import; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING+=("$cmd")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Missing dependencies: ${MISSING[*]}" >&2
  echo "" >&2
  echo "Install on Ubuntu/Debian:" >&2
  echo "  sudo apt install xvfb xdotool imagemagick" >&2
  echo "  (flutter must be installed separately: https://docs.flutter.dev/get-started/install/linux)" >&2
  exit 1
fi

echo "Output dir : $OUTPUT_DIR"
if [[ $USE_CLICK -eq 1 ]]; then
  echo "Navigation : click (NavigationBar)"
else
  echo "Navigation : scroll (xdotool button 7)"
fi
echo ""

# ── build ────────────────────────────────────────────────────────────────
echo "==> Building Linux release..."
flutter build linux --release

BINARY="$ROOT/build/linux/x64/release/bundle/kik_ais"
if [[ ! -x "$BINARY" ]]; then
  echo "Build output not found at $BINARY" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# ── page mapping (index → file name) ─────────────────────────────────────
PAGES=(reception send map editor tools stats simulation docs)
# Display labels for log output
LABELS=(Reception Send Map Editor Tools Stats Simulation Documentation)

# ── start Xvfb ───────────────────────────────────────────────────────────
DISPLAY_NUM=99
export DISPLAY=":${DISPLAY_NUM}"

echo "==> Starting Xvfb on $DISPLAY (1024x810x24)..."
Xvfb "$DISPLAY" -screen 0 1024x810x24 &
XVFB_PID=$!

cleanup() {
  echo ""
  echo "==> Cleaning up..."
  # Kill app if still running
  if [[ -n "${APP_PID:-}" ]] && kill -0 "$APP_PID" 2>/dev/null; then
    kill "$APP_PID" 2>/dev/null || true
    wait "$APP_PID" 2>/dev/null || true
  fi
  # Kill Xvfb
  if kill -0 "$XVFB_PID" 2>/dev/null; then
    kill "$XVFB_PID" 2>/dev/null || true
    wait "$XVFB_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# Give Xvfb a moment to start
sleep 1

# ── launch app ───────────────────────────────────────────────────────────
echo "==> Launching $BINARY on $DISPLAY..."
"$BINARY" &
APP_PID=$!

# ── wait for window ──────────────────────────────────────────────────────
echo "==> Waiting for window 'KikAis'..."
WIN_ID=""
for _ in $(seq 1 30); do
  WIN_ID=$(xdotool search --onlyvisible --name "KikAis" 2>/dev/null | head -n1 || true)
  if [[ -n "$WIN_ID" ]]; then
    break
  fi
  sleep 1
done

if [[ -z "$WIN_ID" ]]; then
  echo "Timed out waiting for KikAis window" >&2
  exit 1
fi

echo "    Window ID: $WIN_ID"

# Activate and ensure visible
xdotool windowactivate "$WIN_ID" 2>/dev/null || true
sleep 1

# Get window geometry for click calculations
GEOM=$(xdotool getwindowgeometry "$WIN_ID" 2>/dev/null || true)
# Parse width/height from e.g. "  Geometry: 1024x810"
WIN_W=$(echo "$GEOM" | grep -oP '\d+(?=x\d+)' | tail -1 || echo 1024)
WIN_H=$(echo "$GEOM" | grep -oP 'x\K\d+' | tail -1 || echo 810)
# Fallback to defaults if parsing failed
if [[ -z "$WIN_W" ]]; then WIN_W=1024; fi
if [[ -z "$WIN_H" ]]; then WIN_H=810; fi

echo "    Geometry : ${WIN_W}x${WIN_H}"

# ── capture each page ────────────────────────────────────────────────────
echo ""
echo "==> Capturing pages..."

CAPTURED=()
FAILED=()

for i in "${!PAGES[@]}"; do
  PAGE="${PAGES[$i]}"
  LABEL="${LABELS[$i]}"
  DEST="$OUTPUT_DIR/${PAGE}.png"

  if [[ $i -gt 0 ]]; then
    if [[ $USE_CLICK -eq 1 ]]; then
      # NavigationBar is at the bottom of the window, 8 destinations evenly
      # distributed. Click the center of destination i.
      #   center_x = (i + 0.5) * (width / 8)
      #   y        = height - 40
      CLICK_X=$(awk "BEGIN {printf \"%d\", ($i + 0.5) * ($WIN_W / 8)}")
      CLICK_Y=$((WIN_H - 40))
      echo "  [$i] $LABEL -> click at ${CLICK_X},${CLICK_Y}"
      xdotool mousemove --window "$WIN_ID" "$CLICK_X" "$CLICK_Y" 2>/dev/null || true
      sleep 0.2
      xdotool click --window "$WIN_ID" 1 2>/dev/null || true
    else
      echo "  [$i] $LABEL -> scroll-right (button 7)"
      # Move cursor to content area, then send horizontal scroll
      CENTER_X=$((WIN_W / 2))
      CENTER_Y=$((WIN_H / 2))
      xdotool mousemove --window "$WIN_ID" "$CENTER_X" "$CENTER_Y" 2>/dev/null || true
      sleep 0.2
      xdotool click --window "$WIN_ID" 7 2>/dev/null || true
    fi
    sleep 1.5
  else
    echo "  [$i] $LABEL (initial page)"
    sleep 1.5
  fi

  echo "      Capturing -> $DEST"
  if import -window "$WIN_ID" "$DEST" 2>/dev/null; then
    CAPTURED+=("$DEST")
  else
    echo "      FAILED to capture $PAGE" >&2
    FAILED+=("$PAGE")
  fi
done

# ── summary ──────────────────────────────────────────────────────────────
echo ""
echo "========================================"
echo " Screenshot summary"
echo "========================================"
echo " Output dir : $OUTPUT_DIR"
echo " Captured   : ${#CAPTURED[@]}/${#PAGES[@]}"
for f in "${CAPTURED[@]}"; do
  SIZE=$(du -h "$f" 2>/dev/null | cut -f1 || echo "?")
  echo "   ✓ $f ($SIZE)"
done
if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo " Failed     : ${FAILED[*]}"
fi
echo "========================================"

if [[ ${#FAILED[@]} -gt 0 ]]; then
  exit 1
fi
