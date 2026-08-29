# KikAis — AGENTS.md

> AIS NMEA 0183 forwarding & visualization hub. Desktop Flutter app (Windows primary, Linux) that receives, decodes (isolate), maps and rebroadcasts live AIS streams. Single-window, 8-tab `IndexedStack`.

## Tech Stack

- **Flutter stable + Dart ^3.9.0** · `flutter_lints` + strict `analysis_options.yaml:11` (`strict-casts/inference/raw-types`) · `provider 6.0.5` (only state mgmt)
- **Desktop:** `bitsdojo_window 0.1.6` custom chrome · `flutter_map 8.3.1` + `latlong2` · `shared_preferences` persistence
- **IO:** `flutter_libserialport` · `file_selector` · `url_launcher` · `http`/`archive`/`crypto` · `auto_updater` (WinSparkle) + `package_info_plus`
- **Version:** `pubspec.yaml:19` `2.6.4` (`publish_to: none`, `flutter: generate: true`)

## Setup & Commands — copy-paste, in order

```bash
flutter pub get                          # also triggers gen-l10n
flutter gen-l10n                         # after any ARB edit; must leave lib/l10n/untranslated.json == {}
flutter analyze                          # must be 0 errors (strict-casts/inference/raw-types enabled)
flutter test                             # 48 tests (unit + widget + tools_data + sdr)
flutter test test/boatmanager_test.dart  # single file
flutter test --name "MMSI lookup"        # single test by name
pwsh scripts/check.ps1                   # single-command verify: format + analyze + test (MUST run before done)
flutter build windows --release
flutter build linux --release            # needs sudo apt install libgtk-3-dev ninja-build
flutter clean                            # after adding/upgrading a native plugin

# SDR / DSP harness (no live dongle needed)
dart tool/sdr_probe.dart --list
dart tool/ais_replay.dart --cu8 capture.cu8
dart tool/ais_replay.dart --audio ais.wav --rate 48000

# Full Windows artifacts (zip + portable exe + installer + appcast)
pwsh scripts/build_release.ps1
pwsh scripts/build_release.ps1 -SkipBuild   # reuse existing build/windows/x64/runner/Release
```

Dev perf quirk: run with `flutter run --enable-impeller` on Windows to avoid Skia shader stalls (README Known Bugs); release builds are Skia until Impeller becomes default.

## Project Structure

```
lib/main.dart               entry: BoatManager.startDecoder() → AppSettings.load() → UpdateNotifier (fire-and-forget) → bitsdojo_window
lib/swipper.dart            8-tab IndexedStack + WindowBorder/TitleBar + NavigationBar (reception/send/map/editor/tools/stats/simulation/docs)
lib/boatmanager.dart        central Map<int,Boat> + isolate decoding (see Architecture)
lib/boat.dart               Boat/BoatKind + frameLog (200 cap)
lib/app_settings.dart       SharedPreferences ChangeNotifier (granular saves)
lib/themes.dart             AppTheme dark/light/highContrast + AppColors extension + InkRipple.splashFactory
lib/forwarder_service.dart  N feeds → applyNmeaFormat → N TargetConfigs
lib/feed_def.dart           FeedType network/file/serial/rtlsdr + kFeedDefs (6 built-ins)
lib/target_config.dart      TargetConfig UDP Server/Client + TCP Server/Client
lib/reception_page.dart     feed tiles (cached) + log (2000 cap, 120ms batched flush) + simulation wiring
lib/world_map_page.dart + boat_map_layer.dart + basemaps.dart + weather_*  map + clustering/trails/vectors
lib/sim_fleet.dart + simulator_service.dart    SimFleet generation (>1000 via compute())
lib/sdr/                    rtlsdr_ffi/device/feed_player + ais_catcher_process/feed_player + dsp/
lib/ais/                    nmea (sentence/tag_block/format/assembler/decoder) + message_factory + messages/** (27 types) + encoder/** + utils
lib/tools/ + tools_data/    8 tools hub (checksum/MMSI/binary/ETA/radio_range/speed…) + 7 pure data helpers
lib/l10n/                   10 ARB (app_en template) + generated/ (never edit) + translations_data_*.dart + country_names/value_labels
lib/widgets.dart            HoverTooltip / CopyIconButton / SectionHeader / TintedCard (NOT stock Tooltip)
test/                       mirrors lib/ + l10n_test_utils.dart: withLocalizations()
tool/                       sdr_probe.dart, ais_replay.dart (regression harness)
scripts/                    check.ps1 (single verify), build_release.ps1, make_portable.ps1, make_setup.ps1, fetch_*.ps1
docs/                       i18n.md (canonical), i18n/*.json, superpowers/specs/
.github/                    workflows/ci.yml|release.yml + copilot-instructions.md + pull_request_template.md
CLAUDE.md                   → @AGENTS.md bridge (Claude Code); AGENTS.md is canonical
```

