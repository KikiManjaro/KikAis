import 'ais/src/encoder/ais_message_encoder.dart';
import 'ais/src/utils/binary_conversion.dart';

/// A single AIS message type described for the documentation.
class DocMessageType {
  final int type;
  final String name;
  final String family;
  final String summary;
  final String emittedBy;
  final int bits;
  final String cadence;

  const DocMessageType({
    required this.type,
    required this.name,
    required this.family,
    required this.summary,
    required this.emittedBy,
    required this.bits,
    required this.cadence,
  });
}

/// The 27 international AIS message types from ITU-R M.1371.
const List<DocMessageType> kDocMessageTypes = [
  // Position reports
  DocMessageType(
    type: 1,
    name: 'Position Report Class A',
    family: 'Position reports',
    summary:
        'The workhorse of the system: a Class A transponder broadcasting its '
        'position, course, speed, heading and navigation status.',
    emittedBy: 'Class A transponders (SOLAS vessels)',
    bits: 168,
    cadence: 'Every 2-10 s while underway, every 3 min at anchor',
  ),
  DocMessageType(
    type: 2,
    name: 'Position Report Class A (assigned)',
    family: 'Position reports',
    summary:
        'Identical to type 1, but sent on a slot schedule assigned to the '
        'vessel by a base station (assignment mode).',
    emittedBy: 'Class A transponders under assignment',
    bits: 168,
    cadence: 'Assigned schedule',
  ),
  DocMessageType(
    type: 3,
    name: 'Position Report Class A (response)',
    family: 'Position reports',
    summary:
        'Identical to type 1, sent as the response to an interrogation '
        '(type 15).',
    emittedBy: 'Class A transponders answering an interrogation',
    bits: 168,
    cadence: 'On interrogation',
  ),
  DocMessageType(
    type: 18,
    name: 'Standard Class B CS Position Report',
    family: 'Position reports',
    summary:
        'The standard Class B position report. Lighter than Class A: no '
        'navigation status or rate of turn, but works with CSTDMA.',
    emittedBy: 'Class B transponders',
    bits: 168,
    cadence: 'Every 30 s (or less in some regions)',
  ),
  DocMessageType(
    type: 19,
    name: 'Extended Class B Equipment Position Report',
    family: 'Position reports',
    summary:
        'A larger Class B position report that also carries the vessel name, '
        'ship type and dimensions — a one-shot static+position hybrid.',
    emittedBy: 'Extended Class B transponders',
    bits: 312,
    cadence: 'Every 30 s',
  ),
  DocMessageType(
    type: 27,
    name: 'Position Report for Long-Range Applications',
    family: 'Position reports',
    summary:
        'A very compact position report designed for reception by satellite '
        'over long ranges, with reduced resolution.',
    emittedBy: 'Vessels in long-range (satellite) mode',
    bits: 96,
    cadence: 'Every 3 min (long-range mode)',
  ),
  DocMessageType(
    type: 9,
    name: 'Standard SAR Aircraft Position Report',
    family: 'Position reports',
    summary:
        'A position report used by search-and-rescue aircraft to be visible '
        'to ships. Carries altitude and a special MMSI range (111MIDXXX).',
    emittedBy: 'SAR aircraft',
    bits: 168,
    cadence: 'Every 10 s while on station',
  ),
  // Static & voyage
  DocMessageType(
    type: 5,
    name: 'Static and Voyage Related Data',
    family: 'Static & voyage data',
    summary:
        'The "identity card" of a ship: name, call sign, IMO number, ship '
        'type, dimensions, draught, ETA and destination.',
    emittedBy: 'Class A transponders',
    bits: 424,
    cadence: 'Every 6 min and on change of data',
  ),
  DocMessageType(
    type: 24,
    name: 'Static Data Report',
    family: 'Static & voyage data',
    summary:
        'The Class B equivalent of type 5, split into Part A (name) and '
        'Part B (ship type, call sign, dimensions).',
    emittedBy: 'Class B transponders',
    bits: 168,
    cadence: 'Every 6 min',
  ),
  // Safety & text
  DocMessageType(
    type: 14,
    name: 'Safety-Related Broadcast Message',
    family: 'Safety & text',
    summary:
        'A free-text broadcast addressed to everyone in range — navigational '
        'warnings, distress or traffic announcements.',
    emittedBy: 'Any station (often base stations / VTS)',
    bits: 1008,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 12,
    name: 'Addressed Safety-Related Message',
    family: 'Safety & text',
    summary:
        'A free-text safety message sent to a single destination MMSI '
        '(e.g. a distress message to the nearest base station).',
    emittedBy: 'Any station',
    bits: 1008,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 13,
    name: 'Safety-Related Acknowledgement',
    family: 'Safety & text',
    summary:
        'The acknowledgement sent in reply to a type 12 addressed safety '
        'message.',
    emittedBy: 'Any station that received a type 12',
    bits: 168,
    cadence: 'On reply',
  ),
  // Binary
  DocMessageType(
    type: 8,
    name: 'Binary Broadcast Message',
    family: 'Binary data',
    summary:
        'A structured binary payload broadcast to all — weather and '
        'hydrographic reports, regional data, or private/encrypted messages.',
    emittedBy: 'Any station',
    bits: 1008,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 6,
    name: 'Binary Addressed Message',
    family: 'Binary data',
    summary:
        'A structured binary payload sent to one specific destination MMSI '
        '(e.g. a requested meteo report).',
    emittedBy: 'Any station',
    bits: 1008,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 7,
    name: 'Binary Acknowledge',
    family: 'Binary data',
    summary:
        'The acknowledgement sent in reply to a type 6 binary addressed '
        'message.',
    emittedBy: 'Any station that received a type 6',
    bits: 168,
    cadence: 'On reply',
  ),
  DocMessageType(
    type: 17,
    name: 'DGNSS Binary Broadcast Message',
    family: 'Binary data',
    summary:
        'Differential GNSS correction data broadcast by shore stations to '
        'improve positioning accuracy in the covered area.',
    emittedBy: 'DGNSS reference stations',
    bits: 816,
    cadence: 'Periodic',
  ),
  DocMessageType(
    type: 25,
    name: 'Single Slot Binary Message',
    family: 'Binary data',
    summary:
        'A short binary message fitting in a single TDMA slot, with an '
        'optional destination and application ID.',
    emittedBy: 'Any station',
    bits: 168,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 26,
    name: 'Multiple Slot Binary Message',
    family: 'Binary data',
    summary:
        'A longer binary message spread over several TDMA slots, carrying '
        'radio-status information.',
    emittedBy: 'Any station',
    bits: 1064,
    cadence: 'On demand',
  ),
  // Base station & network
  DocMessageType(
    type: 4,
    name: 'Base Station Report',
    family: 'Base station & network',
    summary:
        'The periodic report of a fixed shore station: its position plus the '
        'UTC date and time reference.',
    emittedBy: 'Fixed base stations',
    bits: 168,
    cadence: 'Every 10 s',
  ),
  DocMessageType(
    type: 11,
    name: 'UTC and Date Response',
    family: 'Base station & network',
    summary:
        'Identical in structure to type 4, sent as the answer to a type 10 '
        'UTC/date inquiry.',
    emittedBy: 'Base stations',
    bits: 168,
    cadence: 'On inquiry',
  ),
  DocMessageType(
    type: 10,
    name: 'UTC and Date Inquiry',
    family: 'Base station & network',
    summary:
        'A small request asking a specific station for its UTC date and time.',
    emittedBy: 'Any station',
    bits: 72,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 20,
    name: 'Data Link Management',
    family: 'Base station & network',
    summary:
        'A network housekeeping message used to allocate and reserve TDMA '
        'time slots in an area.',
    emittedBy: 'Base stations',
    bits: 160,
    cadence: 'Network management',
  ),
  DocMessageType(
    type: 22,
    name: 'Channel Management',
    family: 'Base station & network',
    summary:
        'Used by a base station to switch stations to different VHF '
        'channels within a geographic zone.',
    emittedBy: 'Base stations',
    bits: 168,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 23,
    name: 'Group Assignment Command',
    family: 'Base station & network',
    summary:
        'A command sent by a base station to a group of vessels within a '
        'zone, setting reporting intervals and transmission mode.',
    emittedBy: 'Base stations',
    bits: 160,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 15,
    name: 'Interrogation',
    family: 'Base station & network',
    summary:
        'A request asking one or two specific stations to send a particular '
        'message type (usually type 3 or 5).',
    emittedBy: 'Base stations',
    bits: 160,
    cadence: 'On demand',
  ),
  DocMessageType(
    type: 16,
    name: 'Assignment Mode Command',
    family: 'Base station & network',
    summary:
        'Instructs up to two vessels to transmit on a specific slot '
        'allocation (assignment mode).',
    emittedBy: 'Base stations',
    bits: 144,
    cadence: 'On demand',
  ),
  // AtoN
  DocMessageType(
    type: 21,
    name: 'Aid-to-Navigation Report',
    family: 'Aid to navigation',
    summary:
        'Broadcasts the position, name and status of an aid to navigation — '
        'buoys, beacons, lighthouses, or virtual aids. Often sent from a '
        'virtual position.',
    emittedBy: 'AtoN stations (real or virtual)',
    bits: 360,
    cadence: 'Every 3 min (or on event)',
  ),
];

