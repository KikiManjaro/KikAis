# KikAis: AIS Data Forwarding and Visualization Tool

KikAis is a desktop application built using the Flutter framework, designed to operate as a central hub for receiving, 
processing, and redistributing Automatic Identification System (AIS) NMEA 0183 data. 
This tool aggregates real-time vessel data from multiple sources—including public streams and a "private" server (see aisstreamio2nmea part of the project)—and
broadcasts it across various network protocols.

The application’s core function is dual-layered: first, it manages the low-level network connections and data forwarding via various protocols (UDP/TCP); 
second, it processes the received NMEA 0183 messages to extract vessel information and visualize their positions in real-time on a world map. 
This architecture ensures high-performance data handling while maintaining a responsive and informative user interface. 
The UI is organized around seven tabs:
- **Reception** — connection management, feeds and the log console
- **Send** — the forwarding destinations (read-only by default)
- **Map** — the real-time vessel visualization
- **Editor** — build and send your own AIS messages (all 27 types)
- **Decoder** — paste and decode NMEA sentences
- **Stats** — live statistics and the accounting of received vs decoded messages
- **Simulation** — configure and emit a fleet of vessels around a chosen location

## Architecture

The architecture of KikAis was intentionally designed to address the challenges inherent in handling high-volume, real-time network data, prioritizing performance, decoupling of concerns, and user experience.

Given that AIS messages arrive continuously, requiring rapid updates to both the UI logs and the map markers, 
an approach with fine-grained control over widget rebuilding was necessary.
The BoatManager holds the central vessel collection (Map<int, Boat>). When new messages arrive, the manager updates the relevant Boat object.
To prevent these computational tasks from blocking the main thread, the boat manager was designed to execute the parsing logic asynchronously.
By offloading the message decoding to an isolated thread, we ensure the UI remains smooth and map updates even while the underlying data stream is being heavily processed.
This single source of truth ensures the map page is instantly updated with minimal overhead, preventing the application from freezing under heavy data load (was happening a lot during the development).

The main application window is a single view implemented with an IndexedStack inside the SwipperUi widget, 
switched through a NavigationBar with seven destinations (Reception, Send, Map, Editor, Decoder, Stats, Simulation). 
A light/dark/high-contrast theme can be selected from the custom window title bar.
Note that the map only renders vessels when the "show decoded vessels" toggle is enabled (off by default) to avoid overload: 
using a heavy stream such as the one provided by aisstreamio2nmea (vessels all around the world) could still make the map stutter.

The app operates as follows:

1. Connects to a configurable list of external data feeds (built-in and user-defined) all transmitting AIS NMEA 0183 sentences.

2. The application acts as a relay, enabling the rebroadcast of the aggregated AIS data to every enabled destination
   (UDP server/client, TCP client/server). Forwarding is read-only by default: no destination is active until you enable one.

3. A dedicated log console provides immediate feedback on incoming data, displaying raw NMEA messages, connection status updates,
   and a copy button on every frame.

4. Integrates a world map to display the live positions of all reported vessels (marker clustering, trails, speed vectors,
   search and filters, and a detail panel with a per-vessel frame log).

5. Provides a decoder tab to paste and decode NMEA sentences (multi-part messages are regrouped into a single block) and an editor
   tab to compose and inject/send messages of any of the 27 supported AIS types.

6. A statistics tab summarizes the flow: received/decoded rates, checksum and parse errors, dropped and pending fragments,
   and an "accounting" view that reconciles the received vs decoded counters.

7. A simulation tab generates a configurable fleet of vessels around a chosen location (position reports, static data, base
   stations, aids to navigation...), fed into the same pipeline as a regular source. File feeds can also replay a saved
   NMEA log as a live stream.

## Misc

The AIS decoder in `lib/ais` (all 27 ITU-R M.1371 message types, including the NMEA/checksum/fragment pipeline and the message encoders used by the editor) is a vendored fork of [ais_decoder](https://github.com/LucasMnzb/ais_decoder) by LucasMnzb (BSD-3-Clause, see `lib/ais/LICENSE.ais_decoder.txt`), with the charset bug fix and the payload-based `getUintDirect` retained. The files have been adapted (relative imports, lints).

This app has been tested on both Windows and Linux.

I had to learn how to create a portable exe with [Enigma Virtual Box](https://enigmaprotector.com/),
how to build a proper installer with [Inno Setup](https://jrsoftware.org/isinfo.php) and wire auto-updates through [WinSparkle](https://winsparkle.org/),
how to make good LAF (Look And Feel) for windows using [bitsdojo_window](https://pub.dev/packages/bitsdojo_window),
how to learn about the [flutter_map](https://pub.dev/packages/flutter_map) library for vessels visualization.

Note that GPSD public feeds are not always up.

LLM have been used mainly to help me redact (and mostly translate) this README file in english and to help me to solve some bugs I have encountered while trying to connect multiple clients.

This app is still in development, i choose to provide it as it is since i think it is enough to fulfill the requirements of the end-of-year project,
some improvements are already planned and some bugs are already known, i'll keep working on it.

## Known Bugs & Roadmap

#### Known bugs

- The app will sometimes not boot on Linux (tested on raspberry pi), retrying to boot multiple times solves the issue
- The map page could be laggy when receiving too much data

#### Improvements

- Logs processing for NMEA sentences and connection state are in the same pipeline causing some issues between them since there is only
one processor, this should be reworked
- Add the ability to filter what is forwarded (by message type, geographic zone, vessel, etc...)
- Support for NMEA 4.0
- Add serial reception
- Improve compatibility with other platforms (running on macOS, iOS and Android)

## Images

*Main page:*

![img.png](readme_images/img.png)

*Console/Logs data:*

![img_1.png](readme_images/img_1.png)

*Map page:*

![img_2.png](readme_images/img_2.png)

*Map page with ships clustered:*

![img_3.png](readme_images/img_3.png)

*Map page with ships unclustered:*

![img_4.png](readme_images/img_4.png)

*Ships data:*

![img_5.png](readme_images/img_5.png)
