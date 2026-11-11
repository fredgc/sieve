// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get aboutAndHelpTooltip => 'Sobre e Ajuda';

  @override
  String get aboutDialogClose => 'Fechar';

  @override
  String get aboutDialogHarmonicAnalogy => 'Analogia Harmônica';

  @override
  String get aboutDialogPrivacyPolicy => 'Política de Privacidade';

  @override
  String get aboutDialogTermsOfService => 'Termos de Serviço';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => 'PRECISÃO TOTAL';

  @override
  String get analogyDialogTitle => 'Analogia Audiovisual';

  @override
  String get appTitle => 'Crivo de Eratóstenes';

  @override
  String get bestStreak => 'MELHOR SEQUÊNCIA';

  @override
  String get bestStreakSubtext => 'Primos seguidos';

  @override
  String get cancel => 'Cancelar';

  @override
  String cancelGuessTooltip(int number) {
    return 'Cancelar palpite para #$number (Espaço)';
  }

  @override
  String get compositeLabel => 'COMPOSTO';

  @override
  String get compositesGuessedSubtext => 'Compostos indicados';

  @override
  String get correctGuesses => 'CORRETO';

  @override
  String get countingBeginsAtZero =>
      'A contagem começa em 0. Pressione Reproduzir para iniciar o Crivo de Eratóstenes.';

  @override
  String get endMatch => 'Encerrar Partida';

  @override
  String get endMatchDisbandTooltip => 'Encerrar Partida e Fechar Sala';

  @override
  String get gameHelpClose => 'Entendi! Vamos Jogar';

  @override
  String get gameHelpError => 'Não foi possível carregar as regras do jogo.';

  @override
  String get gameHelpTitle => 'Como Jogar';

  @override
  String get gameHelpTooltip => 'Como Jogar (Regras do Jogo)';

  @override
  String get gridGo => 'Vai!';

  @override
  String get gridGuess => 'PALPITE';

  @override
  String get gridPrime => 'PRIMO';

  @override
  String get gridReady => 'Pronto';

  @override
  String guessButtonActive(int number) {
    return 'Palpite #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return 'Adivinhar Próximo (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return 'Adivinhar que #$number é Primo (Espaço)';
  }

  @override
  String get harmonicFrequency => 'Frequência Harmônica';

  @override
  String get harmonicsLabel => 'Harmônicos';

  @override
  String get harmonicsOffTooltip =>
      'Desativar harmônicos (potências como 4 e 8 tocarão nota única)';

  @override
  String get harmonicsOnTooltip =>
      'Ativar harmônicos (potências como 4 e 8 tocarão em múltiplas oitavas)';

  @override
  String get heroGo => '1 - Vai!';

  @override
  String heroPrime(int number) {
    return '$number - Primo!';
  }

  @override
  String get heroReady => '0 - Pronto...';

  @override
  String get highScore => 'RECORDE';

  @override
  String hostControls(String roomCode) {
    return 'Controles do Anfitrião (Sala $roomCode)';
  }

  @override
  String get incorrectGuesses => 'INCORRETO';

  @override
  String get languageAuto => 'Automático (Sistema)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest =>
      'Você sairá da sala atual e retornará ao modo solo.';

  @override
  String get leaveMultiplayerContentHost =>
      'Sair fechará a sala para todos os jogadores e você voltará ao modo solo.';

  @override
  String get leaveMultiplayerTitleGuest => 'Sair da Sala Multijogador?';

  @override
  String get leaveMultiplayerTitleHost => 'Encerrar Partida Multijogador?';

  @override
  String get leaveRoom => 'Sair da Sala';

  @override
  String get muteAudioTooltip => 'Silenciar Áudio';

  @override
  String get multiplayerCopyLink => 'Copiar Link';

  @override
  String get multiplayerCreateRoom => 'Criar Nova Sala';

  @override
  String get multiplayerCreatingRoom => 'Criando sala...';

  @override
  String get multiplayerEnterCode => 'Código da Sala de 4 caracteres';

  @override
  String get multiplayerHostTab => 'Criar Sala';

  @override
  String get multiplayerJoinMatch => 'Entrar na Partida';

  @override
  String get multiplayerJoinTab => 'Entrar na Sala';

  @override
  String get multiplayerJoining => 'Entrando na sala...';

  @override
  String get multiplayerLockRoom => 'Bloquear Sala';

  @override
  String get multiplayerLocked => 'Sala Bloqueada';

  @override
  String get multiplayerMatchTooltip => 'Partida Multijogador';

  @override
  String get multiplayerNicknameOptional => 'Seu Apelido (Opcional)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'JOGADORES ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return 'Voltar à Sala Anterior ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'CÓDIGO DA SALA';

  @override
  String get multiplayerYouTag => '(Você)';

  @override
  String get newHighScoreBadge => 'NOVO!';

  @override
  String get nextNumberIsTwo => 'O próximo número é 2: O primeiro primo!';

  @override
  String get numberStreamGrid => 'GRADE DE NÚMEROS';

  @override
  String get pauseTooltip => 'Pausar (P)';

  @override
  String get playTooltip => 'Reproduzir (P)';

  @override
  String get playbackControlledByHost =>
      'A reprodução é controlada pelo anfitrião. Toque em \"Sair da Sala\" para sair.';

  @override
  String get playerStatsTitle => 'Estatísticas e Recordes';

  @override
  String get pointsSubtext => 'Pontos';

  @override
  String get primeFactors => 'Fatores Primos';

  @override
  String get primeNumberBadge => 'NÚMERO PRIMO';

  @override
  String get primesCaughtSubtext => 'Primos acertados';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Primos Descobertos',
      one: '1 Primo Descoberto',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'Política de Privacidade';

  @override
  String get proximityWaves => 'ONDAS DE PROXIMIDADE';

  @override
  String get quitDisbandTooltip => 'Encerrar Partida e Fechar Sala';

  @override
  String get quitLeaveTooltip => 'Sair do Jogo e da Sala';

  @override
  String get resetAllStatsConfirm =>
      'Isso excluirá permanentemente seu recorde, sequências e precisão.';

  @override
  String get resetAllStatsTitle => 'Redefinir Estatísticas?';

  @override
  String get resetEverything => 'Redefinir Tudo';

  @override
  String get resetMatchHostTooltip => 'Reiniciar Partida (Anfitrião)';

  @override
  String get resetSieveScoreTooltip => 'Reiniciar Crivo e Pontuação';

  @override
  String get resetStatsButton => 'Redefinir Dados';

  @override
  String get roomDismantledHostSnackbar =>
      'Sala fechada. Retornando ao modo solo.';

  @override
  String get roomLeftGuestSnackbar =>
      'Você saiu da sala. Retornando ao modo solo.';

  @override
  String scoreBest(int highScore) {
    return 'Melhor: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'Pontos: $score';
  }

  @override
  String get soloOnlyHostReset =>
      'Apenas o anfitrião pode reiniciar a partida.';

  @override
  String get startLabel => 'INÍCIO';

  @override
  String get statsDialogTooltip => 'Estatísticas e Recordes';

  @override
  String get stepForwardTooltip => 'Avançar Passo';

  @override
  String get switchLanguageTooltip => 'Alterar idioma';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'Tempo: $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (Anfitrião)';

  @override
  String get tempoSyncTooltip => 'O tempo está sincronizado com o anfitrião';

  @override
  String get tempoTooltip => 'Ajustar tempo: Teclas seta Esquerda / Direita';

  @override
  String get termsOfServiceDialogTitle => 'Termos de Serviço';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total palpites',
      one: '1 palpite',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => 'Ativar Áudio';

  @override
  String get upcomingLabel => 'PRÓXIMO';

  @override
  String volumeTooltip(int volume) {
    return 'Volume: $volume%';
  }

  @override
  String get themeLightTooltip => 'Alternar para modo claro';

  @override
  String get themeDarkTooltip => 'Alternar para modo escuro';
}