/// A milestone in the history of AIS.
class DocEvent {
  final String year;
  final String title;
  final String text;

  const DocEvent({
    required this.year,
    required this.title,
    required this.text,
  });
}

/// Chronology used by the interactive history timeline.
const List<DocEvent> kAisTimeline = [
  DocEvent(
    year: '1990s',
    title: 'A Swedish invention',
    text:
        'The concept is born in Sweden: a VHF system where every ship '
        'announces itself so that others "see and be seen", even in fog '
        'and behind islands. It is presented to the IMO and becomes the '
        'seed of AIS.',
  ),
  DocEvent(
    year: '1998',
    title: 'Standardisation begins',
    text:
        'The ITU and IEC start turning the concept into a radio standard '
        'with precise bit-level formats, based on TDMA over two VHF '
        'channels.',
  ),
  DocEvent(
    year: '2001',
    title: 'ITU-R M.1371 published',
    text:
        'Recommendation ITU-R M.1371 "Technical characteristics for a '
        'universal shipborne automatic identification system" defines the '
        '27 message types and their bit layout.',
  ),
  DocEvent(
    year: '2002',
    title: 'SOLAS mandate',
    text:
        'The IMO makes AIS mandatory for all international vessels over '
        '300 gross tons and all passenger ships — roughly 100,000 vessels. '
        'AIS becomes a standard anti-collision aid alongside radar.',
  ),
  DocEvent(
    year: '2006',
    title: 'Class B arrives',
    text:
        'The Class B standard is published, opening the door to cheap, '
        'simpler transponders. The same year, the TacSat-2 satellite '
        'becomes the first to capture AIS signals from space (S-AIS).',
  ),
  DocEvent(
    year: '2008-2015',
    title: 'Satellite constellations',
    text:
        'exactEarth, ORBCOMM, Spire and others deploy AIS receivers in '
        'low-Earth orbit, extending coverage far beyond the VHF horizon '
        'and enabling near-global vessel tracking.',
  ),
  DocEvent(
    year: '2010',
    title: 'AIS-SART in GMDSS',
    text:
        'The AIS search-and-rescue transmitter (AIS-SART, IEC 61097-14) '
        'joins the Global Maritime Distress and Safety System, letting '
        'lifeboats broadcast distress positions over AIS.',
  ),
  DocEvent(
    year: '2014',
    title: 'Fisheries & inland fleets',
    text:
        'European rules require Class A AIS on all EU fishing vessels over '
        '15 m; inland-waterways AIS is widely deployed on European rivers.',
  ),
  DocEvent(
    year: '2021',
    title: '1.6 million ships',
    text:
        'More than 1.6 million vessels are fitted with AIS, feeding '
        'terrestrial and satellite networks that power ship tracking, '
        'fisheries control and maritime security worldwide.',
  ),
  DocEvent(
    year: 'Next',
    title: 'VDES — the successor',
    text:
        'The VHF Data Exchange System (ITU-R M.2092) is being rolled out '
        'to relieve congested areas, adding far more bandwidth and secure '
        'e-navigation services.',
  ),
];

