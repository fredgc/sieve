// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get aboutAndHelpTooltip => '关于与帮助';

  @override
  String get aboutDialogClose => '关闭';

  @override
  String get aboutDialogHarmonicAnalogy => '泛音类比';

  @override
  String get aboutDialogPrivacyPolicy => '隐私政策';

  @override
  String get aboutDialogTermsOfService => '服务条款';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => '历史准确率';

  @override
  String get analogyDialogTitle => '视听类比';

  @override
  String get appTitle => '埃拉托斯特尼筛法';

  @override
  String get bestStreak => '最佳连续';

  @override
  String get bestStreakSubtext => '连续猜对素数';

  @override
  String get cancel => '取消';

  @override
  String cancelGuessTooltip(int number) {
    return '取消对 #$number 的猜测 (空格键)';
  }

  @override
  String get compositeLabel => '合数';

  @override
  String get compositesGuessedSubtext => '误猜合数';

  @override
  String get correctGuesses => '正确';

  @override
  String get countingBeginsAtZero => '从 0 开始计数。点击播放开始埃拉托斯特尼筛法。';

  @override
  String get endMatch => '结束比赛';

  @override
  String get endMatchDisbandTooltip => '结束比赛并解散房间';

  @override
  String get gameHelpClose => '明白了！开始游戏';

  @override
  String get gameHelpError => '无法加载游戏规则。';

  @override
  String get gameHelpTitle => '玩法说明';

  @override
  String get gameHelpTooltip => '玩法说明 (规则)';

  @override
  String get gridGo => '开始！';

  @override
  String get gridGuess => '预测';

  @override
  String get gridPrime => '素数';

  @override
  String get gridReady => '准备';

  @override
  String guessButtonActive(int number) {
    return '已猜测 #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return '猜测下一个 (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return '猜测下一个 #$number 是素数 (空格键)';
  }

  @override
  String get harmonicFrequency => '泛音频率';

  @override
  String get harmonicsLabel => '泛音';

  @override
  String get harmonicsOffTooltip => '关闭泛音（4 和 8 等素数幂将播放单音）';

  @override
  String get harmonicsOnTooltip => '开启泛音（4 和 8 等素数幂将播放多个八度音）';

  @override
  String get heroGo => '1 - 开始！';

  @override
  String heroPrime(int number) {
    return '$number - 素数！';
  }

  @override
  String get heroReady => '0 - 准备...';

  @override
  String get highScore => '最高分';

  @override
  String hostControls(String roomCode) {
    return '房主控制 (房间 $roomCode)';
  }

  @override
  String get incorrectGuesses => '错误';

  @override
  String get languageAuto => '自动 (系统)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest => '您将离开当前房间并返回单人模式。';

  @override
  String get leaveMultiplayerContentHost => '离开将解散所有玩家的房间并返回单人模式。';

  @override
  String get leaveMultiplayerTitleGuest => '离开多人游戏房间？';

  @override
  String get leaveMultiplayerTitleHost => '结束多人比赛？';

  @override
  String get leaveRoom => '离开房间';

  @override
  String get muteAudioTooltip => '静音';

  @override
  String get multiplayerCopyLink => '复制链接';

  @override
  String get multiplayerCreateRoom => '创建新房间';

  @override
  String get multiplayerCreatingRoom => '正在创建房间...';

  @override
  String get multiplayerEnterCode => '输入 4 位房间代码';

  @override
  String get multiplayerHostTab => '主持房间';

  @override
  String get multiplayerJoinMatch => '加入比赛';

  @override
  String get multiplayerJoinTab => '加入房间';

  @override
  String get multiplayerJoining => '正在加入房间...';

  @override
  String get multiplayerLockRoom => '锁定房间';

  @override
  String get multiplayerLocked => '房间已锁定';

  @override
  String get multiplayerMatchTooltip => '多人对战';

  @override
  String get multiplayerNicknameOptional => '您的昵称 (可选)';

  @override
  String multiplayerPlayersHeader(int count) {
    return '玩家 ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return '重新加入上一房间 ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => '房间代码';

  @override
  String get multiplayerYouTag => '(你)';

  @override
  String get newHighScoreBadge => '新纪录！';

  @override
  String get nextNumberIsTwo => '下一个数字是 2：第一个素数！';

  @override
  String get numberStreamGrid => '数字流网格';

  @override
  String get pauseTooltip => '暂停 (P)';

  @override
  String get playTooltip => '播放 (P)';

  @override
  String get playbackControlledByHost => '播放由房主控制。点击“离开房间”退出。';

  @override
  String get playerStatsTitle => '玩家统计与记录';

  @override
  String get pointsSubtext => '得分';

  @override
  String get primeFactors => '素因数';

  @override
  String get primeNumberBadge => '素数';

  @override
  String get primesCaughtSubtext => '捕获的素数';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已发现 $count 个素数',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => '隐私政策';

  @override
  String get proximityWaves => '邻近波';

  @override
  String get quitDisbandTooltip => '退出比赛并解散房间';

  @override
  String get quitLeaveTooltip => '退出游戏并离开房间';

  @override
  String get resetAllStatsConfirm => '这将永久删除您的最高分、连胜和准确率记录。';

  @override
  String get resetAllStatsTitle => '重置所有统计数据？';

  @override
  String get resetEverything => '重置一切';

  @override
  String get resetMatchHostTooltip => '重置比赛 (房主)';

  @override
  String get resetSieveScoreTooltip => '重置筛法和得分';

  @override
  String get resetStatsButton => '重置数据';

  @override
  String get roomDismantledHostSnackbar => '房间已解散。已返回单人模式。';

  @override
  String get roomLeftGuestSnackbar => '已离开房间。已返回单人模式。';

  @override
  String scoreBest(int highScore) {
    return '最高: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return '得分: $score';
  }

  @override
  String get soloOnlyHostReset => '只有房主才能重置比赛。';

  @override
  String get startLabel => '开始';

  @override
  String get statsDialogTooltip => '玩家统计与记录';

  @override
  String get stepForwardTooltip => '单步前进';

  @override
  String get switchLanguageTooltip => '切换语言';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return '速度: $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (房主)';

  @override
  String get tempoSyncTooltip => '速度已与房主同步';

  @override
  String get tempoTooltip => '调整速度：左 / 右方向键';

  @override
  String get termsOfServiceDialogTitle => '服务条款';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total 次猜测',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => '开启声音';

  @override
  String get upcomingLabel => '即将到来';

  @override
  String volumeTooltip(int volume) {
    return '音量: $volume%';
  }

  @override
  String get themeLightTooltip => '切换至浅色模式';

  @override
  String get themeDarkTooltip => '切换至深色模式';
}
