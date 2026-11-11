import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_pt.dart';
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
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ja'),
    Locale('lt'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// Tooltip for the About & Help button
  ///
  /// In en, this message translates to:
  /// **'About & Help'**
  String get aboutAndHelpTooltip;

  /// Close button label in About dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get aboutDialogClose;

  /// Button to open the Harmonic Analogy dialog
  ///
  /// In en, this message translates to:
  /// **'Harmonic Analogy'**
  String get aboutDialogHarmonicAnalogy;

  /// Button to open the Privacy Policy dialog
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutDialogPrivacyPolicy;

  /// Button to open Terms of Service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutDialogTermsOfService;

  /// Version string in About dialog
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String aboutDialogVersion(String version);

  /// Percentage display for accuracy
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String accuracyPercent(String percent);

  /// Title for all-time accuracy metric
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME ACCURACY'**
  String get allTimeAccuracy;

  /// Title of the Harmonic Analogy modal dialog
  ///
  /// In en, this message translates to:
  /// **'Audio-Visual Analogy'**
  String get analogyDialogTitle;

  /// Main application title
  ///
  /// In en, this message translates to:
  /// **'Sieve of Eratosthenes'**
  String get appTitle;

  /// Metric card title for best streak
  ///
  /// In en, this message translates to:
  /// **'BEST STREAK'**
  String get bestStreak;

  /// Metric card subtext for best streak
  ///
  /// In en, this message translates to:
  /// **'Primes in a row'**
  String get bestStreakSubtext;

  /// Generic cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Tooltip to cancel the prime guess for the next number
  ///
  /// In en, this message translates to:
  /// **'Cancel Guess for #{number} (Space)'**
  String cancelGuessTooltip(int number);

  /// Label indicating a composite number
  ///
  /// In en, this message translates to:
  /// **'COMPOSITE'**
  String get compositeLabel;

  /// Subtext for incorrect guesses
  ///
  /// In en, this message translates to:
  /// **'Composites guessed'**
  String get compositesGuessedSubtext;

  /// Metric card title for correct guesses
  ///
  /// In en, this message translates to:
  /// **'CORRECT'**
  String get correctGuesses;

  /// Introductory instruction text when number is 0
  ///
  /// In en, this message translates to:
  /// **'Counting begins at 0. Press Play to start the Sieve of Eratosthenes.'**
  String get countingBeginsAtZero;

  /// Button to end a match as host
  ///
  /// In en, this message translates to:
  /// **'End Match'**
  String get endMatch;

  /// Tooltip for ending a multiplayer match as host
  ///
  /// In en, this message translates to:
  /// **'End Match & Disband Room'**
  String get endMatchDisbandTooltip;

  /// Dismiss button in game rules dialog
  ///
  /// In en, this message translates to:
  /// **'Got it! Let\'s Play'**
  String get gameHelpClose;

  /// Error message when game rules html cannot load
  ///
  /// In en, this message translates to:
  /// **'Unable to load game rules.'**
  String get gameHelpError;

  /// Title of the Game Rules / How to Play dialog
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get gameHelpTitle;

  /// Tooltip for Game Rules button
  ///
  /// In en, this message translates to:
  /// **'How to Play (Game Rules)'**
  String get gameHelpTooltip;

  /// Subtext for 1 in grid cell
  ///
  /// In en, this message translates to:
  /// **'Go!'**
  String get gridGo;

  /// Badge in grid cell when number is guessed prime
  ///
  /// In en, this message translates to:
  /// **'GUESS'**
  String get gridGuess;

  /// Badge in grid cell when prime is discovered
  ///
  /// In en, this message translates to:
  /// **'PRIME'**
  String get gridPrime;

  /// Subtext for 0 in grid cell
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get gridReady;

  /// Label on guess button when active
  ///
  /// In en, this message translates to:
  /// **'Guessed #{number}'**
  String guessButtonActive(int number);

  /// Label on guess button when inactive
  ///
  /// In en, this message translates to:
  /// **'Guess Next (#{number})'**
  String guessButtonInactive(int number);

  /// Tooltip for guess button
  ///
  /// In en, this message translates to:
  /// **'Guess Next #{number} is Prime (Space)'**
  String guessNextTooltip(int number);

  /// Header in factor inspector for frequency
  ///
  /// In en, this message translates to:
  /// **'Harmonic Frequency'**
  String get harmonicFrequency;

  /// Checkbox label for audio harmonics
  ///
  /// In en, this message translates to:
  /// **'Harmonics'**
  String get harmonicsLabel;

  /// Tooltip when harmonics is on
  ///
  /// In en, this message translates to:
  /// **'Turn off harmonics (prime powers like 4 and 8 will play a single note)'**
  String get harmonicsOffTooltip;

  /// Tooltip when harmonics is off
  ///
  /// In en, this message translates to:
  /// **'Turn on harmonics (prime powers like 4 and 8 will play multiple octave notes)'**
  String get harmonicsOnTooltip;

  /// Hero text for number 1
  ///
  /// In en, this message translates to:
  /// **'1 - Go!'**
  String get heroGo;

  /// Hero text when number is prime
  ///
  /// In en, this message translates to:
  /// **'{number} - Prime!'**
  String heroPrime(int number);

  /// Hero text when starting at 0
  ///
  /// In en, this message translates to:
  /// **'0 - Ready...'**
  String get heroReady;

  /// Metric card title for high score
  ///
  /// In en, this message translates to:
  /// **'HIGH SCORE'**
  String get highScore;

  /// Guest banner showing host room controls
  ///
  /// In en, this message translates to:
  /// **'Host Controls (Room {roomCode})'**
  String hostControls(String roomCode);

  /// Metric card title for incorrect guesses
  ///
  /// In en, this message translates to:
  /// **'INCORRECT'**
  String get incorrectGuesses;

  /// Option to use system language
  ///
  /// In en, this message translates to:
  /// **'Auto (System)'**
  String get languageAuto;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Dialog message for guest leaving multiplayer room
  ///
  /// In en, this message translates to:
  /// **'You will leave the current room and return to solo mode.'**
  String get leaveMultiplayerContentGuest;

  /// Dialog message for host leaving multiplayer room
  ///
  /// In en, this message translates to:
  /// **'Leaving will end the room for all players and return to solo mode.'**
  String get leaveMultiplayerContentHost;

  /// Dialog title for guest leaving multiplayer room
  ///
  /// In en, this message translates to:
  /// **'Leave Multiplayer Room?'**
  String get leaveMultiplayerTitleGuest;

  /// Dialog title for host leaving multiplayer room
  ///
  /// In en, this message translates to:
  /// **'End Multiplayer Match?'**
  String get leaveMultiplayerTitleHost;

  /// Button to leave a room as guest
  ///
  /// In en, this message translates to:
  /// **'Leave Room'**
  String get leaveRoom;

  /// Tooltip to mute audio
  ///
  /// In en, this message translates to:
  /// **'Mute Audio'**
  String get muteAudioTooltip;

  /// Button to copy room link
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get multiplayerCopyLink;

  /// Button to create a room
  ///
  /// In en, this message translates to:
  /// **'Create New Room'**
  String get multiplayerCreateRoom;

  /// Status text while creating room
  ///
  /// In en, this message translates to:
  /// **'Creating room...'**
  String get multiplayerCreatingRoom;

  /// Hint text for room code input
  ///
  /// In en, this message translates to:
  /// **'Enter 4-character Room Code'**
  String get multiplayerEnterCode;

  /// Tab title for hosting a room
  ///
  /// In en, this message translates to:
  /// **'Host Room'**
  String get multiplayerHostTab;

  /// Button to join a match
  ///
  /// In en, this message translates to:
  /// **'Join Match'**
  String get multiplayerJoinMatch;

  /// Tab title for joining a room
  ///
  /// In en, this message translates to:
  /// **'Join Room'**
  String get multiplayerJoinTab;

  /// Status text while joining a room
  ///
  /// In en, this message translates to:
  /// **'Joining room...'**
  String get multiplayerJoining;

  /// Button to lock multiplayer room
  ///
  /// In en, this message translates to:
  /// **'Lock Room'**
  String get multiplayerLockRoom;

  /// Badge when multiplayer room is locked
  ///
  /// In en, this message translates to:
  /// **'Room Locked'**
  String get multiplayerLocked;

  /// Tooltip for Multiplayer dialog button
  ///
  /// In en, this message translates to:
  /// **'Multiplayer Match'**
  String get multiplayerMatchTooltip;

  /// Hint text for player nickname
  ///
  /// In en, this message translates to:
  /// **'Your Nickname (Optional)'**
  String get multiplayerNicknameOptional;

  /// Header for player list in room
  ///
  /// In en, this message translates to:
  /// **'PLAYERS ({count})'**
  String multiplayerPlayersHeader(int count);

  /// Button to rejoin cached room session
  ///
  /// In en, this message translates to:
  /// **'Rejoin Previous Room ({roomCode})'**
  String multiplayerRejoin(String roomCode);

  /// Label for room code display
  ///
  /// In en, this message translates to:
  /// **'ROOM CODE'**
  String get multiplayerRoomCode;

  /// Tag next to the local player name
  ///
  /// In en, this message translates to:
  /// **'(You)'**
  String get multiplayerYouTag;

  /// Badge displayed when new high score is achieved
  ///
  /// In en, this message translates to:
  /// **'NEW!'**
  String get newHighScoreBadge;

  /// Text banner when current number is 1
  ///
  /// In en, this message translates to:
  /// **'Next number is 2: The very first prime!'**
  String get nextNumberIsTwo;

  /// Section header for the number grid
  ///
  /// In en, this message translates to:
  /// **'NUMBER STREAM GRID'**
  String get numberStreamGrid;

  /// Tooltip to pause playback
  ///
  /// In en, this message translates to:
  /// **'Pause (P)'**
  String get pauseTooltip;

  /// Tooltip to play playback
  ///
  /// In en, this message translates to:
  /// **'Play (P)'**
  String get playTooltip;

  /// Snackbar message when guest attempts playback control
  ///
  /// In en, this message translates to:
  /// **'Playback is controlled by the room host. Tap \"Leave Room\" to exit.'**
  String get playbackControlledByHost;

  /// Title of player stats dialog
  ///
  /// In en, this message translates to:
  /// **'Player Stats & Records'**
  String get playerStatsTitle;

  /// Subtext under high score
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsSubtext;

  /// Header in factor inspector for factors
  ///
  /// In en, this message translates to:
  /// **'Prime Factors'**
  String get primeFactors;

  /// Badge indicating prime number in hero spotlight
  ///
  /// In en, this message translates to:
  /// **'PRIME NUMBER'**
  String get primeNumberBadge;

  /// Subtext for correct guesses
  ///
  /// In en, this message translates to:
  /// **'Primes caught'**
  String get primesCaughtSubtext;

  /// Count of primes discovered
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Prime Discovered} other{{count} Primes Discovered}}'**
  String primesDiscovered(int count);

  /// Title of privacy policy modal dialog
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyDialogTitle;

  /// Title of the proximity dashboard
  ///
  /// In en, this message translates to:
  /// **'PROXIMITY WAVES'**
  String get proximityWaves;

  /// Tooltip to quit and disband room as host
  ///
  /// In en, this message translates to:
  /// **'Quit Match & Disband Room'**
  String get quitDisbandTooltip;

  /// Tooltip to quit and leave room as guest
  ///
  /// In en, this message translates to:
  /// **'Quit Game & Leave Room'**
  String get quitLeaveTooltip;

  /// Confirmation content for resetting stats
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your high score, streaks, and accuracy metrics.'**
  String get resetAllStatsConfirm;

  /// Title of stats reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset All Stats?'**
  String get resetAllStatsTitle;

  /// Confirm button label in reset stats dialog
  ///
  /// In en, this message translates to:
  /// **'Reset Everything'**
  String get resetEverything;

  /// Tooltip to reset match in multiplayer room
  ///
  /// In en, this message translates to:
  /// **'Reset Match (Host)'**
  String get resetMatchHostTooltip;

  /// Tooltip to reset sieve and score
  ///
  /// In en, this message translates to:
  /// **'Reset Sieve & Score'**
  String get resetSieveScoreTooltip;

  /// Button to trigger stats reset
  ///
  /// In en, this message translates to:
  /// **'Reset Stats'**
  String get resetStatsButton;

  /// Snackbar shown to host when leaving room
  ///
  /// In en, this message translates to:
  /// **'Room dismantled. Returned to solo mode.'**
  String get roomDismantledHostSnackbar;

  /// Snackbar shown to guest when leaving room
  ///
  /// In en, this message translates to:
  /// **'Left multiplayer room. Returned to solo mode.'**
  String get roomLeftGuestSnackbar;

  /// Best score display
  ///
  /// In en, this message translates to:
  /// **'Best: {highScore}'**
  String scoreBest(int highScore);

  /// Current score display
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreDisplay(int score);

  /// Snackbar message when guest attempts reset
  ///
  /// In en, this message translates to:
  /// **'Only the host can reset the match. Tap \"Leave Room\" to exit.'**
  String get soloOnlyHostReset;

  /// Label for 0 and 1 in factor inspector
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get startLabel;

  /// Tooltip for player stats button
  ///
  /// In en, this message translates to:
  /// **'Player Stats & Records'**
  String get statsDialogTooltip;

  /// Tooltip to step forward by 1
  ///
  /// In en, this message translates to:
  /// **'Step Forward'**
  String get stepForwardTooltip;

  /// Tooltip for the language switcher menu button
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguageTooltip;

  /// Tempo readout
  ///
  /// In en, this message translates to:
  /// **'Tempo: {tempo} Hz ({bpm} BPM)'**
  String tempoDisplay(String tempo, int bpm);

  /// Suffix when tempo is controlled by host
  ///
  /// In en, this message translates to:
  /// **' (Host)'**
  String get tempoHostSuffix;

  /// Tooltip when tempo slider is locked by host
  ///
  /// In en, this message translates to:
  /// **'Tempo is synchronized to the room host'**
  String get tempoSyncTooltip;

  /// Tooltip for tempo slider
  ///
  /// In en, this message translates to:
  /// **'Adjust tempo: Left / Right arrow keys'**
  String get tempoTooltip;

  /// Title of terms of service modal dialog
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceDialogTitle;

  /// Plural for total guesses
  ///
  /// In en, this message translates to:
  /// **'{total, plural, =1{1 guess} other{{total} guesses}}'**
  String totalGuesses(int total);

  /// Tooltip to unmute audio
  ///
  /// In en, this message translates to:
  /// **'Unmute Audio'**
  String get unmuteAudioTooltip;

  /// Badge in factor inspector for upcoming number
  ///
  /// In en, this message translates to:
  /// **'UPCOMING'**
  String get upcomingLabel;

  /// Tooltip for volume slider
  ///
  /// In en, this message translates to:
  /// **'Volume: {volume}%'**
  String volumeTooltip(int volume);

  /// Tooltip for button to switch to light mode
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get themeLightTooltip;

  /// Tooltip for button to switch to dark mode
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get themeDarkTooltip;
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
    'ja',
    'lt',
    'pt',
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
    case 'ja':
      return AppLocalizationsJa();
    case 'lt':
      return AppLocalizationsLt();
    case 'pt':
      return AppLocalizationsPt();
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
