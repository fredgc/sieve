// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aboutAndHelpTooltip => 'About & Help';

  @override
  String get aboutDialogClose => 'Close';

  @override
  String get aboutDialogHarmonicAnalogy => 'Harmonic Analogy';

  @override
  String get aboutDialogPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutDialogTermsOfService => 'Terms of Service';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => 'ALL-TIME ACCURACY';

  @override
  String get analogyDialogTitle => 'Audio-Visual Analogy';

  @override
  String get appTitle => 'Sieve of Eratosthenes';

  @override
  String get bestStreak => 'BEST STREAK';

  @override
  String get bestStreakSubtext => 'Primes in a row';

  @override
  String get cancel => 'Cancel';

  @override
  String cancelGuessTooltip(int number) {
    return 'Cancel Guess for #$number (Space)';
  }

  @override
  String get compositeLabel => 'COMPOSITE';

  @override
  String get compositesGuessedSubtext => 'Composites guessed';

  @override
  String get correctGuesses => 'CORRECT';

  @override
  String get countingBeginsAtZero =>
      'Counting begins at 0. Press Play to start the Sieve of Eratosthenes.';

  @override
  String get endMatch => 'End Match';

  @override
  String get endMatchDisbandTooltip => 'End Match & Disband Room';

  @override
  String get gameHelpClose => 'Got it! Let\'s Play';

  @override
  String get gameHelpError => 'Unable to load game rules.';

  @override
  String get gameHelpTitle => 'How to Play';

  @override
  String get gameHelpTooltip => 'How to Play (Game Rules)';

  @override
  String get gridGo => 'Go!';

  @override
  String get gridGuess => 'GUESS';

  @override
  String get gridPrime => 'PRIME';

  @override
  String get gridReady => 'Ready';

  @override
  String guessButtonActive(int number) {
    return 'Guessed #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return 'Guess Next (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return 'Guess Next #$number is Prime (Space)';
  }

  @override
  String get harmonicFrequency => 'Harmonic Frequency';

  @override
  String get harmonicsLabel => 'Harmonics';

  @override
  String get harmonicsOffTooltip =>
      'Turn off harmonics (prime powers like 4 and 8 will play a single note)';

  @override
  String get harmonicsOnTooltip =>
      'Turn on harmonics (prime powers like 4 and 8 will play multiple octave notes)';

  @override
  String get heroGo => '1 - Go!';

  @override
  String heroPrime(int number) {
    return '$number - Prime!';
  }

  @override
  String get heroReady => '0 - Ready...';

  @override
  String get highScore => 'HIGH SCORE';

  @override
  String hostControls(String roomCode) {
    return 'Host Controls (Room $roomCode)';
  }

  @override
  String get incorrectGuesses => 'INCORRECT';

  @override
  String get languageAuto => 'Auto (System)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest =>
      'You will leave the current room and return to solo mode.';

  @override
  String get leaveMultiplayerContentHost =>
      'Leaving will end the room for all players and return to solo mode.';

  @override
  String get leaveMultiplayerTitleGuest => 'Leave Multiplayer Room?';

  @override
  String get leaveMultiplayerTitleHost => 'End Multiplayer Match?';

  @override
  String get leaveRoom => 'Leave Room';

  @override
  String get muteAudioTooltip => 'Mute Audio';

  @override
  String get multiplayerCopyLink => 'Copy Link';

  @override
  String get multiplayerCreateRoom => 'Create New Room';

  @override
  String get multiplayerCreatingRoom => 'Creating room...';

  @override
  String get multiplayerEnterCode => 'Enter 4-character Room Code';

  @override
  String get multiplayerHostTab => 'Host Room';

  @override
  String get multiplayerJoinMatch => 'Join Match';

  @override
  String get multiplayerJoinTab => 'Join Room';

  @override
  String get multiplayerJoining => 'Joining room...';

  @override
  String get multiplayerLockRoom => 'Lock Room';

  @override
  String get multiplayerLocked => 'Room Locked';

  @override
  String get multiplayerMatchTooltip => 'Multiplayer Match';

  @override
  String get multiplayerNicknameOptional => 'Your Nickname (Optional)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'PLAYERS ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return 'Rejoin Previous Room ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'ROOM CODE';

  @override
  String get multiplayerYouTag => '(You)';

  @override
  String get newHighScoreBadge => 'NEW!';

  @override
  String get nextNumberIsTwo => 'Next number is 2: The very first prime!';

  @override
  String get numberStreamGrid => 'NUMBER STREAM GRID';

  @override
  String get pauseTooltip => 'Pause (P)';

  @override
  String get playTooltip => 'Play (P)';

  @override
  String get playbackControlledByHost =>
      'Playback is controlled by the room host. Tap \"Leave Room\" to exit.';

  @override
  String get playerStatsTitle => 'Player Stats & Records';

  @override
  String get pointsSubtext => 'Points';

  @override
  String get primeFactors => 'Prime Factors';

  @override
  String get primeNumberBadge => 'PRIME NUMBER';

  @override
  String get primesCaughtSubtext => 'Primes caught';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Primes Discovered',
      one: '1 Prime Discovered',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'Privacy Policy';

  @override
  String get proximityWaves => 'PROXIMITY WAVES';

  @override
  String get quitDisbandTooltip => 'Quit Match & Disband Room';

  @override
  String get quitLeaveTooltip => 'Quit Game & Leave Room';

  @override
  String get resetAllStatsConfirm =>
      'This will permanently delete your high score, streaks, and accuracy metrics.';

  @override
  String get resetAllStatsTitle => 'Reset All Stats?';

  @override
  String get resetEverything => 'Reset Everything';

  @override
  String get resetMatchHostTooltip => 'Reset Match (Host)';

  @override
  String get resetSieveScoreTooltip => 'Reset Sieve & Score';

  @override
  String get resetStatsButton => 'Reset Stats';

  @override
  String get roomDismantledHostSnackbar =>
      'Room dismantled. Returned to solo mode.';

  @override
  String get roomLeftGuestSnackbar =>
      'Left multiplayer room. Returned to solo mode.';

  @override
  String scoreBest(int highScore) {
    return 'Best: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'Score: $score';
  }

  @override
  String get soloOnlyHostReset =>
      'Only the host can reset the match. Tap \"Leave Room\" to exit.';

  @override
  String get startLabel => 'START';

  @override
  String get statsDialogTooltip => 'Player Stats & Records';

  @override
  String get stepForwardTooltip => 'Step Forward';

  @override
  String get switchLanguageTooltip => 'Switch Language';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'Tempo: $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (Host)';

  @override
  String get tempoSyncTooltip => 'Tempo is synchronized to the room host';

  @override
  String get tempoTooltip => 'Adjust tempo: Left / Right arrow keys';

  @override
  String get termsOfServiceDialogTitle => 'Terms of Service';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total guesses',
      one: '1 guess',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => 'Unmute Audio';

  @override
  String get upcomingLabel => 'UPCOMING';

  @override
  String volumeTooltip(int volume) {
    return 'Volume: $volume%';
  }

  @override
  String get themeLightTooltip => 'Switch to Light Mode';

  @override
  String get themeDarkTooltip => 'Switch to Dark Mode';
}
