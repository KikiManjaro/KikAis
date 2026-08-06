# KikAis: AIS Data Forwarding and Visualization Tool

KikAis is a desktop application built using the Flutter framework, designed to operate as a central hub for receiving, 
processing, and redistributing Automatic Identification System (AIS) NMEA 0183 data. 
This tool aggregate real-time vessel data from multiple sources—including public streams and a "private" server (see aisstreamio2nmea part of the project) and
broadcast it across various network protocols.

The application’s core function is dual-layered: first, it manages the low-level network connections and data forwarding via various protocols (UDP/TCP); 
second, it processes the received NMEA 0183 messages to extract vessel information and visualize their positions in real-time on a world map. 
This architecture ensures high-performance data handling while maintaining a responsive and informative user interface. 
The UI is split into two distinct, easily navigable pages: 
- a Configuration and Log Console for connection management and monitoring
- a Map Visualization page for showing ships

## Architecture
   
The architecture of KikAis was intentionally designed to address the challenges inherent in handling high-volume, real-time network data, prioritizing performance, decoupling of concerns, and user experience.

Given that AIS messages arrive continuously, requiring rapid updates to both the UI logs and the map markers, 
an approach with fine-grained control over widget rebuilding was necessary.
The BoatManager holds the central vessel collection (Map<int, Boat>). When new messages arrive, the manager updates the relevant Boat object.
To prevent these computational tasks from blocking the main thread, the boat manager was designed to execute the parsing logic asynchronously.
By offloading the message decoding to an isolated thread, we ensure the UI remains smooth and map updates even while the underlying data stream is being heavily processed.
This single source of truth ensures the map page is instantly updated with minimal overhead, preventing the application from freezing under heavy data load (was happening a lot during the development)

The main application window is a single view implemented using a PageView within the SwipperUi widget, 
allowing users to effortlessly switch between the ForwarderUI (Configuration/Logs) and the WorldMapPage (Map visualization).
Note that the Map page is disabled by default to avoid overload, using heavy stream such as the one provided by aisstreamio2nmea (vessels all arround the world) could still make the map stutter.

The app operates as follows:

1. Connects to a configurable list of external data feeds all transmitting AIS NMEA 0183 sentences.

2. The application acts as a relay, enabling the rebroadcast of all aggregated AIS data via multiple protocols.

3. A dedicated log console provides immediate feedback on incoming data, displaying raw NMEA messages and connection status updates.

4. Integrates a world map to display the live positions of all reported vessels (includes features like marker clustering for performance and detailed info-bubbles on hover)

## File Breakdown

`main.dart`

The application entry point. 
It initializes the Flutter app, sets up the theme, configures the BoatManager with ChangeNotifierProvider for global state access, 
and applies desktop window settings (size, title, alignment) using bitsdojo_window.

`swipper.dart`

Manages the main user interface structure. It implements the PageView logic to allow swiping/switching between the ForwarderUI and WorldMapPage. 
It also defines the custom window control buttons.

`forwarder_ui.dart`

Implements the Configuration and Log Console screen.
This includes UI elements for setting the host, port and protocols, managing connection feeds, and the scrollable console widget 
that displays real-time AIS NMEA 0183 messages.

`forwarder_service.dart`

The networking and data management core.
It handles socket connections to all configured AIS data feeds and manages the target output connection for forwarding the raw data. 
It communicates with forwarder_ui via callbacks for logging.

`boatmanager.dart`

The vessel state and message parser.
This extends ChangeNotifier and maintains the list of all tracked Boat objects. 
It is responsible for taking raw NMEA 0183 sentences, parsing them (using the internal ais decode (in ais/src) library), 
and update the corresponding ships data (position, speed, name...).

`world_map_page.dart`

The map visualization screen.
It uses flutter_map to render the interactive world map. It consumes data from the BoatManager to create Marker widgets for each vessel.

`bubble_boat.dart`

Contains UI components for map markers.
BoatMarkerWithInfo defines the visual marker and BoatInfoBubble defines tooltip page that appears when a user hovers over a vessel, 
listing key AIS datas.

`ip_address_input_formatter.dart`

A utility TextInputFormatter used to validate user input in configuration fields, ensuring address format.

`port_input_formatter.dart`

A utility TextInputFormatter to ensure that port numbers entered by the user are valid and within the standard range of 0 to 65535.

`global.dart`

A simple class used to store application-wide static variables like GlobalVariables.sendToMap, 
allowing different parts of the application to share them. (was expecting to put more variables in this)

`boat.dart`

Defines the Boat model class.
This class serves as the structured data container for all information extracted from AIS messages.

`boat_animation.dart`

Implements the animated boat visual feedback on the ForwarderUI page.
It uses Flutter's AnimationController to make a boat image traverse the screen horizontally and tilt slightly to simulate movement,
providing a visual cue that the network services are running. I've made this animation to change my mind in the middle of the project and make 
something with some visual returns.

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