Generated: `lib/l10n/generated/**` only. No `*.freezed.dart`/`*.g.dart` in this repo.

## Architecture & Critical Gotchas — read before editing

**Isolate decoding (`lib/boatmanager.dart:22`):** `startDecoder()` spawns isolate with `AisNmeaDecoder`. Main sends `List [feed, line, ts]` via pre-allocated `_sendBuf` (avoid GC at 300+ msg/s). Isolate replies `_DecodedWithFeed(message, feed, rawLines)` + `int ts` RTT + `DecoderReport`. Fallback to `_fallbackDecoder` if spawn fails. Protocol toggles: `bool validateChecksum`, `String 'reset'`. Measure via `lib/perf_probe.dart` (`PerfProbe`).

**Throttling (`lib/boatmanager.dart:25`):** `notifyThrottle 200ms`, `_throttleTimer`, `boatsVersion++` on mutation. Map memoizes visible boats on `boatsVersion` — don't call `notifyListeners()` per message.

**TTL:** `boatTtl 30m`, `purgeInterval 1m` (`purgeStaleBoats()`).

**NMEA pipeline (`lib/ais/src/nmea/`):** `NmeaTagBlock.split` → `NmeaSentence.tryParse` (payload may contain commas) → checksum XOR (`isChecksumValid`) → `FragmentAssembler` (5s timeout, key `sequentialId|channel`, dedupe) → `MessageFactory.create(payload,true)` (27 types) → `BoatManager.updateFromMessage`. Counters `invalidChecksumCount/droppedFragmentCount/parseErrorCount/pendingFragmentCount/fragmentsSeen/multiPartCompleted` via `DecoderReport`.

**NMEA formatting (`lib/ais/src/nmea/nmea_format.dart`):** `NmeaFormat {passthrough, strip, tag}` + `applyNmeaFormat(line, format, sourceId)` + `buildTagBlock(s:,t:msSinceUtcMidnight,c:)`. Reception import format `AppSettings.nmeaImportFormat` + `nmeaImportTagSource`; per-target `TargetConfig.sendFormat/tagSourceId`. Use helpers, don't hand-build tag blocks.

**Forwarder (`lib/forwarder_service.dart`):** `ForwarderService.feedStatuses: ValueNotifier<Map<String,FeedStatus>>`, `_FeedConnection` (Socket + reconnect 5s) + `_TargetConnection` (UDP/TCP). `FeedStatus {connecting, connected, error, messageCount, lastMessageAt}` consumed by `reception_page.dart:46 feedDotColor()` grey/red/orange/green via `feedStaleAfter 10s`. `_handleData` normalizes via `importFormat`, forwards to all enabled targets, `onLog`. Fire-and-forget `tcp flush` — never `await` it in pipeline.

