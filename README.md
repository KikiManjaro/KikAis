# KikAis: AIS Data Forwarding and Visualization Tool

KikAis is a desktop application built using the Flutter framework, designed to operate as a central hub for receiving, 
processing, and redistributing Automatic Identification System (AIS) NMEA 0183 data. 
This tool aggregates real-time vessel data from multiple sources—including public streams and a "private" server (see aisstreamio2nmea part of the project)—and
broadcasts it across various network protocols.

The application’s core function is dual-layered: first, it manages the low-level network connections and data forwarding via various protocols (UDP/TCP); 
second, it processes the received NMEA 0183 messages to extract vessel information and visualize their positions in real-time on a world map. 
This architecture ensures high-performance data handling while maintaining a responsive and informative user interface. 
The UI is organized around six tabs:
- **Reception** — connection management, feeds and the log console
- **Send** — the forwarding destinations (read-only by default)
- **Map** — the real-time vessel visualization
- **Editor** — build and send your own AIS messages (all 27 types)
- **Decoder** — paste and decode NMEA sentences
- **Stats** — live statistics and the accounting of received vs decoded messages

## Architecture

The architecture of KikAis was intentionally designed to address the challenges inherent in handling high-volume, real-time network data, prioritizing performance, decoupling of concerns, and user experience.

Given that AIS messages arrive continuously, requiring rapid updates to both the UI logs and the map markers, 
an approach with fine-grained control over widget rebuilding was necessary.
The BoatManager holds the central vessel collection (Map<int, Boat>). When new messages arrive, the manager updates the relevant Boat object.
To prevent these computational tasks from blocking the main thread, the boat manager was designed to execute the parsing logic asynchronously.
By offloading the message decoding to an isolated thread, we ensure the UI remains smooth and map updates even while the underlying data stream is being heavily processed.
This single source of truth ensures the map page is instantly updated with minimal overhead, preventing the application from freezing under heavy data load (was happening a lot during the development).

The main application window is a single view implemented with an IndexedStack inside the SwipperUi widget, 
switched through a NavigationBar with six destinations (Reception, Send, Map, Editor, Decoder, Stats). 
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

## File Breakdown

`main.dart`

The application entry point. 
It initializes the Flutter app, sets up the global providers (BoatManager, AppSettings, MessageStats), 
and applies desktop window settings (size, title, alignment) using bitsdojo_window.

`swipper.dart`

Manages the main user interface structure. It hosts the six tabs (Reception, Send, Map, Editor, Decoder, Stats) in an IndexedStack
with a NavigationBar, and defines the custom window control buttons and the theme picker.

`reception_page.dart`

Implements the Reception screen: managing the built-in and custom feeds, the forwarder start/stop, and the scrollable log console
that displays real-time AIS NMEA 0183 messages (with per-frame copy and checksum validation).

`send_page.dart`

Implements the Send screen: the list of forwarding destinations. Each destination has its own transport (UDP server/client,
TCP client/server), host and port, and can be individually enabled. The list is locked while the forwarder runs.

`target_config.dart`

Defines the TargetConfig model (a forwarding destination) with its JSON serialization, used by both the Send screen and the forwarder.

`forwarder_service.dart`

The networking and data management core.
It handles socket connections to all configured AIS data feeds and forwards the raw data to every enabled destination. 
It communicates with the reception page via callbacks for logging and exposes per-feed connection statuses.

`boatmanager.dart`

The vessel state and message parser.
This extends ChangeNotifier and maintains the list of all tracked Boat objects. 
It is responsible for taking raw NMEA 0183 sentences, parsing them in a dedicated isolate (using the internal ais decoder in ais/src), 
and updating the corresponding ships data (position, speed, name...). It also counts invalid checksums, dropped/pending fragments and parse errors.

`boat.dart`

Defines the Boat model class.
This class serves as the structured data container for all information extracted from AIS messages, and keeps the log of raw frames
that decoded into that vessel.

`world_map_page.dart`

The map visualization screen.
It uses flutter_map to render the interactive world map, with selectable basemaps, vessel search, filters, and a detail panel.

`boat_map_layer.dart`

The custom canvas layer that draws the vessels directly (rotated hulls, trails, speed vectors, optional clustering), 
keeping the map fluid even with many boats.

`basemaps.dart`