/// Navigation status codes of the Common Navigation Block.
const List<(int, String)> kNavStatus = [
  (0, 'Under way using engine'),
  (1, 'At anchor'),
  (2, 'Not under command'),
  (3, 'Restricted manoeuvrability'),
  (4, 'Constrained by her draught'),
  (5, 'Moored'),
  (6, 'Aground'),
  (7, 'Engaged in fishing'),
  (8, 'Under way sailing'),
  (9, 'Reserved (HSC)'),
  (10, 'Reserved (WIG)'),
  (11, 'Towing astern (regional)'),
  (12, 'Pushing ahead / towing alongside (regional)'),
  (13, 'Reserved for future use'),
  (14, 'AIS-SART active'),
  (15, 'Undefined (default)'),
];

/// EPFD fix types.
const List<(int, String)> kEpfdTypes = [
  (0, 'Undefined (default)'),
  (1, 'GPS'),
  (2, 'GLONASS'),
  (3, 'GPS + GLONASS'),
  (4, 'Loran-C'),
  (5, 'Chayka'),
  (6, 'Integrated navigation system'),
  (7, 'Surveyed (fixed)'),
  (8, 'Galileo'),
  (15, 'Internal GNSS'),
];

/// MMSI number formats (from gpsd / ITU).
const List<(String, String)> kMmsiFormats = [
  ('8MIDXXXXX', 'Diver\'s radio'),
  ('MIDXXXXXX', 'Ship'),
  ('0MIDXXXXX', 'Group of ships (e.g. a fleet or the USCG)'),
  ('00MIDXXXX', 'Coastal / shore station'),
  ('111MIDXXX', 'SAR aircraft'),
  ('98MIDXXXX', 'Auxiliary craft associated with a parent ship'),
  ('99MIDXXXX', 'Aid to navigation'),
  ('970MIDXXX', 'AIS-SART (search & rescue transmitter)'),
  ('972XXXXXX', 'MOB (man overboard) device'),
  ('974XXXXXX', 'AIS EPIRB (emergency beacon)'),
];

/// Coarse ITU-R M.1371 ship-type categories.
const List<(String, String)> kVesselTypeCategories = [
  ('0-9', 'Reserved / future use'),
  ('10-19', 'Reserved for future use'),
  ('20-29', 'Wing in ground (WIG) craft'),
  ('30-39', 'Fishing'),
  ('40-49', 'High-speed craft'),
  ('50-59', 'Special craft (pilot, tugs, dredgers…)'),
  ('60-69', 'Passenger ships'),
  ('70-79', 'Cargo ships'),
  ('80-89', 'Tankers'),
  ('90-99', 'Other types'),
];

