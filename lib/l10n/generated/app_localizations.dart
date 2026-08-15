import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Auto (system)'**
  String get languageSystem;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @languageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @languageDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageDe;

  /// No description provided for @languagePt.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePt;

  /// No description provided for @languageIt.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageIt;

  /// No description provided for @languageNl.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get languageNl;

  /// No description provided for @languageZh.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageZh;

  /// No description provided for @languageJa.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJa;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRu;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get themeHighContrast;

  /// No description provided for @tabReception.
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get tabReception;

  /// No description provided for @tabSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get tabSend;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabEditor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get tabEditor;

  /// No description provided for @tabTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tabTools;

  /// No description provided for @tabStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get tabStats;

  /// No description provided for @tabSimulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get tabSimulation;

  /// No description provided for @tabDocs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get tabDocs;

  /// No description provided for @protocolUdpServer.
  ///
  /// In en, this message translates to:
  /// **'UDP Server'**
  String get protocolUdpServer;

  /// No description provided for @protocolUdpClient.
  ///
  /// In en, this message translates to:
  /// **'UDP Client'**
  String get protocolUdpClient;

  /// No description provided for @protocolTcpClient.
  ///
  /// In en, this message translates to:
  /// **'TCP Client'**
  String get protocolTcpClient;

  /// No description provided for @protocolTcpServer.
  ///
  /// In en, this message translates to:
  /// **'TCP Server'**
  String get protocolTcpServer;

  /// No description provided for @formatPassthrough.
  ///
  /// In en, this message translates to:
  /// **'Pass-through'**
  String get formatPassthrough;

  /// No description provided for @formatStrip.
  ///
  /// In en, this message translates to:
  /// **'Strip tag blocks'**
  String get formatStrip;

  /// No description provided for @formatTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag block'**
  String get formatTag;

  /// No description provided for @sendAddDestination.
  ///
  /// In en, this message translates to:
  /// **'Add destination'**
  String get sendAddDestination;

  /// No description provided for @sendEditDestination.
  ///
  /// In en, this message translates to:
  /// **'Edit destination'**
  String get sendEditDestination;

  /// No description provided for @sendFormat.
  ///
  /// In en, this message translates to:
  /// **'Send format'**
  String get sendFormat;

  /// No description provided for @sendSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sendSave;

  /// No description provided for @sendLockedBanner.
  ///
  /// In en, this message translates to:
  /// **'Forwarder is running — destinations are locked.'**
  String get sendLockedBanner;

  /// No description provided for @sendEmpty.
  ///
  /// In en, this message translates to:
  /// **'No destination yet. Add one to forward received AIS frames.'**
  String get sendEmpty;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldProtocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get fieldProtocol;

  /// No description provided for @fieldHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get fieldHost;

  /// No description provided for @fieldPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get fieldPort;

  /// No description provided for @fieldTagSourceId.
  ///
  /// In en, this message translates to:
  /// **'Tag source ID'**
  String get fieldTagSourceId;

  /// No description provided for @fieldFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fieldFile;

  /// No description provided for @fieldCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get fieldCancel;

  /// No description provided for @fieldAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get fieldAdd;

  /// No description provided for @receptionFeeds.
  ///
  /// In en, this message translates to:
  /// **'Feeds'**
  String get receptionFeeds;

  /// No description provided for @receptionValidateChecksums.
  ///
  /// In en, this message translates to:
  /// **'Validate NMEA checksums'**
  String get receptionValidateChecksums;

  /// No description provided for @receptionDroppedSentences.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sentence dropped} =1{1 sentence dropped} other{{count} sentences dropped}}'**
  String receptionDroppedSentences(num count);

  /// No description provided for @receptionImportFormat.
  ///
  /// In en, this message translates to:
  /// **'Import frame format'**
  String get receptionImportFormat;

  /// No description provided for @receptionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get receptionStart;

  /// No description provided for @receptionStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get receptionStop;

  /// No description provided for @receptionLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get receptionLogs;

  /// No description provided for @receptionFrameCopied.
  ///
  /// In en, this message translates to:
  /// **'Frame copied'**
  String get receptionFrameCopied;

  /// No description provided for @receptionAddSource.
  ///
  /// In en, this message translates to:
  /// **'Add source'**
  String get receptionAddSource;

  /// No description provided for @receptionNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get receptionNetwork;

  /// No description provided for @receptionFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get receptionFile;

  /// No description provided for @receptionSerial.
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get receptionSerial;

  /// No description provided for @receptionHeaderOptional.
  ///
  /// In en, this message translates to:
  /// **'Header (optional)'**
  String get receptionHeaderOptional;

  /// No description provided for @receptionPathOrBrowse.
  ///
  /// In en, this message translates to:
  /// **'Path or Browse…'**
  String get receptionPathOrBrowse;

  /// No description provided for @receptionIntervalMs.
  ///
  /// In en, this message translates to:
  /// **'Interval between frames (ms)'**
  String get receptionIntervalMs;

  /// No description provided for @receptionReplayTimestamps.
  ///
  /// In en, this message translates to:
  /// **'Replay using file timestamps'**
  String get receptionReplayTimestamps;

  /// No description provided for @receptionReplayTimestampsHint.
  ///
  /// In en, this message translates to:
  /// **'Follows the recorded times (tag block t: or timestamp prefix) instead of a fixed interval'**
  String get receptionReplayTimestampsHint;

  /// No description provided for @receptionSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get receptionSpeed;

  /// No description provided for @receptionReplayLoop.
  ///
  /// In en, this message translates to:
  /// **'Loop (replay from the start)'**
  String get receptionReplayLoop;

  /// No description provided for @receptionSerialPort.
  ///
  /// In en, this message translates to:
  /// **'Serial port'**
  String get receptionSerialPort;

  /// No description provided for @receptionSerialPortHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. COM3 or /dev/ttyUSB0'**
  String get receptionSerialPortHint;

  /// No description provided for @receptionBaudRate.
  ///
  /// In en, this message translates to:
  /// **'Baud rate'**
  String get receptionBaudRate;

  /// No description provided for @msgType1.
  ///
  /// In en, this message translates to:
  /// **'Position Report Class A'**
  String get msgType1;

  /// No description provided for @msgType2.
  ///
  /// In en, this message translates to:
  /// **'Position Report Class A (assigned)'**
  String get msgType2;

  /// No description provided for @msgType3.
  ///
  /// In en, this message translates to:
  /// **'Position Report Class A (response)'**
  String get msgType3;

  /// No description provided for @msgType4.
  ///
  /// In en, this message translates to:
  /// **'Base Station'**
  String get msgType4;

  /// No description provided for @msgType5.
  ///
  /// In en, this message translates to:
  /// **'Static and Voyage Related Data'**
  String get msgType5;

  /// No description provided for @msgType6.
  ///
  /// In en, this message translates to:
  /// **'Binary Addressed Message'**
  String get msgType6;

  /// No description provided for @msgType7.
  ///
  /// In en, this message translates to:
  /// **'Binary Acknowledge'**
  String get msgType7;

  /// No description provided for @msgType8.
  ///
  /// In en, this message translates to:
  /// **'Binary Broadcast Message'**
  String get msgType8;

  /// No description provided for @msgType9.
  ///
  /// In en, this message translates to:
  /// **'Standard SAR Aircraft Position Report'**
  String get msgType9;

  /// No description provided for @msgType10.
  ///
  /// In en, this message translates to:
  /// **'UTC/Date Inquiry'**
  String get msgType10;

  /// No description provided for @msgType11.
  ///
  /// In en, this message translates to:
  /// **'UTC/Date Response'**
  String get msgType11;

  /// No description provided for @msgType12.
  ///
  /// In en, this message translates to:
  /// **'Addressed Safety Related Message'**
  String get msgType12;

  /// No description provided for @msgType13.
  ///
  /// In en, this message translates to:
  /// **'Safety Acknowledgement'**
  String get msgType13;

  /// No description provided for @msgType14.
  ///
  /// In en, this message translates to:
  /// **'Safety Broadcast Message'**
  String get msgType14;

  /// No description provided for @msgType15.
  ///
  /// In en, this message translates to:
  /// **'Interrogation'**
  String get msgType15;

  /// No description provided for @msgType16.
  ///
  /// In en, this message translates to:
  /// **'Assignment Mode Command'**
  String get msgType16;

  /// No description provided for @msgType17.
  ///
  /// In en, this message translates to:
  /// **'DGNSS Binary Broadcast Message'**
  String get msgType17;

  /// No description provided for @msgType18.
  ///
  /// In en, this message translates to:
  /// **'Standard Class B CS Position Report'**
  String get msgType18;

  /// No description provided for @msgType19.
  ///
  /// In en, this message translates to:
  /// **'Extended Class B Equipment Position Report'**
  String get msgType19;

  /// No description provided for @msgType20.
  ///
  /// In en, this message translates to:
  /// **'Data Link Management Message'**
  String get msgType20;

  /// No description provided for @msgType21.
  ///
  /// In en, this message translates to:
  /// **'Aid-to-Navigation Report'**
  String get msgType21;

  /// No description provided for @msgType22.
  ///
  /// In en, this message translates to:
  /// **'Channel Management'**
  String get msgType22;

  /// No description provided for @msgType23.
  ///
  /// In en, this message translates to:
  /// **'Group Assignment Command'**
  String get msgType23;

  /// No description provided for @msgType24.
  ///
  /// In en, this message translates to:
  /// **'Static Data Report'**
  String get msgType24;

  /// No description provided for @msgType25.
  ///
  /// In en, this message translates to:
  /// **'Single Slot Binary Message'**
  String get msgType25;

  /// No description provided for @msgType26.
  ///
  /// In en, this message translates to:
  /// **'Multiple Slot Binary Message'**
  String get msgType26;

  /// No description provided for @msgType27.
  ///
  /// In en, this message translates to:
  /// **'Position Report for Long-Range Applications'**
  String get msgType27;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get statsFeed;

  /// No description provided for @statsAllFeeds.
  ///
  /// In en, this message translates to:
  /// **'All feeds'**
  String get statsAllFeeds;

  /// No description provided for @statsReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get statsReceived;

  /// No description provided for @statsDecoded.
  ///
  /// In en, this message translates to:
  /// **'Decoded'**
  String get statsDecoded;

  /// No description provided for @statsInvalidChecksums.
  ///
  /// In en, this message translates to:
  /// **'Invalid checksums'**
  String get statsInvalidChecksums;

  /// No description provided for @statsDroppedFragments.
  ///
  /// In en, this message translates to:
  /// **'Dropped fragments'**
  String get statsDroppedFragments;

  /// No description provided for @statsParseErrors.
  ///
  /// In en, this message translates to:
  /// **'Parse errors'**
  String get statsParseErrors;

  /// No description provided for @statsPendingFragments.
  ///
  /// In en, this message translates to:
  /// **'Pending fragments'**
  String get statsPendingFragments;

  /// No description provided for @statsPerSecond.
  ///
  /// In en, this message translates to:
  /// **'{rate}/s'**
  String statsPerSecond(Object rate);

  /// No description provided for @statsAllFeedsShort.
  ///
  /// In en, this message translates to:
  /// **'(all feeds)'**
  String get statsAllFeedsShort;

  /// No description provided for @statsReceivedVsDecoded.
  ///
  /// In en, this message translates to:
  /// **'Received vs Decoded (last 60 s)'**
  String get statsReceivedVsDecoded;

  /// No description provided for @statsPerSecondLabel.
  ///
  /// In en, this message translates to:
  /// **'per second'**
  String get statsPerSecondLabel;

  /// No description provided for @statsAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get statsAccounting;

  /// No description provided for @statsMultiPartParts.
  ///
  /// In en, this message translates to:
  /// **'Multi-part parts'**
  String get statsMultiPartParts;

  /// No description provided for @statsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statsPending;

  /// No description provided for @statsDropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get statsDropped;

  /// No description provided for @statsReconcile.
  ///
  /// In en, this message translates to:
  /// **'Received and decoded reconcile.'**
  String get statsReconcile;

  /// No description provided for @statsGapPaused.
  ///
  /// In en, this message translates to:
  /// **'Gap includes sentences received while decoding was paused.'**
  String get statsGapPaused;

  /// No description provided for @statsReceivedAmountEquals.
  ///
  /// In en, this message translates to:
  /// **'Received {received} = {sum}'**
  String statsReceivedAmountEquals(Object received, Object sum);

  /// No description provided for @statsByMessageType.
  ///
  /// In en, this message translates to:
  /// **'By message type'**
  String get statsByMessageType;

  /// No description provided for @statsNoDecodedYet.
  ///
  /// In en, this message translates to:
  /// **'No decoded messages yet'**
  String get statsNoDecodedYet;

  /// No description provided for @statsTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'Type {type}'**
  String statsTypeFallback(Object type);

  /// No description provided for @statsByFeed.
  ///
  /// In en, this message translates to:
  /// **'By feed'**
  String get statsByFeed;

  /// No description provided for @statsFeedFilter.
  ///
  /// In en, this message translates to:
  /// **'Feed: {filter}'**
  String statsFeedFilter(Object filter);

  /// No description provided for @statsNoActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No feed activity yet'**
  String get statsNoActivityYet;

  /// No description provided for @statsCollecting.
  ///
  /// In en, this message translates to:
  /// **'collecting…'**
  String get statsCollecting;

  /// No description provided for @simVesselCargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get simVesselCargo;

  /// No description provided for @simVesselTanker.
  ///
  /// In en, this message translates to:
  /// **'Tanker'**
  String get simVesselTanker;

  /// No description provided for @simVesselFishing.
  ///
  /// In en, this message translates to:
  /// **'Fishing'**
  String get simVesselFishing;

  /// No description provided for @simVesselSailing.
  ///
  /// In en, this message translates to:
  /// **'Sailing'**
  String get simVesselSailing;

  /// No description provided for @simVesselPassenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get simVesselPassenger;

  /// No description provided for @simVesselTug.
  ///
  /// In en, this message translates to:
  /// **'Tug'**
  String get simVesselTug;

  /// No description provided for @simVesselHsc.
  ///
  /// In en, this message translates to:
  /// **'High speed craft'**
  String get simVesselHsc;

  /// No description provided for @simVesselOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get simVesselOther;

  /// No description provided for @simType1.
  ///
  /// In en, this message translates to:
  /// **'Position report (1/2/3)'**
  String get simType1;

  /// No description provided for @simType5.
  ///
  /// In en, this message translates to:
  /// **'Static & Voyage (5)'**
  String get simType5;

  /// No description provided for @simType9.
  ///
  /// In en, this message translates to:
  /// **'SAR aircraft (9)'**
  String get simType9;

  /// No description provided for @simType18.
  ///
  /// In en, this message translates to:
  /// **'Class B position (18)'**
  String get simType18;

  /// No description provided for @simType19.
  ///
  /// In en, this message translates to:
  /// **'Class B extended (19)'**
  String get simType19;

  /// No description provided for @simType27.
  ///
  /// In en, this message translates to:
  /// **'Long range (27)'**
  String get simType27;

  /// No description provided for @simType4.
  ///
  /// In en, this message translates to:
  /// **'Base station (4)'**
  String get simType4;

  /// No description provided for @simType21.
  ///
  /// In en, this message translates to:
  /// **'Aid to navigation (21)'**
  String get simType21;

  /// No description provided for @simType8.
  ///
  /// In en, this message translates to:
  /// **'Weather broadcast (8)'**
  String get simType8;

  /// No description provided for @simType11.
  ///
  /// In en, this message translates to:
  /// **'UTC/date response (11)'**
  String get simType11;

  /// No description provided for @simType12.
  ///
  /// In en, this message translates to:
  /// **'Safety addressed (12)'**
  String get simType12;

  /// No description provided for @simType14.
  ///
  /// In en, this message translates to:
  /// **'Safety broadcast (14)'**
  String get simType14;

  /// No description provided for @simType22.
  ///
  /// In en, this message translates to:
  /// **'Channel management (22)'**
  String get simType22;

  /// No description provided for @simType23.
  ///
  /// In en, this message translates to:
  /// **'Group assignment (23)'**
  String get simType23;

  /// No description provided for @simType24.
  ///
  /// In en, this message translates to:
  /// **'Class B static (24)'**
  String get simType24;

  /// No description provided for @simTitle.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get simTitle;

  /// No description provided for @simInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'The fleet is emitted when the \"Simulation\" feed is enabled on the Reception tab and the forwarder is running.'**
  String get simInfoBanner;

  /// No description provided for @simOpenReception.
  ///
  /// In en, this message translates to:
  /// **'Open Reception'**
  String get simOpenReception;

  /// No description provided for @simFleetSection.
  ///
  /// In en, this message translates to:
  /// **'Fleet'**
  String get simFleetSection;

  /// No description provided for @simRadiusKm.
  ///
  /// In en, this message translates to:
  /// **'Radius (km)'**
  String get simRadiusKm;

  /// No description provided for @simVessels.
  ///
  /// In en, this message translates to:
  /// **'Vessels'**
  String get simVessels;

  /// No description provided for @simSpeedMinKn.
  ///
  /// In en, this message translates to:
  /// **'Speed min (kn)'**
  String get simSpeedMinKn;

  /// No description provided for @simSpeedMaxKn.
  ///
  /// In en, this message translates to:
  /// **'Speed max (kn)'**
  String get simSpeedMaxKn;

  /// No description provided for @simIntervalS.
  ///
  /// In en, this message translates to:
  /// **'Interval (s)'**
  String get simIntervalS;

  /// No description provided for @simSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get simSeed;

  /// No description provided for @simAnchoredPct.
  ///
  /// In en, this message translates to:
  /// **'Anchored (%)'**
  String get simAnchoredPct;

  /// No description provided for @simNamePrefix.
  ///
  /// In en, this message translates to:
  /// **'Name prefix'**
  String get simNamePrefix;

  /// No description provided for @simMmsiMid.
  ///
  /// In en, this message translates to:
  /// **'MMSI country / MID'**
  String get simMmsiMid;

  /// No description provided for @simSearchMmid.
  ///
  /// In en, this message translates to:
  /// **'Search a country or type a 3-digit MID'**
  String get simSearchMmid;

  /// No description provided for @simCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get simCustom;

  /// No description provided for @simVesselTypes.
  ///
  /// In en, this message translates to:
  /// **'Vessel types'**
  String get simVesselTypes;

  /// No description provided for @simRealisticNames.
  ///
  /// In en, this message translates to:
  /// **'Realistic names'**
  String get simRealisticNames;

  /// No description provided for @simRealisticDimensions.
  ///
  /// In en, this message translates to:
  /// **'Realistic dimensions'**
  String get simRealisticDimensions;

  /// No description provided for @simRealisticMmsi.
  ///
  /// In en, this message translates to:
  /// **'Realistic ITU MMSI'**
  String get simRealisticMmsi;

  /// No description provided for @simZoneSection.
  ///
  /// In en, this message translates to:
  /// **'Zone & traffic'**
  String get simZoneSection;

  /// No description provided for @simLocationPreset.
  ///
  /// In en, this message translates to:
  /// **'Location preset'**
  String get simLocationPreset;

  /// No description provided for @simSearchPort.
  ///
  /// In en, this message translates to:
  /// **'Search a port…'**
  String get simSearchPort;

  /// No description provided for @simCenterLat.
  ///
  /// In en, this message translates to:
  /// **'Center latitude'**
  String get simCenterLat;

  /// No description provided for @simCenterLon.
  ///
  /// In en, this message translates to:
  /// **'Center longitude'**
  String get simCenterLon;

  /// No description provided for @simZoneShape.
  ///
  /// In en, this message translates to:
  /// **'Zone shape'**
  String get simZoneShape;

  /// No description provided for @simTransitPct.
  ///
  /// In en, this message translates to:
  /// **'Transit (%)'**
  String get simTransitPct;

  /// No description provided for @simRegeneratePeriodically.
  ///
  /// In en, this message translates to:
  /// **'Regenerate periodically'**
  String get simRegeneratePeriodically;

  /// No description provided for @simRegenerateTicks.
  ///
  /// In en, this message translates to:
  /// **'Regenerate (ticks)'**
  String get simRegenerateTicks;

  /// No description provided for @simPresetHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a preset to fill the coordinates, or type Center latitude / longitude directly.'**
  String get simPresetHint;

  /// No description provided for @simMovementSection.
  ///
  /// In en, this message translates to:
  /// **'Movement & emission'**
  String get simMovementSection;

  /// No description provided for @simVarySpeed.
  ///
  /// In en, this message translates to:
  /// **'Vary speed over time'**
  String get simVarySpeed;

  /// No description provided for @simReportIntervalTicks.
  ///
  /// In en, this message translates to:
  /// **'Report interval (ticks)'**
  String get simReportIntervalTicks;

  /// No description provided for @simWander.
  ///
  /// In en, this message translates to:
  /// **'Wander (0-3)'**
  String get simWander;

  /// No description provided for @simSpeedByType.
  ///
  /// In en, this message translates to:
  /// **'Speed by vessel type'**
  String get simSpeedByType;

  /// No description provided for @simClassBSharePct.
  ///
  /// In en, this message translates to:
  /// **'Class B share (%)'**
  String get simClassBSharePct;

  /// No description provided for @simHighAccuracy.
  ///
  /// In en, this message translates to:
  /// **'High accuracy'**
  String get simHighAccuracy;

  /// No description provided for @simRealisticRot.
  ///
  /// In en, this message translates to:
  /// **'Realistic rate of turn'**
  String get simRealisticRot;

  /// No description provided for @simContentSection.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get simContentSection;

  /// No description provided for @simSafetyTexts.
  ///
  /// In en, this message translates to:
  /// **'Safety texts (one per line)'**
  String get simSafetyTexts;

  /// No description provided for @simDestinations.
  ///
  /// In en, this message translates to:
  /// **'Destinations (one per line)'**
  String get simDestinations;

  /// No description provided for @simStationsSection.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get simStationsSection;

  /// No description provided for @simBaseStations.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get simBaseStations;

  /// No description provided for @simAtoN.
  ///
  /// In en, this message translates to:
  /// **'AtoN'**
  String get simAtoN;

  /// No description provided for @simQualitySection.
  ///
  /// In en, this message translates to:
  /// **'Transmission quality'**
  String get simQualitySection;

  /// No description provided for @simInjectErrors.
  ///
  /// In en, this message translates to:
  /// **'Inject errors'**
  String get simInjectErrors;

  /// No description provided for @simErrorRatePct.
  ///
  /// In en, this message translates to:
  /// **'Error rate (%)'**
  String get simErrorRatePct;

  /// No description provided for @simTalkerId.
  ///
  /// In en, this message translates to:
  /// **'Talker ID'**
  String get simTalkerId;

  /// No description provided for @simNmea4Tag.
  ///
  /// In en, this message translates to:
  /// **'NMEA 4.0 tag block'**
  String get simNmea4Tag;

  /// No description provided for @simMessagesSection.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get simMessagesSection;

  /// No description provided for @simApplyFleet.
  ///
  /// In en, this message translates to:
  /// **'Apply fleet'**
  String get simApplyFleet;

  /// No description provided for @simRegenerateFleet.
  ///
  /// In en, this message translates to:
  /// **'Regenerate fleet'**
  String get simRegenerateFleet;

  /// No description provided for @simGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get simGenerating;

  /// No description provided for @simLiveFleet.
  ///
  /// In en, this message translates to:
  /// **'Live fleet'**
  String get simLiveFleet;

  /// No description provided for @simFleetSummary.
  ///
  /// In en, this message translates to:
  /// **'{boats} boats · {frames} frames emitted'**
  String simFleetSummary(Object boats, Object frames);

  /// No description provided for @mapSearchVessels.
  ///
  /// In en, this message translates to:
  /// **'Search vessels'**
  String get mapSearchVessels;

  /// No description provided for @mapSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, MMSI or IMO'**
  String get mapSearchHint;

  /// No description provided for @mapNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get mapNoResults;

  /// No description provided for @mapMmsi.
  ///
  /// In en, this message translates to:
  /// **'MMSI {mmsi}'**
  String mapMmsi(Object mmsi);

  /// No description provided for @mapImo.
  ///
  /// In en, this message translates to:
  /// **'IMO {imo}'**
  String mapImo(Object imo);

  /// No description provided for @mapFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get mapFilters;

  /// No description provided for @mapAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All {label}'**
  String mapAllLabel(Object label);

  /// No description provided for @mapVesselType.
  ///
  /// In en, this message translates to:
  /// **'Vessel type'**
  String get mapVesselType;

  /// No description provided for @mapNavigationStatus.
  ///
  /// In en, this message translates to:
  /// **'Navigation status'**
  String get mapNavigationStatus;

  /// No description provided for @mapCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get mapCountry;

  /// No description provided for @mapMinSog.
  ///
  /// In en, this message translates to:
  /// **'Min SOG (kn)'**
  String get mapMinSog;

  /// No description provided for @mapMaxSog.
  ///
  /// In en, this message translates to:
  /// **'Max SOG (kn)'**
  String get mapMaxSog;

  /// No description provided for @mapOnlyNamed.
  ///
  /// In en, this message translates to:
  /// **'Only vessels with a name'**
  String get mapOnlyNamed;

  /// No description provided for @mapReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get mapReset;

  /// No description provided for @mapApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get mapApply;

  /// No description provided for @mapAutoBasemap.
  ///
  /// In en, this message translates to:
  /// **'Auto (follow theme)'**
  String get mapAutoBasemap;

  /// No description provided for @mapFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following {mmsi}'**
  String mapFollowing(Object mmsi);

  /// No description provided for @mapMmsiHover.
  ///
  /// In en, this message translates to:
  /// **'MMSI {mmsi}'**
  String mapMmsiHover(Object mmsi);

  /// No description provided for @mapMmsiFallback.
  ///
  /// In en, this message translates to:
  /// **'MMSI {mmsi}'**
  String mapMmsiFallback(Object mmsi);

  /// No description provided for @basemapVoyagerLight.
  ///
  /// In en, this message translates to:
  /// **'Voyager (light)'**
  String get basemapVoyagerLight;

  /// No description provided for @basemapPositronLight.
  ///
  /// In en, this message translates to:
  /// **'Positron (light minimal)'**
  String get basemapPositronLight;

  /// No description provided for @basemapDarkMatter.
  ///
  /// In en, this message translates to:
  /// **'Dark Matter'**
  String get basemapDarkMatter;

  /// No description provided for @basemapOsm.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap'**
  String get basemapOsm;

  /// No description provided for @basemapOpenTopo.
  ///
  /// In en, this message translates to:
  /// **'OpenTopoMap'**
  String get basemapOpenTopo;

  /// No description provided for @basemapEsriSatellite.
  ///
  /// In en, this message translates to:
  /// **'Esri Satellite'**
  String get basemapEsriSatellite;

  /// No description provided for @basemapEsriStreets.
  ///
  /// In en, this message translates to:
  /// **'Esri World Street Map'**
  String get basemapEsriStreets;

  /// No description provided for @decoderInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Paste or write one or more NMEA AIS sentences'**
  String get decoderInputLabel;

  /// No description provided for @decoderValidateChecksums.
  ///
  /// In en, this message translates to:
  /// **'Validate checksums'**
  String get decoderValidateChecksums;

  /// No description provided for @decoderDecode.
  ///
  /// In en, this message translates to:
  /// **'Decode'**
  String get decoderDecode;

  /// No description provided for @decoderDecoded.
  ///
  /// In en, this message translates to:
  /// **'Decoded'**
  String get decoderDecoded;

  /// No description provided for @decoderDecodedN.
  ///
  /// In en, this message translates to:
  /// **'Decoded ({n} sentences)'**
  String decoderDecodedN(Object n);

  /// No description provided for @decoderInvalidChecksum.
  ///
  /// In en, this message translates to:
  /// **'Invalid checksum'**
  String get decoderInvalidChecksum;

  /// No description provided for @decoderParseError.
  ///
  /// In en, this message translates to:
  /// **'Parse error'**
  String get decoderParseError;

  /// No description provided for @decoderWaitingFragments.
  ///
  /// In en, this message translates to:
  /// **'Waiting for more fragments…'**
  String get decoderWaitingFragments;

  /// No description provided for @decoderTagSource.
  ///
  /// In en, this message translates to:
  /// **'source {id}'**
  String decoderTagSource(Object id);

  /// No description provided for @decoderTagBlock.
  ///
  /// In en, this message translates to:
  /// **'Tag block · {content}'**
  String decoderTagBlock(Object content);

  /// No description provided for @toolDecoder.
  ///
  /// In en, this message translates to:
  /// **'NMEA Decoder'**
  String get toolDecoder;

  /// No description provided for @toolDecoderSub.
  ///
  /// In en, this message translates to:
  /// **'Decode AIS sentences'**
  String get toolDecoderSub;

  /// No description provided for @toolChecksum.
  ///
  /// In en, this message translates to:
  /// **'Checksum'**
  String get toolChecksum;

  /// No description provided for @toolChecksumSub.
  ///
  /// In en, this message translates to:
  /// **'Compute NMEA XOR checksums'**
  String get toolChecksumSub;

  /// No description provided for @toolMmsi.
  ///
  /// In en, this message translates to:
  /// **'MMSI lookup'**
  String get toolMmsi;

  /// No description provided for @toolMmsiSub.
  ///
  /// In en, this message translates to:
  /// **'Validate and identify an MMSI'**
  String get toolMmsiSub;

  /// No description provided for @toolSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed converter'**
  String get toolSpeed;

  /// No description provided for @toolSpeedSub.
  ///
  /// In en, this message translates to:
  /// **'kn · km/h · m/s · mph'**
  String get toolSpeedSub;

  /// No description provided for @toolBinary.
  ///
  /// In en, this message translates to:
  /// **'Binary inspector'**
  String get toolBinary;

  /// No description provided for @toolBinarySub.
  ///
  /// In en, this message translates to:
  /// **'Payload down to the bits'**
  String get toolBinarySub;

  /// No description provided for @toolEta.
  ///
  /// In en, this message translates to:
  /// **'ETA calculator'**
  String get toolEta;

  /// No description provided for @toolEtaSub.
  ///
  /// In en, this message translates to:
  /// **'ETA as AIS type-5 fields'**
  String get toolEtaSub;

  /// No description provided for @toolRadio.
  ///
  /// In en, this message translates to:
  /// **'Radio range'**
  String get toolRadio;

  /// No description provided for @toolRadioSub.
  ///
  /// In en, this message translates to:
  /// **'VHF-AIS radio horizon'**
  String get toolRadioSub;

  /// No description provided for @toolTextToBinary.
  ///
  /// In en, this message translates to:
  /// **'Text to binary'**
  String get toolTextToBinary;

  /// No description provided for @toolTextToBinarySub.
  ///
  /// In en, this message translates to:
  /// **'6-bit ASCII to hex/bits'**
  String get toolTextToBinarySub;

  /// No description provided for @checksumInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Paste one or more NMEA sentences'**
  String get checksumInputLabel;

  /// No description provided for @checksumComputed.
  ///
  /// In en, this message translates to:
  /// **'Computed'**
  String get checksumComputed;

  /// No description provided for @checksumDeclared.
  ///
  /// In en, this message translates to:
  /// **'Declared'**
  String get checksumDeclared;

  /// No description provided for @checksumValid.
  ///
  /// In en, this message translates to:
  /// **'Checksum valid'**
  String get checksumValid;

  /// No description provided for @checksumInvalid.
  ///
  /// In en, this message translates to:
  /// **'Checksum mismatch'**
  String get checksumInvalid;

  /// No description provided for @checksumFix.
  ///
  /// In en, this message translates to:
  /// **'Fix checksum'**
  String get checksumFix;

  /// No description provided for @mmsiInputLabel.
  ///
  /// In en, this message translates to:
  /// **'MMSI (9 digits)'**
  String get mmsiInputLabel;

  /// No description provided for @mmsiValid.
  ///
  /// In en, this message translates to:
  /// **'Valid MMSI'**
  String get mmsiValid;

  /// No description provided for @mmsiInvalid.
  ///
  /// In en, this message translates to:
  /// **'Not a valid 9-digit MMSI'**
  String get mmsiInvalid;

  /// No description provided for @mmsiMid.
  ///
  /// In en, this message translates to:
  /// **'MID'**
  String get mmsiMid;

  /// No description provided for @mmsiCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get mmsiCountry;

  /// No description provided for @mmsiCountryUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown MID'**
  String get mmsiCountryUnknown;

  /// No description provided for @mmsiType.
  ///
  /// In en, this message translates to:
  /// **'Station type'**
  String get mmsiType;

  /// No description provided for @mmsiGroupCall.
  ///
  /// In en, this message translates to:
  /// **'Group call'**
  String get mmsiGroupCall;

  /// No description provided for @mmsiSarAircraft.
  ///
  /// In en, this message translates to:
  /// **'SAR aircraft'**
  String get mmsiSarAircraft;

  /// No description provided for @mmsiCoastStation.
  ///
  /// In en, this message translates to:
  /// **'Coast station'**
  String get mmsiCoastStation;

  /// No description provided for @mmsiShipStation.
  ///
  /// In en, this message translates to:
  /// **'Ship station'**
  String get mmsiShipStation;

  /// No description provided for @mmsiHandheldVhf.
  ///
  /// In en, this message translates to:
  /// **'Handheld VHF'**
  String get mmsiHandheldVhf;

  /// No description provided for @mmsiAton.
  ///
  /// In en, this message translates to:
  /// **'Aid to navigation (AtoN)'**
  String get mmsiAton;

  /// No description provided for @mmsiSar.
  ///
  /// In en, this message translates to:
  /// **'SAR unit'**
  String get mmsiSar;

  /// No description provided for @mmsiOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get mmsiOther;

  /// No description provided for @speedValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get speedValue;

  /// No description provided for @speedUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get speedUnit;

  /// No description provided for @binaryInputLabel.
  ///
  /// In en, this message translates to:
  /// **'NMEA sentence or raw 6-bit payload'**
  String get binaryInputLabel;

  /// No description provided for @binaryPayload.
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get binaryPayload;

  /// No description provided for @binaryBits.
  ///
  /// In en, this message translates to:
  /// **'Bits'**
  String get binaryBits;

  /// No description provided for @binaryBinary.
  ///
  /// In en, this message translates to:
  /// **'Binary'**
  String get binaryBinary;

  /// No description provided for @binaryHex.
  ///
  /// In en, this message translates to:
  /// **'Hex'**
  String get binaryHex;

  /// No description provided for @binaryHexBytes.
  ///
  /// In en, this message translates to:
  /// **'Hex bytes'**
  String get binaryHexBytes;

  /// No description provided for @binarySixBit.
  ///
  /// In en, this message translates to:
  /// **'6-bit characters'**
  String get binarySixBit;

  /// No description provided for @etaDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get etaDistance;

  /// No description provided for @etaUnitNm.
  ///
  /// In en, this message translates to:
  /// **'nautical miles'**
  String get etaUnitNm;

  /// No description provided for @etaUnitKm.
  ///
  /// In en, this message translates to:
  /// **'kilometres'**
  String get etaUnitKm;

  /// No description provided for @etaSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get etaSpeed;

  /// No description provided for @etaDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get etaDuration;

  /// No description provided for @etaEtaLocal.
  ///
  /// In en, this message translates to:
  /// **'ETA (local)'**
  String get etaEtaLocal;

  /// No description provided for @etaEtaUtc.
  ///
  /// In en, this message translates to:
  /// **'ETA (UTC)'**
  String get etaEtaUtc;

  /// No description provided for @etaAisFields.
  ///
  /// In en, this message translates to:
  /// **'AIS type-5 ETA fields'**
  String get etaAisFields;

  /// No description provided for @etaMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get etaMonth;

  /// No description provided for @etaDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get etaDay;

  /// No description provided for @etaHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get etaHour;

  /// No description provided for @etaMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get etaMinute;

  /// No description provided for @etaCombined.
  ///
  /// In en, this message translates to:
  /// **'MM/DD HH:MM'**
  String get etaCombined;

  /// No description provided for @radioHeight1.
  ///
  /// In en, this message translates to:
  /// **'Antenna height 1'**
  String get radioHeight1;

  /// No description provided for @radioHeight2.
  ///
  /// In en, this message translates to:
  /// **'Antenna height 2'**
  String get radioHeight2;

  /// No description provided for @radioHorizon.
  ///
  /// In en, this message translates to:
  /// **'Radio horizon'**
  String get radioHorizon;

  /// No description provided for @radioHorizonKm.
  ///
  /// In en, this message translates to:
  /// **'Radio horizon (km)'**
  String get radioHorizonKm;

  /// No description provided for @radioFrequencies.
  ///
  /// In en, this message translates to:
  /// **'AIS channels'**
  String get radioFrequencies;

  /// No description provided for @radioAis1.
  ///
  /// In en, this message translates to:
  /// **'AIS 1'**
  String get radioAis1;

  /// No description provided for @radioAis2.
  ///
  /// In en, this message translates to:
  /// **'AIS 2'**
  String get radioAis2;

  /// No description provided for @t2bInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Type some text (AIS 6-bit alphabet)'**
  String get t2bInputLabel;

  /// No description provided for @t2bCharTable.
  ///
  /// In en, this message translates to:
  /// **'Character · value · 6-bit'**
  String get t2bCharTable;

  /// No description provided for @t2bBinary.
  ///
  /// In en, this message translates to:
  /// **'Binary'**
  String get t2bBinary;

  /// No description provided for @t2bHex.
  ///
  /// In en, this message translates to:
  /// **'Hex'**
  String get t2bHex;

  /// No description provided for @t2bBytes.
  ///
  /// In en, this message translates to:
  /// **'Bytes (editor format)'**
  String get t2bBytes;

  /// No description provided for @t2bPayload.
  ///
  /// In en, this message translates to:
  /// **'Armored payload'**
  String get t2bPayload;

  /// No description provided for @t2bNote.
  ///
  /// In en, this message translates to:
  /// **'The byte list can be pasted into the Editor\'s “Data bytes” field of a type 6/8/25/26 message; the armored payload is the exact NMEA payload field.'**
  String get t2bNote;

  /// No description provided for @editorAsmDetected.
  ///
  /// In en, this message translates to:
  /// **'Application Specific Message — {name}'**
  String editorAsmDetected(Object name);

  /// No description provided for @editorAsmRawHint.
  ///
  /// In en, this message translates to:
  /// **'Fields of the matched ASM. The raw “Data bytes” field still overrides them when filled.'**
  String get editorAsmRawHint;

  /// No description provided for @fMessageType.
  ///
  /// In en, this message translates to:
  /// **'Message type'**
  String get fMessageType;

  /// No description provided for @editorAsmPreset.
  ///
  /// In en, this message translates to:
  /// **'ASM preset'**
  String get editorAsmPreset;

  /// No description provided for @editorAsmPresetManual.
  ///
  /// In en, this message translates to:
  /// **'Custom — enter DAC/FID manually'**
  String get editorAsmPresetManual;

  /// No description provided for @editorDataSourceRaw.
  ///
  /// In en, this message translates to:
  /// **'Data bytes'**
  String get editorDataSourceRaw;

  /// No description provided for @editorDataSourceAsm.
  ///
  /// In en, this message translates to:
  /// **'ASM fields'**
  String get editorDataSourceAsm;

  /// No description provided for @asmStateInForce.
  ///
  /// In en, this message translates to:
  /// **'in force'**
  String get asmStateInForce;

  /// No description provided for @asmStateDeprecated.
  ///
  /// In en, this message translates to:
  /// **'deprecated'**
  String get asmStateDeprecated;

  /// No description provided for @asmStateReplaced.
  ///
  /// In en, this message translates to:
  /// **'replaced'**
  String get asmStateReplaced;

  /// No description provided for @asmStateDiscontinued.
  ///
  /// In en, this message translates to:
  /// **'discontinued'**
  String get asmStateDiscontinued;

  /// No description provided for @asmStateDraft.
  ///
  /// In en, this message translates to:
  /// **'draft'**
  String get asmStateDraft;

  /// No description provided for @asmStateProposal.
  ///
  /// In en, this message translates to:
  /// **'proposal'**
  String get asmStateProposal;

  /// No description provided for @asmStateTesting.
  ///
  /// In en, this message translates to:
  /// **'testing'**
  String get asmStateTesting;

  /// No description provided for @asmDeprecatedSince.
  ///
  /// In en, this message translates to:
  /// **'Deprecated since {note}'**
  String asmDeprecatedSince(Object note);

  /// No description provided for @asmLayoutUnknown.
  ///
  /// In en, this message translates to:
  /// **'No bit layout is documented for {name} — edit the raw Data bytes.'**
  String asmLayoutUnknown(Object name);

  /// No description provided for @docChapterAsm.
  ///
  /// In en, this message translates to:
  /// **'Application Specific Messages'**
  String get docChapterAsm;

  /// No description provided for @docAsmIntro.
  ///
  /// In en, this message translates to:
  /// **'Not every AIS payload is a standard position report. Message types 6, 8, 25 and 26 carry application-specific binary data (an ASM) whose meaning is defined by two numbers: a Designated Area Code (DAC) and a Function Identifier (FID).'**
  String get docAsmIntro;

  /// No description provided for @docAsmWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What is an ASM?'**
  String get docAsmWhatTitle;

  /// No description provided for @docAsmWhat.
  ///
  /// In en, this message translates to:
  /// **'An Application Specific Message is a structured payload published by an organisation (IMO, IALA, national administrations, manufacturers) for a specific use: meteo and hydrographic data, aid-to-navigation monitoring, DGPS corrections, port services and more. Types 6/8 carry the DAC/FID header; 25/26 repeat the same DAC/FID layout inside the slot messages.'**
  String get docAsmWhat;

  /// No description provided for @docAsmDacFidTitle.
  ///
  /// In en, this message translates to:
  /// **'DAC and FID'**
  String get docAsmDacFidTitle;

  /// No description provided for @docAsmDacFid1.
  ///
  /// In en, this message translates to:
  /// **'The DAC is a 10-bit code identifying the issuing organisation or country (e.g. 001 = IMO, 002 = IALA). The FID is a 6-bit function code inside that DAC\'s namespace (e.g. 001/11 = IMO meteo & hydrographic data).'**
  String get docAsmDacFid1;

  /// No description provided for @docAsmDacFid2.
  ///
  /// In en, this message translates to:
  /// **'The data bytes that follow the DAC/FID header are decoded according to the matching application standard. Different DAC/FID pairs can lay out the same bytes completely differently, so the pair must always be known first.'**
  String get docAsmDacFid2;

  /// No description provided for @docAsmWhereTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to find the definitions'**
  String get docAsmWhereTitle;

  /// No description provided for @docAsmWhere1.
  ///
  /// In en, this message translates to:
  /// **'IMO circulars and ITU-R M.1371 (Annexes) — the authoritative source for IMO DAC 001.'**
  String get docAsmWhere1;

  /// No description provided for @docAsmWhere2.
  ///
  /// In en, this message translates to:
  /// **'IALA guidelines (e.g. G1139) and national administrations — for regional DACs.'**
  String get docAsmWhere2;

  /// No description provided for @docAsmWhere3.
  ///
  /// In en, this message translates to:
  /// **'The gpsd AIVDM documentation — an open, machine-readable catalogue of the most common DAC/FID layouts.'**
  String get docAsmWhere3;

  /// No description provided for @docAsmInKikaisTitle.
  ///
  /// In en, this message translates to:
  /// **'In KikAis'**
  String get docAsmInKikaisTitle;

  /// No description provided for @docAsmInKikais.
  ///
  /// In en, this message translates to:
  /// **'The Editor understands a curated set of well-known ASMs: when the DAC/FID of a 6/8/25/26 message matches one of them, the data field is shown as named sub-fields that are packed automatically. The raw “Data bytes” field always overrides the ASM when it is filled in. The list lives in asm_formats.dart and is easy to extend.'**
  String get docAsmInKikais;

  /// No description provided for @docAsmExampleTitle.
  ///
  /// In en, this message translates to:
  /// **'Example: IMO Meteo & Hydrographic (001/11)'**
  String get docAsmExampleTitle;

  /// No description provided for @docAsmExample.
  ///
  /// In en, this message translates to:
  /// **'Set the Editor to type 8, DAC=1 and FID=11 to build an IMO meteo message: wind, air and water temperature, pressure, visibility, currents and waves are then edited field by field instead of as a byte blob.'**
  String get docAsmExample;

  /// No description provided for @fMmsi.
  ///
  /// In en, this message translates to:
  /// **'MMSI'**
  String get fMmsi;

  /// No description provided for @fRepeatIndicator.
  ///
  /// In en, this message translates to:
  /// **'Repeat indicator'**
  String get fRepeatIndicator;

  /// No description provided for @fNavStatus.
  ///
  /// In en, this message translates to:
  /// **'Navigation status'**
  String get fNavStatus;

  /// No description provided for @fLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get fLatitude;

  /// No description provided for @fLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get fLongitude;

  /// No description provided for @fSogKn.
  ///
  /// In en, this message translates to:
  /// **'SOG (kn)'**
  String get fSogKn;

  /// No description provided for @fCogDeg.
  ///
  /// In en, this message translates to:
  /// **'COG (°)'**
  String get fCogDeg;

  /// No description provided for @fHeadingDeg.
  ///
  /// In en, this message translates to:
  /// **'Heading (°)'**
  String get fHeadingDeg;

  /// No description provided for @fRateOfTurn.
  ///
  /// In en, this message translates to:
  /// **'Rate of turn'**
  String get fRateOfTurn;

  /// No description provided for @fManeuver.
  ///
  /// In en, this message translates to:
  /// **'Maneuver'**
  String get fManeuver;

  /// No description provided for @fTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get fTimestamp;

  /// No description provided for @fRaim.
  ///
  /// In en, this message translates to:
  /// **'RAIM'**
  String get fRaim;

  /// No description provided for @fUtc.
  ///
  /// In en, this message translates to:
  /// **'UTC'**
  String get fUtc;

  /// No description provided for @fAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get fAccuracy;

  /// No description provided for @fEpfdFixType.
  ///
  /// In en, this message translates to:
  /// **'EPFD fix type'**
  String get fEpfdFixType;

  /// No description provided for @fSyncState.
  ///
  /// In en, this message translates to:
  /// **'Sync state'**
  String get fSyncState;

  /// No description provided for @fImo.
  ///
  /// In en, this message translates to:
  /// **'IMO'**
  String get fImo;

  /// No description provided for @fCallSign.
  ///
  /// In en, this message translates to:
  /// **'Call sign'**
  String get fCallSign;

  /// No description provided for @fVesselName.
  ///
  /// In en, this message translates to:
  /// **'Vessel name'**
  String get fVesselName;

  /// No description provided for @fShipType.
  ///
  /// In en, this message translates to:
  /// **'Ship type'**
  String get fShipType;

  /// No description provided for @fShipTypeText.
  ///
  /// In en, this message translates to:
  /// **'Ship type (text)'**
  String get fShipTypeText;

  /// No description provided for @fDims.
  ///
  /// In en, this message translates to:
  /// **'Bow/Stern/Port/Starboard (m)'**
  String get fDims;

  /// No description provided for @fEta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get fEta;

  /// No description provided for @fDraughtM.
  ///
  /// In en, this message translates to:
  /// **'Draught (m)'**
  String get fDraughtM;

  /// No description provided for @fDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get fDestination;

  /// No description provided for @fDte.
  ///
  /// In en, this message translates to:
  /// **'DTE'**
  String get fDte;

  /// No description provided for @fDestMmsi.
  ///
  /// In en, this message translates to:
  /// **'Destination MMSI'**
  String get fDestMmsi;

  /// No description provided for @fSeqNumber.
  ///
  /// In en, this message translates to:
  /// **'Sequence number'**
  String get fSeqNumber;

  /// No description provided for @fRetransmit.
  ///
  /// In en, this message translates to:
  /// **'Retransmit'**
  String get fRetransmit;

  /// No description provided for @fDac.
  ///
  /// In en, this message translates to:
  /// **'DAC'**
  String get fDac;

  /// No description provided for @fFid.
  ///
  /// In en, this message translates to:
  /// **'FID'**
  String get fFid;

  /// No description provided for @fData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get fData;

  /// No description provided for @fAltitudeM.
  ///
  /// In en, this message translates to:
  /// **'Altitude (m)'**
  String get fAltitudeM;

  /// No description provided for @fAssignedMode.
  ///
  /// In en, this message translates to:
  /// **'Assigned mode'**
  String get fAssignedMode;

  /// No description provided for @fRegionalReserved.
  ///
  /// In en, this message translates to:
  /// **'Regional reserved'**
  String get fRegionalReserved;

  /// No description provided for @fText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fText;

  /// No description provided for @fStationN.
  ///
  /// In en, this message translates to:
  /// **'Station {n}'**
  String fStationN(Object n);

  /// No description provided for @fSlotN.
  ///
  /// In en, this message translates to:
  /// **'Slot {n}'**
  String fSlotN(Object n);

  /// No description provided for @fSlotDetail.
  ///
  /// In en, this message translates to:
  /// **'offset {offset} · number {number} · timeout {timeout} · inc {increment}'**
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  );

  /// No description provided for @fAidType.
  ///
  /// In en, this message translates to:
  /// **'Aid type'**
  String get fAidType;

  /// No description provided for @fAidTypeCode.
  ///
  /// In en, this message translates to:
  /// **'Aid type (code)'**
  String get fAidTypeCode;

  /// No description provided for @fName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fName;

  /// No description provided for @fNameExt.
  ///
  /// In en, this message translates to:
  /// **'Name extension'**
  String get fNameExt;

  /// No description provided for @fVirtualAid.
  ///
  /// In en, this message translates to:
  /// **'Virtual aid'**
  String get fVirtualAid;

  /// No description provided for @fOffPosition.
  ///
  /// In en, this message translates to:
  /// **'Off position'**
  String get fOffPosition;

  /// No description provided for @fSecond.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get fSecond;

  /// No description provided for @fChannelA.
  ///
  /// In en, this message translates to:
  /// **'Channel A'**
  String get fChannelA;

  /// No description provided for @fChannelB.
  ///
  /// In en, this message translates to:
  /// **'Channel B'**
  String get fChannelB;

  /// No description provided for @fTxRxMode.
  ///
  /// In en, this message translates to:
  /// **'TX/RX mode'**
  String get fTxRxMode;

  /// No description provided for @fPower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get fPower;

  /// No description provided for @fZone.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get fZone;

  /// No description provided for @fAddressed.
  ///
  /// In en, this message translates to:
  /// **'Addressed'**
  String get fAddressed;

  /// No description provided for @fMmsi1.
  ///
  /// In en, this message translates to:
  /// **'MMSI 1'**
  String get fMmsi1;

  /// No description provided for @fMmsi2.
  ///
  /// In en, this message translates to:
  /// **'MMSI 2'**
  String get fMmsi2;

  /// No description provided for @fBandA.
  ///
  /// In en, this message translates to:
  /// **'Band A'**
  String get fBandA;

  /// No description provided for @fBandB.
  ///
  /// In en, this message translates to:
  /// **'Band B'**
  String get fBandB;

  /// No description provided for @fZoneSize.
  ///
  /// In en, this message translates to:
  /// **'Zone size'**
  String get fZoneSize;

  /// No description provided for @fStationType.
  ///
  /// In en, this message translates to:
  /// **'Station type'**
  String get fStationType;

  /// No description provided for @fReportInterval.
  ///
  /// In en, this message translates to:
  /// **'Report interval'**
  String get fReportInterval;

  /// No description provided for @fQuietTime.
  ///
  /// In en, this message translates to:
  /// **'Quiet time'**
  String get fQuietTime;

  /// No description provided for @fPart.
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get fPart;

  /// No description provided for @fVendorId.
  ///
  /// In en, this message translates to:
  /// **'Vendor ID'**
  String get fVendorId;

  /// No description provided for @fUnitModel.
  ///
  /// In en, this message translates to:
  /// **'Unit model'**
  String get fUnitModel;

  /// No description provided for @fSerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial number'**
  String get fSerialNumber;

  /// No description provided for @fMothershipMmsi.
  ///
  /// In en, this message translates to:
  /// **'Mothership MMSI'**
  String get fMothershipMmsi;

  /// No description provided for @fRadioStatus.
  ///
  /// In en, this message translates to:
  /// **'Radio status'**
  String get fRadioStatus;

  /// No description provided for @fGnssStatus.
  ///
  /// In en, this message translates to:
  /// **'GNSS position status'**
  String get fGnssStatus;

  /// No description provided for @fDestN.
  ///
  /// In en, this message translates to:
  /// **'Destination {n}'**
  String fDestN(Object n);

  /// No description provided for @fDestDetail.
  ///
  /// In en, this message translates to:
  /// **'{mmsi} seq {seq}'**
  String fDestDetail(Object mmsi, Object seq);

  /// No description provided for @fDestIndicator.
  ///
  /// In en, this message translates to:
  /// **'Destination indicator'**
  String get fDestIndicator;

  /// No description provided for @fBinaryDataFlag.
  ///
  /// In en, this message translates to:
  /// **'Binary data flag'**
  String get fBinaryDataFlag;

  /// No description provided for @fApplicationId.
  ///
  /// In en, this message translates to:
  /// **'Application ID'**
  String get fApplicationId;

  /// No description provided for @fPowerHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get fPowerHigh;

  /// No description provided for @fPowerLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get fPowerLow;

  /// No description provided for @fPartA.
  ///
  /// In en, this message translates to:
  /// **'A (name)'**
  String get fPartA;

  /// No description provided for @fPartB.
  ///
  /// In en, this message translates to:
  /// **'B (ship data)'**
  String get fPartB;

  /// No description provided for @editorTitle.
  ///
  /// In en, this message translates to:
  /// **'AIS Message Editor'**
  String get editorTitle;

  /// No description provided for @editorCompose.
  ///
  /// In en, this message translates to:
  /// **'Compose message'**
  String get editorCompose;

  /// No description provided for @editorMessageType.
  ///
  /// In en, this message translates to:
  /// **'Message type'**
  String get editorMessageType;

  /// No description provided for @editorAddTagBlock.
  ///
  /// In en, this message translates to:
  /// **'Add NMEA 4.0 tag block'**
  String get editorAddTagBlock;

  /// No description provided for @editorSourceId.
  ///
  /// In en, this message translates to:
  /// **'Source ID'**
  String get editorSourceId;

  /// No description provided for @editorInjectToMap.
  ///
  /// In en, this message translates to:
  /// **'Inject to map'**
  String get editorInjectToMap;

  /// No description provided for @editorSendToTarget.
  ///
  /// In en, this message translates to:
  /// **'Send to target'**
  String get editorSendToTarget;

  /// No description provided for @editorPreview.
  ///
  /// In en, this message translates to:
  /// **'NMEA preview'**
  String get editorPreview;

  /// No description provided for @editorNmeaCopied.
  ///
  /// In en, this message translates to:
  /// **'NMEA copied'**
  String get editorNmeaCopied;

  /// No description provided for @editorInjected.
  ///
  /// In en, this message translates to:
  /// **'Message injected'**
  String get editorInjected;

  /// No description provided for @editorSentToTarget.
  ///
  /// In en, this message translates to:
  /// **'Message sent to target'**
  String get editorSentToTarget;

  /// No description provided for @editorNavStatus0_15.
  ///
  /// In en, this message translates to:
  /// **'Nav status (0-15)'**
  String get editorNavStatus0_15;

  /// No description provided for @editorYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get editorYear;

  /// No description provided for @editorMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get editorMonth;

  /// No description provided for @editorDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get editorDay;

  /// No description provided for @editorHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get editorHour;

  /// No description provided for @editorMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get editorMinute;

  /// No description provided for @editorSecond.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get editorSecond;

  /// No description provided for @editorImoNumber.
  ///
  /// In en, this message translates to:
  /// **'IMO number'**
  String get editorImoNumber;

  /// No description provided for @editorBowM.
  ///
  /// In en, this message translates to:
  /// **'Bow (m)'**
  String get editorBowM;

  /// No description provided for @editorSternM.
  ///
  /// In en, this message translates to:
  /// **'Stern (m)'**
  String get editorSternM;

  /// No description provided for @editorPortM.
  ///
  /// In en, this message translates to:
  /// **'Port (m)'**
  String get editorPortM;

  /// No description provided for @editorStarboardM.
  ///
  /// In en, this message translates to:
  /// **'Starboard (m)'**
  String get editorStarboardM;

  /// No description provided for @editorEtaMonth.
  ///
  /// In en, this message translates to:
  /// **'ETA month'**
  String get editorEtaMonth;

  /// No description provided for @editorEtaDay.
  ///
  /// In en, this message translates to:
  /// **'ETA day'**
  String get editorEtaDay;

  /// No description provided for @editorEtaHour.
  ///
  /// In en, this message translates to:
  /// **'ETA hour'**
  String get editorEtaHour;

  /// No description provided for @editorEtaMinute.
  ///
  /// In en, this message translates to:
  /// **'ETA minute'**
  String get editorEtaMinute;

  /// No description provided for @editorSequence0_3.
  ///
  /// In en, this message translates to:
  /// **'Sequence (0-3)'**
  String get editorSequence0_3;

  /// No description provided for @editorDataBytes.
  ///
  /// In en, this message translates to:
  /// **'Data bytes (hex or 1,2,3)'**
  String get editorDataBytes;

  /// No description provided for @editorDestMmsisComma.
  ///
  /// In en, this message translates to:
  /// **'Dest. MMSIs (comma)'**
  String get editorDestMmsisComma;

  /// No description provided for @editorSequencesComma.
  ///
  /// In en, this message translates to:
  /// **'Sequences (comma)'**
  String get editorSequencesComma;

  /// No description provided for @editorInterrogatedMmsi.
  ///
  /// In en, this message translates to:
  /// **'Interrogated MMSI'**
  String get editorInterrogatedMmsi;

  /// No description provided for @editorType1.
  ///
  /// In en, this message translates to:
  /// **'Type 1'**
  String get editorType1;

  /// No description provided for @editorOffset1.
  ///
  /// In en, this message translates to:
  /// **'Offset 1'**
  String get editorOffset1;

  /// No description provided for @editorTargetMmsi.
  ///
  /// In en, this message translates to:
  /// **'Target MMSI'**
  String get editorTargetMmsi;

  /// No description provided for @editorOffset.
  ///
  /// In en, this message translates to:
  /// **'Offset'**
  String get editorOffset;

  /// No description provided for @editorIncrement.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get editorIncrement;

  /// No description provided for @editorNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get editorNumber;

  /// No description provided for @editorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get editorTimeout;

  /// No description provided for @editorAidType0_31.
  ///
  /// In en, this message translates to:
  /// **'Aid type (0-31)'**
  String get editorAidType0_31;

  /// No description provided for @editorVirtualAid0_1.
  ///
  /// In en, this message translates to:
  /// **'Virtual aid (0/1)'**
  String get editorVirtualAid0_1;

  /// No description provided for @editorTxRxMode0_15.
  ///
  /// In en, this message translates to:
  /// **'Tx/Rx mode (0-15)'**
  String get editorTxRxMode0_15;

  /// No description provided for @editorTxRxMode0_3.
  ///
  /// In en, this message translates to:
  /// **'Tx/Rx mode (0-3)'**
  String get editorTxRxMode0_3;

  /// No description provided for @editorNeLat.
  ///
  /// In en, this message translates to:
  /// **'NE latitude'**
  String get editorNeLat;

  /// No description provided for @editorNeLon.
  ///
  /// In en, this message translates to:
  /// **'NE longitude'**
  String get editorNeLon;

  /// No description provided for @editorSwLat.
  ///
  /// In en, this message translates to:
  /// **'SW latitude'**
  String get editorSwLat;

  /// No description provided for @editorSwLon.
  ///
  /// In en, this message translates to:
  /// **'SW longitude'**
  String get editorSwLon;

  /// No description provided for @editorInterval0_15.
  ///
  /// In en, this message translates to:
  /// **'Interval (0-15)'**
  String get editorInterval0_15;

  /// No description provided for @editorPart.
  ///
  /// In en, this message translates to:
  /// **'Part (0 = A name, 1 = B static)'**
  String get editorPart;

  /// No description provided for @editorDestMmsiEmpty.
  ///
  /// In en, this message translates to:
  /// **'Destination MMSI (empty = broadcast)'**
  String get editorDestMmsiEmpty;

  /// No description provided for @editorAppDacEmpty.
  ///
  /// In en, this message translates to:
  /// **'App DAC (empty = none)'**
  String get editorAppDacEmpty;

  /// No description provided for @editorAppFidEmpty.
  ///
  /// In en, this message translates to:
  /// **'App FID (empty = none)'**
  String get editorAppFidEmpty;

  /// No description provided for @nmeaTalker.
  ///
  /// In en, this message translates to:
  /// **'Talker'**
  String get nmeaTalker;

  /// No description provided for @nmeaFragments.
  ///
  /// In en, this message translates to:
  /// **'Fragments'**
  String get nmeaFragments;

  /// No description provided for @nmeaFragmentN.
  ///
  /// In en, this message translates to:
  /// **'Fragment #'**
  String get nmeaFragmentN;

  /// No description provided for @nmeaMessageId.
  ///
  /// In en, this message translates to:
  /// **'Message ID'**
  String get nmeaMessageId;

  /// No description provided for @nmeaChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get nmeaChannel;

  /// No description provided for @nmeaPayload.
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get nmeaPayload;

  /// No description provided for @nmeaFillBits.
  ///
  /// In en, this message translates to:
  /// **'Fill bits'**
  String get nmeaFillBits;

  /// No description provided for @nmeaTagBlock.
  ///
  /// In en, this message translates to:
  /// **'Tag block'**
  String get nmeaTagBlock;

  /// No description provided for @nmeaChecksum.
  ///
  /// In en, this message translates to:
  /// **'Checksum'**
  String get nmeaChecksum;

  /// No description provided for @nmeaEmpty.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get nmeaEmpty;

  /// No description provided for @bubbleKindVessel.
  ///
  /// In en, this message translates to:
  /// **'Vessel'**
  String get bubbleKindVessel;

  /// No description provided for @bubbleKindAircraft.
  ///
  /// In en, this message translates to:
  /// **'SAR Aircraft'**
  String get bubbleKindAircraft;

  /// No description provided for @bubbleKindAton.
  ///
  /// In en, this message translates to:
  /// **'Aid to Navigation'**
  String get bubbleKindAton;

  /// No description provided for @bubbleKindStation.
  ///
  /// In en, this message translates to:
  /// **'Base Station'**
  String get bubbleKindStation;

  /// No description provided for @bubbleGeneralInfo.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get bubbleGeneralInfo;

  /// No description provided for @bubbleKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get bubbleKind;

  /// No description provided for @bubbleAidType.
  ///
  /// In en, this message translates to:
  /// **'Aid Type'**
  String get bubbleAidType;

  /// No description provided for @bubbleVirtual.
  ///
  /// In en, this message translates to:
  /// **'Virtual'**
  String get bubbleVirtual;

  /// No description provided for @bubbleAltitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get bubbleAltitude;

  /// No description provided for @bubbleCallSign.
  ///
  /// In en, this message translates to:
  /// **'Call Sign'**
  String get bubbleCallSign;

  /// No description provided for @bubblePosNav.
  ///
  /// In en, this message translates to:
  /// **'Position & Navigation'**
  String get bubblePosNav;

  /// No description provided for @bubbleHeading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get bubbleHeading;

  /// No description provided for @bubbleCog.
  ///
  /// In en, this message translates to:
  /// **'COG'**
  String get bubbleCog;

  /// No description provided for @bubbleSog.
  ///
  /// In en, this message translates to:
  /// **'SOG'**
  String get bubbleSog;

  /// No description provided for @bubbleVesselDetails.
  ///
  /// In en, this message translates to:
  /// **'Vessel Details'**
  String get bubbleVesselDetails;

  /// No description provided for @bubbleType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bubbleType;

  /// No description provided for @bubbleTypeInt.
  ///
  /// In en, this message translates to:
  /// **'Type (Int)'**
  String get bubbleTypeInt;

  /// No description provided for @bubbleDimsBowStern.
  ///
  /// In en, this message translates to:
  /// **'Dimensions Bow/Stern'**
  String get bubbleDimsBowStern;

  /// No description provided for @bubbleDimsPortStarboard.
  ///
  /// In en, this message translates to:
  /// **'Dimensions Port/Starboard'**
  String get bubbleDimsPortStarboard;

  /// No description provided for @bubbleSpare.
  ///
  /// In en, this message translates to:
  /// **'Spare'**
  String get bubbleSpare;

  /// No description provided for @bubbleDraught.
  ///
  /// In en, this message translates to:
  /// **'Draught'**
  String get bubbleDraught;

  /// No description provided for @bubbleFrames.
  ///
  /// In en, this message translates to:
  /// **'Frames ({n})'**
  String bubbleFrames(Object n);

  /// No description provided for @bubbleNoFrames.
  ///
  /// In en, this message translates to:
  /// **'No frames yet'**
  String get bubbleNoFrames;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @textFiles.
  ///
  /// In en, this message translates to:
  /// **'Text Files'**
  String get textFiles;

  /// No description provided for @logTargetConnected.
  ///
  /// In en, this message translates to:
  /// **'Target {name} connected ({protocol} {host}:{port}).'**
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  );

  /// No description provided for @logTargetConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect target {name}: {error}'**
  String logTargetConnectFailed(Object error, Object name);

  /// No description provided for @logStopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping forwarder...'**
  String get logStopping;

  /// No description provided for @logStopped.
  ///
  /// In en, this message translates to:
  /// **'Forwarder stopped.'**
  String get logStopped;

  /// No description provided for @logFeedAdded.
  ///
  /// In en, this message translates to:
  /// **'Feed added: {name} ({host}:{port})'**
  String logFeedAdded(Object host, Object name, Object port);

  /// No description provided for @logFeedRemoved.
  ///
  /// In en, this message translates to:
  /// **'Feed removed: {name}'**
  String logFeedRemoved(Object name);

  /// No description provided for @logFeedConnected.
  ///
  /// In en, this message translates to:
  /// **'Feed {name} connected.'**
  String logFeedConnected(Object name);

  /// No description provided for @logFeedDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Feed {name} disconnected. Reconnecting in 5s...'**
  String logFeedDisconnected(Object name);

  /// No description provided for @logFeedConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect feed {name}: {error}. Retrying in 5s...'**
  String logFeedConnectFailed(Object error, Object name);

  /// No description provided for @logTcpListening.
  ///
  /// In en, this message translates to:
  /// **'Target {name}: TCP server listening on port {port}'**
  String logTcpListening(Object name, Object port);

  /// No description provided for @logTcpClientConnected.
  ///
  /// In en, this message translates to:
  /// **'Target {name}: client connected {address}:{port}'**
  String logTcpClientConnected(Object address, Object name, Object port);

  /// No description provided for @logTcpClientDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Target {name}: client disconnected'**
  String logTcpClientDisconnected(Object name);

  /// No description provided for @logTcpClientError.
  ///
  /// In en, this message translates to:
  /// **'Target {name}: client error {error}'**
  String logTcpClientError(Object error, Object name);

  /// No description provided for @logSendError.
  ///
  /// In en, this message translates to:
  /// **'Target {name} send error: {error}'**
  String logSendError(Object error, Object name);

  /// No description provided for @docNavStatus0.
  ///
  /// In en, this message translates to:
  /// **'Under way using engine'**
  String get docNavStatus0;

  /// No description provided for @docNavStatus1.
  ///
  /// In en, this message translates to:
  /// **'At anchor'**
  String get docNavStatus1;

  /// No description provided for @docNavStatus2.
  ///
  /// In en, this message translates to:
  /// **'Not under command'**
  String get docNavStatus2;

  /// No description provided for @docNavStatus3.
  ///
  /// In en, this message translates to:
  /// **'Restricted manoeuvrability'**
  String get docNavStatus3;

  /// No description provided for @docNavStatus4.
  ///
  /// In en, this message translates to:
  /// **'Constrained by her draught'**
  String get docNavStatus4;

  /// No description provided for @docNavStatus5.
  ///
  /// In en, this message translates to:
  /// **'Moored'**
  String get docNavStatus5;

  /// No description provided for @docNavStatus6.
  ///
  /// In en, this message translates to:
  /// **'Aground'**
  String get docNavStatus6;

  /// No description provided for @docNavStatus7.
  ///
  /// In en, this message translates to:
  /// **'Engaged in fishing'**
  String get docNavStatus7;

  /// No description provided for @docNavStatus8.
  ///
  /// In en, this message translates to:
  /// **'Under way sailing'**
  String get docNavStatus8;

  /// No description provided for @docNavStatus9.
  ///
  /// In en, this message translates to:
  /// **'Reserved (HSC)'**
  String get docNavStatus9;

  /// No description provided for @docNavStatus10.
  ///
  /// In en, this message translates to:
  /// **'Reserved (WIG)'**
  String get docNavStatus10;

  /// No description provided for @docNavStatus11.
  ///
  /// In en, this message translates to:
  /// **'Towing astern (regional)'**
  String get docNavStatus11;

  /// No description provided for @docNavStatus12.
  ///
  /// In en, this message translates to:
  /// **'Pushing ahead / towing alongside (regional)'**
  String get docNavStatus12;

  /// No description provided for @docNavStatus13.
  ///
  /// In en, this message translates to:
  /// **'Reserved for future use'**
  String get docNavStatus13;

  /// No description provided for @docNavStatus14.
  ///
  /// In en, this message translates to:
  /// **'AIS-SART active'**
  String get docNavStatus14;

  /// No description provided for @docNavStatus15.
  ///
  /// In en, this message translates to:
  /// **'Undefined (default)'**
  String get docNavStatus15;

  /// No description provided for @docEpfd0.
  ///
  /// In en, this message translates to:
  /// **'Undefined (default)'**
  String get docEpfd0;

  /// No description provided for @docEpfd1.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get docEpfd1;

  /// No description provided for @docEpfd2.
  ///
  /// In en, this message translates to:
  /// **'GLONASS'**
  String get docEpfd2;

  /// No description provided for @docEpfd3.
  ///
  /// In en, this message translates to:
  /// **'GPS + GLONASS'**
  String get docEpfd3;

  /// No description provided for @docEpfd4.
  ///
  /// In en, this message translates to:
  /// **'Loran-C'**
  String get docEpfd4;

  /// No description provided for @docEpfd5.
  ///
  /// In en, this message translates to:
  /// **'Chayka'**
  String get docEpfd5;

  /// No description provided for @docEpfd6.
  ///
  /// In en, this message translates to:
  /// **'Integrated navigation system'**
  String get docEpfd6;

  /// No description provided for @docEpfd7.
  ///
  /// In en, this message translates to:
  /// **'Surveyed (fixed)'**
  String get docEpfd7;

  /// No description provided for @docEpfd8.
  ///
  /// In en, this message translates to:
  /// **'Galileo'**
  String get docEpfd8;

  /// No description provided for @docEpfd15.
  ///
  /// In en, this message translates to:
  /// **'Internal GNSS'**
  String get docEpfd15;

  /// No description provided for @docBitFieldBits.
  ///
  /// In en, this message translates to:
  /// **'{name} · bits {start}-{end}'**
  String docBitFieldBits(Object end, Object name, Object start);

  /// No description provided for @docBitLayoutSummary.
  ///
  /// In en, this message translates to:
  /// **'{fields} fields · {bits} bits total · tap a segment'**
  String docBitLayoutSummary(Object bits, Object fields);

  /// No description provided for @docTextToEncode.
  ///
  /// In en, this message translates to:
  /// **'Text to encode'**
  String get docTextToEncode;

  /// No description provided for @docSixBitUnencodable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get docSixBitUnencodable;

  /// No description provided for @docSixBitExplanation.
  ///
  /// In en, this message translates to:
  /// **'Each character is one 6-bit value (\"@\" = 0, space = 32, \"A\" = 1…). Lowercase letters are not encodable and are usually sent as uppercase.'**
  String get docSixBitExplanation;

  /// No description provided for @docChecksumBody.
  ///
  /// In en, this message translates to:
  /// **'Body (without leading ! and trailing *XX)'**
  String get docChecksumBody;

  /// No description provided for @docChecksumExplanation.
  ///
  /// In en, this message translates to:
  /// **'The NMEA checksum is the XOR of every byte between the \"!\" and the \"*\".'**
  String get docChecksumExplanation;

  /// No description provided for @docLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get docLatitude;

  /// No description provided for @docLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get docLongitude;

  /// No description provided for @docLatitudeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Latitude: enter a number'**
  String get docLatitudeInvalid;

  /// No description provided for @docLongitudeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Longitude: enter a number'**
  String get docLongitudeInvalid;

  /// No description provided for @docCoordLatitudeValue.
  ///
  /// In en, this message translates to:
  /// **'Latitude → {value} (27-bit signed, deg = {deg} / 600000)'**
  String docCoordLatitudeValue(Object deg, Object value);

  /// No description provided for @docCoordLongitudeValue.
  ///
  /// In en, this message translates to:
  /// **'Longitude → {value} (28-bit signed, deg = {deg} / 600000)'**
  String docCoordLongitudeValue(Object deg, Object value);

  /// No description provided for @docCoordsExplanation.
  ///
  /// In en, this message translates to:
  /// **'Coordinates are stored in 1/10 000 of a minute: divide by 600 000 to recover degrees.'**
  String get docCoordsExplanation;

  /// No description provided for @docSearchShipTypes.
  ///
  /// In en, this message translates to:
  /// **'Search ship types'**
  String get docSearchShipTypes;

  /// No description provided for @docShipCat0_19.
  ///
  /// In en, this message translates to:
  /// **'0-19 · Reserved'**
  String get docShipCat0_19;

  /// No description provided for @docShipCat20_29.
  ///
  /// In en, this message translates to:
  /// **'20-29 · Wing in ground (WIG)'**
  String get docShipCat20_29;

  /// No description provided for @docShipCat30_39.
  ///
  /// In en, this message translates to:
  /// **'30-39 · Fishing'**
  String get docShipCat30_39;

  /// No description provided for @docShipCat40_49.
  ///
  /// In en, this message translates to:
  /// **'40-49 · High-speed craft'**
  String get docShipCat40_49;

  /// No description provided for @docShipCat50_59.
  ///
  /// In en, this message translates to:
  /// **'50-59 · Special craft'**
  String get docShipCat50_59;

  /// No description provided for @docShipCat60_69.
  ///
  /// In en, this message translates to:
  /// **'60-69 · Passenger'**
  String get docShipCat60_69;

  /// No description provided for @docShipCat70_79.
  ///
  /// In en, this message translates to:
  /// **'70-79 · Cargo'**
  String get docShipCat70_79;

  /// No description provided for @docShipCat80_89.
  ///
  /// In en, this message translates to:
  /// **'80-89 · Tanker'**
  String get docShipCat80_89;

  /// No description provided for @docShipCat90_99.
  ///
  /// In en, this message translates to:
  /// **'90-99 · Other'**
  String get docShipCat90_99;

  /// No description provided for @docSearchGlossary.
  ///
  /// In en, this message translates to:
  /// **'Search glossary'**
  String get docSearchGlossary;

  /// No description provided for @docNoMatchingTerms.
  ///
  /// In en, this message translates to:
  /// **'No matching terms.'**
  String get docNoMatchingTerms;

  /// No description provided for @docAspect.
  ///
  /// In en, this message translates to:
  /// **'Aspect'**
  String get docAspect;

  /// No description provided for @docClassA.
  ///
  /// In en, this message translates to:
  /// **'Class A'**
  String get docClassA;

  /// No description provided for @docClassB.
  ///
  /// In en, this message translates to:
  /// **'Class B'**
  String get docClassB;

  /// No description provided for @docCheatRadio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get docCheatRadio;

  /// No description provided for @docCheatFrequencies.
  ///
  /// In en, this message translates to:
  /// **'Frequencies'**
  String get docCheatFrequencies;

  /// No description provided for @docCheatFrequenciesValue.
  ///
  /// In en, this message translates to:
  /// **'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)'**
  String get docCheatFrequenciesValue;

  /// No description provided for @docCheatModulation.
  ///
  /// In en, this message translates to:
  /// **'Modulation'**
  String get docCheatModulation;

  /// No description provided for @docCheatModulationValue.
  ///
  /// In en, this message translates to:
  /// **'GMSK, 9 600 bits/s'**
  String get docCheatModulationValue;

  /// No description provided for @docCheatRange.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get docCheatRange;

  /// No description provided for @docCheatRangeValue.
  ///
  /// In en, this message translates to:
  /// **'~10-20 NM ship-to-ship, line of sight'**
  String get docCheatRangeValue;

  /// No description provided for @docCheatReportingRates.
  ///
  /// In en, this message translates to:
  /// **'Reporting rates'**
  String get docCheatReportingRates;

  /// No description provided for @docCheatClassAPos1.
  ///
  /// In en, this message translates to:
  /// **'Class A position (1)'**
  String get docCheatClassAPos1;

  /// No description provided for @docCheatClassAPos1Value.
  ///
  /// In en, this message translates to:
  /// **'Every 2-10 s underway, 3 min anchored'**
  String get docCheatClassAPos1Value;

  /// No description provided for @docCheatStatic5.
  ///
  /// In en, this message translates to:
  /// **'Static (5)'**
  String get docCheatStatic5;

  /// No description provided for @docCheatStatic5Value.
  ///
  /// In en, this message translates to:
  /// **'Every 6 min'**
  String get docCheatStatic5Value;

  /// No description provided for @docCheatClassBPos18.
  ///
  /// In en, this message translates to:
  /// **'Class B position (18)'**
  String get docCheatClassBPos18;

  /// No description provided for @docCheatClassBPos18Value.
  ///
  /// In en, this message translates to:
  /// **'~Every 30 s'**
  String get docCheatClassBPos18Value;

  /// No description provided for @docCheatAtoN21.
  ///
  /// In en, this message translates to:
  /// **'Aid to navigation (21)'**
  String get docCheatAtoN21;

  /// No description provided for @docCheatAtoN21Value.
  ///
  /// In en, this message translates to:
  /// **'Every 3 min'**
  String get docCheatAtoN21Value;

  /// No description provided for @docCheatNavStatus0_15.
  ///
  /// In en, this message translates to:
  /// **'Navigation status (0-15)'**
  String get docCheatNavStatus0_15;

  /// No description provided for @docCheatNavStatus0.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get docCheatNavStatus0;

  /// No description provided for @docCheatNavStatus0Value.
  ///
  /// In en, this message translates to:
  /// **'Under way using engine'**
  String get docCheatNavStatus0Value;

  /// No description provided for @docCheatNavStatus1.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get docCheatNavStatus1;

  /// No description provided for @docCheatNavStatus1Value.
  ///
  /// In en, this message translates to:
  /// **'At anchor'**
  String get docCheatNavStatus1Value;

  /// No description provided for @docCheatNavStatus3.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get docCheatNavStatus3;

  /// No description provided for @docCheatNavStatus3Value.
  ///
  /// In en, this message translates to:
  /// **'Restricted manoeuvrability'**
  String get docCheatNavStatus3Value;

  /// No description provided for @docCheatNavStatus5.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get docCheatNavStatus5;

  /// No description provided for @docCheatNavStatus5Value.
  ///
  /// In en, this message translates to:
  /// **'Moored'**
  String get docCheatNavStatus5Value;

  /// No description provided for @docCheatNavStatus6.
  ///
  /// In en, this message translates to:
  /// **'6'**
  String get docCheatNavStatus6;

  /// No description provided for @docCheatNavStatus6Value.
  ///
  /// In en, this message translates to:
  /// **'Aground'**
  String get docCheatNavStatus6Value;

  /// No description provided for @docCheatNavStatus7.
  ///
  /// In en, this message translates to:
  /// **'7'**
  String get docCheatNavStatus7;

  /// No description provided for @docCheatNavStatus7Value.
  ///
  /// In en, this message translates to:
  /// **'Fishing'**
  String get docCheatNavStatus7Value;

  /// No description provided for @docCheatNavStatus8.
  ///
  /// In en, this message translates to:
  /// **'8'**
  String get docCheatNavStatus8;

  /// No description provided for @docCheatNavStatus8Value.
  ///
  /// In en, this message translates to:
  /// **'Under way sailing'**
  String get docCheatNavStatus8Value;

  /// No description provided for @docCheatNavStatus14.
  ///
  /// In en, this message translates to:
  /// **'14'**
  String get docCheatNavStatus14;

  /// No description provided for @docCheatNavStatus14Value.
  ///
  /// In en, this message translates to:
  /// **'AIS-SART active'**
  String get docCheatNavStatus14Value;

  /// No description provided for @docCheatMmsiFormats.
  ///
  /// In en, this message translates to:
  /// **'MMSI formats'**
  String get docCheatMmsiFormats;

  /// No description provided for @docCheatFixTypes.
  ///
  /// In en, this message translates to:
  /// **'Fix types (EPFD)'**
  String get docCheatFixTypes;

  /// No description provided for @docCheatEpfd1.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get docCheatEpfd1;

  /// No description provided for @docCheatEpfd1Value.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get docCheatEpfd1Value;

  /// No description provided for @docCheatEpfd2.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get docCheatEpfd2;

  /// No description provided for @docCheatEpfd2Value.
  ///
  /// In en, this message translates to:
  /// **'GLONASS'**
  String get docCheatEpfd2Value;

  /// No description provided for @docCheatEpfd3.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get docCheatEpfd3;

  /// No description provided for @docCheatEpfd3Value.
  ///
  /// In en, this message translates to:
  /// **'GPS + GLONASS'**
  String get docCheatEpfd3Value;

  /// No description provided for @docCheatEpfd8.
  ///
  /// In en, this message translates to:
  /// **'8'**
  String get docCheatEpfd8;

  /// No description provided for @docCheatEpfd8Value.
  ///
  /// In en, this message translates to:
  /// **'Galileo'**
  String get docCheatEpfd8Value;

  /// No description provided for @docCheatEpfd15.
  ///
  /// In en, this message translates to:
  /// **'15'**
  String get docCheatEpfd15;

  /// No description provided for @docCheatEpfd15Value.
  ///
  /// In en, this message translates to:
  /// **'Internal GNSS'**
  String get docCheatEpfd15Value;

  /// No description provided for @docCheatFooter.
  ///
  /// In en, this message translates to:
  /// **'KikAis ships a full interactive reference on every tab — the Editor can build any message, the Decoder reads them back.'**
  String get docCheatFooter;

  /// No description provided for @docMmsiFmtDiversRadio.
  ///
  /// In en, this message translates to:
  /// **'Diver\'s radio'**
  String get docMmsiFmtDiversRadio;

  /// No description provided for @docMmsiFmtShip.
  ///
  /// In en, this message translates to:
  /// **'Ship'**
  String get docMmsiFmtShip;

  /// No description provided for @docMmsiFmtGroupShips.
  ///
  /// In en, this message translates to:
  /// **'Group of ships (e.g. a fleet or the USCG)'**
  String get docMmsiFmtGroupShips;

  /// No description provided for @docMmsiFmtCoastalShore.
  ///
  /// In en, this message translates to:
  /// **'Coastal / shore station'**
  String get docMmsiFmtCoastalShore;

  /// No description provided for @docMmsiFmtSarAircraft.
  ///
  /// In en, this message translates to:
  /// **'SAR aircraft'**
  String get docMmsiFmtSarAircraft;

  /// No description provided for @docMmsiFmtAuxCraft.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary craft associated with a parent ship'**
  String get docMmsiFmtAuxCraft;

  /// No description provided for @docMmsiFmtAtoN.
  ///
  /// In en, this message translates to:
  /// **'Aid to navigation'**
  String get docMmsiFmtAtoN;

  /// No description provided for @docMmsiFmtSart.
  ///
  /// In en, this message translates to:
  /// **'AIS-SART (search & rescue transmitter)'**
  String get docMmsiFmtSart;

  /// No description provided for @docMmsiFmtMob.
  ///
  /// In en, this message translates to:
  /// **'MOB (man overboard) device'**
  String get docMmsiFmtMob;

  /// No description provided for @docMmsiFmtEpirb.
  ///
  /// In en, this message translates to:
  /// **'AIS EPIRB (emergency beacon)'**
  String get docMmsiFmtEpirb;

  /// No description provided for @docVesselCat0_9.
  ///
  /// In en, this message translates to:
  /// **'Reserved / future use'**
  String get docVesselCat0_9;

  /// No description provided for @docVesselCat10_19.
  ///
  /// In en, this message translates to:
  /// **'Reserved for future use'**
  String get docVesselCat10_19;

  /// No description provided for @docVesselCat20_29.
  ///
  /// In en, this message translates to:
  /// **'Wing in ground (WIG) craft'**
  String get docVesselCat20_29;

  /// No description provided for @docVesselCat30_39.
  ///
  /// In en, this message translates to:
  /// **'Fishing'**
  String get docVesselCat30_39;

  /// No description provided for @docVesselCat40_49.
  ///
  /// In en, this message translates to:
  /// **'High-speed craft'**
  String get docVesselCat40_49;

  /// No description provided for @docVesselCat50_59.
  ///
  /// In en, this message translates to:
  /// **'Special craft (pilot, tugs, dredgers…)'**
  String get docVesselCat50_59;

  /// No description provided for @docVesselCat60_69.
  ///
  /// In en, this message translates to:
  /// **'Passenger ships'**
  String get docVesselCat60_69;

  /// No description provided for @docVesselCat70_79.
  ///
  /// In en, this message translates to:
  /// **'Cargo ships'**
  String get docVesselCat70_79;

  /// No description provided for @docVesselCat80_89.
  ///
  /// In en, this message translates to:
  /// **'Tankers'**
  String get docVesselCat80_89;

  /// No description provided for @docVesselCat90_99.
  ///
  /// In en, this message translates to:
  /// **'Other types'**
  String get docVesselCat90_99;

  /// No description provided for @docTalkerAB.
  ///
  /// In en, this message translates to:
  /// **'Base AIS station'**
  String get docTalkerAB;

  /// No description provided for @docTalkerAD.
  ///
  /// In en, this message translates to:
  /// **'Dependent AIS base station'**
  String get docTalkerAD;

  /// No description provided for @docTalkerAI.
  ///
  /// In en, this message translates to:
  /// **'Mobile AIS station'**
  String get docTalkerAI;

  /// No description provided for @docTalkerAN.
  ///
  /// In en, this message translates to:
  /// **'Aid-to-navigation AIS station'**
  String get docTalkerAN;

  /// No description provided for @docTalkerAR.
  ///
  /// In en, this message translates to:
  /// **'AIS receiving station'**
  String get docTalkerAR;

  /// No description provided for @docTalkerAS.
  ///
  /// In en, this message translates to:
  /// **'Limited base station'**
  String get docTalkerAS;

  /// No description provided for @docTalkerAT.
  ///
  /// In en, this message translates to:
  /// **'AIS transmitting station'**
  String get docTalkerAT;

  /// No description provided for @docTalkerAX.
  ///
  /// In en, this message translates to:
  /// **'AIS repeater station'**
  String get docTalkerAX;

  /// No description provided for @docTalkerBS.
  ///
  /// In en, this message translates to:
  /// **'Base AIS station (deprecated)'**
  String get docTalkerBS;

  /// No description provided for @docTalkerSA.
  ///
  /// In en, this message translates to:
  /// **'Physical shore AIS station'**
  String get docTalkerSA;

  /// No description provided for @docType1Name.
  ///
  /// In en, this message translates to:
  /// **'Position Report Class A'**
  String get docType1Name;

  /// No description provided for @docType1Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType1Family;

  /// No description provided for @docType1Summary.
  ///
  /// In en, this message translates to:
  /// **'The workhorse of the system: a Class A transponder broadcasting its position, course, speed, heading and navigation status.'**
  String get docType1Summary;

  /// No description provided for @docType1EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Class A transponders (SOLAS vessels)'**
  String get docType1EmittedBy;

  /// No description provided for @docType1Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 2-10 s while underway, every 3 min at anchor'**
  String get docType1Cadence;

  /// No description provided for @docType2Name.
  ///
  /// In en, this message translates to:
  /// **'Position Report Class A (assigned)'**
  String get docType2Name;

  /// No description provided for @docType2Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType2Family;

  /// No description provided for @docType2Summary.
  ///
  /// In en, this message translates to:
  /// **'Identical to type 1, but sent on a slot schedule assigned to the vessel by a base station (assignment mode).'**
  String get docType2Summary;

  /// No description provided for @docType2EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Class A transponders under assignment'**
  String get docType2EmittedBy;

  /// No description provided for @docType2Cadence.
  ///
  /// In en, this message translates to:
  /// **'Assigned schedule'**
  String get docType2Cadence;

  /// No description provided for @docType3Name.
  ///
  /// In en, this message translates to:
  /// **'Position Report Class A (response)'**
  String get docType3Name;

  /// No description provided for @docType3Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType3Family;

  /// No description provided for @docType3Summary.
  ///
  /// In en, this message translates to:
  /// **'Identical to type 1, sent as the response to an interrogation (type 15).'**
  String get docType3Summary;

  /// No description provided for @docType3EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Class A transponders answering an interrogation'**
  String get docType3EmittedBy;

  /// No description provided for @docType3Cadence.
  ///
  /// In en, this message translates to:
  /// **'On interrogation'**
  String get docType3Cadence;

  /// No description provided for @docType4Name.
  ///
  /// In en, this message translates to:
  /// **'Base Station Report'**
  String get docType4Name;

  /// No description provided for @docType4Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType4Family;

  /// No description provided for @docType4Summary.
  ///
  /// In en, this message translates to:
  /// **'The periodic report of a fixed shore station: its position plus the UTC date and time reference.'**
  String get docType4Summary;

  /// No description provided for @docType4EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Fixed base stations'**
  String get docType4EmittedBy;

  /// No description provided for @docType4Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 10 s'**
  String get docType4Cadence;

  /// No description provided for @docType5Name.
  ///
  /// In en, this message translates to:
  /// **'Static and Voyage Related Data'**
  String get docType5Name;

  /// No description provided for @docType5Family.
  ///
  /// In en, this message translates to:
  /// **'Static & voyage data'**
  String get docType5Family;

  /// No description provided for @docType5Summary.
  ///
  /// In en, this message translates to:
  /// **'The \"identity card\" of a ship: name, call sign, IMO number, ship type, dimensions, draught, ETA and destination.'**
  String get docType5Summary;

  /// No description provided for @docType5EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Class A transponders'**
  String get docType5EmittedBy;

  /// No description provided for @docType5Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 6 min and on change of data'**
  String get docType5Cadence;

  /// No description provided for @docType6Name.
  ///
  /// In en, this message translates to:
  /// **'Binary Addressed Message'**
  String get docType6Name;

  /// No description provided for @docType6Family.
  ///
  /// In en, this message translates to:
  /// **'Binary data'**
  String get docType6Family;

  /// No description provided for @docType6Summary.
  ///
  /// In en, this message translates to:
  /// **'A structured binary payload sent to one specific destination MMSI (e.g. a requested meteo report).'**
  String get docType6Summary;

  /// No description provided for @docType6EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get docType6EmittedBy;

  /// No description provided for @docType6Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType6Cadence;

  /// No description provided for @docType7Name.
  ///
  /// In en, this message translates to:
  /// **'Binary Acknowledge'**
  String get docType7Name;

  /// No description provided for @docType7Family.
  ///
  /// In en, this message translates to:
  /// **'Binary data'**
  String get docType7Family;

  /// No description provided for @docType7Summary.
  ///
  /// In en, this message translates to:
  /// **'The acknowledgement sent in reply to a type 6 binary addressed message.'**
  String get docType7Summary;

  /// No description provided for @docType7EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station that received a type 6'**
  String get docType7EmittedBy;

  /// No description provided for @docType7Cadence.
  ///
  /// In en, this message translates to:
  /// **'On reply'**
  String get docType7Cadence;

  /// No description provided for @docType8Name.
  ///
  /// In en, this message translates to:
  /// **'Binary Broadcast Message'**
  String get docType8Name;

  /// No description provided for @docType8Family.
  ///
  /// In en, this message translates to:
  /// **'Binary data'**
  String get docType8Family;

  /// No description provided for @docType8Summary.
  ///
  /// In en, this message translates to:
  /// **'A structured binary payload broadcast to all — weather and hydrographic reports, regional data, or private/encrypted messages.'**
  String get docType8Summary;

  /// No description provided for @docType8EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get docType8EmittedBy;

  /// No description provided for @docType8Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType8Cadence;

  /// No description provided for @docType9Name.
  ///
  /// In en, this message translates to:
  /// **'Standard SAR Aircraft Position Report'**
  String get docType9Name;

  /// No description provided for @docType9Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType9Family;

  /// No description provided for @docType9Summary.
  ///
  /// In en, this message translates to:
  /// **'A position report used by search-and-rescue aircraft to be visible to ships. Carries altitude and a special MMSI range (111MIDXXX).'**
  String get docType9Summary;

  /// No description provided for @docType9EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'SAR aircraft'**
  String get docType9EmittedBy;

  /// No description provided for @docType9Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 10 s while on station'**
  String get docType9Cadence;

  /// No description provided for @docType10Name.
  ///
  /// In en, this message translates to:
  /// **'UTC and Date Inquiry'**
  String get docType10Name;

  /// No description provided for @docType10Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType10Family;

  /// No description provided for @docType10Summary.
  ///
  /// In en, this message translates to:
  /// **'A small request asking a specific station for its UTC date and time.'**
  String get docType10Summary;

  /// No description provided for @docType10EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get docType10EmittedBy;

  /// No description provided for @docType10Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType10Cadence;

  /// No description provided for @docType11Name.
  ///
  /// In en, this message translates to:
  /// **'UTC and Date Response'**
  String get docType11Name;

  /// No description provided for @docType11Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType11Family;

  /// No description provided for @docType11Summary.
  ///
  /// In en, this message translates to:
  /// **'Identical in structure to type 4, sent as the answer to a type 10 UTC/date inquiry.'**
  String get docType11Summary;

  /// No description provided for @docType11EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get docType11EmittedBy;

  /// No description provided for @docType11Cadence.
  ///
  /// In en, this message translates to:
  /// **'On inquiry'**
  String get docType11Cadence;

  /// No description provided for @docType12Name.
  ///
  /// In en, this message translates to:
  /// **'Addressed Safety-Related Message'**
  String get docType12Name;

  /// No description provided for @docType12Family.
  ///
  /// In en, this message translates to:
  /// **'Safety & text'**
  String get docType12Family;

  /// No description provided for @docType12Summary.
  ///
  /// In en, this message translates to:
  /// **'A free-text safety message sent to a single destination MMSI (e.g. a distress message to the nearest base station).'**
  String get docType12Summary;

  /// No description provided for @docType12EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get docType12EmittedBy;

  /// No description provided for @docType12Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType12Cadence;

  /// No description provided for @docType13Name.
  ///
  /// In en, this message translates to:
  /// **'Safety-Related Acknowledgement'**
  String get docType13Name;

  /// No description provided for @docType13Family.
  ///
  /// In en, this message translates to:
  /// **'Safety & text'**
  String get docType13Family;

  /// No description provided for @docType13Summary.
  ///
  /// In en, this message translates to:
  /// **'The acknowledgement sent in reply to a type 12 addressed safety message.'**
  String get docType13Summary;

  /// No description provided for @docType13EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station that received a type 12'**
  String get docType13EmittedBy;

  /// No description provided for @docType13Cadence.
  ///
  /// In en, this message translates to:
  /// **'On reply'**
  String get docType13Cadence;

  /// No description provided for @docType14Name.
  ///
  /// In en, this message translates to:
  /// **'Safety-Related Broadcast Message'**
  String get docType14Name;

  /// No description provided for @docType14Family.
  ///
  /// In en, this message translates to:
  /// **'Safety & text'**
  String get docType14Family;

  /// No description provided for @docType14Summary.
  ///
  /// In en, this message translates to:
  /// **'A free-text broadcast addressed to everyone in range — navigational warnings, distress or traffic announcements.'**
  String get docType14Summary;

  /// No description provided for @docType14EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station (often base stations / VTS)'**
  String get docType14EmittedBy;

  /// No description provided for @docType14Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType14Cadence;

  /// No description provided for @docType15Name.
  ///
  /// In en, this message translates to:
  /// **'Interrogation'**
  String get docType15Name;

  /// No description provided for @docType15Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType15Family;

  /// No description provided for @docType15Summary.
  ///
  /// In en, this message translates to:
  /// **'A request asking one or two specific stations to send a particular message type (usually type 3 or 5).'**
  String get docType15Summary;

  /// No description provided for @docType15EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get docType15EmittedBy;

  /// No description provided for @docType15Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType15Cadence;

  /// No description provided for @docType16Name.
  ///
  /// In en, this message translates to:
  /// **'Assignment Mode Command'**
  String get docType16Name;

  /// No description provided for @docType16Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType16Family;

  /// No description provided for @docType16Summary.
  ///
  /// In en, this message translates to:
  /// **'Instructs up to two vessels to transmit on a specific slot allocation (assignment mode).'**
  String get docType16Summary;

  /// No description provided for @docType16EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get docType16EmittedBy;

  /// No description provided for @docType16Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType16Cadence;

  /// No description provided for @docType17Name.
  ///
  /// In en, this message translates to:
  /// **'DGNSS Binary Broadcast Message'**
  String get docType17Name;

  /// No description provided for @docType17Family.
  ///
  /// In en, this message translates to:
  /// **'Binary data'**
  String get docType17Family;

  /// No description provided for @docType17Summary.
  ///
  /// In en, this message translates to:
  /// **'Differential GNSS correction data broadcast by shore stations to improve positioning accuracy in the covered area.'**
  String get docType17Summary;

  /// No description provided for @docType17EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'DGNSS reference stations'**
  String get docType17EmittedBy;

  /// No description provided for @docType17Cadence.
  ///
  /// In en, this message translates to:
  /// **'Periodic'**
  String get docType17Cadence;

  /// No description provided for @docType18Name.
  ///
  /// In en, this message translates to:
  /// **'Standard Class B CS Position Report'**
  String get docType18Name;

  /// No description provided for @docType18Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType18Family;

  /// No description provided for @docType18Summary.
  ///
  /// In en, this message translates to:
  /// **'The standard Class B position report. Lighter than Class A: no navigation status or rate of turn, but works with CSTDMA.'**
  String get docType18Summary;

  /// No description provided for @docType18EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Class B transponders'**
  String get docType18EmittedBy;

  /// No description provided for @docType18Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 30 s (or less in some regions)'**
  String get docType18Cadence;

  /// No description provided for @docType19Name.
  ///
  /// In en, this message translates to:
  /// **'Extended Class B Equipment Position Report'**
  String get docType19Name;

  /// No description provided for @docType19Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType19Family;

  /// No description provided for @docType19Summary.
  ///
  /// In en, this message translates to:
  /// **'A larger Class B position report that also carries the vessel name, ship type and dimensions — a one-shot static+position hybrid.'**
  String get docType19Summary;

  /// No description provided for @docType19EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Extended Class B transponders'**
  String get docType19EmittedBy;

  /// No description provided for @docType19Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 30 s'**
  String get docType19Cadence;

  /// No description provided for @docType20Name.
  ///
  /// In en, this message translates to:
  /// **'Data Link Management'**
  String get docType20Name;

  /// No description provided for @docType20Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType20Family;

  /// No description provided for @docType20Summary.
  ///
  /// In en, this message translates to:
  /// **'A network housekeeping message used to allocate and reserve TDMA time slots in an area.'**
  String get docType20Summary;

  /// No description provided for @docType20EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get docType20EmittedBy;

  /// No description provided for @docType20Cadence.
  ///
  /// In en, this message translates to:
  /// **'Network management'**
  String get docType20Cadence;

  /// No description provided for @docType21Name.
  ///
  /// In en, this message translates to:
  /// **'Aid-to-Navigation Report'**
  String get docType21Name;

  /// No description provided for @docType21Family.
  ///
  /// In en, this message translates to:
  /// **'Aid to navigation'**
  String get docType21Family;

  /// No description provided for @docType21Summary.
  ///
  /// In en, this message translates to:
  /// **'Broadcasts the position, name and status of an aid to navigation — buoys, beacons, lighthouses, or virtual aids. Often sent from a virtual position.'**
  String get docType21Summary;

  /// No description provided for @docType21EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'AtoN stations (real or virtual)'**
  String get docType21EmittedBy;

  /// No description provided for @docType21Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 3 min (or on event)'**
  String get docType21Cadence;

  /// No description provided for @docType22Name.
  ///
  /// In en, this message translates to:
  /// **'Channel Management'**
  String get docType22Name;

  /// No description provided for @docType22Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType22Family;

  /// No description provided for @docType22Summary.
  ///
  /// In en, this message translates to:
  /// **'Used by a base station to switch stations to different VHF channels within a geographic zone.'**
  String get docType22Summary;

  /// No description provided for @docType22EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get docType22EmittedBy;

  /// No description provided for @docType22Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType22Cadence;

  /// No description provided for @docType23Name.
  ///
  /// In en, this message translates to:
  /// **'Group Assignment Command'**
  String get docType23Name;

  /// No description provided for @docType23Family.
  ///
  /// In en, this message translates to:
  /// **'Base station & network'**
  String get docType23Family;

  /// No description provided for @docType23Summary.
  ///
  /// In en, this message translates to:
  /// **'A command sent by a base station to a group of vessels within a zone, setting reporting intervals and transmission mode.'**
  String get docType23Summary;

  /// No description provided for @docType23EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Base stations'**
  String get docType23EmittedBy;

  /// No description provided for @docType23Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType23Cadence;

  /// No description provided for @docType24Name.
  ///
  /// In en, this message translates to:
  /// **'Static Data Report'**
  String get docType24Name;

  /// No description provided for @docType24Family.
  ///
  /// In en, this message translates to:
  /// **'Static & voyage data'**
  String get docType24Family;

  /// No description provided for @docType24Summary.
  ///
  /// In en, this message translates to:
  /// **'The Class B equivalent of type 5, split into Part A (name) and Part B (ship type, call sign, dimensions).'**
  String get docType24Summary;

  /// No description provided for @docType24EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Class B transponders'**
  String get docType24EmittedBy;

  /// No description provided for @docType24Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 6 min'**
  String get docType24Cadence;

  /// No description provided for @docType25Name.
  ///
  /// In en, this message translates to:
  /// **'Single Slot Binary Message'**
  String get docType25Name;

  /// No description provided for @docType25Family.
  ///
  /// In en, this message translates to:
  /// **'Binary data'**
  String get docType25Family;

  /// No description provided for @docType25Summary.
  ///
  /// In en, this message translates to:
  /// **'A short binary message fitting in a single TDMA slot, with an optional destination and application ID.'**
  String get docType25Summary;

  /// No description provided for @docType25EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get docType25EmittedBy;

  /// No description provided for @docType25Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType25Cadence;

  /// No description provided for @docType26Name.
  ///
  /// In en, this message translates to:
  /// **'Multiple Slot Binary Message'**
  String get docType26Name;

  /// No description provided for @docType26Family.
  ///
  /// In en, this message translates to:
  /// **'Binary data'**
  String get docType26Family;

  /// No description provided for @docType26Summary.
  ///
  /// In en, this message translates to:
  /// **'A longer binary message spread over several TDMA slots, carrying radio-status information.'**
  String get docType26Summary;

  /// No description provided for @docType26EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get docType26EmittedBy;

  /// No description provided for @docType26Cadence.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get docType26Cadence;

  /// No description provided for @docType27Name.
  ///
  /// In en, this message translates to:
  /// **'Position Report for Long-Range Applications'**
  String get docType27Name;

  /// No description provided for @docType27Family.
  ///
  /// In en, this message translates to:
  /// **'Position reports'**
  String get docType27Family;

  /// No description provided for @docType27Summary.
  ///
  /// In en, this message translates to:
  /// **'A very compact position report designed for reception by satellite over long ranges, with reduced resolution.'**
  String get docType27Summary;

  /// No description provided for @docType27EmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Vessels in long-range (satellite) mode'**
  String get docType27EmittedBy;

  /// No description provided for @docType27Cadence.
  ///
  /// In en, this message translates to:
  /// **'Every 3 min (long-range mode)'**
  String get docType27Cadence;

  /// No description provided for @docTimeline1990sTitle.
  ///
  /// In en, this message translates to:
  /// **'A Swedish invention'**
  String get docTimeline1990sTitle;

  /// No description provided for @docTimeline1990sText.
  ///
  /// In en, this message translates to:
  /// **'The concept is born in Sweden: a VHF system where every ship announces itself so that others \"see and be seen\", even in fog and behind islands. It is presented to the IMO and becomes the seed of AIS.'**
  String get docTimeline1990sText;

  /// No description provided for @docTimeline1998Title.
  ///
  /// In en, this message translates to:
  /// **'Standardisation begins'**
  String get docTimeline1998Title;

  /// No description provided for @docTimeline1998Text.
  ///
  /// In en, this message translates to:
  /// **'The ITU and IEC start turning the concept into a radio standard with precise bit-level formats, based on TDMA over two VHF channels.'**
  String get docTimeline1998Text;

  /// No description provided for @docTimeline2001Title.
  ///
  /// In en, this message translates to:
  /// **'ITU-R M.1371 published'**
  String get docTimeline2001Title;

  /// No description provided for @docTimeline2001Text.
  ///
  /// In en, this message translates to:
  /// **'Recommendation ITU-R M.1371 \"Technical characteristics for a universal shipborne automatic identification system\" defines the 27 message types and their bit layout.'**
  String get docTimeline2001Text;

  /// No description provided for @docTimeline2002Title.
  ///
  /// In en, this message translates to:
  /// **'SOLAS mandate'**
  String get docTimeline2002Title;

  /// No description provided for @docTimeline2002Text.
  ///
  /// In en, this message translates to:
  /// **'The IMO makes AIS mandatory for all international vessels over 300 gross tons and all passenger ships — roughly 100,000 vessels. AIS becomes a standard anti-collision aid alongside radar.'**
  String get docTimeline2002Text;

  /// No description provided for @docTimeline2006Title.
  ///
  /// In en, this message translates to:
  /// **'Class B arrives'**
  String get docTimeline2006Title;

  /// No description provided for @docTimeline2006Text.
  ///
  /// In en, this message translates to:
  /// **'The Class B standard is published, opening the door to cheap, simpler transponders. The same year, the TacSat-2 satellite becomes the first to capture AIS signals from space (S-AIS).'**
  String get docTimeline2006Text;

  /// No description provided for @docTimeline2008_2015Title.
  ///
  /// In en, this message translates to:
  /// **'Satellite constellations'**
  String get docTimeline2008_2015Title;

  /// No description provided for @docTimeline2008_2015Text.
  ///
  /// In en, this message translates to:
  /// **'exactEarth, ORBCOMM, Spire and others deploy AIS receivers in low-Earth orbit, extending coverage far beyond the VHF horizon and enabling near-global vessel tracking.'**
  String get docTimeline2008_2015Text;

  /// No description provided for @docTimeline2010Title.
  ///
  /// In en, this message translates to:
  /// **'AIS-SART in GMDSS'**
  String get docTimeline2010Title;

  /// No description provided for @docTimeline2010Text.
  ///
  /// In en, this message translates to:
  /// **'The AIS search-and-rescue transmitter (AIS-SART, IEC 61097-14) joins the Global Maritime Distress and Safety System, letting lifeboats broadcast distress positions over AIS.'**
  String get docTimeline2010Text;

  /// No description provided for @docTimeline2014Title.
  ///
  /// In en, this message translates to:
  /// **'Fisheries & inland fleets'**
  String get docTimeline2014Title;

  /// No description provided for @docTimeline2014Text.
  ///
  /// In en, this message translates to:
  /// **'European rules require Class A AIS on all EU fishing vessels over 15 m; inland-waterways AIS is widely deployed on European rivers.'**
  String get docTimeline2014Text;

  /// No description provided for @docTimeline2021Title.
  ///
  /// In en, this message translates to:
  /// **'1.6 million ships'**
  String get docTimeline2021Title;

  /// No description provided for @docTimeline2021Text.
  ///
  /// In en, this message translates to:
  /// **'More than 1.6 million vessels are fitted with AIS, feeding terrestrial and satellite networks that power ship tracking, fisheries control and maritime security worldwide.'**
  String get docTimeline2021Text;

  /// No description provided for @docTimelineVdesTitle.
  ///
  /// In en, this message translates to:
  /// **'VDES — the successor'**
  String get docTimelineVdesTitle;

  /// No description provided for @docTimelineVdesText.
  ///
  /// In en, this message translates to:
  /// **'The VHF Data Exchange System (ITU-R M.2092) is being rolled out to relieve congested areas, adding far more bandwidth and secure e-navigation services.'**
  String get docTimelineVdesText;

  /// No description provided for @docAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get docAppTitle;

  /// No description provided for @docSearchChapters.
  ///
  /// In en, this message translates to:
  /// **'Search chapters'**
  String get docSearchChapters;

  /// No description provided for @docChapterOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get docChapterOverview;

  /// No description provided for @docChapterHistory.
  ///
  /// In en, this message translates to:
  /// **'History & regulation'**
  String get docChapterHistory;

  /// No description provided for @docChapterHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get docChapterHowItWorks;

  /// No description provided for @docChapterRadio.
  ///
  /// In en, this message translates to:
  /// **'Radio & TDMA'**
  String get docChapterRadio;

  /// No description provided for @docChapterClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes & equipment'**
  String get docChapterClasses;

  /// No description provided for @docChapterMmsi.
  ///
  /// In en, this message translates to:
  /// **'MMSI & identity'**
  String get docChapterMmsi;

  /// No description provided for @docChapterShipTypes.
  ///
  /// In en, this message translates to:
  /// **'Ship types'**
  String get docChapterShipTypes;

  /// No description provided for @docChapterMessages.
  ///
  /// In en, this message translates to:
  /// **'The 27 messages'**
  String get docChapterMessages;

  /// No description provided for @docChapterNmea.
  ///
  /// In en, this message translates to:
  /// **'NMEA & AIVDM'**
  String get docChapterNmea;

  /// No description provided for @docChapterPayload.
  ///
  /// In en, this message translates to:
  /// **'Inside the payload'**
  String get docChapterPayload;

  /// No description provided for @docChapterSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & limits'**
  String get docChapterSecurity;

  /// No description provided for @docChapterFieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Field notes'**
  String get docChapterFieldNotes;

  /// No description provided for @docChapterKikais.
  ///
  /// In en, this message translates to:
  /// **'AIS in KikAis'**
  String get docChapterKikais;

  /// No description provided for @docChapterGlossary.
  ///
  /// In en, this message translates to:
  /// **'Glossary'**
  String get docChapterGlossary;

  /// No description provided for @docChapterCheatSheet.
  ///
  /// In en, this message translates to:
  /// **'Cheat sheet'**
  String get docChapterCheatSheet;

  /// No description provided for @docChapterSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get docChapterSources;

  /// No description provided for @docOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'What is AIS?'**
  String get docOverviewTitle;

  /// No description provided for @docOverviewIntro.
  ///
  /// In en, this message translates to:
  /// **'The Automatic Identification System (AIS) is a tracking system used on ships and by vessel traffic services (VTS). Every equipped vessel continuously broadcasts its identity, position, course and speed over VHF radio, so that every other ship and shore station in range can \"see\" it — the concept of \"see and be seen\".'**
  String get docOverviewIntro;

  /// No description provided for @docOverviewRadar.
  ///
  /// In en, this message translates to:
  /// **'AIS does not replace marine radar. Radar independently detects any object, but tells you little about who it is. AIS tells you exactly who, where and where they are going — but it trusts what the sender declares. The two systems complement each other.'**
  String get docOverviewRadar;

  /// No description provided for @docOverviewAdsBTitle.
  ///
  /// In en, this message translates to:
  /// **'Think of it as the maritime ADS-B'**
  String get docOverviewAdsBTitle;

  /// No description provided for @docOverviewAdsBText.
  ///
  /// In en, this message translates to:
  /// **'Just as ADS-B lets aircraft announce themselves to air traffic control, AIS lets ships announce themselves to each other and to shore. Ships view surrounding traffic on a chartplotter or on a radar-like display; port authorities monitor movements and fisheries.'**
  String get docOverviewAdsBText;

  /// No description provided for @docOverviewTransponder.
  ///
  /// In en, this message translates to:
  /// **'What a transponder broadcasts'**
  String get docOverviewTransponder;

  /// No description provided for @docOverviewBullet1.
  ///
  /// In en, this message translates to:
  /// **'Unique identity: a 9-digit MMSI number (whose first three digits identify the issuing country).'**
  String get docOverviewBullet1;

  /// No description provided for @docOverviewBullet2.
  ///
  /// In en, this message translates to:
  /// **'Dynamic data: position, speed over ground (SOG), course over ground (COG), true heading, rate of turn, navigation status.'**
  String get docOverviewBullet2;

  /// No description provided for @docOverviewBullet3.
  ///
  /// In en, this message translates to:
  /// **'Static & voyage data: name, call sign, IMO number, ship type, dimensions, draught, destination, ETA.'**
  String get docOverviewBullet3;

  /// No description provided for @docOverviewBullet4.
  ///
  /// In en, this message translates to:
  /// **'Safety and binary messages: distress texts, weather reports, network commands.'**
  String get docOverviewBullet4;

  /// No description provided for @docOverviewWho.
  ///
  /// In en, this message translates to:
  /// **'Who must carry it'**
  String get docOverviewWho;

  /// No description provided for @docOverviewImo.
  ///
  /// In en, this message translates to:
  /// **'The IMO (SOLAS convention) mandates AIS on international vessels over 300 gross tons and on all passenger ships. Regional rules extend this to fishing fleets, inland waterways and increasingly to recreational craft via low-cost Class B transponders.'**
  String get docOverviewImo;

  /// No description provided for @docOverviewLimits.
  ///
  /// In en, this message translates to:
  /// **'Limits at a glance'**
  String get docOverviewLimits;

  /// No description provided for @docOverviewLimit1.
  ///
  /// In en, this message translates to:
  /// **'Range is roughly line of sight: about 10-20 nautical miles for ship-to-ship, more from coast stations and satellites.'**
  String get docOverviewLimit1;

  /// No description provided for @docOverviewLimit2.
  ///
  /// In en, this message translates to:
  /// **'AIS has no authentication: anyone can broadcast any identity (spoofing) or jam the channel.'**
  String get docOverviewLimit2;

  /// No description provided for @docOverviewLimit3.
  ///
  /// In en, this message translates to:
  /// **'Accuracy depends on the sender\'s GNSS fix and on the honesty of the data it declares.'**
  String get docOverviewLimit3;

  /// No description provided for @docHistoryIntro.
  ///
  /// In en, this message translates to:
  /// **'AIS grew from a Swedish idea into a worldwide mandatory safety system. Tap any milestone on the timeline for details.'**
  String get docHistoryIntro;

  /// No description provided for @docHistoryStandards.
  ///
  /// In en, this message translates to:
  /// **'The governing standards'**
  String get docHistoryStandards;

  /// No description provided for @docHistoryStd1.
  ///
  /// In en, this message translates to:
  /// **'ITU-R M.1371 — Technical characteristics for a universal shipborne AIS (defines the 27 message types and their bit layout).'**
  String get docHistoryStd1;

  /// No description provided for @docHistoryStd2.
  ///
  /// In en, this message translates to:
  /// **'IALA guidelines — clarifications and implementation guidance.'**
  String get docHistoryStd2;

  /// No description provided for @docHistoryStd3.
  ///
  /// In en, this message translates to:
  /// **'IEC 61162 / 62287 — the NMEA sentence framing and Class B/CSTDMA requirements.'**
  String get docHistoryStd3;

  /// No description provided for @docHistoryStd4.
  ///
  /// In en, this message translates to:
  /// **'IEC 61097-14 — the AIS-SART distress transmitter.'**
  String get docHistoryStd4;

  /// No description provided for @docHowIntro.
  ///
  /// In en, this message translates to:
  /// **'AIS is a VHF radio system. Each transponder listens to the traffic around it and transmits its own reports in reserved time slots, avoiding collisions with the other ships in range.'**
  String get docHowIntro;

  /// No description provided for @docHowRadioLink.
  ///
  /// In en, this message translates to:
  /// **'The radio link'**
  String get docHowRadioLink;

  /// No description provided for @docHowRadioLink1.
  ///
  /// In en, this message translates to:
  /// **'Two dedicated VHF channels: AIS 1 at 161.975 MHz (87B) and AIS 2 at 162.025 MHz (88B).'**
  String get docHowRadioLink1;

  /// No description provided for @docHowRadioLink2.
  ///
  /// In en, this message translates to:
  /// **'Digital narrow-band FM, at 9 600 bits per second.'**
  String get docHowRadioLink2;

  /// No description provided for @docHowRadioLink3.
  ///
  /// In en, this message translates to:
  /// **'Messages are organised into TDMA frames of 2250 time slots (1 minute).'**
  String get docHowRadioLink3;

  /// No description provided for @docHowSlots.
  ///
  /// In en, this message translates to:
  /// **'How slots are shared'**
  String get docHowSlots;

  /// No description provided for @docHowSotdma.
  ///
  /// In en, this message translates to:
  /// **'Class A transponders use SOTDMA (Self-Organizing Time Division Multiple Access): each unit reserves a repeating slot and re-reserves when the picture changes, so ships continuously coordinate without a central controller.'**
  String get docHowSotdma;

  /// No description provided for @docHowCstdma.
  ///
  /// In en, this message translates to:
  /// **'Class B transponders use the simpler CSTDMA (Carrier Sense TDMA): they listen for a free slot and grab it, which is why Class B reports are less frequent and can be lost in very dense traffic.'**
  String get docHowCstdma;

  /// No description provided for @docHowRates.
  ///
  /// In en, this message translates to:
  /// **'Reporting rates'**
  String get docHowRates;

  /// No description provided for @docHowRates1.
  ///
  /// In en, this message translates to:
  /// **'Class A position report (type 1): every 2-10 seconds while underway, every 3 minutes at anchor.'**
  String get docHowRates1;

  /// No description provided for @docHowRates2.
  ///
  /// In en, this message translates to:
  /// **'Static & voyage data (type 5): every 6 minutes.'**
  String get docHowRates2;

  /// No description provided for @docHowRates3.
  ///
  /// In en, this message translates to:
  /// **'Class B position (type 18): roughly every 30 seconds.'**
  String get docHowRates3;

  /// No description provided for @docHowRates4.
  ///
  /// In en, this message translates to:
  /// **'Aid to navigation (type 21): every 3 minutes.'**
  String get docHowRates4;

  /// No description provided for @docHowTerrestrial.
  ///
  /// In en, this message translates to:
  /// **'Terrestrial and satellite'**
  String get docHowTerrestrial;

  /// No description provided for @docHowTerrestrialText.
  ///
  /// In en, this message translates to:
  /// **'On the surface, AIS range is limited by the VHF horizon (T-AIS). Since the mid-2000s, satellites in low-Earth orbit (S-AIS) receive the same signals, giving near-global coverage — satellites augment rather than replace the terrestrial network.'**
  String get docHowTerrestrialText;

  /// No description provided for @docRadioIntro.
  ///
  /// In en, this message translates to:
  /// **'Beneath the messages lies a small, efficient radio system. AIS transmits at 9 600 bits per second on two VHF channels, using Gaussian minimum-shift keying (GMSK) and HDLC-style framing.'**
  String get docRadioIntro;

  /// No description provided for @docRadioPhysical.
  ///
  /// In en, this message translates to:
  /// **'The physical link'**
  String get docRadioPhysical;

  /// No description provided for @docRadioPhysical1.
  ///
  /// In en, this message translates to:
  /// **'AIS 1 at 161.975 MHz and AIS 2 at 162.025 MHz (VHF channels 87B and 88B).'**
  String get docRadioPhysical1;

  /// No description provided for @docRadioPhysical2.
  ///
  /// In en, this message translates to:
  /// **'GMSK modulation at 9 600 baud — narrow enough to fit the maritime VHF band.'**
  String get docRadioPhysical2;

  /// No description provided for @docRadioPhysical3.
  ///
  /// In en, this message translates to:
  /// **'HDLC framing with bit stuffing, and NRZI line coding, inherited from the packet-radio world.'**
  String get docRadioPhysical3;

  /// No description provided for @docRadioFrames.
  ///
  /// In en, this message translates to:
  /// **'TDMA frames and slots'**
  String get docRadioFrames;

  /// No description provided for @docRadioFrames1.
  ///
  /// In en, this message translates to:
  /// **'Each channel is split into frames of exactly 1 minute, divided into 2 250 time slots of ~26.7 ms each.'**
  String get docRadioFrames1;

  /// No description provided for @docRadioFrames2.
  ///
  /// In en, this message translates to:
  /// **'A slot carries one AIS message (256 bits with ramp-up/down and guard time).'**
  String get docRadioFrames2;

  /// No description provided for @docRadioFrames3.
  ///
  /// In en, this message translates to:
  /// **'Stations reuse the same slots every frame so they broadcast periodically without colliding.'**
  String get docRadioFrames3;

  /// No description provided for @docRadioCode.
  ///
  /// In en, this message translates to:
  /// **'2250 slots/frame · 1 frame = 60 s · slot ≈ 26.7 ms · 9600 bit/s'**
  String get docRadioCode;

  /// No description provided for @docRadioSotdma.
  ///
  /// In en, this message translates to:
  /// **'SOTDMA — how Class A self-organises'**
  String get docRadioSotdma;

  /// No description provided for @docRadioSotdmaText.
  ///
  /// In en, this message translates to:
  /// **'Each Class A transponder listens to the slots around it, picks a free one and announces in its radio-status field when it will transmit next. Stations continuously re-reserve as the traffic picture changes, so no central coordinator is needed.'**
  String get docRadioSotdmaText;

  /// No description provided for @docRadioCstdma.
  ///
  /// In en, this message translates to:
  /// **'CSTDMA — how Class B joins in'**
  String get docRadioCstdma;

  /// No description provided for @docRadioCstdmaText.
  ///
  /// In en, this message translates to:
  /// **'Class B units are simpler: they listen for a slot that is currently free and transmit once in it. This is cheaper, but Class B reports can be lost in very dense traffic where a slot is always busy.'**
  String get docRadioCstdmaText;

  /// No description provided for @docRadioVdes.
  ///
  /// In en, this message translates to:
  /// **'VDES — the future'**
  String get docRadioVdes;

  /// No description provided for @docRadioVdesText.
  ///
  /// In en, this message translates to:
  /// **'The VHF Data Exchange System (ITU-R M.2092) is rolling out to relieve congested waters: it adds new frequencies, far more bandwidth and secure two-way data for e-navigation, alongside the existing AIS service.'**
  String get docRadioVdesText;

  /// No description provided for @docClassesIntro.
  ///
  /// In en, this message translates to:
  /// **'AIS hardware comes in different classes and roles. The two you will meet most often are the full Class A transponder and the cheap Class B unit.'**
  String get docClassesIntro;

  /// No description provided for @docClassesComparison.
  ///
  /// In en, this message translates to:
  /// **'Class A vs Class B'**
  String get docClassesComparison;

  /// No description provided for @docClassesReceivers.
  ///
  /// In en, this message translates to:
  /// **'Receivers and transponders'**
  String get docClassesReceivers;

  /// No description provided for @docClassesReceiversText.
  ///
  /// In en, this message translates to:
  /// **'Transponders both receive and transmit. Many shore stations and hobbyists run receivers only, so they can watch traffic without appearing on it.'**
  String get docClassesReceiversText;

  /// No description provided for @docClassesAton.
  ///
  /// In en, this message translates to:
  /// **'Aids to navigation'**
  String get docClassesAton;

  /// No description provided for @docClassesAtonText.
  ///
  /// In en, this message translates to:
  /// **'AtoN stations (type 21) broadcast buoys, beacons and lighthouses. They can also transmit a virtual aid — a marker that exists only on charts, useful to warn of a new hazard.'**
  String get docClassesAtonText;

  /// No description provided for @docClassesDistress.
  ///
  /// In en, this message translates to:
  /// **'Distress & safety devices'**
  String get docClassesDistress;

  /// No description provided for @docClassesDistressIntro.
  ///
  /// In en, this message translates to:
  /// **'Beyond regular ships, AIS carries distress transmitters that every receiver should be able to spot:'**
  String get docClassesDistressIntro;

  /// No description provided for @docClassesSartNote.
  ///
  /// In en, this message translates to:
  /// **'A SART in action also sets navigation status 14 (\"AIS-SART active\") on its position report.'**
  String get docClassesSartNote;

  /// No description provided for @docShipTypesIntro.
  ///
  /// In en, this message translates to:
  /// **'Type 5 and 24 static messages carry an 8-bit ship-type code (0-99) that describes what the vessel is — cargo, tanker, fishing boat, pleasure craft and so on. The full table is shown below.'**
  String get docShipTypesIntro;

  /// No description provided for @docShipTypesCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories at a glance'**
  String get docShipTypesCategories;

  /// No description provided for @docVesselCatRow.
  ///
  /// In en, this message translates to:
  /// **'{range} — {label}'**
  String docVesselCatRow(Object label, Object range);

  /// No description provided for @docFieldNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Field notes & real-world quirks'**
  String get docFieldNotesTitle;

  /// No description provided for @docFieldNotesIntro.
  ///
  /// In en, this message translates to:
  /// **'Real AIS traffic does not always match the theory. Knowing these quirks helps you trust what the decoder shows you — and what it rejects.'**
  String get docFieldNotesIntro;

  /// No description provided for @docGlossaryIntro.
  ///
  /// In en, this message translates to:
  /// **'A searchable dictionary of the acronyms and terms used throughout this guide and by the AIS community.'**
  String get docGlossaryIntro;

  /// No description provided for @docCheatSheetIntro.
  ///
  /// In en, this message translates to:
  /// **'The essential numbers and codes at a glance — frequencies, reporting rates, status codes and formats.'**
  String get docCheatSheetIntro;

  /// No description provided for @docMmsiIntro.
  ///
  /// In en, this message translates to:
  /// **'The Maritime Mobile Service Identity (MMSI) is a unique 9-digit number identifying a ship\'s radio equipment, like a phone number for the vessel. Its first three digits are the MID — the Maritime Identification Digits that identify the country that issued it.'**
  String get docMmsiIntro;

  /// No description provided for @docMmsiFormats.
  ///
  /// In en, this message translates to:
  /// **'Number formats'**
  String get docMmsiFormats;

  /// No description provided for @docMmsiFmtRow.
  ///
  /// In en, this message translates to:
  /// **'{format} — {label}'**
  String docMmsiFmtRow(Object format, Object label);

  /// No description provided for @docMmsiLookupHeading.
  ///
  /// In en, this message translates to:
  /// **'Look up an MMSI'**
  String get docMmsiLookupHeading;

  /// No description provided for @docMmsiLookupHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a 9-digit MMSI below to see its class and the country of the issuing authority.'**
  String get docMmsiLookupHint;

  /// No description provided for @docMmsiMidHeading.
  ///
  /// In en, this message translates to:
  /// **'Country codes (MID)'**
  String get docMmsiMidHeading;

  /// No description provided for @docMmsiMidText.
  ///
  /// In en, this message translates to:
  /// **'The full MID table is bundled with KikAis and used everywhere an MMSI is displayed.'**
  String get docMmsiMidText;

  /// No description provided for @docMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'The 27 message types'**
  String get docMessagesTitle;

  /// No description provided for @docMessagesIntro.
  ///
  /// In en, this message translates to:
  /// **'Every AIS payload begins with a 6-bit message type (1 to 27). The catalog below groups them by family. Each card shows a real NMEA sentence generated by KikAis\' own encoder, its decoded fields, and a button to open it in the Decoder.'**
  String get docMessagesIntro;

  /// No description provided for @docNmeaTitle.
  ///
  /// In en, this message translates to:
  /// **'NMEA & AIVDM framing'**
  String get docNmeaTitle;

  /// No description provided for @docNmeaIntro.
  ///
  /// In en, this message translates to:
  /// **'On the wire, AIS messages travel as NMEA 0183 sentences starting with !AIVDM (other ships) or !AIVDO (your own ship). The payload is an ASCII-armored bit vector.'**
  String get docNmeaIntro;

  /// No description provided for @docNmeaSampleSingle.
  ///
  /// In en, this message translates to:
  /// **'!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C'**
  String get docNmeaSampleSingle;

  /// No description provided for @docNmeaFields.
  ///
  /// In en, this message translates to:
  /// **'Sentence fields'**
  String get docNmeaFields;

  /// No description provided for @docNmeaField1.
  ///
  /// In en, this message translates to:
  /// **'Talker & formatter — !AIVDM or !AIVDO (see talker IDs below).'**
  String get docNmeaField1;

  /// No description provided for @docNmeaField2.
  ///
  /// In en, this message translates to:
  /// **'Fragment count — how many sentences make up the full message (NMEA limits each line to ~82 characters).'**
  String get docNmeaField2;

  /// No description provided for @docNmeaField3.
  ///
  /// In en, this message translates to:
  /// **'Fragment number — which part this is (1-based).'**
  String get docNmeaField3;

  /// No description provided for @docNmeaField4.
  ///
  /// In en, this message translates to:
  /// **'Sequential message ID — ties fragments of the same message together.'**
  String get docNmeaField4;

  /// No description provided for @docNmeaField5.
  ///
  /// In en, this message translates to:
  /// **'Radio channel — A or B (AIS1 / AIS2).'**
  String get docNmeaField5;

  /// No description provided for @docNmeaField6.
  ///
  /// In en, this message translates to:
  /// **'Data payload — the six-bit armoured AIS payload.'**
  String get docNmeaField6;

  /// No description provided for @docNmeaField7.
  ///
  /// In en, this message translates to:
  /// **'Fill bits — how many pad bits were added to the last 6-bit group (0-5).'**
  String get docNmeaField7;

  /// No description provided for @docNmeaField8.
  ///
  /// In en, this message translates to:
  /// **'Checksum — the XOR of all bytes before the *, in hexadecimal.'**
  String get docNmeaField8;

  /// No description provided for @docNmeaMulti.
  ///
  /// In en, this message translates to:
  /// **'Multi-fragment messages'**
  String get docNmeaMulti;

  /// No description provided for @docNmeaMultiText.
  ///
  /// In en, this message translates to:
  /// **'Messages longer than one line (such as type 5 static data) are split: the first sentence reports a fragment count of 2 and the second completes it with the same message ID.'**
  String get docNmeaMultiText;

  /// No description provided for @docNmeaSampleMulti.
  ///
  /// In en, this message translates to:
  /// **'!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55'**
  String get docNmeaSampleMulti;

  /// No description provided for @docNmeaArmoring.
  ///
  /// In en, this message translates to:
  /// **'Six-bit armoring'**
  String get docNmeaArmoring;

  /// No description provided for @docNmeaArmoringText.
  ///
  /// In en, this message translates to:
  /// **'Each payload character holds 6 bits. Subtract 48 from the ASCII code, then subtract another 8 if the result is above 40.'**
  String get docNmeaArmoringText;

  /// No description provided for @docNmeaTalkers.
  ///
  /// In en, this message translates to:
  /// **'Talker IDs'**
  String get docNmeaTalkers;

  /// No description provided for @docNmeaTalkersIntro.
  ///
  /// In en, this message translates to:
  /// **'Different NMEA 4.0 talker IDs identify the type of AIS station:'**
  String get docNmeaTalkersIntro;

  /// No description provided for @docTalkerRow.
  ///
  /// In en, this message translates to:
  /// **'!{talker} — {label}'**
  String docTalkerRow(Object label, Object talker);

  /// No description provided for @docNmeaChecksum.
  ///
  /// In en, this message translates to:
  /// **'Checksum'**
  String get docNmeaChecksum;

  /// No description provided for @docNmeaChecksumText.
  ///
  /// In en, this message translates to:
  /// **'The trailing checksum is the XOR of every byte between the \"!\" and the \"*\". Calculate your own below:'**
  String get docNmeaChecksumText;

  /// No description provided for @docNmeaInspectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Try it: sentence inspector'**
  String get docNmeaInspectorTitle;

  /// No description provided for @docNmeaInspectorText.
  ///
  /// In en, this message translates to:
  /// **'Paste any AIVDM/AIVDO sentence (or use a sample above) to see its fields broken down and the decoded values.'**
  String get docNmeaInspectorText;

  /// No description provided for @docPayloadIntro.
  ///
  /// In en, this message translates to:
  /// **'Once the six-bit armoring is undone, an AIS payload is a sequence of bit fields. The first six bits are the message type; the next two are the repeat indicator; then come 30 bits of MMSI.'**
  String get docPayloadIntro;

  /// No description provided for @docPayloadCnb.
  ///
  /// In en, this message translates to:
  /// **'The Common Navigation Block (types 1-3)'**
  String get docPayloadCnb;

  /// No description provided for @docPayloadCnbText.
  ///
  /// In en, this message translates to:
  /// **'The most important layout is shared by the Class A position reports. Use the selector to browse the main message layouts, and click a segment to read what it encodes.'**
  String get docPayloadCnbText;

  /// No description provided for @docPayloadCoords.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get docPayloadCoords;

  /// No description provided for @docPayloadCoordsText.
  ///
  /// In en, this message translates to:
  /// **'Latitude and longitude are stored in 1/10 000 of a minute. Divide by 600 000 to get degrees: 60 minutes in a degree, and 10 000 units per minute. East/North are positive.'**
  String get docPayloadCoordsText;

  /// No description provided for @docPayloadCoordsCode.
  ///
  /// In en, this message translates to:
  /// **'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°'**
  String get docPayloadCoordsCode;

  /// No description provided for @docPayloadCoordsConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert your own coordinates below:'**
  String get docPayloadCoordsConvert;

  /// No description provided for @docPayloadSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed, course, heading'**
  String get docPayloadSpeed;

  /// No description provided for @docPayloadSpeed1.
  ///
  /// In en, this message translates to:
  /// **'SOG — speed over ground in tenths of a knot (0-102.2 kn); 1023 means \"not available\".'**
  String get docPayloadSpeed1;

  /// No description provided for @docPayloadSpeed2.
  ///
  /// In en, this message translates to:
  /// **'COG — course over ground in tenths of a degree, relative to true north.'**
  String get docPayloadSpeed2;

  /// No description provided for @docPayloadSpeed3.
  ///
  /// In en, this message translates to:
  /// **'Heading — true heading in whole degrees; 511 means \"not available\".'**
  String get docPayloadSpeed3;

  /// No description provided for @docPayloadSpeed4.
  ///
  /// In en, this message translates to:
  /// **'ROT — rate of turn: value ≈ 4.733 × √(turning rate in °/min), signed (positive = right).'**
  String get docPayloadSpeed4;

  /// No description provided for @docPayloadNavStatus.
  ///
  /// In en, this message translates to:
  /// **'Navigation status'**
  String get docPayloadNavStatus;

  /// No description provided for @docPayloadEpfd.
  ///
  /// In en, this message translates to:
  /// **'Position fix type (EPFD)'**
  String get docPayloadEpfd;

  /// No description provided for @docPayloadText.
  ///
  /// In en, this message translates to:
  /// **'Six-bit text'**
  String get docPayloadText;

  /// No description provided for @docPayloadTextIntro.
  ///
  /// In en, this message translates to:
  /// **'Names, call signs and destinations use the same six-bit alphabet as the payload itself. Lowercase letters cannot be encoded, which is why AIS names are usually uppercase.'**
  String get docPayloadTextIntro;

  /// No description provided for @docSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security & data quality'**
  String get docSecurityTitle;

  /// No description provided for @docSecurityIntro.
  ///
  /// In en, this message translates to:
  /// **'AIS is designed for cooperation, not security. The radio channel is open and unencrypted, and there is no authentication of who is broadcasting.'**
  String get docSecurityIntro;

  /// No description provided for @docSecurityThreats.
  ///
  /// In en, this message translates to:
  /// **'Threats'**
  String get docSecurityThreats;

  /// No description provided for @docSecurityThreat1.
  ///
  /// In en, this message translates to:
  /// **'Spoofing — transmitting a fake MMSI, position or identity (phantom ships, sanctions evasion).'**
  String get docSecurityThreat1;

  /// No description provided for @docSecurityThreat2.
  ///
  /// In en, this message translates to:
  /// **'Jamming — flooding the two VHF channels so real traffic cannot be received.'**
  String get docSecurityThreat2;

  /// No description provided for @docSecurityThreat3.
  ///
  /// In en, this message translates to:
  /// **'Meaconing — replaying real signals from elsewhere to confuse receivers.'**
  String get docSecurityThreat3;

  /// No description provided for @docSecurityQuality.
  ///
  /// In en, this message translates to:
  /// **'Data quality'**
  String get docSecurityQuality;

  /// No description provided for @docSecurityQuality1.
  ///
  /// In en, this message translates to:
  /// **'The position accuracy bit distinguishes an unaugmented GNSS fix (> 10 m) from a DGPS-quality fix (< 10 m).'**
  String get docSecurityQuality1;

  /// No description provided for @docSecurityQuality2.
  ///
  /// In en, this message translates to:
  /// **'Receivers should sanity-check positions, speeds and timestamps; about 0.3% of real-world messages have a bad payload length.'**
  String get docSecurityQuality2;

  /// No description provided for @docSecurityQuality3.
  ///
  /// In en, this message translates to:
  /// **'Satellite AIS occasionally suffers collisions because the satellite footprint is much larger than a TDMA cell — one more reason to correlate with radar and other sources.'**
  String get docSecurityQuality3;

  /// No description provided for @docKikaisIntro.
  ///
  /// In en, this message translates to:
  /// **'KikAis is a full AIS lab: receive live or simulated traffic, decode it, inspect and send your own messages, and build fleets. Here is how each tab maps to what you just read.'**
  String get docKikaisIntro;

  /// No description provided for @docTabReceptionText.
  ///
  /// In en, this message translates to:
  /// **'Choose feeds (file, serial, simulation), start the forwarder and watch the raw NMEA stream and the decoded boats.'**
  String get docTabReceptionText;

  /// No description provided for @docTabSendText.
  ///
  /// In en, this message translates to:
  /// **'Forward the received sentences to one or more TCP/UDP targets — how a shore station would distribute traffic.'**
  String get docTabSendText;

  /// No description provided for @docTabMapText.
  ///
  /// In en, this message translates to:
  /// **'See decoded vessels plotted from their type 1/2/3, 18, 19 and 27 position reports.'**
  String get docTabMapText;

  /// No description provided for @docTabEditorText.
  ///
  /// In en, this message translates to:
  /// **'Build any of the 27 message types by hand from a friendly form and send it — the best way to learn the fields.'**
  String get docTabEditorText;

  /// No description provided for @docTabDecoderText.
  ///
  /// In en, this message translates to:
  /// **'Paste any sentence and get the decoded fields, checksum and fragment handling — the practical companion to this guide.'**
  String get docTabDecoderText;

  /// No description provided for @docTabStatsText.
  ///
  /// In en, this message translates to:
  /// **'Message counters, rates per feed and decoder health (invalid checksums, dropped fragments).'**
  String get docTabStatsText;

  /// No description provided for @docTabSimulationText.
  ///
  /// In en, this message translates to:
  /// **'Generate a whole fleet around any location — every message type, MMSI scheme, zone shape and even error injection.'**
  String get docTabSimulationText;

  /// No description provided for @docSourcesIntro.
  ///
  /// In en, this message translates to:
  /// **'This guide synthesizes publicly available, authoritative documentation:'**
  String get docSourcesIntro;

  /// No description provided for @docSources1.
  ///
  /// In en, this message translates to:
  /// **'gpsd — AIVDM/AIVDO protocol decoding, by Eric S. Raymond (the de-facto technical bible for the sentence format and payload bit fields).'**
  String get docSources1;

  /// No description provided for @docSources2.
  ///
  /// In en, this message translates to:
  /// **'Wikipedia — Automatic Identification System (overview, history, applications, security).'**
  String get docSources2;

  /// No description provided for @docSources3.
  ///
  /// In en, this message translates to:
  /// **'US Coast Guard Navigation Center (NavCen) — AIS pages.'**
  String get docSources3;

  /// No description provided for @docSources4.
  ///
  /// In en, this message translates to:
  /// **'ITU-R Recommendation M.1371 — the governing AIS standard.'**
  String get docSources4;

  /// No description provided for @docSources5.
  ///
  /// In en, this message translates to:
  /// **'IALA — clarifications of ITU-R M.1371.'**
  String get docSources5;

  /// No description provided for @docSources6.
  ///
  /// In en, this message translates to:
  /// **'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA framing, Class B and AIS-SART.'**
  String get docSources6;

  /// No description provided for @docSourcesLearn.
  ///
  /// In en, this message translates to:
  /// **'How to learn more'**
  String get docSourcesLearn;

  /// No description provided for @docSourcesLearnText.
  ///
  /// In en, this message translates to:
  /// **'The best way to understand AIS is to experiment: use the Editor to build messages, the Decoder to read them back, and the Simulation tab to watch a whole fleet. Everything in this guide is generated by KikAis\' own encoder and decoder.'**
  String get docSourcesLearnText;

  /// No description provided for @docTypeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Type {type} — {name}'**
  String docTypeCardTitle(Object name, Object type);

  /// No description provided for @docTypeCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{bits} bits · {cadence}'**
  String docTypeCardSubtitle(Object bits, Object cadence);

  /// No description provided for @docTypeCardEmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Emitted by: {emittedBy}'**
  String docTypeCardEmittedBy(Object emittedBy);

  /// No description provided for @docOpenInDecoder.
  ///
  /// In en, this message translates to:
  /// **'Open in Decoder'**
  String get docOpenInDecoder;

  /// No description provided for @docInspectorNmeaLabel.
  ///
  /// In en, this message translates to:
  /// **'NMEA sentence'**
  String get docInspectorNmeaLabel;

  /// No description provided for @docInspectorInspect.
  ///
  /// In en, this message translates to:
  /// **'Inspect'**
  String get docInspectorInspect;

  /// No description provided for @docInspectorInvalidChecksum.
  ///
  /// In en, this message translates to:
  /// **'Invalid checksum'**
  String get docInspectorInvalidChecksum;

  /// No description provided for @docInspectorCouldNotDecode.
  ///
  /// In en, this message translates to:
  /// **'Could not decode'**
  String get docInspectorCouldNotDecode;

  /// No description provided for @docInspectorDecoded.
  ///
  /// In en, this message translates to:
  /// **'Decoded: T{type} · {label}'**
  String docInspectorDecoded(Object label, Object type);

  /// No description provided for @docInspectorTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'Type {type}'**
  String docInspectorTypeFallback(Object type);

  /// No description provided for @docMmsiLookupLabel.
  ///
  /// In en, this message translates to:
  /// **'MMSI (9 digits)'**
  String get docMmsiLookupLabel;

  /// No description provided for @docMmsiLookupButton.
  ///
  /// In en, this message translates to:
  /// **'Look up'**
  String get docMmsiLookupButton;

  /// No description provided for @docMmsiLookupError.
  ///
  /// In en, this message translates to:
  /// **'Enter a 9-digit MMSI (digits only).'**
  String get docMmsiLookupError;

  /// No description provided for @docMmsiLookupClassGroup.
  ///
  /// In en, this message translates to:
  /// **'Group of ships (group call)'**
  String get docMmsiLookupClassGroup;

  /// No description provided for @docMmsiUnknownCountry.
  ///
  /// In en, this message translates to:
  /// **'unknown country'**
  String get docMmsiUnknownCountry;

  /// No description provided for @docMmsiLookupResult.
  ///
  /// In en, this message translates to:
  /// **'{cls} — MID {mid} ({country})'**
  String docMmsiLookupResult(Object cls, Object country, Object mid);

  /// No description provided for @docTabOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get docTabOpen;

  /// No description provided for @updateCheckForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get updateCheckForUpdates;

  /// No description provided for @updateChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates.'**
  String get updateChecking;

  /// No description provided for @updateNewVersion.
  ///
  /// In en, this message translates to:
  /// **'New version {version}'**
  String updateNewVersion(Object version);

  /// No description provided for @updateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re up to date.'**
  String get updateUpToDate;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Update check failed.'**
  String get updateCheckFailed;

  /// No description provided for @tooltipLanguage.
  ///
  /// In en, this message translates to:
  /// **'Defines the interface language. All ten languages are fully translated; choose \"Auto\" to follow the operating system language.'**
  String get tooltipLanguage;

  /// No description provided for @tooltipTheme.
  ///
  /// In en, this message translates to:
  /// **'Defines the color theme: dark, light or high contrast. High contrast improves readability.'**
  String get tooltipTheme;

  /// No description provided for @tooltipUpdate.
  ///
  /// In en, this message translates to:
  /// **'Checks for a new version. A green badge appears next to the version number when an update is available.'**
  String get tooltipUpdate;

  /// No description provided for @tooltipMapSearch.
  ///
  /// In en, this message translates to:
  /// **'Searches for a vessel by name, MMSI or IMO number, then centers and follows it on the map.'**
  String get tooltipMapSearch;

  /// No description provided for @tooltipMapFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters the displayed vessels by type, navigation status, country (MID), speed or name.'**
  String get tooltipMapFilters;

  /// No description provided for @tooltipMapCluster.
  ///
  /// In en, this message translates to:
  /// **'Enables or disables vessel clustering. When enabled, nearby vessels are grouped into one marker with a count.'**
  String get tooltipMapCluster;

  /// No description provided for @tooltipMapTrails.
  ///
  /// In en, this message translates to:
  /// **'Enables or disables the trails. When enabled, each vessel draws its recent path on the map.'**
  String get tooltipMapTrails;

  /// No description provided for @tooltipMapVectors.
  ///
  /// In en, this message translates to:
  /// **'Enables or disables the heading vectors. When enabled, each vessel shows an arrow along its course.'**
  String get tooltipMapVectors;

  /// No description provided for @tooltipMapSendToMap.
  ///
  /// In en, this message translates to:
  /// **'Enables or disables sending decoded vessels to the map. When enabled, every decoded vessel appears as a marker.'**
  String get tooltipMapSendToMap;

  /// No description provided for @tooltipMapBasemap.
  ///
  /// In en, this message translates to:
  /// **'Defines the map background. \"Auto\" follows the current theme.'**
  String get tooltipMapBasemap;

  /// No description provided for @tooltipSendAdd.
  ///
  /// In en, this message translates to:
  /// **'Adds a new send destination (UDP or TCP, client or server). Incoming AIS frames are forwarded to every enabled destination.'**
  String get tooltipSendAdd;

  /// No description provided for @tooltipSendEdit.
  ///
  /// In en, this message translates to:
  /// **'Edits this destination\'s name, protocol, host, port and frame format.'**
  String get tooltipSendEdit;

  /// No description provided for @tooltipSendDelete.
  ///
  /// In en, this message translates to:
  /// **'Deletes this destination. This action cannot be undone.'**
  String get tooltipSendDelete;

  /// No description provided for @tooltipSendToggle.
  ///
  /// In en, this message translates to:
  /// **'Enables or disables forwarding to this destination.'**
  String get tooltipSendToggle;

  /// No description provided for @tooltipSendLocked.
  ///
  /// In en, this message translates to:
  /// **'Destinations are locked while the forwarder is running. Stop the feed on the Reception tab to edit them.'**
  String get tooltipSendLocked;

  /// No description provided for @tooltipReceptionAddSource.
  ///
  /// In en, this message translates to:
  /// **'Adds a data source: a network feed (UDP/TCP/gpsd), a file of recorded NMEA sentences, or a serial port.'**
  String get tooltipReceptionAddSource;

  /// No description provided for @tooltipReceptionStart.
  ///
  /// In en, this message translates to:
  /// **'Starts receiving and forwarding AIS frames from all enabled sources.'**
  String get tooltipReceptionStart;

  /// No description provided for @tooltipReceptionStop.
  ///
  /// In en, this message translates to:
  /// **'Stops receiving and forwarding AIS frames.'**
  String get tooltipReceptionStop;

  /// No description provided for @tooltipReceptionFeed.
  ///
  /// In en, this message translates to:
  /// **'Enables or disables this AIS source.'**
  String get tooltipReceptionFeed;

  /// No description provided for @tooltipReceptionSaveLogs.
  ///
  /// In en, this message translates to:
  /// **'Saves the connection log to a text file.'**
  String get tooltipReceptionSaveLogs;

  /// No description provided for @tooltipReceptionClearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clears the connection log.'**
  String get tooltipReceptionClearLogs;

  /// No description provided for @tooltipReceptionRemoveSource.
  ///
  /// In en, this message translates to:
  /// **'Removes this AIS source.'**
  String get tooltipReceptionRemoveSource;

  /// No description provided for @tooltipReceptionValidateChecksums.
  ///
  /// In en, this message translates to:
  /// **'Rejects frames with an invalid NMEA checksum when enabled.'**
  String get tooltipReceptionValidateChecksums;

  /// No description provided for @tooltipReceptionImportFormat.
  ///
  /// In en, this message translates to:
  /// **'Defines how received frames are normalized before decoding.'**
  String get tooltipReceptionImportFormat;

  /// No description provided for @tooltipReceptionLoop.
  ///
  /// In en, this message translates to:
  /// **'Restarts the file replay from the beginning when the end is reached.'**
  String get tooltipReceptionLoop;

  /// No description provided for @tooltipReceptionSpeed.
  ///
  /// In en, this message translates to:
  /// **'Defines the replay speed multiplier (1x = real time).'**
  String get tooltipReceptionSpeed;

  /// No description provided for @tooltipReceptionSerialPorts.
  ///
  /// In en, this message translates to:
  /// **'Refreshes the list of available serial ports.'**
  String get tooltipReceptionSerialPorts;

  /// No description provided for @tooltipSimApply.
  ///
  /// In en, this message translates to:
  /// **'Applies the current settings and generates the fleet. Large fleets are generated in the background.'**
  String get tooltipSimApply;

  /// No description provided for @tooltipSimGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generates a new random fleet with a fresh seed, then applies it.'**
  String get tooltipSimGenerate;

  /// No description provided for @tooltipSimOpenReception.
  ///
  /// In en, this message translates to:
  /// **'Opens the Reception tab to start the Simulation feed.'**
  String get tooltipSimOpenReception;

  /// No description provided for @tooltipSimRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius of the navigation zone around the center, in kilometers.'**
  String get tooltipSimRadius;

  /// No description provided for @tooltipSimVessels.
  ///
  /// In en, this message translates to:
  /// **'Number of vessels to generate in the fleet.'**
  String get tooltipSimVessels;

  /// No description provided for @tooltipSimSpeedMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum vessel speed over ground, in knots.'**
  String get tooltipSimSpeedMin;

  /// No description provided for @tooltipSimSpeedMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum vessel speed over ground, in knots.'**
  String get tooltipSimSpeedMax;

  /// No description provided for @tooltipSimInterval.
  ///
  /// In en, this message translates to:
  /// **'Delay between two emission ticks, in seconds.'**
  String get tooltipSimInterval;

  /// No description provided for @tooltipSimSeed.
  ///
  /// In en, this message translates to:
  /// **'Random seed. The same seed always produces the same fleet.'**
  String get tooltipSimSeed;

  /// No description provided for @tooltipSimAnchored.
  ///
  /// In en, this message translates to:
  /// **'Percentage of vessels left anchored or moored instead of moving.'**
  String get tooltipSimAnchored;

  /// No description provided for @tooltipSimNamePrefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix used for the generated vessel names.'**
  String get tooltipSimNamePrefix;

  /// No description provided for @tooltipSimMmsiMid.
  ///
  /// In en, this message translates to:
  /// **'Maritime Identification Digits (3-digit country code) used to build the MMSIs.'**
  String get tooltipSimMmsiMid;

  /// No description provided for @tooltipSimCenterLat.
  ///
  /// In en, this message translates to:
  /// **'Latitude of the navigation zone center.'**
  String get tooltipSimCenterLat;

  /// No description provided for @tooltipSimCenterLon.
  ///
  /// In en, this message translates to:
  /// **'Longitude of the navigation zone center.'**
  String get tooltipSimCenterLon;

  /// No description provided for @tooltipSimTransit.
  ///
  /// In en, this message translates to:
  /// **'Percentage of vessels crossing the zone on a straight transit route.'**
  String get tooltipSimTransit;

  /// No description provided for @tooltipSimRegenEvery.
  ///
  /// In en, this message translates to:
  /// **'Regenerate the fleet every N ticks when periodic regeneration is enabled.'**
  String get tooltipSimRegenEvery;

  /// No description provided for @tooltipSimReportInterval.
  ///
  /// In en, this message translates to:
  /// **'Maximum position-report interval per vessel, in ticks.'**
  String get tooltipSimReportInterval;

  /// No description provided for @tooltipSimWander.
  ///
  /// In en, this message translates to:
  /// **'Strength of the random heading wander (0 = straight lines).'**
  String get tooltipSimWander;

  /// No description provided for @tooltipSimClassBShare.
  ///
  /// In en, this message translates to:
  /// **'Percentage of Class B versus Class A position reports when both are enabled.'**
  String get tooltipSimClassBShare;

  /// No description provided for @tooltipSimErrorRate.
  ///
  /// In en, this message translates to:
  /// **'Probability of corrupting or duplicating each emitted sentence.'**
  String get tooltipSimErrorRate;

  /// No description provided for @tooltipSimBaseStations.
  ///
  /// In en, this message translates to:
  /// **'Number of fixed base stations to generate.'**
  String get tooltipSimBaseStations;

  /// No description provided for @tooltipSimAtoN.
  ///
  /// In en, this message translates to:
  /// **'Number of fixed Aids to Navigation (beacons) to generate.'**
  String get tooltipSimAtoN;

  /// No description provided for @tooltipSimRealisticNames.
  ///
  /// In en, this message translates to:
  /// **'Use realistic vessel names, call signs and destinations.'**
  String get tooltipSimRealisticNames;

  /// No description provided for @tooltipSimRealisticDimensions.
  ///
  /// In en, this message translates to:
  /// **'Scale vessel dimensions and draught by ship type.'**
  String get tooltipSimRealisticDimensions;

  /// No description provided for @tooltipSimRealisticMmsi.
  ///
  /// In en, this message translates to:
  /// **'Build MMSIs that follow the ITU structure per vessel category.'**
  String get tooltipSimRealisticMmsi;

  /// No description provided for @tooltipSimVarySpeed.
  ///
  /// In en, this message translates to:
  /// **'Let vessel speed drift gently within the configured range.'**
  String get tooltipSimVarySpeed;

  /// No description provided for @tooltipSimSpeedByType.
  ///
  /// In en, this message translates to:
  /// **'Pick the speed from the typical range of each ship type.'**
  String get tooltipSimSpeedByType;

  /// No description provided for @tooltipSimHighAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Set the high-accuracy position flag on emitted reports.'**
  String get tooltipSimHighAccuracy;

  /// No description provided for @tooltipSimRealisticRot.
  ///
  /// In en, this message translates to:
  /// **'Emit a rate of turn derived from the heading change.'**
  String get tooltipSimRealisticRot;

  /// No description provided for @tooltipSimRegeneratePeriodically.
  ///
  /// In en, this message translates to:
  /// **'Automatically regenerate the fleet every N ticks to simulate changing traffic.'**
  String get tooltipSimRegeneratePeriodically;

  /// No description provided for @tooltipSimInjectErrors.
  ///
  /// In en, this message translates to:
  /// **'Corrupt or duplicate some emitted sentences to test error handling.'**
  String get tooltipSimInjectErrors;

  /// No description provided for @tooltipSimNmea4Tag.
  ///
  /// In en, this message translates to:
  /// **'Prefix every emitted frame with an NMEA 4.0 tag block.'**
  String get tooltipSimNmea4Tag;

  /// No description provided for @tooltipSimVesselType.
  ///
  /// In en, this message translates to:
  /// **'Include this ship type in the fleet.'**
  String get tooltipSimVesselType;

  /// No description provided for @tooltipSimMessageType.
  ///
  /// In en, this message translates to:
  /// **'Emit this AIS message type.'**
  String get tooltipSimMessageType;

  /// No description provided for @tooltipDecoderClear.
  ///
  /// In en, this message translates to:
  /// **'Clears the decoder input and results.'**
  String get tooltipDecoderClear;

  /// No description provided for @tooltipStatsDecode.
  ///
  /// In en, this message translates to:
  /// **'Pauses or resumes decoding of incoming AIS frames.'**
  String get tooltipStatsDecode;

  /// No description provided for @tooltipStatsReset.
  ///
  /// In en, this message translates to:
  /// **'Resets all statistics counters to zero.'**
  String get tooltipStatsReset;

  /// No description provided for @tooltipDocOpenTab.
  ///
  /// In en, this message translates to:
  /// **'Opens this section in its own tab.'**
  String get tooltipDocOpenTab;

  /// No description provided for @tooltipEditorInject.
  ///
  /// In en, this message translates to:
  /// **'Injects the composed message into the decoder as if it had been received.'**
  String get tooltipEditorInject;

  /// No description provided for @tooltipEditorSend.
  ///
  /// In en, this message translates to:
  /// **'Sends the composed message to every enabled send destination.'**
  String get tooltipEditorSend;

  /// No description provided for @tooltipCopy.
  ///
  /// In en, this message translates to:
  /// **'Copies the selection to the clipboard.'**
  String get tooltipCopy;

  /// No description provided for @tooltipClose.
  ///
  /// In en, this message translates to:
  /// **'Closes this panel.'**
  String get tooltipClose;

  /// No description provided for @tooltipBrowse.
  ///
  /// In en, this message translates to:
  /// **'Opens a file browser to choose a file.'**
  String get tooltipBrowse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'nl',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
