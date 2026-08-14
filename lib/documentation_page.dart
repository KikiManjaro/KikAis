import 'package:flutter/material.dart';

import 'ais/ais_decoder.dart';
import 'ais_message_details.dart';
import 'documentation_content.dart';
import 'documentation_widgets.dart';
import 'l10n/country_names.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n_ext.dart';
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

List<_Chapter> _chapters(AppLocalizations l10n) {
  return [
    _Chapter(l10n.docChapterOverview, Icons.info_outline, [
      'AIS',
      'introduction',
      'radar',
      'VTS',
      'SOLAS',
      'ADS-B',
    ]),
    _Chapter(l10n.docChapterHistory, Icons.history, [
      'history',
      'Sweden',
      'IMO',
      'SOLAS',
      '2002',
      'class b',
      'satellite',
    ]),
    _Chapter(l10n.docChapterHowItWorks, Icons.radio, [
      'VHF',
      'channel',
      '161.975',
      '162.025',
      'TDMA',
      'slot',
      'range',
      'report',
    ]),
    _Chapter(l10n.docChapterRadio, Icons.settings_input_antenna, [
      'radio',
      'SOTDMA',
      'CSTDMA',
      'HDLC',
      'GMSK',
      '9600',
      'NRZI',
      'frame',
      'slots',
      'VDES',
    ]),
    _Chapter(l10n.docChapterClasses, Icons.architecture, [
      'class a',
      'class b',
      'SOTDMA',
      'CSTDMA',
      'transponder',
      'SART',
      'MOB',
      'EPIRB',
      'comparison',
    ]),
    _Chapter(l10n.docChapterMmsi, Icons.badge_outlined, [
      'MMSI',
      'MID',
      'country',
      'format',
      'identity',
    ]),
    _Chapter(l10n.docChapterShipTypes, Icons.inventory_2, [
      'ship type',
      'vessel type',
      'cargo',
      'tanker',
      'fishing',
      'tug',
      'passenger',
      '0-99',
    ]),
    _Chapter(l10n.docChapterMessages, Icons.message_outlined, [
      'message',
      'catalog',
      'position',
      'static',
      'safety',
      'binary',
      'type 1',
    ]),
    _Chapter(l10n.docChapterNmea, Icons.code, [
      'NMEA',
      'AIVDM',
      'AIVDO',
      'sentence',
      'payload',
      'checksum',
      'fragment',
      'armoring',
      'six-bit',
    ]),
    _Chapter(l10n.docChapterPayload, Icons.hexagon_outlined, [
      'bits',
      'bit layout',
      'coordinate',
      'longitude',
      'latitude',
      'six-bit',
      'nav status',
      'EPFD',
    ]),
    _Chapter(l10n.docChapterSecurity, Icons.shield_outlined, [
      'security',
      'spoofing',
      'jamming',
      'meaconing',
      'data quality',
    ]),
    _Chapter(l10n.docChapterFieldNotes, Icons.tips_and_updates, [
      'gotchas',
      'quirks',
      'length',
      'noise',
      'timestamp',
      'regional',
      '8-digit',
    ]),
    _Chapter(l10n.docChapterKikais, Icons.directions_boat, [
      'kikais',
      'reception',
      'decoder',
      'editor',
      'simulation',
      'map',
      'stats',
    ]),
    _Chapter(l10n.docChapterGlossary, Icons.translate, [
      'glossary',
      'terms',
      'dictionary',
      'SOTDMA',
      'MMSI',
      'VDES',
    ]),
    _Chapter(l10n.docChapterCheatSheet, Icons.bolt, [
      'cheat sheet',
      'reference',
      'frequencies',
      'report rates',
      'at a glance',
    ]),
    _Chapter(l10n.docChapterSources, Icons.link, [
      'sources',
      'gpsd',
      'wikipedia',
      'navcen',
      'ITU',
      'IALA',
      'IEC',
    ]),
  ];
}

