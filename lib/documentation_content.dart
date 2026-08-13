import 'ais/src/encoder/ais_message_encoder.dart';
import 'ais/src/utils/binary_conversion.dart';
import 'l10n/generated/app_localizations.dart';

/// A single AIS message type described for the documentation.
class DocMessageType {
  final int type;
  final String nameKey;
  final String familyKey;
  final String summaryKey;
  final String emittedByKey;
  final int bits;
  final String cadenceKey;

  const DocMessageType({
    required this.type,
    required this.nameKey,
    required this.familyKey,
    required this.summaryKey,
    required this.emittedByKey,
    required this.bits,
    required this.cadenceKey,
  });
}

/// The 27 international AIS message types from ITU-R M.1371.
const List<DocMessageType> kDocMessageTypes = [
  // Position reports
  DocMessageType(
    type: 1,
    nameKey: 'docType1Name',
    familyKey: 'docType1Family',
    summaryKey: 'docType1Summary',
    emittedByKey: 'docType1EmittedBy',
    bits: 168,
    cadenceKey: 'docType1Cadence',
  ),
  DocMessageType(
    type: 2,
    nameKey: 'docType2Name',
    familyKey: 'docType2Family',
    summaryKey: 'docType2Summary',
    emittedByKey: 'docType2EmittedBy',
    bits: 168,
    cadenceKey: 'docType2Cadence',
  ),
  DocMessageType(
    type: 3,
    nameKey: 'docType3Name',
    familyKey: 'docType3Family',
    summaryKey: 'docType3Summary',
    emittedByKey: 'docType3EmittedBy',
    bits: 168,
    cadenceKey: 'docType3Cadence',
  ),
  DocMessageType(
    type: 18,
    nameKey: 'docType18Name',
    familyKey: 'docType18Family',
    summaryKey: 'docType18Summary',
    emittedByKey: 'docType18EmittedBy',
    bits: 168,
    cadenceKey: 'docType18Cadence',
  ),
  DocMessageType(
    type: 19,
    nameKey: 'docType19Name',
    familyKey: 'docType19Family',
    summaryKey: 'docType19Summary',
    emittedByKey: 'docType19EmittedBy',
    bits: 312,
    cadenceKey: 'docType19Cadence',
  ),
  DocMessageType(
    type: 27,
    nameKey: 'docType27Name',
    familyKey: 'docType27Family',
    summaryKey: 'docType27Summary',
    emittedByKey: 'docType27EmittedBy',
    bits: 96,
    cadenceKey: 'docType27Cadence',
  ),
  DocMessageType(
    type: 9,
    nameKey: 'docType9Name',
    familyKey: 'docType9Family',
    summaryKey: 'docType9Summary',
    emittedByKey: 'docType9EmittedBy',
    bits: 168,
    cadenceKey: 'docType9Cadence',
  ),
  // Static & voyage
  DocMessageType(
    type: 5,
    nameKey: 'docType5Name',
    familyKey: 'docType5Family',
    summaryKey: 'docType5Summary',
    emittedByKey: 'docType5EmittedBy',
    bits: 424,
    cadenceKey: 'docType5Cadence',
  ),
  DocMessageType(
    type: 24,
    nameKey: 'docType24Name',
    familyKey: 'docType24Family',
    summaryKey: 'docType24Summary',
    emittedByKey: 'docType24EmittedBy',
    bits: 168,
    cadenceKey: 'docType24Cadence',
  ),
  // Safety & text
  DocMessageType(
    type: 14,
    nameKey: 'docType14Name',
    familyKey: 'docType14Family',
    summaryKey: 'docType14Summary',
    emittedByKey: 'docType14EmittedBy',
    bits: 1008,
    cadenceKey: 'docType14Cadence',
  ),
  DocMessageType(
    type: 12,
    nameKey: 'docType12Name',
    familyKey: 'docType12Family',
    summaryKey: 'docType12Summary',
    emittedByKey: 'docType12EmittedBy',
    bits: 1008,
    cadenceKey: 'docType12Cadence',
  ),
  DocMessageType(
    type: 13,
    nameKey: 'docType13Name',
    familyKey: 'docType13Family',
    summaryKey: 'docType13Summary',
    emittedByKey: 'docType13EmittedBy',
    bits: 168,
    cadenceKey: 'docType13Cadence',
  ),
  // Binary
  DocMessageType(
    type: 8,
    nameKey: 'docType8Name',
    familyKey: 'docType8Family',
    summaryKey: 'docType8Summary',
    emittedByKey: 'docType8EmittedBy',
    bits: 1008,
    cadenceKey: 'docType8Cadence',
  ),
  DocMessageType(
    type: 6,
    nameKey: 'docType6Name',
    familyKey: 'docType6Family',
    summaryKey: 'docType6Summary',
    emittedByKey: 'docType6EmittedBy',
    bits: 1008,
    cadenceKey: 'docType6Cadence',
  ),
  DocMessageType(
    type: 7,
    nameKey: 'docType7Name',
    familyKey: 'docType7Family',
    summaryKey: 'docType7Summary',
    emittedByKey: 'docType7EmittedBy',
    bits: 168,
    cadenceKey: 'docType7Cadence',
  ),
  DocMessageType(
    type: 17,
    nameKey: 'docType17Name',
    familyKey: 'docType17Family',
    summaryKey: 'docType17Summary',
    emittedByKey: 'docType17EmittedBy',
    bits: 816,
    cadenceKey: 'docType17Cadence',
  ),
  DocMessageType(
    type: 25,
    nameKey: 'docType25Name',
    familyKey: 'docType25Family',
    summaryKey: 'docType25Summary',
    emittedByKey: 'docType25EmittedBy',
    bits: 168,
    cadenceKey: 'docType25Cadence',
  ),
  DocMessageType(
    type: 26,
    nameKey: 'docType26Name',
    familyKey: 'docType26Family',
    summaryKey: 'docType26Summary',
    emittedByKey: 'docType26EmittedBy',
    bits: 1064,
    cadenceKey: 'docType26Cadence',
  ),
  // Base station & network
  DocMessageType(
    type: 4,
    nameKey: 'docType4Name',
    familyKey: 'docType4Family',
    summaryKey: 'docType4Summary',
    emittedByKey: 'docType4EmittedBy',
    bits: 168,
    cadenceKey: 'docType4Cadence',
  ),
  DocMessageType(
    type: 11,
    nameKey: 'docType11Name',
    familyKey: 'docType11Family',
    summaryKey: 'docType11Summary',
    emittedByKey: 'docType11EmittedBy',
    bits: 168,
    cadenceKey: 'docType11Cadence',
  ),
  DocMessageType(
    type: 10,
    nameKey: 'docType10Name',
    familyKey: 'docType10Family',
    summaryKey: 'docType10Summary',
    emittedByKey: 'docType10EmittedBy',
    bits: 72,
    cadenceKey: 'docType10Cadence',
  ),
  DocMessageType(
    type: 20,
    nameKey: 'docType20Name',
    familyKey: 'docType20Family',
    summaryKey: 'docType20Summary',
    emittedByKey: 'docType20EmittedBy',
    bits: 160,
    cadenceKey: 'docType20Cadence',
  ),
  DocMessageType(
    type: 22,
    nameKey: 'docType22Name',
    familyKey: 'docType22Family',
    summaryKey: 'docType22Summary',
    emittedByKey: 'docType22EmittedBy',
    bits: 168,
    cadenceKey: 'docType22Cadence',
  ),
  DocMessageType(
    type: 23,
    nameKey: 'docType23Name',
    familyKey: 'docType23Family',
    summaryKey: 'docType23Summary',
    emittedByKey: 'docType23EmittedBy',
    bits: 160,
    cadenceKey: 'docType23Cadence',
  ),
  DocMessageType(
    type: 15,
    nameKey: 'docType15Name',
    familyKey: 'docType15Family',
    summaryKey: 'docType15Summary',
    emittedByKey: 'docType15EmittedBy',
    bits: 160,
    cadenceKey: 'docType15Cadence',
  ),
  DocMessageType(
    type: 16,
    nameKey: 'docType16Name',
    familyKey: 'docType16Family',
    summaryKey: 'docType16Summary',
    emittedByKey: 'docType16EmittedBy',
    bits: 144,
    cadenceKey: 'docType16Cadence',
  ),
  // AtoN
  DocMessageType(
    type: 21,
    nameKey: 'docType21Name',
    familyKey: 'docType21Family',
    summaryKey: 'docType21Summary',
    emittedByKey: 'docType21EmittedBy',
    bits: 360,
    cadenceKey: 'docType21Cadence',
  ),
];

