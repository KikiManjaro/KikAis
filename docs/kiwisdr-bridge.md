# KiwiSDR IQ Bridge — clean-room notes (Plan A)

Source publique : `jks-prv/Beagle_SDR_GPS` (GPL), `kiwisdrclient` Python, et SDR++ `SDRPlusPlus` Brown.

Protocole Kiwi (SND/IQ) :
- Transport : WebSocket `ws://host:port/kiwi/<n>/SND` (WS), pas HTTP.
- Handshake : client envoie `SET auth t=kiwi p=<pwd>` (pwd vide si ouvert), puis `SET ident_user=...`, `SET geoloc=...`.
- Mode IQ : `SET mod=iq` ou `SET mod=nfm` + `SET iq` selon fork ; trames binaires : header `SND` 6 bytes `[ 'S' 'N' 'D' flags seq ]` puis payload IQ int16 LE ou float32 selon `SET AR OK WT=...`.
- Tuning : `SET freq=161975000` (+ offset), `SET agc=0`, `SET lpf=...`.
- Référence Dart : aucune lib Flutter existante ; on utilise `dart:io WebSocket` (desktop) + `Isolate` pour `AisDemodulator.process(Uint8List)`.

Choix KikAis :
- Ne pas reverser WebSDR PA3FWM (`~~stream?v=11` a-law) sans accord auteur (FAQ websdr.org déconseille clients tiers, risque ban). Pont V1 = Kiwi IQ seul.
- Réutilise `lib/sdr/dsp/ais_demodulator.dart` déjà embarqué (GMSK 64 kHz, 2 canaux). Isolate dédié par feed.

Flow :
`WebsdrFeedPlayer (type kiwiSdr)` → `KiwiIqBridge.connect(host,port,freq=161975000)` → WS → binary IQ → `Isolate.run(AisDemodulator)` → `forwarderService.ingest(displayName, key, nmea)` + `status`.

Limitations honnêtes :
- Kiwi hardware 0-30 MHz natif : seuls les Kiwi avec transverter VHF/BBA couvrent 162 MHz ; filtre `coversAis` élargi garde `wideband`/`rtl` mais Kiwi reste filtré sauf bande marine stricte.
- OpenWebRX IQ (option C) fera l'objet d'un second bridge identique (`ws://host/ws/`).

Refs : `rx.skywavelinux.com/kiwisdr_com.js` (centaines Kiwi 0-30M), `rx.skywavelinux.com/static_rx.js` (54 entrées), `wiki.kiwisdr.com/wiki/KiwiSDR_client`, `github.com/pabr/ais-catcher` (seul RTL-TCP, pas de Kiwi/WebSDR).
