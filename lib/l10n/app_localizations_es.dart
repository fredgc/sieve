// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get aboutAndHelpTooltip => 'Acerca de y Ayuda';

  @override
  String get aboutDialogClose => 'Cerrar';

  @override
  String get aboutDialogHarmonicAnalogy => 'Analogía Armónica';

  @override
  String get aboutDialogPrivacyPolicy => 'Política de Privacidad';

  @override
  String get aboutDialogTermsOfService => 'Términos de Servicio';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => 'PRECISIÓN TOTAL';

  @override
  String get analogyDialogTitle => 'Analogía Audiovisual';

  @override
  String get appTitle => 'Criba de Eratóstenes';

  @override
  String get bestStreak => 'MEJOR RACHA';

  @override
  String get bestStreakSubtext => 'Primos seguidos';

  @override
  String get cancel => 'Cancelar';

  @override
  String cancelGuessTooltip(int number) {
    return 'Cancelar predicción para #$number (Espacio)';
  }

  @override
  String get compositeLabel => 'COMPUESTO';

  @override
  String get compositesGuessedSubtext => 'Compuestos seleccionados';

  @override
  String get correctGuesses => 'CORRECTO';

  @override
  String get countingBeginsAtZero =>
      'El conteo comienza en 0. Pulsa Reproducir para iniciar la Criba de Eratóstenes.';

  @override
  String get endMatch => 'Terminar Partida';

  @override
  String get endMatchDisbandTooltip => 'Terminar Partida y Cerrar Sala';

  @override
  String get gameHelpClose => '¡Entendido! A Jugar';

  @override
  String get gameHelpError => 'No se pudieron cargar las reglas del juego.';

  @override
  String get gameHelpTitle => 'Cómo Jugar';

  @override
  String get gameHelpTooltip => 'Cómo Jugar (Reglas del Juego)';

  @override
  String get gridGo => '¡Ya!';

  @override
  String get gridGuess => 'PRED';

  @override
  String get gridPrime => 'PRIMO';

  @override
  String get gridReady => 'Listo';

  @override
  String guessButtonActive(int number) {
    return 'Elegido #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return 'Adivinar Siguiente (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return 'Adivinar que #$number es Primo (Espacio)';
  }

  @override
  String get harmonicFrequency => 'Frecuencia Armónica';

  @override
  String get harmonicsLabel => 'Armónicos';

  @override
  String get harmonicsOffTooltip =>
      'Desactivar armónicos (potencias como 4 y 8 sonarán como nota única)';

  @override
  String get harmonicsOnTooltip =>
      'Activar armónicos (potencias como 4 y 8 sonarán en múltiples octavas)';

  @override
  String get heroGo => '1 - ¡Ya!';

  @override
  String heroPrime(int number) {
    return '$number - ¡Primo!';
  }

  @override
  String get heroReady => '0 - Listo...';

  @override
  String get highScore => 'RÉCORD';

  @override
  String hostControls(String roomCode) {
    return 'Control del Anfitrión (Sala $roomCode)';
  }

  @override
  String get incorrectGuesses => 'INCORRECTO';

  @override
  String get languageAuto => 'Automático (Sistema)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest =>
      'Saldrás de la sala actual y volverás al modo individual.';

  @override
  String get leaveMultiplayerContentHost =>
      'Salir cerrará la sala para todos los jugadores y volverás al modo individual.';

  @override
  String get leaveMultiplayerTitleGuest => '¿Salir de la Sala Multijugador?';

  @override
  String get leaveMultiplayerTitleHost => '¿Terminar Partida Multijugador?';

  @override
  String get leaveRoom => 'Salir de la Sala';

  @override
  String get muteAudioTooltip => 'Silenciar Audio';

  @override
  String get multiplayerCopyLink => 'Copiar Enlace';

  @override
  String get multiplayerCreateRoom => 'Crear Nueva Sala';

  @override
  String get multiplayerCreatingRoom => 'Creando sala...';

  @override
  String get multiplayerEnterCode => 'Código de Sala de 4 caracteres';

  @override
  String get multiplayerHostTab => 'Crear Sala';

  @override
  String get multiplayerJoinMatch => 'Unirse a Partida';

  @override
  String get multiplayerJoinTab => 'Unirse a Sala';

  @override
  String get multiplayerJoining => 'Uniéndose a la sala...';

  @override
  String get multiplayerLockRoom => 'Bloquear Sala';

  @override
  String get multiplayerLocked => 'Sala Bloqueada';

  @override
  String get multiplayerMatchTooltip => 'Partida Multijugador';

  @override
  String get multiplayerNicknameOptional => 'Tu Apodo (Opcional)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'JUGADORES ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return 'Volver a Sala Anterior ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'CÓDIGO DE SALA';

  @override
  String get multiplayerYouTag => '(Tú)';

  @override
  String get newHighScoreBadge => '¡NUEVO!';

  @override
  String get nextNumberIsTwo => 'El siguiente número es 2: ¡El primer primo!';

  @override
  String get numberStreamGrid => 'CUADRÍCULA DE NÚMEROS';

  @override
  String get pauseTooltip => 'Pausa (P)';

  @override
  String get playTooltip => 'Reproducir (P)';

  @override
  String get playbackControlledByHost =>
      'La reproducción es controlada por el anfitrión. Pulsa \"Salir de la Sala\" para salir.';

  @override
  String get playerStatsTitle => 'Estadísticas y Récords';

  @override
  String get pointsSubtext => 'Puntos';

  @override
  String get primeFactors => 'Factores Primos';

  @override
  String get primeNumberBadge => 'NÚMERO PRIMO';

  @override
  String get primesCaughtSubtext => 'Primos acertados';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Primos Descubiertos',
      one: '1 Primo Descubierto',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'Política de Privacidad';

  @override
  String get proximityWaves => 'ONDAS DE PROXIMIDAD';

  @override
  String get quitDisbandTooltip => 'Terminar Partida y Cerrar Sala';

  @override
  String get quitLeaveTooltip => 'Salir del Juego y de la Sala';

  @override
  String get resetAllStatsConfirm =>
      'Esto borrará permanentemente tu récord, rachas y métricas de precisión.';

  @override
  String get resetAllStatsTitle => '¿Restablecer Estadísticas?';

  @override
  String get resetEverything => 'Restablecer Todo';

  @override
  String get resetMatchHostTooltip => 'Reiniciar Partida (Anfitrión)';

  @override
  String get resetSieveScoreTooltip => 'Reiniciar Criba y Puntuación';

  @override
  String get resetStatsButton => 'Restablecer Datos';

  @override
  String get roomDismantledHostSnackbar =>
      'Sala cerrada. Regresando al modo individual.';

  @override
  String get roomLeftGuestSnackbar =>
      'Saliste de la sala. Regresando al modo individual.';

  @override
  String scoreBest(int highScore) {
    return 'Mejor: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'Puntos: $score';
  }

  @override
  String get soloOnlyHostReset =>
      'Solo el anfitrión puede reiniciar la partida. Pulsa \"Salir de la Sala\" para salir.';

  @override
  String get startLabel => 'INICIO';

  @override
  String get statsDialogTooltip => 'Estadísticas y Récords';

  @override
  String get stepForwardTooltip => 'Avanzar Paso';

  @override
  String get switchLanguageTooltip => 'Cambiar idioma';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'Tempo: $tempo Hz ($bpm PPM)';
  }

  @override
  String get tempoHostSuffix => ' (Anfitrión)';

  @override
  String get tempoSyncTooltip => 'El tempo está sincronizado con el anfitrión';

  @override
  String get tempoTooltip => 'Ajustar tempo: Teclas flecha Izquierda / Derecha';

  @override
  String get termsOfServiceDialogTitle => 'Términos de Servicio';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total intentos',
      one: '1 intento',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => 'Activar Audio';

  @override
  String get upcomingLabel => 'PRÓXIMO';

  @override
  String volumeTooltip(int volume) {
    return 'Volumen: $volume%';
  }

  @override
  String get themeLightTooltip => 'Cambiar a modo claro';

  @override
  String get themeDarkTooltip => 'Cambiar a modo oscuro';
}