**ReceptionPage (`lib/reception_page.dart`):** `maxLogEntries 2000`, flush `120ms/60` batched, `_tilesCache` per-feed (checkbox only rebuilds tile; dot repaints via `_FeedStatusDot` listening to `feedStatuses` + 1s `_statusTick`), `_statusTimer` gated on `isRunning`. Post-frame defer BoatManager setters to avoid `setState() during build`. `sendRaw()` logs + forwards.

**Windows engine traps — never regress:**
- **Never use stock `Tooltip` with `ListView`** — crashes `flutter_windows.dll` AXTree (`flutter/flutter#182444`). Always `HoverTooltip` (`lib/widgets.dart:15` OverlayEntry+MouseRegion).
- **Never `InkSparkle`** — `lib/themes.dart:185` forces `InkRipple.splashFactory`.
- **`bitsdojo_window` only** — not `window_manager`. `WindowBorder` + `MoveWindow` + `WindowButtons` in `swipper.dart:103`.

**Persistence (`lib/app_settings.dart`):** `SharedPreferences` with granular `saveFeedEnabled()`, `saveTheme()`, `saveLocale()` etc. Toggling a feed via `save()` rewrites every pref and stalls frame on Windows (sync IO) — always use granular saves.

**Simulation:** `SimFleet.generate()` ≤1000 sync, >1000 `compute(generateFleetIsolate)`. `SimulatorService` timer emits `onSentence → forwarderService.ingest('Simulation',…)`.

## Code Style & Conventions

- `flutter analyze` zero warnings; `dart format lib test` (trailing commas, 80-ish).
- `const` constructors where possible. Widgets are classes, not functions returning Widget.
- Provider: `context.select`/`watch` in build, `context.read` in callbacks. `ChangeNotifierProvider.value` for singletons created in `main()`.
- `log` via `debugPrint`, not `print`. Comments explain *why*.
- Naming: `camelCase` keys (`tab*`, `send*`, `field*`, `msgType*`, `log*`); file `snake_case`.
- Never invent commands/paths — verify before running.

## Internationalization — see `docs/i18n.md` (canonical)

- `l10n.yaml: arb-dir lib/l10n, template app_en.arb → lib/l10n/generated/app_localizations.dart` (`AppLocalizations`). Never edit `generated/`.
- 10 locales: `en fr es de pt it nl zh ja ru` (`lib/l10n_ext.dart:13 kSupportedLocaleCodes`, `resolveSystemLocaleCode`). Top bar globe → `AppSettings.localeCode` (`null`=system).
- Conventions: ICU placeholders/plurals; keep `{placeholder}` names identical across ARBs or `gen-l10n` fails. Do NOT translate acronyms/units/proper nouns/basemap attributions (full list in `docs/i18n.md:72`).
- Adding a locale: copy ARB → translate → `flutter gen-l10n` → register in `l10n_ext.dart` + `swipper.dart:_languageName` → add `languageXx` in every ARB → add `translations_data_<code>.dart` + `country_names.dart`/`value_labels.dart` → `analyze` + `test`.
- Check: `lib/l10n/untranslated.json` must be `{}`. Use `withLocalizations(child)` (`test/l10n_test_utils.dart:8`) in widget tests (assert English).

## Testing Instructions

```bash
flutter test                          # all 48 (vendor/decoder_test.dart excluded from CI coverage)
flutter test test/decoder_page_test.dart
flutter test --plain-name "HoverTooltip"
```

- Location mirrors `lib/`; `test/tools_data/`, `test/sdr/` separate.
- Always add/update tests for changed code; keep `flutter analyze` + `flutter test` green before PR.
- For file/serial/RTL-SDR, tests mock FFI (`listRtlSdrDevices()` returns `[]` when DLL missing).
- **Single-command gate:** `pwsh scripts/check.ps1` runs format + analyze + test — use it as the final check before claiming done (mirrors CI).

## Git & Release Workflow