/// Resolves a [DocMessageType] name l10n key to its translated label.
String docMessageTypeName(DocMessageType m, AppLocalizations l10n) =>
    switch (m.nameKey) {
      'docType1Name' => l10n.docType1Name,
      'docType2Name' => l10n.docType2Name,
      'docType3Name' => l10n.docType3Name,
      'docType18Name' => l10n.docType18Name,
      'docType19Name' => l10n.docType19Name,
      'docType27Name' => l10n.docType27Name,
      'docType9Name' => l10n.docType9Name,
      'docType5Name' => l10n.docType5Name,
      'docType24Name' => l10n.docType24Name,
      'docType14Name' => l10n.docType14Name,
      'docType12Name' => l10n.docType12Name,
      'docType13Name' => l10n.docType13Name,
      'docType8Name' => l10n.docType8Name,
      'docType6Name' => l10n.docType6Name,
      'docType7Name' => l10n.docType7Name,
      'docType17Name' => l10n.docType17Name,
      'docType25Name' => l10n.docType25Name,
      'docType26Name' => l10n.docType26Name,
      'docType4Name' => l10n.docType4Name,
      'docType11Name' => l10n.docType11Name,
      'docType10Name' => l10n.docType10Name,
      'docType20Name' => l10n.docType20Name,
      'docType22Name' => l10n.docType22Name,
      'docType23Name' => l10n.docType23Name,
      'docType15Name' => l10n.docType15Name,
      'docType16Name' => l10n.docType16Name,
      'docType21Name' => l10n.docType21Name,
      _ => m.nameKey,
    };

