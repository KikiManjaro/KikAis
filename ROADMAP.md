# KikAis — ROADMAP

> Feuille de route vivante. Source de vérité pour les priorités. Triée par **impact × urgence**, pas par catégorie. Inspirée du `README.md:177 Backlog` + audit complet `AGENTS.md` + retours LLM best-practices.
> Chaque item porte `impact | effort | risque | dépendances`. Mettre à jour à chaque release + cocher les cases.

**Légende impact:** 🔴 bloquant/crash · 🟠 perf majeure · 🟡 fonctionnel demandé · 🔵 qualité/dette · 🟣 polish
**Effort:** XS <2h · S <1j · M 1-3j · L 1s · XL >1s

---

## P0 — Stabiliser (faire maintenant)

### P0.1 Finaliser le durcissement LLM entamé — 🔵 S
- **Quoi:** corriger `reception_page.dart:1256` `cacheExtent` → `scrollCacheExtent` propre (le `dart fix` a généré `ScrollCacheExtent.pixels(400)` invalide, à revert).
- **Pourquoi:** le `dart fix` a laissé 1 ligne invalide.
- **Done when:** `flutter analyze` 0 + `pwsh scripts/check.ps1` vert sans fallback.
- **Source:** audit strict `analysis_options.yaml:11`

### P0.2 Nettoyer le diff format 132 fichiers — 🔵 XS
- **Quoi:** commit isolé `style: dart format` pour les 6131 insertions `dart format`/`dart fix`. Sans ça, chaque PR porte 132 fichiers de bruit.
- **Pourquoi:** `git diff --stat HEAD` illisible; agent confond format et logique.
- **Done when:** `git status` ne montre plus 110 fichiers `M` format-only.

### P0.3 Linux boot aléatoire — 🔴 S
- **Quoi:** `README:154` "app will sometimes not boot on Linux (Raspberry Pi)" — investiguer `bitsdojo_window` init vs `doWhenWindowReady` race, `lib/main.dart:61` `appWindow.show()` sans `await` + `WidgetsFlutterBinding.ensureInitialized` timing.
- **Pourquoi:** Seul bug bloquant multi-plateforme; Linux est 2e target.
- **Done when:** 10 boots successifs sur Pi sans retry.

### P0.4 Pipeline unique NMEA + état connexion — 🟠 M
- **Quoi:** `README:178` "Logs processing for NMEA sentences and connection state are in the same pipeline causing some issues between them since there is only one processor" — séparer `ForwarderService._handleData` (NMEA) et `FeedStatus` (ValueNotifier) en 2 streams. Aujourd'hui `_FeedConnection.listen` appelle `onData` et `_setStatus` entremêlés.
- **Pourquoi:** Cause des `0.0/s` + log "Feed disconnected" interleaved avec trames; root cause des stalls perf.
- **Done when:** `FeedStatus` ne passe plus par `onLog`, 2 canaux distincts + test `feed_status_test.dart`.

---

## P1 — Perf & fiabilité (prochaine release 2.7.0)

### P1.1 Log viewport pour grosses réceptions — 🟠 M
- **Quoi:** `README:188` + `AGENTS.md:50` `maxLogEntries 2000`, flush 120ms/60 mais pas de virtualisation hauteur variable. Implémenter `ListView.builder` + `SliverPrototypeExtentList` ou `scrollable_positioned_list`, mémoïser `NmeaLogText` spans, `cacheExtent` adaptatif, fade pour frames >200c.
- **Pourquoi:** Map laggy à 300+ msg/s (README:155); log est le hotspot.
- **Done when:** 10k lignes log <16ms/frame sur Windows Skia.

### P1.2 Isolate & throttling — 🟠 M
- **Quoi:** `README:188` "throttle reception burst (chunked simulator emission, batched isolate decode, batched feedStatuses notify)". Aujourd'hui `BoatManager._sendBuf` atomique par msg; batcher par 10 + `SimFleet.advanceAndCollect` émettre par chunk; `feedStatuses` notifier par 50ms pas par msg.
- **Pourquoi:** `PerfProbe.pendingHandleData >100` + `backlogEvents` déjà instrumentés mais pas de backpressure.
- **Done when:** `PerfProbe.backlogEvents == 0` à 500 msg/s simulés.