/// NMEA 4.0 AIS talker IDs.
const Map<String, String> kTalkerIds = {
  'AB': 'Base AIS station',
  'AD': 'Dependent AIS base station',
  'AI': 'Mobile AIS station',
  'AN': 'Aid-to-navigation AIS station',
  'AR': 'AIS receiving station',
  'AS': 'Limited base station',
  'AT': 'AIS transmitting station',
  'AX': 'AIS repeater station',
  'BS': 'Base AIS station (deprecated)',
  'SA': 'Physical shore AIS station',
};

/// Builds a plausible, always-decodable NMEA sample for a message type.
String sampleSentencesFor(int type) {
  switch (type) {
    case 1 || 2 || 3:
      return encodePositionReport(
        mmsi: 227006789,
        latitude: 48.39,
        longitude: -4.49,
        sog: 12.5,
        cog: 245,
        heading: 250,
        navigationStatus: 0,
      );
    case 4:
      return encodeBaseStationReport(
        mmsi: 227010000,
        year: 2026,
        month: 8,
        day: 6,
        hour: 12,
        minute: 30,
        second: 0,
        latitude: 48.39,
        longitude: -4.49,
      );
    case 5:
      return encodeStaticAndVoyage(
        mmsi: 227006789,
        name: 'KIKAIS',
        callSign: 'FLO21',
        imoNumber: 9000000,
        vesselType: 70,
        dimensionBow: 20,
        dimensionStern: 80,
        dimensionPort: 10,
        dimensionStarboard: 10,
        draught: 8,
        destination: 'BREST',
      );
    case 6:
      return encodeBinaryAddressed(
        mmsi: 227006789,
        destinationMmsi: 227010000,
        dac: 1,
        fid: 11,
        data: const [1, 2, 3, 4],
      );
    case 7:
      return encodeBinaryAcknowledge(
        mmsi: 227010000,
        destinationMmsis: const [227006789],
      );
    case 8:
      return encodeBinaryBroadcast(
        mmsi: 227010000,
        dac: 1,
        fid: 11,
        data: const [1, 2, 3, 4, 5, 6, 7, 8],
      );
    case 9:
      return encodeSarAircraftPosition(
        mmsi: 111227001,
        latitude: 48.4,
        longitude: -4.5,
        cog: 250,
        altitude: 300,
        sog: 120,
      );
    case 10:
      return encodeUtcDateInquiry(
        mmsi: 227006789,
        destinationMmsi: 227010000,
      );
    case 11:
      return encodeUtcDateResponse(
        mmsi: 227010000,
        year: 2026,
        month: 8,
        day: 6,
        hour: 12,
        minute: 30,
        second: 0,
        latitude: 48.39,
        longitude: -4.49,
      );
    case 12:
      return encodeAddressedSafety(
        mmsi: 227006789,
        destinationMmsi: 227010000,
        text: 'MAN OVERBOARD',
      );
    case 13:
      return encodeSafetyAck(
        mmsi: 227010000,
        destinationMmsis: const [227006789],
      );
    case 14:
      return encodeSafetyBroadcast(
        mmsi: 227010000,
        text: 'NAVIGATION OBSTRUCTION REPORTED',
      );
    case 15:
      return encodeInterrogation(
        mmsi: 227010000,
        mmsi1: 227006789,
        type1_1: 3,
      );
    case 16:
      return encodeAssignmentMode(
        mmsi: 227010000,
        mmsi1: 227006789,
        offset1: 100,
        increment1: 5,
      );
    case 17:
      return encodeDgnssBroadcast(
        mmsi: 227010000,
        latitude: 48.39,
        longitude: -4.49,
      );
    case 18:
      return encodeClassBPosition(
        mmsi: 227506789,
        latitude: 48.4,
        longitude: -4.48,
        sog: 6.2,
        cog: 120,
        heading: 125,
      );
    case 19:
      return encodeClassBExtended(
        mmsi: 227506789,
        latitude: 48.4,
        longitude: -4.48,
        sog: 6.2,
        cog: 120,
        heading: 125,
        name: 'PETIT BATEAU',
        vesselType: 36,
      );
    case 20:
      return encodeDataLinkManagement(mmsi: 227010000);
    case 21:
      return encodeAidToNavigation(
        mmsi: 992271001,
        latitude: 48.45,
        longitude: -4.5,
        name: 'PORT BUOY',
      );
    case 22:
      return encodeChannelManagement(
        mmsi: 227010000,
        channelA: 2087,
        channelB: 2088,
        txrxMode: 0,
        neLatitude: 48.5,
        neLongitude: -4.4,
        swLatitude: 48.3,
        swLongitude: -4.6,
      );
    case 23:
      return encodeGroupAssignment(
        mmsi: 227010000,
        neLatitude: 48.5,
        neLongitude: -4.4,
        swLatitude: 48.3,
        swLongitude: -4.6,
      );
    case 24:
      return [
        encodeStaticDataReportPartA(mmsi: 227506789, name: 'PETIT BATEAU'),
        encodeStaticDataReportPartB(
          mmsi: 227506789,
          callSign: 'FLO22',
          shipType: 36,
        ),
      ].join('\n');
    case 25:
      return encodeSingleSlotBinary(
        mmsi: 227006789,
        data: const [1, 2, 3, 4, 5, 6],
      );
    case 26:
      return encodeMultipleSlotBinary(
        mmsi: 227006789,
        data: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      );
    case 27:
      return encodeLongRangeBroadcast(
        mmsi: 227006789,
        latitude: 48.4,
        longitude: -4.49,
        sog: 12,
        cog: 245,
      );
    default:
      return '';
  }
}

