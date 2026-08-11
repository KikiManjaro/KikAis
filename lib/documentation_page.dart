import 'package:flutter/material.dart';

import 'ais/ais_decoder.dart';
import 'ais_message_details.dart';
import 'documentation_content.dart';
import 'documentation_widgets.dart';
import 'mid_countries.dart';
import 'nmea_field_breakdown.dart';
import 'themes.dart';
import 'widgets.dart';

/// An interactive, searchable guide to AIS: the history, the radio system,
/// the MMSI, the 27 message types, the NMEA/AIVDM framing and the payload
/// bit layout — a "bible" for newcomers and for testing KikAis.
class DocumentationPage extends StatefulWidget {
  final ValueChanged<int> onOpenTab;
  final ValueChanged<String>? onOpenInDecoder;

  const DocumentationPage({
    super.key,
    required this.onOpenTab,
    this.onOpenInDecoder,
  });

  @override
  State<DocumentationPage> createState() => _DocumentationPageState();
}

class _Chapter {
  final String title;
  final IconData icon;
  final List<String> keywords;
  const _Chapter(this.title, this.icon, this.keywords);
}

const List<_Chapter> _chapters = [
  _Chapter('Overview', Icons.info_outline,
      ['AIS', 'introduction', 'radar', 'VTS', 'SOLAS', 'ADS-B']),
  _Chapter('History & regulation', Icons.history,
      ['history', 'Sweden', 'IMO', 'SOLAS', '2002', 'class b', 'satellite']),
  _Chapter('How it works', Icons.radio,
      ['VHF', 'channel', '161.975', '162.025', 'TDMA', 'slot', 'range', 'report']),
  _Chapter('Radio & TDMA', Icons.settings_input_antenna,
      ['radio', 'SOTDMA', 'CSTDMA', 'HDLC', 'GMSK', '9600', 'NRZI', 'frame', 'slots', 'VDES']),
  _Chapter('Classes & equipment', Icons.architecture,
      ['class a', 'class b', 'SOTDMA', 'CSTDMA', 'transponder', 'SART', 'MOB', 'EPIRB', 'comparison']),
  _Chapter('MMSI & identity', Icons.badge_outlined,
      ['MMSI', 'MID', 'country', 'format', 'identity']),
  _Chapter('Ship types', Icons.inventory_2,
      ['ship type', 'vessel type', 'cargo', 'tanker', 'fishing', 'tug', 'passenger', '0-99']),
  _Chapter('The 27 messages', Icons.message_outlined,
      ['message', 'catalog', 'position', 'static', 'safety', 'binary', 'type 1']),
  _Chapter('NMEA & AIVDM', Icons.code,
      ['NMEA', 'AIVDM', 'AIVDO', 'sentence', 'payload', 'checksum', 'fragment', 'armoring', 'six-bit']),
  _Chapter('Inside the payload', Icons.hexagon_outlined,
      ['bits', 'bit layout', 'coordinate', 'longitude', 'latitude', 'six-bit', 'nav status', 'EPFD']),
  _Chapter('Security & limits', Icons.shield_outlined,
      ['security', 'spoofing', 'jamming', 'meaconing', 'data quality']),
  _Chapter('Field notes', Icons.tips_and_updates,
      ['gotchas', 'quirks', 'length', 'noise', 'timestamp', 'regional', '8-digit']),
  _Chapter('AIS in KikAis', Icons.directions_boat,
      ['kikais', 'reception', 'decoder', 'editor', 'simulation', 'map', 'stats']),
  _Chapter('Glossary', Icons.translate,
      ['glossary', 'terms', 'dictionary', 'SOTDMA', 'MMSI', 'VDES']),
  _Chapter('Cheat sheet', Icons.bolt,
      ['cheat sheet', 'reference', 'frequencies', 'report rates', 'at a glance']),
  _Chapter('Sources', Icons.link,
      ['sources', 'gpsd', 'wikipedia', 'navcen', 'ITU', 'IALA', 'IEC']),
];