/// Resolves a [DocMessageType] family l10n key to its translated label.
String docMessageTypeFamily(DocMessageType m, AppLocalizations l10n) =>
    switch (m.familyKey) {
      'docType1Family' => l10n.docType1Family,
      'docType2Family' => l10n.docType2Family,
      'docType3Family' => l10n.docType3Family,
      'docType18Family' => l10n.docType18Family,
      'docType19Family' => l10n.docType19Family,
      'docType27Family' => l10n.docType27Family,
      'docType9Family' => l10n.docType9Family,
      'docType5Family' => l10n.docType5Family,
      'docType24Family' => l10n.docType24Family,
      'docType14Family' => l10n.docType14Family,
      'docType12Family' => l10n.docType12Family,
      'docType13Family' => l10n.docType13Family,
      'docType8Family' => l10n.docType8Family,
      'docType6Family' => l10n.docType6Family,
      'docType7Family' => l10n.docType7Family,
      'docType17Family' => l10n.docType17Family,
      'docType25Family' => l10n.docType25Family,
      'docType26Family' => l10n.docType26Family,
      'docType4Family' => l10n.docType4Family,
      'docType11Family' => l10n.docType11Family,
      'docType10Family' => l10n.docType10Family,
      'docType20Family' => l10n.docType20Family,
      'docType22Family' => l10n.docType22Family,
      'docType23Family' => l10n.docType23Family,
      'docType15Family' => l10n.docType15Family,
      'docType16Family' => l10n.docType16Family,
      'docType21Family' => l10n.docType21Family,
      _ => m.familyKey,
    };