### P1.3 Skia micro-freezes — 🟠 S (en attente Flutter)
- **Quoi:** `README:156` Skia `SkSL::Compiler::convertProgram` 27-70ms + 1.3s mount. Dev: `flutter run --enable-impeller` déjà doc. Release: attendre Impeller default Windows.
- **Pourquoi:** Plus gros irritant UX Windows.
- **Done when:** Flutter stable passe Impeller default.

### P1.4 Mémoire & TTL — 🟡 M
- **Quoi:** `README:181` "Make verification for memory leaks and performances". `boatTtl 30m` purge O(n) 1m, `Boat.frameLog 200` × 10k boats = 2M frames RAM. Passer à `SplayTreeSet` par `lastUpdate`, LRU global, `WeakReference` pour `Boat` images.
- **Pourquoi:** OOM sur réception longue durée.
- **Done when:** heap stable sur 24h replay `tool/ais_replay.dart --cu8`.

---

## P2 — Fonctionnel cœur (2.7.0-2.8.0)

### P2.1 Filtre à la réémission — 🟡 L
- **Quoi:** `README:179` "Add the ability to filter what is forwarded (by message type, geographic zone, vessel, etc.)". UI dans `send_page.dart` + `TargetConfig` ajouter `filterByTypes: Set<int>`, `filterByBounds: LatLngBounds?`, `filterByMmsis`.
- **Pourquoi:** Demande #1 pour usage pro (relais sélectif).
- **Done when:** `ForwarderService._send` applique filtre + test `target_config_test.dart`.

### P2.2 Couleurs dans le log — 🟡 S
- **Quoi:** `README:186` "Add colors to log (to visually split provider, nmea 4.0 tags, sentence, payload etc)". Colorer `NmeaLogText` spans: `tagBlock` gris, `!AIVDM` bleu, `payload` blanc, `checksum` vert/rouge.
- **Pourquoi:** Lisibilité.
- **Done when:** snapshot `nmea_log_text_test.dart`.

### P2.3 Corriger `0` en fin de trames générées — 🟡 S
- **Quoi:** `README:185` "Look at why generated frame have a bunch of 0 at the end". `lib/ais/src/encoder/ais_payload_encoder.dart` padding `fillBits` mal calculé; comparer avec `ais-decoder` externe (`README:183`).
- **Pourquoi:** Trames générées semblent non conformes, à vérifier si c'est vraiment un problème.
- **Done when:** `encoder_roundtrip_test.dart` + validation `ais-decoder` externe 0 diff.

### P2.4 Validation externe & harness — 🔵 M
- **Quoi:** `README:182-183` "Extend ais_replay.dart as regression harness" + "Test with ais-decoder". Ajouter `tool/ais_replay.dart --verify-external` qui pipe vers `ais-decoder` npm, comparer `MessageFactory.create`.
- **Pourquoi:** Confiance encodeur.
- **Done when:** CI job `verify-ais` vert.