/// A single bit field of an AIS payload, used by the interactive bit layout.
class DocBitField {
  final String name;
  final int start;
  final int end;
  final String description;
  const DocBitField(this.name, this.start, this.end, this.description);
}

/// An interactive bit-layout definition (label + ordered fields).
class DocBitLayout {
  final String label;
  final List<DocBitField> fields;
  const DocBitLayout(this.label, this.fields);
}

const List<DocBitField> _cnb = [
  DocBitField('Type', 0, 5, 'Message type (1-3): identifies the payload.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator: hops this message has been rebroadcast.'),
  DocBitField('MMSI', 8, 37, 'The 9-digit station identity (first 3 digits = country MID).'),
  DocBitField('Nav status', 38, 41, 'Navigation status: under way, at anchor, moored, fishing…'),
  DocBitField('ROT', 42, 49, 'Rate of turn, signed. Value ≈ 4.733 × √(°/min).'),
  DocBitField('SOG', 50, 59, 'Speed over ground in tenths of a knot.'),
  DocBitField('Accuracy', 60, 60, 'Position accuracy: 1 = DGPS-quality (< 10 m).'),
  DocBitField('Longitude', 61, 88, 'Longitude in 1/10 000 of a minute (÷ 600000 = degrees).'),
  DocBitField('Latitude', 89, 115, 'Latitude in 1/10 000 of a minute (÷ 600000 = degrees).'),
  DocBitField('COG', 116, 127, 'Course over ground in tenths of a degree.'),
  DocBitField('Heading', 128, 136, 'True heading in degrees (511 = not available).'),
  DocBitField('Timestamp', 137, 142, 'Second of the UTC fix time (0-59).'),
  DocBitField('Maneuver', 143, 144, 'Maneuver indicator (special maneuver or not).'),
  DocBitField('Spare', 145, 147, 'Spare bits — ignore.'),
  DocBitField('RAIM', 148, 148, 'Receiver autonomous integrity monitoring flag.'),
  DocBitField('Radio', 149, 167, 'SOTDMA radio status / slot information.'),
];

const List<DocBitField> _base = [
  DocBitField('Type', 0, 5, 'Message type (4): base station report.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator.'),
  DocBitField('MMSI', 8, 37, 'Base station identity.'),
  DocBitField('Year', 38, 51, 'UTC year (0 = not available).'),
  DocBitField('Month', 52, 55, 'UTC month (0 = not available).'),
  DocBitField('Day', 56, 60, 'UTC day (0 = not available).'),
  DocBitField('Hour', 61, 65, 'UTC hour (24 = not available).'),
  DocBitField('Minute', 66, 71, 'UTC minute (60 = not available).'),
  DocBitField('Second', 72, 77, 'UTC second (60 = not available).'),
  DocBitField('Accuracy', 78, 78, 'Fix quality: 1 = DGPS-quality.'),
  DocBitField('Longitude', 79, 106, 'Longitude (÷ 600000 = degrees).'),
  DocBitField('Latitude', 107, 133, 'Latitude (÷ 600000 = degrees).'),
  DocBitField('EPFD', 134, 137, 'Position fix type (GPS, GLONASS…).'),
  DocBitField('Spare', 138, 147, 'Spare bits.'),
  DocBitField('RAIM', 148, 148, 'RAIM flag.'),
  DocBitField('SOTDMA', 149, 167, 'SOTDMA radio status.'),
];

const List<DocBitField> _static5 = [
  DocBitField('Type', 0, 5, 'Message type (5): static & voyage data.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator.'),
  DocBitField('MMSI', 8, 37, 'Ship identity.'),
  DocBitField('Version', 38, 39, 'AIS version (0 = ITU-R M.1371-1).'),
  DocBitField('IMO', 40, 69, 'IMO number (7 digits, 0 = not available).'),
  DocBitField('Call sign', 70, 111, 'Call sign (7 six-bit characters).'),
  DocBitField('Name', 112, 231, 'Vessel name (20 six-bit characters).'),
  DocBitField('Ship type', 232, 239, 'ITU ship type code (0-99).'),
  DocBitField('Bow', 240, 248, 'Dimension to bow (metres).'),
  DocBitField('Stern', 249, 257, 'Dimension to stern (metres).'),
  DocBitField('Port', 258, 263, 'Dimension to port (metres).'),
  DocBitField('Starboard', 264, 269, 'Dimension to starboard (metres).'),
  DocBitField('EPFD', 270, 273, 'Position fix type.'),
  DocBitField('ETA month', 274, 277, 'Estimated arrival month (0 = not available).'),
  DocBitField('ETA day', 278, 282, 'Estimated arrival day.'),
  DocBitField('ETA hour', 283, 287, 'Estimated arrival hour (24 = not available).'),
  DocBitField('ETA minute', 288, 293, 'Estimated arrival minute (60 = not available).'),
  DocBitField('Draught', 294, 301, 'Draught in decimetres.'),
  DocBitField('Destination', 302, 421, 'Destination (20 six-bit characters).'),
  DocBitField('DTE', 422, 422, 'Data terminal equipment ready flag.'),
  DocBitField('Spare', 423, 423, 'Spare bit.'),
];