/// Resolves a [DocMessageType] summary l10n key to its translated label.
String docMessageTypeSummary(DocMessageType m, AppLocalizations l10n) =>
    switch (m.summaryKey) {
      'docType1Summary' => l10n.docType1Summary,
      'docType2Summary' => l10n.docType2Summary,
      'docType3Summary' => l10n.docType3Summary,
      'docType18Summary' => l10n.docType18Summary,
      'docType19Summary' => l10n.docType19Summary,
      'docType27Summary' => l10n.docType27Summary,
      'docType9Summary' => l10n.docType9Summary,
      'docType5Summary' => l10n.docType5Summary,
      'docType24Summary' => l10n.docType24Summary,
      'docType14Summary' => l10n.docType14Summary,
      'docType12Summary' => l10n.docType12Summary,
      'docType13Summary' => l10n.docType13Summary,
      'docType8Summary' => l10n.docType8Summary,
      'docType6Summary' => l10n.docType6Summary,
      'docType7Summary' => l10n.docType7Summary,
      'docType17Summary' => l10n.docType17Summary,
      'docType25Summary' => l10n.docType25Summary,
      'docType26Summary' => l10n.docType26Summary,
      'docType4Summary' => l10n.docType4Summary,
      'docType11Summary' => l10n.docType11Summary,
      'docType10Summary' => l10n.docType10Summary,
      'docType20Summary' => l10n.docType20Summary,
      'docType22Summary' => l10n.docType22Summary,
      'docType23Summary' => l10n.docType23Summary,
      'docType15Summary' => l10n.docType15Summary,
      'docType16Summary' => l10n.docType16Summary,
      'docType21Summary' => l10n.docType21Summary,
      _ => m.summaryKey,
    };

/// Resolves a [DocMessageType] emitted-by l10n key to its translated label.
String docMessageTypeEmittedBy(DocMessageType m, AppLocalizations l10n) =>
    switch (m.emittedByKey) {
      'docType1EmittedBy' => l10n.docType1EmittedBy,
      'docType2EmittedBy' => l10n.docType2EmittedBy,
      'docType3EmittedBy' => l10n.docType3EmittedBy,
      'docType18EmittedBy' => l10n.docType18EmittedBy,
      'docType19EmittedBy' => l10n.docType19EmittedBy,
      'docType27EmittedBy' => l10n.docType27EmittedBy,
      'docType9EmittedBy' => l10n.docType9EmittedBy,
      'docType5EmittedBy' => l10n.docType5EmittedBy,
      'docType24EmittedBy' => l10n.docType24EmittedBy,
      'docType14EmittedBy' => l10n.docType14EmittedBy,
      'docType12EmittedBy' => l10n.docType12EmittedBy,
      'docType13EmittedBy' => l10n.docType13EmittedBy,
      'docType8EmittedBy' => l10n.docType8EmittedBy,
      'docType6EmittedBy' => l10n.docType6EmittedBy,
      'docType7EmittedBy' => l10n.docType7EmittedBy,
      'docType17EmittedBy' => l10n.docType17EmittedBy,
      'docType25EmittedBy' => l10n.docType25EmittedBy,
      'docType26EmittedBy' => l10n.docType26EmittedBy,
      'docType4EmittedBy' => l10n.docType4EmittedBy,
      'docType11EmittedBy' => l10n.docType11EmittedBy,
      'docType10EmittedBy' => l10n.docType10EmittedBy,
      'docType20EmittedBy' => l10n.docType20EmittedBy,
      'docType22EmittedBy' => l10n.docType22EmittedBy,
      'docType23EmittedBy' => l10n.docType23EmittedBy,
      'docType15EmittedBy' => l10n.docType15EmittedBy,
      'docType16EmittedBy' => l10n.docType16EmittedBy,
      'docType21EmittedBy' => l10n.docType21EmittedBy,
      _ => m.emittedByKey,
    };

/// Resolves a [DocMessageType] cadence l10n key to its translated label.
String docMessageTypeCadence(DocMessageType m, AppLocalizations l10n) =>
    switch (m.cadenceKey) {
      'docType1Cadence' => l10n.docType1Cadence,
      'docType2Cadence' => l10n.docType2Cadence,
      'docType3Cadence' => l10n.docType3Cadence,
      'docType18Cadence' => l10n.docType18Cadence,
      'docType19Cadence' => l10n.docType19Cadence,
      'docType27Cadence' => l10n.docType27Cadence,
      'docType9Cadence' => l10n.docType9Cadence,
      'docType5Cadence' => l10n.docType5Cadence,
      'docType24Cadence' => l10n.docType24Cadence,
      'docType14Cadence' => l10n.docType14Cadence,
      'docType12Cadence' => l10n.docType12Cadence,
      'docType13Cadence' => l10n.docType13Cadence,
      'docType8Cadence' => l10n.docType8Cadence,
      'docType6Cadence' => l10n.docType6Cadence,
      'docType7Cadence' => l10n.docType7Cadence,
      'docType17Cadence' => l10n.docType17Cadence,
      'docType25Cadence' => l10n.docType25Cadence,
      'docType26Cadence' => l10n.docType26Cadence,
      'docType4Cadence' => l10n.docType4Cadence,
      'docType11Cadence' => l10n.docType11Cadence,
      'docType10Cadence' => l10n.docType10Cadence,
      'docType20Cadence' => l10n.docType20Cadence,
      'docType22Cadence' => l10n.docType22Cadence,
      'docType23Cadence' => l10n.docType23Cadence,
      'docType15Cadence' => l10n.docType15Cadence,
      'docType16Cadence' => l10n.docType16Cadence,
      'docType21Cadence' => l10n.docType21Cadence,
      _ => m.cadenceKey,
    };

