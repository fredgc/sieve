// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get aboutAndHelpTooltip => 'Über & Hilfe';

  @override
  String get aboutDialogClose => 'Schließen';

  @override
  String get aboutDialogHarmonicAnalogy => 'Harmonische Analogie';

  @override
  String get aboutDialogPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get aboutDialogTermsOfService => 'Nutzungsbedingungen';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => 'GESAMTGENAUIGKEIT';

  @override
  String get analogyDialogTitle => 'Audiovisuelle Analogie';

  @override
  String get appTitle => 'Sieb des Eratosthenes';

  @override
  String get bestStreak => 'BESTE SERIE';

  @override
  String get bestStreakSubtext => 'Primzahlen in Folge';

  @override
  String get cancel => 'Abbrechen';

  @override
  String cancelGuessTooltip(int number) {
    return 'Tipp für #$number abbrechen (Leertaste)';
  }

  @override
  String get compositeLabel => 'ZUSAMMENGESETZT';

  @override
  String get compositesGuessedSubtext => 'Zusammengesetzte getippt';

  @override
  String get correctGuesses => 'RICHTIG';

  @override
  String get countingBeginsAtZero =>
      'Das Zählen beginnt bei 0. Drücken Sie Wiedergabe, um das Sieb des Eratosthenes zu starten.';

  @override
  String get endMatch => 'Spiel beenden';

  @override
  String get endMatchDisbandTooltip => 'Spiel beenden & Raum auflösen';

  @override
  String get gameHelpClose => 'Verstanden! Los geht\'s';

  @override
  String get gameHelpError => 'Spielregeln konnten nicht geladen werden.';

  @override
  String get gameHelpTitle => 'Spielanleitung';

  @override
  String get gameHelpTooltip => 'Spielanleitung (Regeln)';

  @override
  String get gridGo => 'Los!';

  @override
  String get gridGuess => 'TIPP';

  @override
  String get gridPrime => 'PRIM';

  @override
  String get gridReady => 'Bereit';

  @override
  String guessButtonActive(int number) {
    return 'Getippt #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return 'Nächste tippen (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return 'Tippen, dass #$number eine Primzahl ist (Leertaste)';
  }

  @override
  String get harmonicFrequency => 'Harmonische Frequenz';

  @override
  String get harmonicsLabel => 'Obertöne';

  @override
  String get harmonicsOffTooltip =>
      'Obertöne ausschalten (Primzahlpotenzen wie 4 und 8 spielen einen einzelnen Ton)';

  @override
  String get harmonicsOnTooltip =>
      'Obertöne einschalten (Primzahlpotenzen wie 4 und 8 spielen mehrere Oktaven)';

  @override
  String get heroGo => '1 - Los!';

  @override
  String heroPrime(int number) {
    return '$number - Primzahl!';
  }

  @override
  String get heroReady => '0 - Bereit...';

  @override
  String get highScore => 'REKORD';

  @override
  String hostControls(String roomCode) {
    return 'Host-Steuerung (Raum $roomCode)';
  }

  @override
  String get incorrectGuesses => 'FALSCH';

  @override
  String get languageAuto => 'Automatisch (System)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest =>
      'Sie verlassen den Raum und kehren zum Einzelspielermodus zurück.';

  @override
  String get leaveMultiplayerContentHost =>
      'Das Verlassen beendet den Raum für alle Spieler und bringt Sie zum Einzelspielermodus zurück.';

  @override
  String get leaveMultiplayerTitleGuest => 'Mehrspieler-Raum verlassen?';

  @override
  String get leaveMultiplayerTitleHost => 'Mehrspieler-Spiel beenden?';

  @override
  String get leaveRoom => 'Raum verlassen';

  @override
  String get muteAudioTooltip => 'Ton stummschalten';

  @override
  String get multiplayerCopyLink => 'Link kopieren';

  @override
  String get multiplayerCreateRoom => 'Neuen Raum erstellen';

  @override
  String get multiplayerCreatingRoom => 'Raum wird erstellt...';

  @override
  String get multiplayerEnterCode => '4-stelligen Raumcode eingeben';

  @override
  String get multiplayerHostTab => 'Raum erstellen';

  @override
  String get multiplayerJoinMatch => 'Spiel beitreten';

  @override
  String get multiplayerJoinTab => 'Raum beitreten';

  @override
  String get multiplayerJoining => 'Raum wird beigetreten...';

  @override
  String get multiplayerLockRoom => 'Raum sperren';

  @override
  String get multiplayerLocked => 'Raum gesperrt';

  @override
  String get multiplayerMatchTooltip => 'Mehrspieler-Spiel';

  @override
  String get multiplayerNicknameOptional => 'Ihr Spitzname (optional)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'SPIELER ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return 'Vorherigem Raum beitreten ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'RAUMCODE';

  @override
  String get multiplayerYouTag => '(Du)';

  @override
  String get newHighScoreBadge => 'NEU!';

  @override
  String get nextNumberIsTwo => 'Nächste Zahl ist 2: Die allererste Primzahl!';

  @override
  String get numberStreamGrid => 'ZAHLENSTROM-GITTER';

  @override
  String get pauseTooltip => 'Pause (P)';

  @override
  String get playTooltip => 'Wiedergabe (P)';

  @override
  String get playbackControlledByHost =>
      'Wiedergabe wird vom Raum-Host gesteuert. Tippen Sie auf \"Raum verlassen\" zum Beenden.';

  @override
  String get playerStatsTitle => 'Spielerstatistiken & Rekorde';

  @override
  String get pointsSubtext => 'Punkte';

  @override
  String get primeFactors => 'Primfaktoren';

  @override
  String get primeNumberBadge => 'PRIMZAHL';

  @override
  String get primesCaughtSubtext => 'Primzahlen gefangen';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Primzahlen entdeckt',
      one: '1 Primzahl entdeckt',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'Datenschutzerklärung';

  @override
  String get proximityWaves => 'NÄHERUNGSWELLEN';

  @override
  String get quitDisbandTooltip => 'Spiel beenden & Raum auflösen';

  @override
  String get quitLeaveTooltip => 'Spiel verlassen & Raum verlassen';

  @override
  String get resetAllStatsConfirm =>
      'Dadurch werden Ihr Rekord, Serien und Genauigkeitswerte dauerhaft gelöscht.';

  @override
  String get resetAllStatsTitle => 'Alle Statistiken zurücksetzen?';

  @override
  String get resetEverything => 'Alles zurücksetzen';

  @override
  String get resetMatchHostTooltip => 'Spiel neu starten (Host)';

  @override
  String get resetSieveScoreTooltip => 'Sieb & Punktestand zurücksetzen';

  @override
  String get resetStatsButton => 'Statistiken zurücksetzen';

  @override
  String get roomDismantledHostSnackbar =>
      'Raum aufgelöst. Zurück zum Einzelspielermodus.';

  @override
  String get roomLeftGuestSnackbar =>
      'Raum verlassen. Zurück zum Einzelspielermodus.';

  @override
  String scoreBest(int highScore) {
    return 'Bester: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'Punkte: $score';
  }

  @override
  String get soloOnlyHostReset =>
      'Nur der Host kann das Spiel zurücksetzen. Tippen Sie auf \"Raum verlassen\" zum Beenden.';

  @override
  String get startLabel => 'START';

  @override
  String get statsDialogTooltip => 'Spielerstatistiken & Rekorde';

  @override
  String get stepForwardTooltip => 'Schritt vorwärts';

  @override
  String get switchLanguageTooltip => 'Sprache wechseln';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'Tempo: $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (Host)';

  @override
  String get tempoSyncTooltip => 'Tempo ist mit dem Host synchronisiert';

  @override
  String get tempoTooltip => 'Tempo anpassen: Pfeiltasten Links / Rechts';

  @override
  String get termsOfServiceDialogTitle => 'Nutzungsbedingungen';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total Tipps',
      one: '1 Tipp',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => 'Ton einschalten';

  @override
  String get upcomingLabel => 'DEMNÄCHST';

  @override
  String volumeTooltip(int volume) {
    return 'Lautstärke: $volume%';
  }

  @override
  String get themeLightTooltip => 'Zum hellen Modus wechseln';

  @override
  String get themeDarkTooltip => 'Zum dunklen Modus wechseln';
}