### P2.5 Panneau Avancé — exposer les micro-réglages en dur — 🟡 M
- **Quoi:** inventaire complet des constantes aujourd'hui hard-codées + UI `Settings > Advanced` (behind `kAdvanced` toggle) persistées dans `AppSettings`/`SharedPreferences`. Recherche systématique (grep `static const` / `Duration` / magic numbers) :
  - **Carte/boat:** `BoatManager.boatTtl 30m` + `purgeInterval 1m` (`boatmanager.dart:23`), `Boat.maxFrameLog 200` (`boat.dart:54`), `notifyThrottle 200ms` (`boatmanager.dart:25`), `trail length 24` + `_kAnimDuration 600ms` + `cluster cellSize 44` / hit 16-20px + vecteur `clamp 10-50` (`boat_map_layer.dart:10,148,177,221`), `feedStaleAfter 10s` (`reception_page.dart:34`), `initialZoom 5.0 / Paris 48.85,2.35` (`world_map_page.dart`)
  - **Pipeline:** `_decodeBatchSize 8` + microtask batch (`boatmanager.dart:26`), `TargetSendQueue.maxPending 2048` (`forwarder_service.dart:37`), `_statusUpdateInterval 50ms` (`forwarder_service.dart:109`), `reconnectDelay 5s` + `_watchdogInterval 15s` + `_silentTimeout 45s` + TCP keepalive 30/10/3 (`forwarder_service.dart:117,519`), `PerfProbe` thresholds `pendingHandleData>100` / `backlogEvents`
  - **Réception/log:** `_logFlushDelay 120ms` + `_logFlushMaxBatch 60` (`reception_page.dart:96`), `maxLogEntries` désormais unbounded disque, `message_stats` sampler `1s` (`message_stats.dart:37`), `FileFeedPlayer interval 1000ms loop` + `kBaudRates [...]` (`reception_page.dart:1420`), `NmeaBuilder maxChars 82`
  - **Simulation/SDR:** `SimFleet kStaticEveryTicks 5` (`sim_fleet.dart:10`), `SimulatorService _syncGenerationThreshold 1000` (`simulator_service.dart:32`), `sdr: kAisOutputRate 64000 / kAisInputRate 1024000 / kKnownSymbols 32 / kMaxDataSymbols 600`, `RtlSdr deadline 5s + poll 5-20ms`
  - **UI divers:** `HoverTooltip delay 500ms` / durations 120/180ms, `UpdateNotifier _startupTimeout 3s`, `StatsPage` durations 300/400/1100ms
- **Pourquoi:** demandé — pouvoir ajuster TTL, batch, queues, timeouts, seuils sans recompiler; indispensable pour tuning 2k msg/s ×3 targets sur machines lentes/rapides.
- **Comment:** `AppSettings` nouvelles clés `boatTtl`, `purgeInterval`, `notifyThrottle`, `frameLogCap`, `trailLen`, `animMs`, `clusterCell`, `logFlushMs/batch`, `feedStaleMs`, `decodeBatch`, `targetQueueCap`, `reconnectMs/watchdogMs/silentMs` — defaults = valeurs actuelles, validation bornes (ex: TTL 1-120m), migration `load()` garde defaults si absent, UI `ExpansionTile Advanced` avec reset defaults.
- **Done when:** tous les hard-codés ci-dessus deviennent `AppSettings` lus (0 `static const` restant hors `const` sémantique), `flutter analyze` 0 + `flutter test` verts + doc `docs/advanced-tuning.md` + entrée `P1.4/P1.2` réutilise les mêmes réglages.
- **Risque:** explosion combinatoire; garder profils `Default / Low-end / High-throughput` + garde-fous.

---

## P3 — UX / Produit

### P3.1 Mode compact / minified — 🟡 M
- **Quoi:** `README:184` "Compact/minified mode always-on-top pin (top bar, FFI Win32 SetWindowPos / window_manager)" + `README:187` "Minified mode". 2 items = 1 feature: toggle `Size(640,480)` → `Size(320,80)`, `SetWindowPos(HWND_TOPMOST)`, `MoveWindow` seul.
- **Pourquoi:** Usage overlay carte.
- **Done when:** bouton pin top bar + `flutter run --enable-impeller` ok.

### P3.2 Onboarding first-run — 🔵 S
- **Quoi:** Wizard 3 étapes: langue → feed (choisir Kikistream/Sinagot) → Start. Aujourd'hui `AppSettings.load()` met `null` système, user ne sait pas qu'il faut enable + Start.
- **Pourquoi:** Drop-off新規.
- **Done when:** `showOnboarding` si `feedEnabled.isEmpty`.