const List<DocBitField> _classB18 = [
  DocBitField('Type', 0, 5, 'Message type (18): Class B position.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator.'),
  DocBitField('MMSI', 8, 37, 'Ship identity.'),
  DocBitField('Spare', 38, 45, 'Spare bits.'),
  DocBitField('SOG', 46, 55, 'Speed over ground in tenths of a knot.'),
  DocBitField('Accuracy', 56, 56, 'Position accuracy flag.'),
  DocBitField('Longitude', 57, 84, 'Longitude (÷ 600000 = degrees).'),
  DocBitField('Latitude', 85, 111, 'Latitude (÷ 600000 = degrees).'),
  DocBitField('COG', 112, 123, 'Course over ground in tenths of a degree.'),
  DocBitField('Heading', 124, 132, 'True heading in degrees (511 = not available).'),
  DocBitField('Timestamp', 133, 138, 'Second of the UTC fix time.'),
  DocBitField('Flags', 139, 146, 'Regional, CS, display, DSC, band, msg22, assigned.'),
  DocBitField('RAIM', 147, 147, 'RAIM flag.'),
  DocBitField('Radio', 148, 167, 'CSTDMA radio status.'),
];

const List<DocBitField> _aton21 = [
  DocBitField('Type', 0, 5, 'Message type (21): aid-to-navigation report.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator.'),
  DocBitField('MMSI', 8, 37, 'AtoN identity (99MIDXXXX).'),
  DocBitField('Aid type', 38, 42, 'Type of aid (buoy, beacon, light…).'),
  DocBitField('Name', 43, 162, 'Name of the aid (20 six-bit characters).'),
  DocBitField('Accuracy', 163, 163, 'Position accuracy flag.'),
  DocBitField('Longitude', 164, 191, 'Longitude (÷ 600000 = degrees).'),
  DocBitField('Latitude', 192, 218, 'Latitude (÷ 600000 = degrees).'),
  DocBitField('Bow', 219, 227, 'Dimension to bow (metres).'),
  DocBitField('Stern', 228, 236, 'Dimension to stern (metres).'),
  DocBitField('Port', 237, 242, 'Dimension to port (metres).'),
  DocBitField('Starboard', 243, 248, 'Dimension to starboard (metres).'),
  DocBitField('EPFD', 249, 252, 'Position fix type.'),
  DocBitField('Second', 253, 258, 'Time of fix (UTC second).'),
  DocBitField('Off position', 259, 259, '1 = the aid is off its assigned position.'),
  DocBitField('Regional', 260, 267, 'Regional reserved bits.'),
  DocBitField('RAIM', 268, 268, 'RAIM flag.'),
  DocBitField('Virtual', 269, 269, '1 = virtual aid (no physical marker).'),
  DocBitField('Assigned', 270, 270, 'Assigned mode flag.'),
  DocBitField('Name ext', 271, 359, 'Name extension (14 six-bit characters).'),
];

const List<DocBitField> _static24A = [
  DocBitField('Type', 0, 5, 'Message type (24): static data report.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator.'),
  DocBitField('MMSI', 8, 37, 'Ship identity.'),
  DocBitField('Part', 38, 39, 'Part number (0 = Part A).'),
  DocBitField('Name', 40, 159, 'Vessel name (20 six-bit characters).'),
];

const List<DocBitField> _static24B = [
  DocBitField('Type', 0, 5, 'Message type (24): static data report.'),
  DocBitField('Repeat', 6, 7, 'Repeat indicator.'),
  DocBitField('MMSI', 8, 37, 'Ship identity.'),
  DocBitField('Part', 38, 39, 'Part number (1 = Part B).'),
  DocBitField('Ship type', 40, 47, 'ITU ship type code.'),
  DocBitField('Vendor', 48, 65, 'Vendor ID (3 six-bit characters).'),
  DocBitField('Model', 66, 69, 'Unit model code.'),
  DocBitField('Serial', 70, 89, 'Unit serial number.'),
  DocBitField('Call sign', 90, 131, 'Call sign (7 six-bit characters).'),
  DocBitField('Bow', 132, 140, 'Dimension to bow (metres).'),
  DocBitField('Stern', 141, 149, 'Dimension to stern (metres).'),
  DocBitField('Port', 150, 155, 'Dimension to port (metres).'),
  DocBitField('Starboard', 156, 161, 'Dimension to starboard (metres).'),
  DocBitField('Spare', 162, 167, 'Spare bits.'),
];