/// A milestone in the history of AIS.
class DocEvent {
  final String year;
  final String titleKey;
  final String textKey;

  const DocEvent({
    required this.year,
    required this.titleKey,
    required this.textKey,
  });
}

/// Chronology used by the interactive history timeline.
const List<DocEvent> kAisTimeline = [
  DocEvent(
    year: '1990s',
    titleKey: 'docTimeline1990sTitle',
    textKey: 'docTimeline1990sText',
  ),
  DocEvent(
    year: '1998',
    titleKey: 'docTimeline1998Title',
    textKey: 'docTimeline1998Text',
  ),
  DocEvent(
    year: '2001',
    titleKey: 'docTimeline2001Title',
    textKey: 'docTimeline2001Text',
  ),
  DocEvent(
    year: '2002',
    titleKey: 'docTimeline2002Title',
    textKey: 'docTimeline2002Text',
  ),
  DocEvent(
    year: '2006',
    titleKey: 'docTimeline2006Title',
    textKey: 'docTimeline2006Text',
  ),
  DocEvent(
    year: '2008-2015',
    titleKey: 'docTimeline2008_2015Title',
    textKey: 'docTimeline2008_2015Text',
  ),
  DocEvent(
    year: '2010',
    titleKey: 'docTimeline2010Title',
    textKey: 'docTimeline2010Text',
  ),
  DocEvent(
    year: '2014',
    titleKey: 'docTimeline2014Title',
    textKey: 'docTimeline2014Text',
  ),
  DocEvent(
    year: '2021',
    titleKey: 'docTimeline2021Title',
    textKey: 'docTimeline2021Text',
  ),
  DocEvent(
    year: 'Next',
    titleKey: 'docTimelineVdesTitle',
    textKey: 'docTimelineVdesText',
  ),
];

/// Resolves a [DocEvent] title l10n key to its translated label.
String docEventTitle(DocEvent e, AppLocalizations l10n) =>
    switch (e.titleKey) {
      'docTimeline1990sTitle' => l10n.docTimeline1990sTitle,
      'docTimeline1998Title' => l10n.docTimeline1998Title,
      'docTimeline2001Title' => l10n.docTimeline2001Title,
      'docTimeline2002Title' => l10n.docTimeline2002Title,
      'docTimeline2006Title' => l10n.docTimeline2006Title,
      'docTimeline2008_2015Title' => l10n.docTimeline2008_2015Title,
      'docTimeline2010Title' => l10n.docTimeline2010Title,
      'docTimeline2014Title' => l10n.docTimeline2014Title,
      'docTimeline2021Title' => l10n.docTimeline2021Title,
      'docTimelineVdesTitle' => l10n.docTimelineVdesTitle,
      _ => e.titleKey,
    };

/// Resolves a [DocEvent] text l10n key to its translated label.
String docEventText(DocEvent e, AppLocalizations l10n) => switch (e.textKey) {
      'docTimeline1990sText' => l10n.docTimeline1990sText,
      'docTimeline1998Text' => l10n.docTimeline1998Text,
      'docTimeline2001Text' => l10n.docTimeline2001Text,
      'docTimeline2002Text' => l10n.docTimeline2002Text,
      'docTimeline2006Text' => l10n.docTimeline2006Text,
      'docTimeline2008_2015Text' => l10n.docTimeline2008_2015Text,
      'docTimeline2010Text' => l10n.docTimeline2010Text,
      'docTimeline2014Text' => l10n.docTimeline2014Text,
      'docTimeline2021Text' => l10n.docTimeline2021Text,
      'docTimelineVdesText' => l10n.docTimelineVdesText,
      _ => e.textKey,
    };

