# KikAis

Flutter desktop app for AIS NMEA 0183 data forwarding and visualization.

## Build
- `flutter build linux` (Linux)
- `flutter build windows` (Windows)
- `flutter test` (unit tests)

## Architecture
- `lib/ais/` — AIS NMEA 0183 decoder and data models
- `lib/` — Flutter UI (map, editor, settings)
- `scripts/` — Build and CI helper scripts