class _DocumentationPageState extends State<DocumentationPage> {
  int _selected = 0;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final chapters = _chapters(l10n);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.docAppTitle)),
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
                    onChanged: (v) =>
                        setState(() => _query = v.trim().toLowerCase()),
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search, size: 18),
                      labelText: l10n.docSearchChapters,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: [
                      for (var i = 0; i < chapters.length; i++)
                        if (_matches(chapters[i]))
                          ListTile(
                            dense: true,
                            selected: i == _selected,
                            leading: Icon(
                              chapters[i].icon,
                              size: 18,
                              color: i == _selected
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                            ),
                            title: Text(
                              chapters[i].title,
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
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
    final l10n = context.l10n;
    return [
      _h1(l10n.docOverviewTitle),
      _p(l10n.docOverviewIntro),
      _p(l10n.docOverviewRadar),
      _factCard(l10n.docOverviewAdsBTitle, l10n.docOverviewAdsBText),
      const SizedBox(height: 12),
      _h2(l10n.docOverviewTransponder),
      _bullets([
        l10n.docOverviewBullet1,
        l10n.docOverviewBullet2,
        l10n.docOverviewBullet3,
        l10n.docOverviewBullet4,
      ]),
      _h2(l10n.docOverviewWho),
      _p(l10n.docOverviewImo),
      _h2(l10n.docOverviewLimits),
      _bullets([
        l10n.docOverviewLimit1,
        l10n.docOverviewLimit2,
        l10n.docOverviewLimit3,
      ]),
    ];
  }

  List<Widget> _history() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterHistory),
      _p(l10n.docHistoryIntro),
      const _TimelineWidget(),
      _h2(l10n.docHistoryStandards),
      _bullets([
        l10n.docHistoryStd1,
        l10n.docHistoryStd2,
        l10n.docHistoryStd3,
        l10n.docHistoryStd4,
      ]),
    ];
  }

  List<Widget> _howItWorks() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterHowItWorks),
      _p(l10n.docHowIntro),
      _h2(l10n.docHowRadioLink),
      _bullets([
        l10n.docHowRadioLink1,
        l10n.docHowRadioLink2,
        l10n.docHowRadioLink3,
      ]),
      _h2(l10n.docHowSlots),
      _p(l10n.docHowSotdma),
      _p(l10n.docHowCstdma),
      _h2(l10n.docHowRates),
      _bullets([
        l10n.docHowRates1,
        l10n.docHowRates2,
        l10n.docHowRates3,
        l10n.docHowRates4,
      ]),
      _h2(l10n.docHowTerrestrial),
      _p(l10n.docHowTerrestrialText),
    ];
  }

  List<Widget> _radio() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterRadio),
      _p(l10n.docRadioIntro),
      _h2(l10n.docRadioPhysical),
      _bullets([
        l10n.docRadioPhysical1,
        l10n.docRadioPhysical2,
        l10n.docRadioPhysical3,
      ]),
      _h2(l10n.docRadioFrames),
      _bullets([
        l10n.docRadioFrames1,
        l10n.docRadioFrames2,
        l10n.docRadioFrames3,
      ]),
      _code(l10n.docRadioCode),
      _h2(l10n.docRadioSotdma),
      _p(l10n.docRadioSotdmaText),
      _h2(l10n.docRadioCstdma),
      _p(l10n.docRadioCstdmaText),
      _h2(l10n.docRadioVdes),
      _p(l10n.docRadioVdesText),
    ];
  }

  List<Widget> _classes() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterClasses),
      _p(l10n.docClassesIntro),
      _h2(l10n.docClassesComparison),
      const ClassComparisonTable(),
      _h2(l10n.docClassesReceivers),
      _p(l10n.docClassesReceiversText),
      _h2(l10n.docClassesAton),
      _p(l10n.docClassesAtonText),
      _h2(l10n.docClassesDistress),
      _p(l10n.docClassesDistressIntro),
      const DistressDeviceCards(),
      _p(l10n.docClassesSartNote),
    ];
  }

  List<Widget> _shipTypes() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterShipTypes),
      _p(l10n.docShipTypesIntro),
      const ShipTypeBrowser(),
      _h2(l10n.docShipTypesCategories),
      _bullets([
        for (final (range, meaning) in kVesselTypeCategories)
          l10n.docVesselCatRow(docVesselCatLabel(l10n, meaning), range),
      ]),
    ];
  }

  List<Widget> _fieldNotes() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docFieldNotesTitle),
      _p(l10n.docFieldNotesIntro),
      const GotchasList(),
    ];
  }

  List<Widget> _glossary() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterGlossary),
      _p(l10n.docGlossaryIntro),
      const GlossarySearch(),
    ];
  }

  List<Widget> _cheatSheet() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterCheatSheet),
      _p(l10n.docCheatSheetIntro),
      const CheatSheet(),
    ];
  }

  List<Widget> _mmsi() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterMmsi),
      _p(l10n.docMmsiIntro),
      _h2(l10n.docMmsiFormats),
      _bullets([
        for (final (fmt, meaning) in kMmsiFormats)
          l10n.docMmsiFmtRow(fmt, docMmsiFmtLabel(l10n, meaning)),
      ]),
      _h2(l10n.docMmsiLookupHeading),
      _p(l10n.docMmsiLookupHint),
      const _MmsiLookupWidget(),
      _h2(l10n.docMmsiMidHeading),
      _p(l10n.docMmsiMidText),
      const _MidiTable(),
    ];
  }

  List<Widget> _messages() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docMessagesTitle),
      _p(l10n.docMessagesIntro),
      _MessageCatalog(onOpenInDecoder: widget.onOpenInDecoder),
    ];
  }

  List<Widget> _nmea() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docNmeaTitle),
      _p(l10n.docNmeaIntro),
      _code(l10n.docNmeaSampleSingle),
      _h2(l10n.docNmeaFields),
      _bullets([
        l10n.docNmeaField1,
        l10n.docNmeaField2,
        l10n.docNmeaField3,
        l10n.docNmeaField4,
        l10n.docNmeaField5,
        l10n.docNmeaField6,
        l10n.docNmeaField7,
        l10n.docNmeaField8,
      ]),
      _h2(l10n.docNmeaMulti),
      _p(l10n.docNmeaMultiText),
      _code(l10n.docNmeaSampleMulti),
      _h2(l10n.docNmeaArmoring),
      _p(l10n.docNmeaArmoringText),
      const _ArmoringGrid(),
      _h2(l10n.docNmeaTalkers),
      _p(l10n.docNmeaTalkersIntro),
      _bullets([
        for (final e in kTalkerIds.entries)
          l10n.docTalkerRow(docTalkerLabel(l10n, e.value), e.key),
      ]),
      _h2(l10n.docNmeaChecksum),
      _p(l10n.docNmeaChecksumText),
      const ChecksumCalculator(),
      _h2(l10n.docNmeaInspectorTitle),
      _p(l10n.docNmeaInspectorText),
      const _SentenceInspector(),
    ];
  }

  List<Widget> _payload() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterPayload),
      _p(l10n.docPayloadIntro),
      _h2(l10n.docPayloadCnb),
      _p(l10n.docPayloadCnbText),
      const BitLayoutViewer(),
      _h2(l10n.docPayloadCoords),
      _p(l10n.docPayloadCoordsText),
      _code(l10n.docPayloadCoordsCode),
      _p(l10n.docPayloadCoordsConvert),
      const CoordinateEncoder(),
      _h2(l10n.docPayloadSpeed),
      _bullets([
        l10n.docPayloadSpeed1,
        l10n.docPayloadSpeed2,
        l10n.docPayloadSpeed3,
        l10n.docPayloadSpeed4,
      ]),
      _h2(l10n.docPayloadNavStatus),
      const _NavStatusTable(),
      _h2(l10n.docPayloadEpfd),
      const _EpfdTable(),
      _h2(l10n.docPayloadText),
      _p(l10n.docPayloadTextIntro),
      const SixBitEncoder(),
    ];
  }

  List<Widget> _security() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docSecurityTitle),
      _p(l10n.docSecurityIntro),
      _h2(l10n.docSecurityThreats),
      _bullets([
        l10n.docSecurityThreat1,
        l10n.docSecurityThreat2,
        l10n.docSecurityThreat3,
      ]),
      _h2(l10n.docSecurityQuality),
      _bullets([
        l10n.docSecurityQuality1,
        l10n.docSecurityQuality2,
        l10n.docSecurityQuality3,
      ]),
    ];
  }

  List<Widget> _kikais() {
    final l10n = context.l10n;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return [
      _h1(l10n.docChapterKikais),
      _p(l10n.docKikaisIntro),
      _TabCard(
        accent: appColors.info,
        icon: Icons.radio,
        title: l10n.tabReception,
        text: l10n.docTabReceptionText,
        tabIndex: 0,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.success,
        icon: Icons.outbox,
        title: l10n.tabSend,
        text: l10n.docTabSendText,
        tabIndex: 1,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.info,
        icon: Icons.map,
        title: l10n.tabMap,
        text: l10n.docTabMapText,
        tabIndex: 2,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.warning,
        icon: Icons.edit_note,
        title: l10n.tabEditor,
        text: l10n.docTabEditorText,
        tabIndex: 3,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.info,
        icon: Icons.manage_search,
        title: l10n.tabDecoder,
        text: l10n.docTabDecoderText,
        tabIndex: 4,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.success,
        icon: Icons.bar_chart,
        title: l10n.tabStats,
        text: l10n.docTabStatsText,
        tabIndex: 5,
        onOpen: widget.onOpenTab,
      ),
      _TabCard(
        accent: appColors.warning,
        icon: Icons.bubble_chart,
        title: l10n.tabSimulation,
        text: l10n.docTabSimulationText,
        tabIndex: 6,
        onOpen: widget.onOpenTab,
      ),
    ];
  }

  List<Widget> _sources() {
    final l10n = context.l10n;
    return [
      _h1(l10n.docChapterSources),
      _p(l10n.docSourcesIntro),
      _bullets([
        l10n.docSources1,
        l10n.docSources2,
        l10n.docSources3,
        l10n.docSources4,
        l10n.docSources5,
        l10n.docSources6,
      ]),
      _h2(l10n.docSourcesLearn),
      _p(l10n.docSourcesLearnText),
    ];
  }
}