/// Bit layouts available in the interactive viewer.
const List<DocBitLayout> kBitLayouts = [
  DocBitLayout('Type 1/2/3 — Position report', _cnb),
  DocBitLayout('Type 4 — Base station', _base),
  DocBitLayout('Type 5 — Static & voyage', _static5),
  DocBitLayout('Type 18 — Class B position', _classB18),
  DocBitLayout('Type 21 — Aid to navigation', _aton21),
  DocBitLayout('Type 24A — Static (name)', _static24A),
  DocBitLayout('Type 24B — Static (ship data)', _static24B),
];

/// Searchable glossary of AIS terms.
const List<(String, String)> kGlossary = [
  ('AIS', 'Automatic Identification System — the VHF tracking system described by this guide.'),
  ('SOTDMA', 'Self-Organizing Time Division Multiple Access — the TDMA scheme used by Class A transponders to reserve their own time slots.'),
  ('CSTDMA', 'Carrier Sense Time Division Multiple Access — the simpler scheme used by Class B: listen for a free slot and grab it.'),
  ('TDMA', 'Time Division Multiple Access — dividing one radio channel into time slots shared by many stations.'),
  ('MMSI', 'Maritime Mobile Service Identity — the unique 9-digit number identifying a ship\'s radio equipment.'),
  ('MID', 'Maritime Identification Digits — the first three digits of an MMSI, identifying the issuing country.'),
  ('VTS', 'Vessel Traffic Service — shore-based traffic monitoring and management.'),
  ('VDES', 'VHF Data Exchange System — the next-generation successor to AIS (ITU-R M.2092).'),
  ('S-AIS', 'Satellite AIS — receiving AIS signals from low-Earth-orbit satellites for global coverage.'),
  ('T-AIS', 'Terrestrial AIS — ship-to-ship and ship-to-shore AIS within VHF range.'),
  ('EPFD', 'Electronic Position Fixing Device — the GNSS receiver feeding the transponder (GPS, GLONASS, Galileo…).'),
  ('RAIM', 'Receiver Autonomous Integrity Monitoring — on-board GNSS health checking.'),
  ('ROT', 'Rate of Turn — how fast a vessel turns, encoded with a square-root scale.'),
  ('SOG', 'Speed Over Ground — vessel speed relative to the seabed.'),
  ('COG', 'Course Over Ground — direction of travel relative to true north.'),
  ('CPA', 'Closest Point of Approach — the closest a target will pass, used for collision alarms.'),
  ('DGPS', 'Differential GPS — corrections that improve GNSS accuracy to a few metres.'),
  ('DR', 'Dead Reckoning — estimating position from course and speed rather than a fix.'),
  ('SART', 'Search and Rescue Transmitter — a distress beacon (AIS-SART broadcasts on MMSI 970MIDXXX).'),
  ('MOB', 'Man Overboard — a personal AIS beacon (MMSI 972XXXXXX).'),
  ('EPIRB', 'Emergency Position Indicating Radio Beacon — a float-free distress beacon (AIS EPIRB, MMSI 974XXXXXX).'),
  ('IALA', 'International Association of Marine Aids to Navigation and Lighthouse Authorities.'),
  ('SOLAS', 'International Convention for the Safety of Life at Sea — the IMO treaty that mandates AIS.'),
  ('IMO', 'International Maritime Organization — the UN agency governing shipping.'),
  ('ITU', 'International Telecommunication Union — publishes Recommendation M.1371 (the AIS standard).'),
  ('IEC', 'International Electrotechnical Commission — publishes the NMEA framing and equipment standards.'),
  ('HDLC', 'High-Level Data Link Control — the framing used on the radio link inside AIS.'),
  ('NRZI', 'Non-Return-to-Zero Inverted — the line coding used before modulation.'),
  ('GMSK', 'Gaussian Minimum Shift Keying — the modulation used for AIS (9600 baud).'),
  ('Class A', 'Full-feature AIS transponder for SOLAS vessels (types 1/2/3 and 5, SOTDMA).'),
  ('Class B', 'Low-cost AIS transponder for recreational/small craft (types 18/19 and 24, CSTDMA).'),
  ('AtoN', 'Aid to Navigation — buoys, beacons and lights broadcasting via type 21.'),
  ('NMEA', 'National Marine Electronics Association — the sentence formats used on the data wire.'),
  ('AIVDM', 'An NMEA sentence reporting another station (AIVDO reports your own).'),
  ('AIS-SART', 'A lifeboat distress transmitter that appears as navigation status 14.'),
  ('UTC', 'Coordinated Universal Time — the time reference used by AIS.'),
  ('GNSS', 'Global Navigation Satellite System — GPS, GLONASS, Galileo, BeiDou.'),
  ('Checksum', 'A one-byte XOR used to detect corrupted NMEA sentences.'),
];

/// Returns the full ITU ship-type table (0-99) using the app decoder mapping.
List<(int, String)> kVesselTypesFull() {
  final converter = BinaryConverter();
  return [
    for (var t = 0; t <= 99; t++) (t, converter.getVesselTypeDirect(t)),
  ];
}