class _DocumentationPageState extends State<DocumentationPage> {
  int _selected = 0;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Documentation')),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 260,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                    decoration: const InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.search, size: 18),
                      labelText: 'Search chapters',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: [
                      for (var i = 0; i < _chapters.length; i++)
                        if (_matches(_chapters[i]))
                          ListTile(
                            dense: true,
                            selected: i == _selected,
                            leading: Icon(
                              _chapters[i].icon,
                              size: 18,
                              color: i == _selected
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                            ),
                            title: Text(
                              _chapters[i].title,
                              style: const TextStyle(fontSize: 13),
                            ),
                            onTap: () => setState(() => _selected = i),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _contentFor(_selected),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _matches(_Chapter c) {
    if (_query.isEmpty) return true;
    if (c.title.toLowerCase().contains(_query)) return true;
    return c.keywords.any((k) => k.toLowerCase().contains(_query));
  }

  // ---------------------------------------------------------------- helpers

  Widget _h1(String text) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
      ),
    );
  }

  Widget _h2(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _p(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
      ),
    );
  }

  Widget _bullets(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, right: 8),
                    child: Icon(Icons.circle, size: 6),
                  ),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _code(String text) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: scheme.primary,
        ),
      ),
    );
  }

  Widget _factCard(String title, String text) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return TintedCard(
      accent: appColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- chapters

  List<Widget> _contentFor(int index) {
    switch (index) {
      case 0:
        return _overview();
      case 1:
        return _history();
      case 2:
        return _howItWorks();
      case 3:
        return _radio();
      case 4:
        return _classes();
      case 5:
        return _mmsi();
      case 6:
        return _shipTypes();
      case 7:
        return _messages();
      case 8:
        return _nmea();
      case 9:
        return _payload();
      case 10:
        return _security();
      case 11:
        return _fieldNotes();
      case 12:
        return _kikais();
      case 13:
        return _glossary();
      case 14:
        return _cheatSheet();
      default:
        return _sources();
    }
  }

  List<Widget> _overview() {
    return [
      _h1('What is AIS?'),
      _p(
        'The Automatic Identification System (AIS) is a tracking system used '
        'on ships and by vessel traffic services (VTS). Every equipped vessel '
        'continuously broadcasts its identity, position, course and speed over '
        'VHF radio, so that every other ship and shore station in range can '
        '"see" it — the concept of "see and be seen".',
      ),
      _p(
        'AIS does not replace marine radar. Radar independently detects any '
        'object, but tells you little about who it is. AIS tells you exactly '
        'who, where and where they are going — but it trusts what the sender '
        'declares. The two systems complement each other.',
      ),
      _factCard(
        'Think of it as the maritime ADS-B',
        'Just as ADS-B lets aircraft announce themselves to air traffic '
        'control, AIS lets ships announce themselves to each other and to '
        'shore. Ships view surrounding traffic on a chartplotter or on a '
        'radar-like display; port authorities monitor movements and fisheries.',
      ),
      const SizedBox(height: 12),
      _h2('What a transponder broadcasts'),
      _bullets([
        'Unique identity: a 9-digit MMSI number (whose first three digits '
            'identify the issuing country).',
        'Dynamic data: position, speed over ground (SOG), course over ground '
            '(COG), true heading, rate of turn, navigation status.',
        'Static & voyage data: name, call sign, IMO number, ship type, '
            'dimensions, draught, destination, ETA.',
        'Safety and binary messages: distress texts, weather reports, '
            'network commands.',
      ]),
      _h2('Who must carry it'),
      _p(
        'The IMO (SOLAS convention) mandates AIS on international vessels '
        'over 300 gross tons and on all passenger ships. Regional rules '
        'extend this to fishing fleets, inland waterways and increasingly to '
        'recreational craft via low-cost Class B transponders.',
      ),
      _h2('Limits at a glance'),
      _bullets([
        'Range is roughly line of sight: about 10-20 nautical miles for '
            'ship-to-ship, more from coast stations and satellites.',
        'AIS has no authentication: anyone can broadcast any identity '
            '(spoofing) or jam the channel.',
        'Accuracy depends on the sender\'s GNSS fix and on the honesty of '
            'the data it declares.',
      ]),
    ];
  }

  List<Widget> _history() {
    return [
      _h1('History & regulation'),
      _p(
        'AIS grew from a Swedish idea into a worldwide mandatory safety '
        'system. Tap any milestone on the timeline for details.',
      ),
      const _TimelineWidget(),
      _h2('The governing standards'),
      _bullets([
        'ITU-R M.1371 — Technical characteristics for a universal shipborne '
            'AIS (defines the 27 message types and their bit layout).',
        'IALA guidelines — clarifications and implementation guidance.',
        'IEC 61162 / 62287 — the NMEA sentence framing and Class B/CSTDMA '
            'requirements.',
        'IEC 61097-14 — the AIS-SART distress transmitter.',
      ]),
    ];
  }

  List<Widget> _howItWorks() {
    return [
      _h1('How it works'),
      _p(
        'AIS is a VHF radio system. Each transponder listens to the traffic '
        'around it and transmits its own reports in reserved time slots, '
        'avoiding collisions with the other ships in range.',
      ),
      _h2('The radio link'),
      _bullets([
        'Two dedicated VHF channels: AIS 1 at 161.975 MHz (87B) and '
            'AIS 2 at 162.025 MHz (88B).',
        'Digital narrow-band FM, at 9 600 bits per second.',
        'Messages are organised into TDMA frames of 2250 time slots '
            '(1 minute).',
      ]),
      _h2('How slots are shared'),
      _p(
        'Class A transponders use SOTDMA (Self-Organizing Time Division '
        'Multiple Access): each unit reserves a repeating slot and '
        're-reserves when the picture changes, so ships continuously '
        'coordinate without a central controller.',
      ),
      _p(
        'Class B transponders use the simpler CSTDMA (Carrier Sense TDMA): '
        'they listen for a free slot and grab it, which is why Class B '
        'reports are less frequent and can be lost in very dense traffic.',
      ),
      _h2('Reporting rates'),
      _bullets([
        'Class A position report (type 1): every 2-10 seconds while '
            'underway, every 3 minutes at anchor.',
        'Static & voyage data (type 5): every 6 minutes.',
        'Class B position (type 18): roughly every 30 seconds.',
        'Aid to navigation (type 21): every 3 minutes.',
      ]),
      _h2('Terrestrial and satellite'),
      _p(
        'On the surface, AIS range is limited by the VHF horizon '
        '(T-AIS). Since the mid-2000s, satellites in low-Earth orbit '
        '(S-AIS) receive the same signals, giving near-global coverage — '
        'satellites augment rather than replace the terrestrial network.',
      ),
    ];
  }

  List<Widget> _radio() {
    return [
      _h1('Radio & TDMA'),
      _p(
        'Beneath the messages lies a small, efficient radio system. AIS '
        'transmits at 9 600 bits per second on two VHF channels, using '
        'Gaussian minimum-shift keying (GMSK) and HDLC-style framing.',
      ),
      _h2('The physical link'),
      _bullets([
        'AIS 1 at 161.975 MHz and AIS 2 at 162.025 MHz (VHF channels 87B '
            'and 88B).',
        'GMSK modulation at 9 600 baud — narrow enough to fit the maritime '
            'VHF band.',
        'HDLC framing with bit stuffing, and NRZI line coding, inherited '
            'from the packet-radio world.',
      ]),
      _h2('TDMA frames and slots'),
      _bullets([
        'Each channel is split into frames of exactly 1 minute, divided '
            'into 2 250 time slots of ~26.7 ms each.',
        'A slot carries one AIS message (256 bits with ramp-up/down and '
            'guard time).',
        'Stations reuse the same slots every frame so they broadcast '
            'periodically without colliding.',
      ]),
      _code('2250 slots/frame · 1 frame = 60 s · slot ≈ 26.7 ms · '
          '9600 bit/s'),
      _h2('SOTDMA — how Class A self-organises'),
      _p(
        'Each Class A transponder listens to the slots around it, picks a '
        'free one and announces in its radio-status field when it will '
        'transmit next. Stations continuously re-reserve as the traffic '
        'picture changes, so no central coordinator is needed.',
      ),
      _h2('CSTDMA — how Class B joins in'),
      _p(
        'Class B units are simpler: they listen for a slot that is currently '
        'free and transmit once in it. This is cheaper, but Class B reports '
        'can be lost in very dense traffic where a slot is always busy.',
      ),
      _h2('VDES — the future'),
      _p(
        'The VHF Data Exchange System (ITU-R M.2092) is rolling out to '
        'relieve congested waters: it adds new frequencies, far more '
        'bandwidth and secure two-way data for e-navigation, alongside the '
        'existing AIS service.',
      ),
    ];
  }

  List<Widget> _classes() {
    return [
      _h1('Classes & equipment'),
      _p(
        'AIS hardware comes in different classes and roles. The two you '
        'will meet most often are the full Class A transponder and the '
        'cheap Class B unit.',
      ),
      _h2('Class A vs Class B'),
      const ClassComparisonTable(),
      _h2('Receivers and transponders'),
      _p(
        'Transponders both receive and transmit. Many shore stations and '
        'hobbyists run receivers only, so they can watch traffic without '
        'appearing on it.',
      ),
      _h2('Aids to navigation'),
      _p(
        'AtoN stations (type 21) broadcast buoys, beacons and lighthouses. '
        'They can also transmit a virtual aid — a marker that exists only '
        'on charts, useful to warn of a new hazard.',
      ),
      _h2('Distress & safety devices'),
      _p(
        'Beyond regular ships, AIS carries distress transmitters that every '
        'receiver should be able to spot:',
      ),
      const DistressDeviceCards(),
      _p(
        'A SART in action also sets navigation status 14 ("AIS-SART '
        'active") on its position report.',
      ),
    ];
  }

  List<Widget> _shipTypes() {
    return [
      _h1('Ship types'),
      _p(
        'Type 5 and 24 static messages carry an 8-bit ship-type code '
        '(0-99) that describes what the vessel is — cargo, tanker, fishing '
        'boat, pleasure craft and so on. The full table is shown below.',
      ),
      const ShipTypeBrowser(),
      _h2('Categories at a glance'),
      _bullets([
        for (final (range, meaning) in kVesselTypeCategories)
          '$range — $meaning',
      ]),
    ];
  }

  List<Widget> _fieldNotes() {
    return [
      _h1('Field notes & real-world quirks'),
      _p(
        'Real AIS traffic does not always match the theory. Knowing these '
        'quirks helps you trust what the decoder shows you — and what it '
        'rejects.',
      ),
      const GotchasList(),
    ];
  }

  List<Widget> _glossary() {
    return [
      _h1('Glossary'),
      _p(
        'A searchable dictionary of the acronyms and terms used throughout '
        'this guide and by the AIS community.',
      ),
      const GlossarySearch(),
    ];
  }

  List<Widget> _cheatSheet() {
    return [
      _h1('Cheat sheet'),
      _p(
        'The essential numbers and codes at a glance — frequencies, '
        'reporting rates, status codes and formats.',
      ),
      const CheatSheet(),
    ];
  }

  List<Widget> _mmsi() {
    return [
      _h1('MMSI & identity'),
      _p(
        'The Maritime Mobile Service Identity (MMSI) is a unique 9-digit '
        'number identifying a ship\'s radio equipment, like a phone number '
        'for the vessel. Its first three digits are the MID — the Maritime '
        'Identification Digits that identify the country that issued it.',
      ),
      _h2('Number formats'),
      _bullets([
        for (final (fmt, meaning) in kMmsiFormats) '$fmt — $meaning',
      ]),
      _h2('Look up an MMSI'),
      _p(
        'Enter a 9-digit MMSI below to see its class and the country of the '
        'issuing authority.',
      ),
      const _MmsiLookupWidget(),
      _h2('Country codes (MID)'),
      _p(
        'The full MID table is bundled with KikAis and used everywhere an '
        'MMSI is displayed.',
      ),
      const _MidiTable(),
    ];
  }

  List<Widget> _messages() {
    return [
      _h1('The 27 message types'),
      _p(
        'Every AIS payload begins with a 6-bit message type (1 to 27). The '
        'catalog below groups them by family. Each card shows a real NMEA '
        'sentence generated by KikAis\' own encoder, its decoded fields, and '
        'a button to open it in the Decoder.',
      ),
      _MessageCatalog(onOpenInDecoder: widget.onOpenInDecoder),
    ];
  }

  List<Widget> _nmea() {
    return [
      _h1('NMEA & AIVDM framing'),
      _p(
        'On the wire, AIS messages travel as NMEA 0183 sentences starting '
        'with !AIVDM (other ships) or !AIVDO (your own ship). The payload is '
        'an ASCII-armored bit vector.',
      ),
      _code('!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C'),
      _h2('Sentence fields'),
      _bullets([
        'Talker & formatter — !AIVDM or !AIVDO (see talker IDs below).',
        'Fragment count — how many sentences make up the full message '
            '(NMEA limits each line to ~82 characters).',
        'Fragment number — which part this is (1-based).',
        'Sequential message ID — ties fragments of the same message together.',
        'Radio channel — A or B (AIS1 / AIS2).',
        'Data payload — the six-bit armoured AIS payload.',
        'Fill bits — how many pad bits were added to the last 6-bit group '
            '(0-5).',
        'Checksum — the XOR of all bytes before the *, in hexadecimal.',
      ]),
      _h2('Multi-fragment messages'),
      _p(
        'Messages longer than one line (such as type 5 static data) are '
        'split: the first sentence reports a fragment count of 2 and the '
        'second completes it with the same message ID.',
      ),
      _code('!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n'
          '!AIVDM,2,2,3,B,1@0000000000000,2*55'),
      _h2('Six-bit armoring'),
      _p(
        'Each payload character holds 6 bits. Subtract 48 from the ASCII '
        'code, then subtract another 8 if the result is above 40.',
      ),
      const _ArmoringGrid(),
      _h2('Talker IDs'),
      _p(
        'Different NMEA 4.0 talker IDs identify the type of AIS station:',
      ),
      _bullets([
        for (final e in kTalkerIds.entries) '!${e.key} — ${e.value}',
      ]),
      _h2('Checksum'),
      _p(
        'The trailing checksum is the XOR of every byte between the "!" '
        'and the "*". Calculate your own below:',
      ),
      const ChecksumCalculator(),
      _h2('Try it: sentence inspector'),
      _p(
        'Paste any AIVDM/AIVDO sentence (or use a sample above) to see its '
        'fields broken down and the decoded values.',
      ),
      const _SentenceInspector(),
    ];
  }

  List<Widget> _payload() {
    return [
      _h1('Inside the payload'),
      _p(
        'Once the six-bit armoring is undone, an AIS payload is a sequence '
        'of bit fields. The first six bits are the message type; the next '
        'two are the repeat indicator; then come 30 bits of MMSI.',
      ),
      _h2('The Common Navigation Block (types 1-3)'),
      _p(
        'The most important layout is shared by the Class A position '
        'reports. Use the selector to browse the main message layouts, and '
        'click a segment to read what it encodes.',
      ),
      const BitLayoutViewer(),
      _h2('Coordinates'),
      _p(
        'Latitude and longitude are stored in 1/10 000 of a minute. Divide '
        'by 600 000 to get degrees: 60 minutes in a degree, and 10 000 '
        'units per minute. East/North are positive.',
      ),
      _code('lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°'),
      _p('Convert your own coordinates below:'),
      const CoordinateEncoder(),
      _h2('Speed, course, heading'),
      _bullets([
        'SOG — speed over ground in tenths of a knot (0-102.2 kn); 1023 '
            'means "not available".',
        'COG — course over ground in tenths of a degree, relative to true '
            'north.',
        'Heading — true heading in whole degrees; 511 means "not available".',
        'ROT — rate of turn: value ≈ 4.733 × √(turning rate in °/min), '
            'signed (positive = right).',
      ]),
      _h2('Navigation status'),
      const _NavStatusTable(),
      _h2('Position fix type (EPFD)'),
      const _EpfdTable(),
      _h2('Six-bit text'),
      _p(
        'Names, call signs and destinations use the same six-bit alphabet '
        'as the payload itself. Lowercase letters cannot be encoded, which '
        'is why AIS names are usually uppercase.',
      ),
      const SixBitEncoder(),
    ];
  }

  List<Widget> _security() {
    return [
      _h1('Security & data quality'),
      _p(
        'AIS is designed for cooperation, not security. The radio channel '
        'is open and unencrypted, and there is no authentication of who is '
        'broadcasting.',
      ),
      _h2('Threats'),
      _bullets([
        'Spoofing — transmitting a fake MMSI, position or identity '
            '(phantom ships, sanctions evasion).',
        'Jamming — flooding the two VHF channels so real traffic cannot '
            'be received.',
        'Meaconing — replaying real signals from elsewhere to confuse '
            'receivers.',
      ]),
      _h2('Data quality'),
      _bullets([
        'The position accuracy bit distinguishes an unaugmented GNSS fix '
            '(> 10 m) from a DGPS-quality fix (< 10 m).',
        'Receivers should sanity-check positions, speeds and timestamps; '
            'about 0.3% of real-world messages have a bad payload length.',
        'Satellite AIS occasionally suffers collisions because the satellite '
            'footprint is much larger than a TDMA cell — one more reason to '
            'correlate with radar and other sources.',
      ]),
    ];
  }

  List<Widget> _kikais() {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return [
      _h1('AIS in KikAis'),
      _p(
        'KikAis is a full AIS lab: receive live or simulated traffic, decode '
        'it, inspect and send your own messages, and build fleets. Here is '
        'how each tab maps to what you just read.',
      ),
      _TabCard(
        accent: appColors.info,
        icon: Icons.radio,
        title: 'Reception',
        text: 'Choose feeds (file, serial, simulation), start the forwarder '
            'and watch the raw NMEA stream and the decoded boats.',
        tabIndex: 0,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.success,
        icon: Icons.outbox,
        title: 'Send',
        text: 'Forward the received sentences to one or more TCP/UDP '
            'targets — how a shore station would distribute traffic.',
        tabIndex: 1,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.info,
        icon: Icons.map,
        title: 'Map',
        text: 'See decoded vessels plotted from their type 1/2/3, 18, 19 '
            'and 27 position reports.',
        tabIndex: 2,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.warning,
        icon: Icons.edit_note,
        title: 'Editor',
        text: 'Build any of the 27 message types by hand from a friendly '
            'form and send it — the best way to learn the fields.',
        tabIndex: 3,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.info,
        icon: Icons.manage_search,
        title: 'Decoder',
        text: 'Paste any sentence and get the decoded fields, checksum and '
            'fragment handling — the practical companion to this guide.',
        tabIndex: 4,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.success,
        icon: Icons.bar_chart,
        title: 'Stats',
        text: 'Message counters, rates per feed and decoder health '
            '(invalid checksums, dropped fragments).',
        tabIndex: 5,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.warning,
        icon: Icons.bubble_chart,
        title: 'Simulation',
        text: 'Generate a whole fleet around any location — every message '
            'type, MMSI scheme, zone shape and even error injection.',
        tabIndex: 6,
        onOpen: widget.onOpenTab,
      ),
    ];
  }

  List<Widget> _sources() {
    return [
      _h1('Sources'),
      _p(
        'This guide synthesizes publicly available, authoritative '
        'documentation:',
      ),
      _bullets([
        'gpsd — AIVDM/AIVDO protocol decoding, by Eric S. Raymond '
            '(the de-facto technical bible for the sentence format and '
            'payload bit fields).',
        'Wikipedia — Automatic Identification System (overview, history, '
            'applications, security).',
        'US Coast Guard Navigation Center (NavCen) — AIS pages.',
        'ITU-R Recommendation M.1371 — the governing AIS standard.',
        'IALA — clarifications of ITU-R M.1371.',
        'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA framing, Class B and '
            'AIS-SART.',
      ]),
      _h2('How to learn more'),
      _p(
        'The best way to understand AIS is to experiment: use the Editor to '
        'build messages, the Decoder to read them back, and the Simulation '
        'tab to watch a whole fleet. Everything in this guide is generated '
        'by KikAis\' own encoder and decoder.',
      ),
    ];
  }
}