- **Branch:** `main` trunk · `feat/*` feature branches · `linux` fork · `gh-pages` deploy target. Worktree `.worktrees/` is gitignored — use it.
- **Commits:** aspire to Conventional Commits `feat(scope):`, `fix(scope):`, `chore(release):`, `docs:`, `perf:`, `ci:` with scopes `rtlsdr|stats|pages|release`. Keep imperative, low-case after colon.
- **Version:** `pubspec.yaml: version: 2.6.4` (+build). Release is tag-driven (`release.yml:6 tags: v*|[0-9]*` + `workflow_dispatch`). Tag semver must match pubspec (warns on mismatch). CI extracts `version` via `sed` (`release.yml:29`).
- **CI (`ci.yml`):** `push main` + `pull_request main`, `concurrency: ci-${ref} cancel-in-progress`. Jobs `analyze` → `test` → `secrets-scan` (gitleaks) → `build-windows` (only `push main`, needs analyze+test).
- **Release (`release.yml`):** `version` → `build-windows` (zip + portable via `make_portable.ps1` + Inno `make_setup.ps1` + appcast `build/pages` → `gh-pages`) → `build-linux` → `release` (`softprops/action-gh-release`).
- **Push policy:** rebase preferred; no force-push `main`.

## Boundaries — Always / Ask / Never

**Always do:**
- Run `flutter analyze` + `flutter test` before pushing/PR. <!-- Reason: prevents regressions; CI fails otherwise -->
- `flutter gen-l10n` after any ARB change; verify `untranslated.json`. <!-- Reason: gen-l10n is the only source of truth for l10n -->
- Use `HoverTooltip` instead of `Tooltip`; `InkRipple.splashFactory`. <!-- Reason: Windows engine crash flutter#182444 + shader stall -->
- Use granular `saveFeedEnabled`/`saveTheme`/`saveLocale`, not blanket `save()`. <!-- Reason: blanket save stalls UI on Windows sync IO -->
- Reference existing `docs/`, `analysis_options.yaml`, `l10n.yaml` rather than duplicating.

**Ask first:**
- New native plugin / `pubspec.yaml` dep bump major · `minSdk`/`Info.plist` permission · route rename in `swipper.dart` · `android/`/`ios/`/`windows/` runner edits · version/tag bump · deep-link / Inno Setup change · re-enabling `ink_sparkle`.

**Never do:**
- Edit `lib/l10n/generated/**`, `build/`, `.dart_tool/`, `pubspec.lock` directly (edit `pubspec.yaml` + `flutter pub get`), `resources/rtlsdr/windows/*.dll` by hand (use `scripts/fetch_rtlsdr_drivers.ps1`), `.worktrees/` commits, `installer/` artifacts, or commit secrets/`.env`/`tools/` downloads.
- Commit `*.exe`/`*.zip`/`*.tar.gz` (gitignored). Run `scripts/check_ui.ps1` locally for UI checks.
- Await TCP `flush()` in pipeline; block UI isolate; inline tag-block strings.

<!-- Maintenance: stale AGENTS.md is worse than none (Cloudflare study). Prune monthly; keep <150 lines. Verify commands still run before each release. -->

## References — lazy-load only when task-relevant

- `README.md` — features, screenshots, RTL-SDR Zadig setup, known bugs/roadmap
- `docs/i18n.md` — full i18n spec (keys, placeholders, adding a language)
- `analysis_options.yaml` + `l10n.yaml` + `pubspec.yaml` — lint/l10n/deps source of truth
- `lib/boatmanager.dart:141 _decoderEntry` · `lib/ais/src/nmea/ais_decoder.dart:30 AisNmeaDecoder` · `lib/forwarder_service.dart:64 ForwarderService`
- `lib/widgets.dart:15 HoverTooltip` · `lib/themes.dart:185 splashFactory`
- `.github/workflows/ci.yml` · `.github/workflows/release.yml` · `scripts/build_release.ps1`

> Keep this file <150 lines and <32 KiB. When referencing `@docs/...` in chat, the agent should `Read` that file on demand — don't preload all docs.
