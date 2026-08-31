# Contributing to KikAis

Thanks for considering a contribution!

## Quick Start

```bash
flutter pub get                          # also triggers gen-l10n
flutter gen-l10n                         # after any ARB edit; must leave lib/l10n/untranslated.json == {}
flutter analyze                          # must be 0 errors (strict lints enabled)
flutter test                             # all tests must pass
pwsh scripts/check.ps1                   # single-command gate: format + analyze + test
```

See `AGENTS.md` for the full project spec, architecture, and gotchas.

## Workflow

1. Fork and create a feature branch from `main` (`feat/*`, `fix/*`, `docs/*`, `ci/*`).
2. Make focused commits (Conventional Commits: `feat(scope):`, `fix(scope):`, `docs:`, `ci:` …).
3. Run `flutter analyze` and `flutter test` locally — CI will enforce the same.
4. If you touched translations (`lib/l10n/*.arb`), run `flutter gen-l10n` and verify `lib/l10n/untranslated.json == {}`.
5. Open a pull request against `main` using the PR template.

## Code Style

- `dart format lib test` (trailing commas, ~80 chars).
- `const` constructors where possible. Widgets are classes, not functions returning `Widget`.
- `provider` for state management — `context.select`/`watch` in `build`, `context.read` in callbacks.
- `debugPrint` for logging, not `print` (enforced by `avoid_print` lint).
- Comments explain *why*, not *what*.

## Windows Gotchas

- **Never use stock `Tooltip` with `ListView`** — use `HoverTooltip` (`lib/widgets.dart`) to avoid a Flutter engine crash (flutter/flutter#182444).
- **Never use `InkSparkle`** — `lib/themes.dart` forces `InkRipple.splashFactory` to avoid shader stalls.
- Use granular `AppSettings.save*()` methods, not blanket `save()` (avoids UI stalls on Windows).

## Internationalization

- `l10n.yaml` drives `flutter gen-l10n` → `lib/l10n/generated/` (never edit generated files).
- 10 locales: `en fr es de pt it nl zh ja ru`. See `docs/i18n.md` for the full guide.
- Keep `{placeholder}` names identical across all ARB files.

## Reporting Issues

Open an [issue](https://github.com/KikiManjaro/KikAis/issues) with steps to reproduce, expected vs actual behavior, and your OS/Flutter version.

## License

By contributing, you agree that your contributions will be licensed under the same [custom source-available license](LICENSE) as the project.