### P3.3 Accessibilité HoverTooltip — 🔵 XS
- **Quoi:** `widgets.dart:15` OverlayEntry sans `Semantics`. Ajouter `Semantics(label: message, tooltip: message)`.
- **Pourquoi:** Screen reader.

---

## P4 — Plateforme & compat

### P4.1 macOS / iOS / Android — 🟡 XL
- **Quoi:** `README:180` "Improve compatibility with other platforms". Migrer `bitsdojo_window` → `window_manager` (support macOS) ou conditionnel `Platform.isWindows ? bitsdojo : window_manager`. Ajouter `Info.plist` + `AndroidManifest` permissions.
- **Pourquoi:** Demande communauté.
- **Done when:** `flutter build macos --release` + `flutter build apk` verts.

### P4.2 Auto-update Linux — 🔵 S
- **Quoi:** `auto_updater` WinSparkle Windows seul. Linux: `package_info_plus` + `http` check GitHub releases, notif manuelle.
- **Pourquoi:** Parité.

---

## P5 — Qualité, tests, docs, LLM

### P5.1 Split fichiers >300l — 🔵 M
- **Quoi:** `reception_page.dart:1883`, `sim_fleet.dart:1490`, `documentation_content.dart:560`, `asm_formats.dart:824` → `reception/` `feed_tiles.dart`, `reception_log.dart`, `_AddFeedDialog.dart` — research: AI préfère 300l max, feature-based.
- **Pourquoi:** Contexte LLM + maintenabilité.

### P5.2 Barrel files & boundaries — 🔵 S
- **Quoi:** `lib/ais/ais.dart`, `lib/sdr/sdr.dart`, `analyzer.yaml` `banned_imports` (ex: `lib/widgets` cannot import `sdr`). Research: barrel = -96% tokens.
- **Done when:** `dart analyze` 0 + `import` check CI.

### P5.3 CI hardening — 🔵 XS
- **Quoi:** `ci.yml` passer à `--fatal-infos --fatal-warnings` (maintenant que 0 issues), ajouter `dart format --set-exit-if-changed .`, cache `pub` fin.
- **Source:** `AGENTS.md:17` `flutter analyze` must be 0 (strict).

### P5.4 Docs vivantes — 🔵 S
- **Quoi:** `docs/ARCHITECTURE.md` ADRs: pourquoi isolate vs `Isolate.run`, `bitsdojo_window` vs `window_manager`, `provider` vs `riverpod`; `llms.txt` pour `kikimanjaro.github.io/KikAis` (Chrome Lighthouse audit 2026).
- **Done when:** ADR 3 entrées.

### P5.5 Invariant tests — 🔵 M
- **Quoi:** `boatTtl` jamais <0, `applyNmeaFormat` idempotent, `boatsVersion` monotone — pattern PostHog invariant tests.
- **Done when:** 10 tests invariants.

### P5.6 Maintenance AGENTS.md — 🔵 XS (récurrent)
- **Quoi:** Prune mensuel `AGENTS.md` (<150l, <32 KiB), vérifier `flutter gen-l10n` + `untranslated.json == {}`. Stale > none (Cloudflare). déjà `CLAUDE.md → @AGENTS.md`, `.github/copilot-instructions.md`.
- **Done when:** check dans PR template coché.

---

## Sources & priorisation

- **README Backlog 10 items** intégrés: `P0.4, P1.1, P1.2, P2.1-2.4, P3.1`. Restant `P0.3 Linux boot` et `P1.3 Skia` sont Known Bugs.
- **Tri:** P0 = crash/data-loss ou dette bloquant CI (format 132 fichiers). P1 = perf perçue (log, isolate, Skia). P2 = fonctionnel demandé. P3+ = polish/plateforme.
- **Dépendances:** `P0.2` avant toute PR; `P0.4` avant `P2.1`; `P1.1` avant `P2.2`; `P5.1` avant `P5.2`.

> Mettre à jour ce fichier à chaque `chore(release): bump to x.y.z` + cocher `docs/i18n.md` si ARB touché. Garder <200 lignes.