/// Navigation status codes of the Common Navigation Block.
const List<(int, String)> kNavStatus = [
  (0, 'docNavStatus0'),
  (1, 'docNavStatus1'),
  (2, 'docNavStatus2'),
  (3, 'docNavStatus3'),
  (4, 'docNavStatus4'),
  (5, 'docNavStatus5'),
  (6, 'docNavStatus6'),
  (7, 'docNavStatus7'),
  (8, 'docNavStatus8'),
  (9, 'docNavStatus9'),
  (10, 'docNavStatus10'),
  (11, 'docNavStatus11'),
  (12, 'docNavStatus12'),
  (13, 'docNavStatus13'),
  (14, 'docNavStatus14'),
  (15, 'docNavStatus15'),
];

/// Resolves a [kNavStatus] l10n key to its translated label.
String docNavStatusLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'docNavStatus0':
      return l10n.docNavStatus0;
    case 'docNavStatus1':
      return l10n.docNavStatus1;
    case 'docNavStatus2':
      return l10n.docNavStatus2;
    case 'docNavStatus3':
      return l10n.docNavStatus3;
    case 'docNavStatus4':
      return l10n.docNavStatus4;
    case 'docNavStatus5':
      return l10n.docNavStatus5;
    case 'docNavStatus6':
      return l10n.docNavStatus6;
    case 'docNavStatus7':
      return l10n.docNavStatus7;
    case 'docNavStatus8':
      return l10n.docNavStatus8;
    case 'docNavStatus9':
      return l10n.docNavStatus9;
    case 'docNavStatus10':
      return l10n.docNavStatus10;
    case 'docNavStatus11':
      return l10n.docNavStatus11;
    case 'docNavStatus12':
      return l10n.docNavStatus12;
    case 'docNavStatus13':
      return l10n.docNavStatus13;
    case 'docNavStatus14':
      return l10n.docNavStatus14;
    case 'docNavStatus15':
      return l10n.docNavStatus15;
    default:
      return key;
  }
}

/// EPFD fix types.
const List<(int, String)> kEpfdTypes = [
  (0, 'docEpfd0'),
  (1, 'docEpfd1'),
  (2, 'docEpfd2'),
  (3, 'docEpfd3'),
  (4, 'docEpfd4'),
  (5, 'docEpfd5'),
  (6, 'docEpfd6'),
  (7, 'docEpfd7'),
  (8, 'docEpfd8'),
  (15, 'docEpfd15'),
];

/// Resolves a [kEpfdTypes] l10n key to its translated label.
String docEpfdLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'docEpfd0':
      return l10n.docEpfd0;
    case 'docEpfd1':
      return l10n.docEpfd1;
    case 'docEpfd2':
      return l10n.docEpfd2;
    case 'docEpfd3':
      return l10n.docEpfd3;
    case 'docEpfd4':
      return l10n.docEpfd4;
    case 'docEpfd5':
      return l10n.docEpfd5;
    case 'docEpfd6':
      return l10n.docEpfd6;
    case 'docEpfd7':
      return l10n.docEpfd7;
    case 'docEpfd8':
      return l10n.docEpfd8;
    case 'docEpfd15':
      return l10n.docEpfd15;
    default:
      return key;
  }
}

/// MMSI number formats (from gpsd / ITU).
const List<(String, String)> kMmsiFormats = [
  ('8MIDXXXXX', 'docMmsiFmtDiversRadio'),
  ('MIDXXXXXX', 'docMmsiFmtShip'),
  ('0MIDXXXXX', 'docMmsiFmtGroupShips'),
  ('00MIDXXXX', 'docMmsiFmtCoastalShore'),
  ('111MIDXXX', 'docMmsiFmtSarAircraft'),
  ('98MIDXXXX', 'docMmsiFmtAuxCraft'),
  ('99MIDXXXX', 'docMmsiFmtAtoN'),
  ('970MIDXXX', 'docMmsiFmtSart'),
  ('972XXXXXX', 'docMmsiFmtMob'),
  ('974XXXXXX', 'docMmsiFmtEpirb'),
];