// ----------------------------------------------------------------- widgets

class _TimelineWidget extends StatelessWidget {
  const _TimelineWidget();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Column(
      children: [
        for (var i = 0; i < kAisTimeline.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    kAisTimeline[i].year,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: appColors.info,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kAisTimeline[i].title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kAisTimeline[i].text,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MmsiLookupWidget extends StatefulWidget {
  const _MmsiLookupWidget();

  @override
  State<_MmsiLookupWidget> createState() => _MmsiLookupWidgetState();
}

class _MmsiLookupWidgetState extends State<_MmsiLookupWidget> {
  final _controller = TextEditingController();
  String? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _lookup() {
    final s = _controller.text.trim();
    if (s.length != 9 || int.tryParse(s) == null) {
      setState(() => _result = 'Enter a 9-digit MMSI (digits only).');
      return;
    }
    String cls;
    String? mid;
    if (s.startsWith('111')) {
      cls = 'SAR aircraft';
      mid = s.substring(3, 6);
    } else if (s.startsWith('970')) {
      cls = 'AIS-SART (search & rescue transmitter)';
    } else if (s.startsWith('972')) {
      cls = 'MOB (man overboard) device';
    } else if (s.startsWith('974')) {
      cls = 'AIS EPIRB (emergency beacon)';
    } else if (s.startsWith('00')) {
      cls = 'Coastal / shore station';
      mid = s.substring(2, 5);
    } else if (s.startsWith('99')) {
      cls = 'Aid to navigation';
      mid = s.substring(2, 5);
    } else if (s.startsWith('98')) {
      cls = 'Auxiliary craft (associated with a parent ship)';
      mid = s.substring(2, 5);
    } else if (s.startsWith('8')) {
      cls = 'Diver\'s radio';
      mid = s.substring(1, 4);
    } else if (s.startsWith('0')) {
      cls = 'Group of ships (group call)';
      mid = s.substring(1, 4);
    } else {
      cls = 'Ship';
      mid = s.substring(0, 3);
    }
    final country = mid != null ? midCountryOf(s) : null;
    setState(() {
      _result = mid != null
          ? '$cls — MID $mid (${country ?? 'unknown country'})'
          : cls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                    decoration: const InputDecoration(
                      isDense: true,
                      counterText: '',
                      labelText: 'MMSI (9 digits)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _lookup,
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Look up'),
                ),
              ],
            ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_result!, style: const TextStyle(fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }
}

class _MidiTable extends StatelessWidget {
  const _MidiTable();

  @override
  Widget build(BuildContext context) {
    final entries = kMidCountries.entries.toList()
      ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final e in entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageCatalog extends StatelessWidget {
  final ValueChanged<String>? onOpenInDecoder;
  const _MessageCatalog({this.onOpenInDecoder});

  @override
  Widget build(BuildContext context) {
    final families = <String, List<DocMessageType>>{};
    for (final m in kDocMessageTypes) {
      families.putIfAbsent(m.family, () => []).add(m);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in families.entries) ...[
          _familyHeader(context, entry.key),
          for (final m in entry.value)
            _MessageTypeCard(message: m, onOpenInDecoder: onOpenInDecoder),
        ],
      ],
    );
  }

  Widget _familyHeader(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _MessageTypeCard extends StatefulWidget {
  final DocMessageType message;
  final ValueChanged<String>? onOpenInDecoder;
  const _MessageTypeCard({required this.message, this.onOpenInDecoder});

  @override
  State<_MessageTypeCard> createState() => _MessageTypeCardState();
}

class _MessageTypeCardState extends State<_MessageTypeCard> {
  late final String _sample = sampleSentencesFor(widget.message.type);
  late final List<MessageField> _decoded = _decodeSample(_sample);
  final _decoder = AisNmeaDecoder();

  List<MessageField> _decodeSample(String sample) {
    for (final line in sample.split('\n')) {
      final m = _decoder.decode(line);
      if (m != null) return describeMessage(m);
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final m = widget.message;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        shape: const Border(),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: appColors.info.withValues(alpha: 0.15),
          child: Text(
            '${m.type}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: appColors.info,
            ),
          ),
        ),
        title: Text(
          'Type ${m.type} — ${m.name}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${m.bits} bits · ${m.cadence}',
          style: const TextStyle(fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            m.summary,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Emitted by: ${m.emittedBy}',
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: SelectableText(
              _sample,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.5,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final field in _decoded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      field.$1,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(field.$2, style: const TextStyle(fontSize: 11.5)),
                  ),
                ],
              ),
            ),
          if (widget.onOpenInDecoder != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton.icon(
                onPressed: () => widget.onOpenInDecoder!(_sample),
                icon: const Icon(Icons.manage_search, size: 16),
                label: const Text('Open in Decoder'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArmoringGrid extends StatelessWidget {
  const _ArmoringGrid();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (var v = 0; v < 64; v++)
              Container(
                width: 52,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Text(
                      String.fromCharCode(_charForBits(v)),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: scheme.primary,
                      ),
                    ),
                    Text(
                      v.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 9,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _charForBits(int value) {
    var ascii = value + 48;
    if (ascii > 87) ascii += 8;
    return ascii;
  }
}

class _NavStatusTable extends StatelessWidget {
  const _NavStatusTable();

  @override
  Widget build(BuildContext context) {
    return _TwoColList(kNavStatus.map((e) => ('${e.$1}', e.$2)).toList());
  }
}

class _EpfdTable extends StatelessWidget {
  const _EpfdTable();

  @override
  Widget build(BuildContext context) {
    return _TwoColList(kEpfdTypes.map((e) => ('${e.$1}', e.$2)).toList());
  }
}

class _TwoColList extends StatelessWidget {
  final List<(String, String)> rows;
  const _TwoColList(this.rows);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final (k, v) in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          k,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(child: Text(v, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SentenceInspector extends StatefulWidget {
  const _SentenceInspector();

  @override
  State<_SentenceInspector> createState() => _SentenceInspectorState();
}

class _SentenceInspectorState extends State<_SentenceInspector> {
  final _controller = TextEditingController(
    text: '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C',
  );
  final _decoder = AisNmeaDecoder();
  List<Widget> _results = const [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _decode() {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final lines = _controller.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final decoded = <AISMessage>[];
    final widgets = <Widget>[];
    for (final line in lines) {
      widgets.add(NmeaFieldBreakdown(sentence: line));
      final message = _decoder.decode(line);
      if (message == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _decoder.invalidChecksums > 0
                  ? 'Invalid checksum'
                  : 'Could not decode',
              style: TextStyle(fontSize: 12, color: appColors.warning),
            ),
          ),
        );
      } else {
        decoded.add(message);
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Decoded: T${message.messageType} · '
              '${kEditorTypeLabel(message.messageType)}',
              style: TextStyle(fontSize: 12, color: appColors.success),
            ),
          ),
        );
      }
    }
    if (decoded.isNotEmpty) {
      widgets.add(const SizedBox(height: 6));
      for (final field in describeMessage(decoded.last)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    field.$1,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(child: Text(field.$2, style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        );
      }
    }
    setState(() => _results = widgets);
  }

  String kEditorTypeLabel(int type) {
    // Local label fallback for a compact header.
    final m = kDocMessageTypes.where((m) => m.type == type).toList();
    return m.isEmpty ? 'Type $type' : m.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 1,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'NMEA sentence',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _decode,
                icon: const Icon(Icons.manage_search, size: 18),
                label: const Text('Inspect'),
              ),
            ),
            const SizedBox(height: 8),
            ..._results,
          ],
        ),
      ),
    );
  }
}

class _TabCard extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String text;
  final int tabIndex;
  final ValueChanged<int> onOpen;

  const _TabCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.text,
    required this.tabIndex,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              AccentBadge(icon: icon, accent: accent, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(text, style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => onOpen(tabIndex),
                child: const Text('Open'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