/// Class A vs Class B comparison rows: attribute, Class A, Class B.
const List<(String, String, String)> kClassComparison = [
  ('Standard', 'Full AIS for SOLAS vessels', 'Simplified AIS for smaller craft'),
  ('Position report', 'Type 1/2/3 (with nav status & ROT)', 'Type 18 (lighter), 19 (extended)'),
  ('Static data', 'Type 5 (name, IMO, voyage)', 'Type 24 (Part A + Part B)'),
  ('Access scheme', 'SOTDMA — reserves its own slots', 'CSTDMA — grabs a free slot'),
  ('Report rate', '2-10 s underway, 3 min anchored', '~30 s'),
  ('Transmit power', '12.5 W typical', '2 W typical'),
  ('Mandatory', 'Yes (SOLAS 300 GT+)', 'Optional / regional rules'),
  ('Cost', 'High', 'Low'),
];

/// Distress / safety transmitters and how to recognise them.
const List<(String, String, String)> kDistressDevices = [
  ('970MIDXXX', 'AIS-SART', 'Lifeboat search-and-rescue transmitter. Sends short bursts and shows up as navigation status 14.'),
  ('972XXXXXX', 'MOB', 'Man-overboard personal beacon worn on the crew.'),
  ('974XXXXXX', 'AIS EPIRB', 'Float-free emergency beacon for ship distress.'),
  ('111MIDXXX', 'SAR aircraft', 'Search-and-rescue aircraft reporting via type 9.'),
];

/// Real-world quirks worth knowing when receiving AIS.
const List<(String, String)> kAisGotchas = [
  ('Wrong payload lengths',
      'About 0.3% of real-world messages have the right checksum but the '
      'wrong payload length for their type. A decoder should reject them, '
      'otherwise the fields decode as garbage.'),
  ('Six-bit text noise',
      'Transmitters pad text fields with "@"; many also leave garbage after '
      'the "@", and some space-fill short names. Decoders must strip both.'),
  ('Lowercase letters are impossible',
      'The six-bit alphabet cannot encode lowercase letters, so names and '
      'call signs are uppercase in AIS.'),
  ('Spare and regional fields',
      'Spare bits should be ignored but are not always zero. Regional '
      'fields are sometimes repurposed by local authorities.'),
  ('8-digit MMSIs',
      'US vessels sailing only in US waters sometimes omit the leading "3", '
      'transmitting 8-digit MMSIs.'),
  ('Special timestamps',
      'The type 1-3 timestamp is the UTC second, but 61 (manual input), 62 '
      '(dead reckoning) and 63 (inoperative) are special values.'),
  ('ROT special values',
      'Rate of turn ±127 means "turning faster than 5°/30s, no turn '
      'indicator", and -128 means "no turn information".'),
  ('Ships that switch AIS off',
      'AIS is cooperative: some vessels disable it for operational or '
      'security reasons, and the channel can be jammed or spoofed.'),
];

/// Keywords per chapter (0-indexed) used for full-text search.
const Map<int, List<String>> kChapterKeywords = {
  0: ['AIS', 'introduction', 'radar', 'VTS', 'SOLAS', 'ADS-B'],
  1: ['history', 'Sweden', 'IMO', 'SOLAS', '2002', 'class b', 'satellite', 'VDES'],
  2: ['VHF', 'channel', '161.975', '162.025', 'TDMA', 'slot', 'range', 'report'],
  3: ['radio', 'SOTDMA', 'CSTDMA', 'HDLC', 'GMSK', '9600', 'NRZI', 'frame', 'slots'],
  4: ['class a', 'class b', 'SOTDMA', 'CSTDMA', 'comparison', 'transponder', 'SART', 'MOB', 'EPIRB'],
  5: ['MMSI', 'MID', 'country', 'format', 'identity'],
  6: ['ship type', 'vessel type', 'cargo', 'tanker', 'fishing', 'tug', 'passenger', '0-99'],
  7: ['message', 'type 1', 'type 5', 'catalog', 'position', 'static', 'safety', 'binary'],
  8: ['NMEA', 'AIVDM', 'AIVDO', 'sentence', 'payload', 'checksum', 'fragment', 'armoring', 'six-bit'],
  9: ['bits', 'payload', 'bit layout', 'coordinate', 'longitude', 'latitude', 'six-bit', 'nav status', 'EPFD'],
  10: ['security', 'spoofing', 'jamming', 'meaconing', 'data quality', 'privacy'],
  11: ['gotchas', 'quirks', 'length', 'noise', 'timestamp', 'regional', '8-digit'],
  12: ['kikais', 'reception', 'decoder', 'editor', 'simulation', 'map', 'stats'],
  13: ['glossary', 'terms', 'SOTDMA', 'MMSI', 'VDES', 'dictionary'],
  14: ['cheat sheet', 'reference', 'frequencies', 'report rates', 'at a glance'],
  15: ['sources', 'gpsd', 'wikipedia', 'navcen', 'ITU', 'IALA', 'IEC'],
};