/// Resolves a [kMmsiFormats] l10n key to its translated label.
String docMmsiFmtLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'docMmsiFmtDiversRadio':
      return l10n.docMmsiFmtDiversRadio;
    case 'docMmsiFmtShip':
      return l10n.docMmsiFmtShip;
    case 'docMmsiFmtGroupShips':
      return l10n.docMmsiFmtGroupShips;
    case 'docMmsiFmtCoastalShore':
      return l10n.docMmsiFmtCoastalShore;
    case 'docMmsiFmtSarAircraft':
      return l10n.docMmsiFmtSarAircraft;
    case 'docMmsiFmtAuxCraft':
      return l10n.docMmsiFmtAuxCraft;
    case 'docMmsiFmtAtoN':
      return l10n.docMmsiFmtAtoN;
    case 'docMmsiFmtSart':
      return l10n.docMmsiFmtSart;
    case 'docMmsiFmtMob':
      return l10n.docMmsiFmtMob;
    case 'docMmsiFmtEpirb':
      return l10n.docMmsiFmtEpirb;
    default:
      return key;
  }
}

/// Coarse ITU-R M.1371 ship-type categories.
const List<(String, String)> kVesselTypeCategories = [
  ('0-9', 'docVesselCat0_9'),
  ('10-19', 'docVesselCat10_19'),
  ('20-29', 'docVesselCat20_29'),
  ('30-39', 'docVesselCat30_39'),
  ('40-49', 'docVesselCat40_49'),
  ('50-59', 'docVesselCat50_59'),
  ('60-69', 'docVesselCat60_69'),
  ('70-79', 'docVesselCat70_79'),
  ('80-89', 'docVesselCat80_89'),
  ('90-99', 'docVesselCat90_99'),
];

/// Resolves a [kVesselTypeCategories] l10n key to its translated label.
String docVesselCatLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'docVesselCat0_9':
      return l10n.docVesselCat0_9;
    case 'docVesselCat10_19':
      return l10n.docVesselCat10_19;
    case 'docVesselCat20_29':
      return l10n.docVesselCat20_29;
    case 'docVesselCat30_39':
      return l10n.docVesselCat30_39;
    case 'docVesselCat40_49':
      return l10n.docVesselCat40_49;
    case 'docVesselCat50_59':
      return l10n.docVesselCat50_59;
    case 'docVesselCat60_69':
      return l10n.docVesselCat60_69;
    case 'docVesselCat70_79':
      return l10n.docVesselCat70_79;
    case 'docVesselCat80_89':
      return l10n.docVesselCat80_89;
    case 'docVesselCat90_99':
      return l10n.docVesselCat90_99;
    default:
      return key;
  }
}

/// NMEA 4.0 AIS talker IDs.
const Map<String, String> kTalkerIds = {
  'AB': 'docTalkerAB',
  'AD': 'docTalkerAD',
  'AI': 'docTalkerAI',
  'AN': 'docTalkerAN',
  'AR': 'docTalkerAR',
  'AS': 'docTalkerAS',
  'AT': 'docTalkerAT',
  'AX': 'docTalkerAX',
  'BS': 'docTalkerBS',
  'SA': 'docTalkerSA',
};

/// Resolves a [kTalkerIds] l10n key to its translated label.
String docTalkerLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'docTalkerAB':
      return l10n.docTalkerAB;
    case 'docTalkerAD':
      return l10n.docTalkerAD;
    case 'docTalkerAI':
      return l10n.docTalkerAI;
    case 'docTalkerAN':
      return l10n.docTalkerAN;
    case 'docTalkerAR':
      return l10n.docTalkerAR;
    case 'docTalkerAS':
      return l10n.docTalkerAS;
    case 'docTalkerAT':
      return l10n.docTalkerAT;
    case 'docTalkerAX':
      return l10n.docTalkerAX;
    case 'docTalkerBS':
      return l10n.docTalkerBS;
    case 'docTalkerSA':
      return l10n.docTalkerSA;
    default:
      return key;
  }
}

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