// ----------------------------------------------------------------- widgets

class _TimelineWidget extends StatelessWidget {
  const _TimelineWidget();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
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
                            docEventTitle(kAisTimeline[i], context.l10n),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            docEventText(kAisTimeline[i], context.l10n),
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
    final l10n = context.l10n;
    if (s.length != 9 || int.tryParse(s) == null) {
      setState(() => _result = l10n.docMmsiLookupError);
      return;
    }
    String cls;
    String? mid;
    if (s.startsWith('111')) {
      cls = l10n.docMmsiFmtSarAircraft;
      mid = s.substring(3, 6);
    } else if (s.startsWith('970')) {
      cls = l10n.docMmsiFmtSart;
    } else if (s.startsWith('972')) {
      cls = l10n.docMmsiFmtMob;
    } else if (s.startsWith('974')) {
      cls = l10n.docMmsiFmtEpirb;
    } else if (s.startsWith('00')) {
      cls = l10n.docMmsiFmtCoastalShore;
      mid = s.substring(2, 5);
    } else if (s.startsWith('99')) {
      cls = l10n.docMmsiFmtAtoN;
      mid = s.substring(2, 5);
    } else if (s.startsWith('98')) {
      cls = l10n.docMmsiFmtAuxCraft;
      mid = s.substring(2, 5);
    } else if (s.startsWith('8')) {
      cls = l10n.docMmsiFmtDiversRadio;
      mid = s.substring(1, 4);
    } else if (s.startsWith('0')) {
      cls = l10n.docMmsiLookupClassGroup;
      mid = s.substring(1, 4);
    } else {
      cls = l10n.docMmsiFmtShip;
      mid = s.substring(0, 3);
    }
    final country = mid != null ? midCountryOf(s) : null;
    setState(() {
      _result = mid != null
          ? l10n.docMmsiLookupResult(
              cls,
              country == null
                  ? l10n.docMmsiUnknownCountry
                  : localizedCountryName(country, context),
              mid,
            )
          : cls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      labelText: l10n.docMmsiLookupLabel,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _lookup,
                  icon: const Icon(Icons.search, size: 18),
                  label: Text(l10n.docMmsiLookupButton),
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
                          localizedCountryName(e.value, context),
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
      families
          .putIfAbsent(docMessageTypeFamily(m, context.l10n), () => [])
          .add(m);
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
  final _decoder = AisNmeaDecoder();

  List<MessageField> _decodeSample(String sample, AppLocalizations l10n) {
    for (final line in sample.split('\n')) {
      final m = _decoder.decode(line);
      if (m != null) return describeMessage(m, l10n);
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final m = widget.message;
    final decoded = _decodeSample(_sample, context.l10n);
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
          context.l10n.docTypeCardTitle(
            docMessageTypeName(m, context.l10n),
            '${m.type}',
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          context.l10n.docTypeCardSubtitle(
            '${m.bits}',
            docMessageTypeCadence(m, context.l10n),
          ),
          style: const TextStyle(fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            docMessageTypeSummary(m, context.l10n),
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.docTypeCardEmittedBy(
              docMessageTypeEmittedBy(m, context.l10n),
            ),
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
          for (final field in decoded)
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
                    child: Text(
                      field.$2,
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.onOpenInDecoder != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: HoverTooltip(
                message: context.l10n.tooltipDocOpenTab,
                child: OutlinedButton.icon(
                  onPressed: () => widget.onOpenInDecoder!(_sample),
                  icon: const Icon(Icons.manage_search, size: 16),
                  label: Text(context.l10n.docOpenInDecoder),
                ),
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
    return _TwoColList(
      kNavStatus
          .map((e) => ('${e.$1}', docNavStatusLabel(context.l10n, e.$2)))
          .toList(),
    );
  }
}

class _EpfdTable extends StatelessWidget {
  const _EpfdTable();

  @override
  Widget build(BuildContext context) {
    return _TwoColList(
      kEpfdTypes
          .map((e) => ('${e.$1}', docEpfdLabel(context.l10n, e.$2)))
          .toList(),
    );
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
                      Expanded(
                        child: Text(v, style: const TextStyle(fontSize: 12)),
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
    final l10n = context.l10n;
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
                  ? l10n.docInspectorInvalidChecksum
                  : l10n.docInspectorCouldNotDecode,
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
              l10n.docInspectorDecoded(
                kEditorTypeLabel(message.messageType),
                '${message.messageType}',
              ),
              style: TextStyle(fontSize: 12, color: appColors.success),
            ),
          ),
        );
      }
    }
    if (decoded.isNotEmpty) {
      widgets.add(const SizedBox(height: 6));
      for (final field in describeMessage(decoded.last, context.l10n)) {
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
                Expanded(
                  child: Text(field.$2, style: const TextStyle(fontSize: 12)),
                ),
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
    return m.isEmpty
        ? context.l10n.docInspectorTypeFallback('$type')
        : docMessageTypeName(m.first, context.l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: InputDecoration(
                isDense: true,
                labelText: l10n.docInspectorNmeaLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _decode,
                icon: const Icon(Icons.manage_search, size: 18),
                label: Text(l10n.docInspectorInspect),
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
              HoverTooltip(
                message: context.l10n.tooltipDocOpenTab,
                child: OutlinedButton(
                  onPressed: () => onOpen(tabIndex),
                  child: Text(context.l10n.docTabOpen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
