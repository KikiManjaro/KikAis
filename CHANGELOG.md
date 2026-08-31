# Changelog

All notable changes to KikAis are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [2.7.0] - 2026-08-29

### Added
- Project standards, roadmap and verification tooling (`AGENTS.md`, `ROADMAP.md`, `scripts/check.ps1`)

### Changed
- Performance: hardened high-throughput pipeline and session logs

### Fixed
- Sleep/wake resilience and diagnostic instrumentation
- Fluidity fixes and diagnostic instrumentation

## [2.6.4] - 2026-08-26

### Changed
- Documentation updates

## [2.6.3] - 2026-08-25

### Added
- Channel occupancy tracking and visualization in Stats page

## [2.6.2] - 2026-08-17

### Added
- RTL-SDR improvements: null-safe UDP socket receive on stop
- RTL-SDR: replaced custom DSP with AIS-catcher external process
- Landing page with i18n showcase (10 languages)

### Fixed
- Removed broken GitHub Sponsors link from README
- Corrected release link

## [2.6.1] - 2026-08-17

### Fixed
- Patch release for 2.6.0 follow-up fixes

## [2.6.0] - 2026-08-17

### Added
- RTL-SDR Blog V4 driver support

## [2.5.0] - 2026-08-17

### Added
- RTL-SDR AIS reception improvements

## [2.4.0] - 2026-08-16

### Added
- In-app RTL-SDR AIS reception, map clear button, tooltips and documentation

## [2.3.0] - 2026-08-15

### Added
- Tools hub with full ASM catalog (148 DAC/FID messages) and editor ASM field editing

## [2.2.0] - 2026-08-13

### Added
- Internationalization in 10 languages (en, fr, es, de, pt, it, nl, zh, ja, ru) and manual update check

### Changed
- NMEA 4.0 tag block support and documentation tab

## [2.1.1] - 2026-08-11

### Fixed
- Simulation improvements

## [2.1.0] - 2026-08-11

### Added
- Simulation fleet generation improvements

## [2.0.1] - 2026-08-07

### Fixed
- Build script fixes for portable executable workflow

## [2.0.0] - 2026-08-07

### Added
- Initial stable release: AIS NMEA 0183 forwarding and visualization hub
- Flutter desktop app (Windows/Linux) with 8-tab interface
- NMEA decoding via dedicated isolate, world map with clustering/trails/vectors
- Network/file/serial feed support, UDP/TCP forwarding
- 27 AIS message types, NMEA tools, simulation engine
- Gitleaks secrets scan in CI

## [1.2.x] - 2025-08 — 2025-09

### Added
- Early releases (v1.0.0 – v1.2.1): initial development iterations

[2.7.0]: https://github.com/KikiManjaro/KikAis/releases/tag/2.7.0
[2.6.4]: https://github.com/KikiManjaro/KikAis/releases/tag/2.6.4
[2.6.3]: https://github.com/KikiManjaro/KikAis/releases/tag/2.6.3
[2.6.2]: https://github.com/KikiManjaro/KikAis/releases/tag/v2.6.2
[2.6.1]: https://github.com/KikiManjaro/KikAis/releases/tag/v2.6.1
[2.6.0]: https://github.com/KikiManjaro/KikAis/releases/tag/v2.6.0
[2.5.0]: https://github.com/KikiManjaro/KikAis/releases/tag/2.5.0
[2.4.0]: https://github.com/KikiManjaro/KikAis/releases/tag/2.4.0
[2.3.0]: https://github.com/KikiManjaro/KikAis/releases/tag/2.3.0
[2.2.0]: https://github.com/KikiManjaro/KikAis/releases/tag/2.2.0
[2.1.1]: https://github.com/KikiManjaro/KikAis/releases/tag/2.1.1
[2.1.0]: https://github.com/KikiManjaro/KikAis/releases/tag/2.1.0
[2.0.1]: https://github.com/KikiManjaro/KikAis/releases/tag/2.0.1
[2.0.0]: https://github.com/KikiManjaro/KikAis/releases/tag/v2.0.0
[1.2.x]: https://github.com/KikiManjaro/KikAis/releases
