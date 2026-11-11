// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get aboutAndHelpTooltip => 'À propos & Aide';

  @override
  String get aboutDialogClose => 'Fermer';

  @override
  String get aboutDialogHarmonicAnalogy => 'Analogie harmonique';

  @override
  String get aboutDialogPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get aboutDialogTermsOfService => 'Conditions d\'utilisation';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => 'PRÉCISION TOTALE';

  @override
  String get analogyDialogTitle => 'Analogie audiovisuelle';

  @override
  String get appTitle => 'Crible d\'Ératosthène';

  @override
  String get bestStreak => 'MEILLEURE SÉRIE';

  @override
  String get bestStreakSubtext => 'Nombres premiers consécutifs';

  @override
  String get cancel => 'Annuler';

  @override
  String cancelGuessTooltip(int number) {
    return 'Annuler la prédiction pour #$number (Espace)';
  }

  @override
  String get compositeLabel => 'COMPOSÉ';

  @override
  String get compositesGuessedSubtext => 'Composés prédits';

  @override
  String get correctGuesses => 'CORRECT';

  @override
  String get countingBeginsAtZero =>
      'Le comptage commence à 0. Appuyez sur Lecture pour démarrer le crible d\'Ératosthène.';

  @override
  String get endMatch => 'Terminer la partie';

  @override
  String get endMatchDisbandTooltip =>
      'Terminer la partie et dissoudre la salle';

  @override
  String get gameHelpClose => 'Compris ! Jouons';

  @override
  String get gameHelpError => 'Impossible de charger les règles du jeu.';

  @override
  String get gameHelpTitle => 'Comment jouer';

  @override
  String get gameHelpTooltip => 'Comment jouer (Règles)';

  @override
  String get gridGo => 'Partez !';

  @override
  String get gridGuess => 'PRÉD';

  @override
  String get gridPrime => 'PREMIER';

  @override
  String get gridReady => 'Prêt';

  @override
  String guessButtonActive(int number) {
    return 'Prédit #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return 'Prédire le suivant (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return 'Prédire que #$number est premier (Espace)';
  }

  @override
  String get harmonicFrequency => 'Fréquence harmonique';

  @override
  String get harmonicsLabel => 'Harmoniques';

  @override
  String get harmonicsOffTooltip =>
      'Désactiver les harmoniques (les puissances de premiers joueront une seule note)';

  @override
  String get harmonicsOnTooltip =>
      'Activer les harmoniques (les puissances de premiers joueront sur plusieurs octaves)';

  @override
  String get heroGo => '1 - Partez !';

  @override
  String heroPrime(int number) {
    return '$number - Premier !';
  }

  @override
  String get heroReady => '0 - Prêt...';

  @override
  String get highScore => 'MEILLEUR SCORE';

  @override
  String hostControls(String roomCode) {
    return 'Contrôles de l\'hôte (Salle $roomCode)';
  }

  @override
  String get incorrectGuesses => 'INCORRECT';

  @override
  String get languageAuto => 'Automatique (Système)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest =>
      'Vous allez quitter la salle actuelle et revenir en mode solo.';

  @override
  String get leaveMultiplayerContentHost =>
      'Quitter fermera la salle pour tous les joueurs et vous ramènera en mode solo.';

  @override
  String get leaveMultiplayerTitleGuest => 'Quitter la salle multijoueur ?';

  @override
  String get leaveMultiplayerTitleHost => 'Terminer la partie multijoueur ?';

  @override
  String get leaveRoom => 'Quitter la salle';

  @override
  String get muteAudioTooltip => 'Couper le son';

  @override
  String get multiplayerCopyLink => 'Copier le lien';

  @override
  String get multiplayerCreateRoom => 'Créer une salle';

  @override
  String get multiplayerCreatingRoom => 'Création de la salle...';

  @override
  String get multiplayerEnterCode => 'Code de salle à 4 caractères';

  @override
  String get multiplayerHostTab => 'Créer une salle';

  @override
  String get multiplayerJoinMatch => 'Rejoindre la partie';

  @override
  String get multiplayerJoinTab => 'Rejoindre une salle';

  @override
  String get multiplayerJoining => 'Connexion à la salle...';

  @override
  String get multiplayerLockRoom => 'Verrouiller la salle';

  @override
  String get multiplayerLocked => 'Salle verrouillée';

  @override
  String get multiplayerMatchTooltip => 'Partie multijoueur';

  @override
  String get multiplayerNicknameOptional => 'Votre pseudo (Optionnel)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'JOUEURS ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return 'Rejoindre la salle précédente ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'CODE DE LA SALLE';

  @override
  String get multiplayerYouTag => '(Vous)';

  @override
  String get newHighScoreBadge => 'NOUVEAU !';

  @override
  String get nextNumberIsTwo =>
      'Le nombre suivant est 2 : Le tout premier nombre premier !';

  @override
  String get numberStreamGrid => 'GRILLE DES NOMBRES';

  @override
  String get pauseTooltip => 'Pause (P)';

  @override
  String get playTooltip => 'Lecture (P)';

  @override
  String get playbackControlledByHost =>
      'La lecture est contrôlée par l\'hôte. Appuyez sur « Quitter la salle » pour sortir.';

  @override
  String get playerStatsTitle => 'Statistiques et records';

  @override
  String get pointsSubtext => 'Points';

  @override
  String get primeFactors => 'Facteurs premiers';

  @override
  String get primeNumberBadge => 'NOMBRE PREMIER';

  @override
  String get primesCaughtSubtext => 'Premiers trouvés';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count premiers découverts',
      one: '1 premier découvert',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'Politique de confidentialité';

  @override
  String get proximityWaves => 'ONDES DE PROXIMITÉ';

  @override
  String get quitDisbandTooltip => 'Quitter et dissoudre la salle';

  @override
  String get quitLeaveTooltip => 'Quitter le jeu et la salle';

  @override
  String get resetAllStatsConfirm =>
      'Cela supprimera définitivement votre meilleur score, vos séries et vos métriques.';

  @override
  String get resetAllStatsTitle => 'Réinitialiser toutes les statistiques ?';

  @override
  String get resetEverything => 'Tout réinitialiser';

  @override
  String get resetMatchHostTooltip => 'Réinitialiser la partie (Hôte)';

  @override
  String get resetSieveScoreTooltip => 'Réinitialiser le crible et le score';

  @override
  String get resetStatsButton => 'Réinitialiser les données';

  @override
  String get roomDismantledHostSnackbar => 'Salle fermée. Retour au mode solo.';

  @override
  String get roomLeftGuestSnackbar =>
      'Vous avez quitté la salle. Retour au mode solo.';

  @override
  String scoreBest(int highScore) {
    return 'Meilleur : $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'Score : $score';
  }

  @override
  String get soloOnlyHostReset =>
      'Seul l\'hôte peut réinitialiser la partie. Appuyez sur « Quitter la salle » pour sortir.';

  @override
  String get startLabel => 'DÉPART';

  @override
  String get statsDialogTooltip => 'Statistiques et records';

  @override
  String get stepForwardTooltip => 'Avancer d\'un pas';

  @override
  String get switchLanguageTooltip => 'Changer de langue';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'Tempo : $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (Hôte)';

  @override
  String get tempoSyncTooltip => 'Le tempo est synchronisé avec l\'hôte';

  @override
  String get tempoTooltip => 'Régler le tempo : Flèches Gauche / Droite';

  @override
  String get termsOfServiceDialogTitle => 'Conditions d\'utilisation';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total prédictions',
      one: '1 prédiction',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => 'Activer le son';

  @override
  String get upcomingLabel => 'À VENIR';

  @override
  String volumeTooltip(int volume) {
    return 'Volume : $volume%';
  }

  @override
  String get themeLightTooltip => 'Passer au mode clair';

  @override
  String get themeDarkTooltip => 'Passer au mode sombre';
}