The list of free basemap providers (CARTO, OpenStreetMap, OpenTopoMap, Esri...) with an "auto (follow theme)" option.

`bubble_boat.dart`

Contains the boat detail panel (BoatInfoBubble) shown when a vessel is selected: key AIS data plus the raw frames that were
decoded for that vessel, each with a copy button.

`decoder_page.dart`

Implements the Decoder tab: paste one or more NMEA sentences, decode them locally (multi-part messages are grouped into a single
block) and copy the result.

`ais_editor_page.dart`

Implements the Editor tab: build a message of any of the 27 supported AIS types through a form, then inject it into the pipeline
or send it to the enabled destinations.

`stats_page.dart`

Implements the Statistics tab: KPI cards (received/decoded rates, invalid checksums, dropped/pending fragments, parse errors),
a received-vs-decoded chart over the last minute, and an accounting view reconciling the counters. The feed can be filtered.

`message_stats.dart`

The statistics model: aggregates per-feed/per-type counters and samples the received/decoded rates every second for the charts.

`app_settings.dart`

Persists the application settings (theme, basemap, destinations, feeds, toggles...) through shared_preferences.

`themes.dart`

Defines the light/dark/high-contrast themes and the semantic color palette (AppColors) used by the UI widgets.

`widgets.dart`

Shared UI building blocks: KPI/tinted cards, section headers, accent badges, mini-toasts and the copy-to-clipboard button.

`feed_def.dart`

The built-in feed definitions (public streams) available on the Reception screen.

`boat_animation.dart`

Implements the animated boat visual feedback on the title bar.
It uses Flutter's AnimationController to make a boat image traverse the screen horizontally and tilt slightly to simulate movement,
providing a visual cue that the network services are running. I've made this animation to change my mind in the middle of the project and make 
something with some visual returns.

`host_input_formatter.dart` / `ip_address_input_formatter.dart` / `port_input_formatter.dart`

Utility TextInputFormatters used to validate user input in configuration fields, ensuring host, IP address and port formats.

## Misc

The AIS decoder in `lib/ais` (all 27 ITU-R M.1371 message types, including the NMEA/checksum/fragment pipeline and the message encoders used by the editor) is a vendored fork of [ais_decoder](https://github.com/LucasMnzb/ais_decoder) by LucasMnzb (BSD-3-Clause, see `lib/ais/LICENSE.ais_decoder.txt`), with the charset bug fix and the payload-based `getUintDirect` retained. The files have been adapted (relative imports, lints).

This app as been tested on both windows and linux.

I had to learn how to create a portable exe with [Enigma Virtual Box](https://enigmaprotector.com/),
how to make good LAF (Look And Feel) for windows using [bitsdojo_window](https://pub.dev/packages/bitsdojo_window),
how to learn about the [flutter_map](https://pub.dev/packages/flutter_map) library for vessels visualization.

Note that GPSD public feed are not always up.

LLM have been used mainly to help me redact (and mostly translate) this README file in english and to help me to solve some bugs I have encountered while trying to connect multiple clients.

This app is still in production, i choose to provide it as it is since i think it is enough to fulfill the requirement or the end year project,
some future improvements are already planned and some bugs are already known, i'll keep working on it.

## Future Improvements

#### Known bugs

- Keeping the app running for a long time period could cause memory issues since the logs are never cleared
- The app will sometimes not boot on linux (tested on raspberry pi), retrying to boot multiple time solve the issue
- The map page could be laggy when receiving to much data
- Info-bubbles z-order is not right at the moment, some ships are sometimes show on top of the text
- Sometimes clicking on the stop buttons to stop the feed will not stop it (the button change state but the feed is still sent)

#### Improvements

- Logs processing for nmea sentences and connection state are in the same pipeline causing some issues between them since there is only
one processor, this should be reworked
- More feeds can be added
- The compatibility with other platforms could be improved (running on macos, ios and android)
- Add the ability for the user to add custom streams
- Add the ability for the user to create and send his own ais messages
- Add the ability to manage multiple endpoint while sending data
- Ajouter un onglet de simulation permettant de simuler une flotte de bateau, a un endroit précis qui envoient certains messages
- Ajouter la possibiliter de filtrer ce qui est renvoyé (filtre par type de message, par zone géographique, par bateau, etc...)

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
