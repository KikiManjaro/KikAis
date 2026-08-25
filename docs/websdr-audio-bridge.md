# WebSDR Classic Audio Bridge (PA3FWM) — expérimental

Classic WebSDR (`DJ8FD Berlin`, `Silec`, `EA2F Bilbao`, `F1AFJ Brest`…) n'expose pas de RTL-TCP brut, seulement `GET /~~stream?v=11&f=161975000&band=2&mode=nfm` en **a-law 12 kHz mono** déjà FM-démodulé (companding ITU G.711, filtre NFM, 1 seul canal).

Pont KikAis (`lib/websdr/websdr_audio_bridge.dart`) : `http.Client GET` → `a-law decode[256]` → `Float64 resample 12k→64k` (linéaire) → normalisation DC `gain = π/2/peak` → synthèse FM `phi += gain*sample + mixStep` → `zero-stuff ×16 → CU8 1.024 MHz (128 centre)` exactement comme `tool/ais_replay.dart:195` → `AisDemodulator.process()` en **Isolate** (`_entry`) → `WebsdrFeedPlayer` pour `type==webSdr/custom`.

Flag `AppSettings.enableClassicWebSdrAudio` (défaut `true`, persistance `classicWebSdrAudio`) — désactivable pour respecter la FAQ `websdr.org` qui déconseille les clients tiers (risque ban). Kiwi IQ reste sur `KiwiIqBridge` (`ws://` SND) ; `kiwi_sdr 0.0.2` pub.dev consulté (audio seul, pas d'IQ) — pont custom conservé pour IQ.
