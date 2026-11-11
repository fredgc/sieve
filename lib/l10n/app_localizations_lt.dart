// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get aboutAndHelpTooltip => 'Apie ir pagalba';

  @override
  String get aboutDialogClose => 'Uždaryti';

  @override
  String get aboutDialogHarmonicAnalogy => 'Harmoninė analogija';

  @override
  String get aboutDialogPrivacyPolicy => 'Privatumo politika';

  @override
  String get aboutDialogTermsOfService => 'Paslaugų teikimo sąlygos';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => 'BENDRAS TIKSLUMAS';

  @override
  String get analogyDialogTitle => 'Garso ir vaizdo analogija';

  @override
  String get appTitle => 'Eratosteno rėtis';

  @override
  String get bestStreak => 'GERIAUSIA SERIJA';

  @override
  String get bestStreakSubtext => 'Pirminiai skaičiai iš eilės';

  @override
  String get cancel => 'Atšaukti';

  @override
  String cancelGuessTooltip(int number) {
    return 'Atšaukti spėjimą skaičiui #$number (Tarpas)';
  }

  @override
  String get compositeLabel => 'SUDĖTINIS';

  @override
  String get compositesGuessedSubtext => 'Spėti sudėtiniai';

  @override
  String get correctGuesses => 'TEISINGAI';

  @override
  String get countingBeginsAtZero =>
      'Skaičiavimas prasideda nuo 0. Spustelėkite Paleisti, kad pradėtumėte Eratosteno rėtį.';

  @override
  String get endMatch => 'Baigti mačą';

  @override
  String get endMatchDisbandTooltip => 'Baigti mačą ir išformuoti kambarį';

  @override
  String get gameHelpClose => 'Supratau! Žaiskime';

  @override
  String get gameHelpError => 'Nepavyko įkelti žaidimo taisyklių.';

  @override
  String get gameHelpTitle => 'Kaip žaisti';

  @override
  String get gameHelpTooltip => 'Kaip žaisti (Taisyklės)';

  @override
  String get gridGo => 'Pirmyn!';

  @override
  String get gridGuess => 'SPĖJIMAS';

  @override
  String get gridPrime => 'PIRMINIS';

  @override
  String get gridReady => 'Pasiruošę';

  @override
  String guessButtonActive(int number) {
    return 'Atspėta #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return 'Spėti kitą (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return 'Spėti, kad #$number yra pirminis (Tarpas)';
  }

  @override
  String get harmonicFrequency => 'Harmoninis dažnis';

  @override
  String get harmonicsLabel => 'Harmonikos';

  @override
  String get harmonicsOffTooltip =>
      'Išjungti harmonikas (pirminių laipsniai, tokie kaip 4 ir 8, skambės kaip viena nata)';

  @override
  String get harmonicsOnTooltip =>
      'Įjungti harmonikas (pirminių laipsniai, tokie kaip 4 ir 8, skambės per kelias oktavas)';

  @override
  String get heroGo => '1 - Pirmyn!';

  @override
  String heroPrime(int number) {
    return '$number - Pirminis!';
  }

  @override
  String get heroReady => '0 - Pasiruošę...';

  @override
  String get highScore => 'REKORDAS';

  @override
  String hostControls(String roomCode) {
    return 'Kambario valdymas (Kambarys $roomCode)';
  }

  @override
  String get incorrectGuesses => 'NETEISINGAI';

  @override
  String get languageAuto => 'Automatinis (Sistemos)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest =>
      'Išeisite iš kambario ir grįšite į vieno žaidėjo režimą.';

  @override
  String get leaveMultiplayerContentHost =>
      'Išėjus kambarys bus uždarytas visiems žaidėjams.';

  @override
  String get leaveMultiplayerTitleGuest => 'Išeiti iš kelių žaidėjų kambario?';

  @override
  String get leaveMultiplayerTitleHost => 'Baigti kelių žaidėjų mačą?';

  @override
  String get leaveRoom => 'Išeiti iš kambario';

  @override
  String get muteAudioTooltip => 'Nutildyti garsą';

  @override
  String get multiplayerCopyLink => 'Kopijuoti nuorodą';

  @override
  String get multiplayerCreateRoom => 'Sukurti naują kambarį';

  @override
  String get multiplayerCreatingRoom => 'Kuriamas kambarys...';

  @override
  String get multiplayerEnterCode => 'Įveskite 4 simbolių kambario kodą';

  @override
  String get multiplayerHostTab => 'Kurti kambarį';

  @override
  String get multiplayerJoinMatch => 'Prisijungti prie mačo';

  @override
  String get multiplayerJoinTab => 'Prisijungti prie kambario';

  @override
  String get multiplayerJoining => 'Jungiamasi prie kambario...';

  @override
  String get multiplayerLockRoom => 'Užrakinti kambarį';

  @override
  String get multiplayerLocked => 'Kambarys užrakintas';

  @override
  String get multiplayerMatchTooltip => 'Kelių žaidėjų mačas';

  @override
  String get multiplayerNicknameOptional => 'Jūsų slapyvardis (neprivaloma)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'ŽAIDĖJAI ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return 'Grįžti į ankstesnį kambarį ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'KAMBARIO KODAS';

  @override
  String get multiplayerYouTag => '(Jūs)';

  @override
  String get newHighScoreBadge => 'NAUJAS!';

  @override
  String get nextNumberIsTwo =>
      'Kitas skaičius yra 2: pats pirmasis pirminis skaičius!';

  @override
  String get numberStreamGrid => 'SKAIČIŲ SRAUTO TINKLELIS';

  @override
  String get pauseTooltip => 'Pauzė (P)';

  @override
  String get playTooltip => 'Paleisti (P)';

  @override
  String get playbackControlledByHost =>
      'Atkūrimą valdo kambario šeimininkas. Bakstelėkite „Išeiti iš kambario“, kad išeitumėte.';

  @override
  String get playerStatsTitle => 'Žaidėjo statistika ir rekordai';

  @override
  String get pointsSubtext => 'Taškai';

  @override
  String get primeFactors => 'Pirminiai daugikliai';

  @override
  String get primeNumberBadge => 'PIRMINIS SKAIČIUS';

  @override
  String get primesCaughtSubtext => 'Sugauti pirminiai';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atrasti pirminiai',
      one: '1 atrastas pirminis',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'Privatumo politika';

  @override
  String get proximityWaves => 'ARTUMO BANGOS';

  @override
  String get quitDisbandTooltip => 'Baigti mačą ir išformuoti kambarį';

  @override
  String get quitLeaveTooltip => 'Išeiti iš žaidimo ir kambario';

  @override
  String get resetAllStatsConfirm =>
      'Tai visam laikui ištrins jūsų rekordą, serijas ir tikslumo rodiklius.';

  @override
  String get resetAllStatsTitle => 'Iš naujo nustatyti visą statistiką?';

  @override
  String get resetEverything => 'Išvalyti viską';

  @override
  String get resetMatchHostTooltip => 'Iš naujo nustatyti mačą (Šeimininkas)';

  @override
  String get resetSieveScoreTooltip => 'Iš naujo nustatyti rėtį ir taškus';

  @override
  String get resetStatsButton => 'Išvalyti duomenis';

  @override
  String get roomDismantledHostSnackbar =>
      'Kambarys uždarytas. Grįžtama į solo režimą.';

  @override
  String get roomLeftGuestSnackbar =>
      'Išėjote iš kambario. Grįžtama į solo režimą.';

  @override
  String scoreBest(int highScore) {
    return 'Geriausias: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'Taškai: $score';
  }

  @override
  String get soloOnlyHostReset => 'Tik šeimininkas gali iš naujo pradėti mačą.';

  @override
  String get startLabel => 'PRADŽIA';

  @override
  String get statsDialogTooltip => 'Žaidėjo statistika ir rekordai';

  @override
  String get stepForwardTooltip => 'Žingsnis į priekį';

  @override
  String get switchLanguageTooltip => 'Keisti kalbą';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'Tempas: $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (Šeimininkas)';

  @override
  String get tempoSyncTooltip => 'Tempas sinchronizuojamas su šeimininku';

  @override
  String get tempoTooltip => 'Reguliuoti tempą: Kairėn / Dešinėn rodyklės';

  @override
  String get termsOfServiceDialogTitle => 'Paslaugų teikimo sąlygos';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total spėjimai',
      one: '1 spėjimas',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => 'Įjungti garsą';

  @override
  String get upcomingLabel => 'BŪSIMAS';

  @override
  String volumeTooltip(int volume) {
    return 'Garsumas: $volume%';
  }

  @override
  String get themeLightTooltip => 'Perjungti į šviesųjį režimą';

  @override
  String get themeDarkTooltip => 'Perjungti į tamsųjį režimą';
}
