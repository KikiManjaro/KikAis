# Copilot Instructions — KikAis

> See `@AGENTS.md` for the full project spec (stack, commands, architecture, boundaries). This file adds Copilot-specific scoping.

- **Stack:** Flutter stable + Dart ^3.9.0 + `provider` + `flutter_map` + `bitsdojo_window` — do not suggest `riverpod`/`bloc`/`window_manager`.
- **Always:** use `HoverTooltip` (`lib/widgets.dart:15`) not `Tooltip`; use `InkRipple.splashFactory` (`lib/themes.dart:185`); use granular `AppSettings.saveFeedEnabled()` not `save()`.
- **NMEA:** always use `applyNmeaFormat`/`buildTagBlock` (`lib/ais/src/nmea/nmea_format.dart`) — never hand-build tag blocks.
- **Verify before done:** `flutter analyze` (0 warnings) + `flutter test` must pass. For i18n: `flutter gen-l10n` + check `lib/l10n/untranslated.json == {}`.
- **Do not edit:** `lib/l10n/generated/**`, `.dart_tool/`, `build/`, `pubspec.lock`, `resources/rtlsdr/windows/*.dll`.
