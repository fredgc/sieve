// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get aboutAndHelpTooltip => '情報 & ヘルプ';

  @override
  String get aboutDialogClose => '閉じる';

  @override
  String get aboutDialogHarmonicAnalogy => '倍音のアナロジー';

  @override
  String get aboutDialogPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get aboutDialogTermsOfService => '利用規約';

  @override
  String aboutDialogVersion(String version) {
    return 'v$version';
  }

  @override
  String accuracyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get allTimeAccuracy => '歴代精度';

  @override
  String get analogyDialogTitle => '視覚と聴覚のアナロジー';

  @override
  String get appTitle => 'エラトステネスの篩';

  @override
  String get bestStreak => 'ベスト連続';

  @override
  String get bestStreakSubtext => '連続正解素数';

  @override
  String get cancel => 'キャンセル';

  @override
  String cancelGuessTooltip(int number) {
    return '#$number の予測を取り消す (スペース)';
  }

  @override
  String get compositeLabel => '合成数';

  @override
  String get compositesGuessedSubtext => '間違えた合成数';

  @override
  String get correctGuesses => '正解';

  @override
  String get countingBeginsAtZero =>
      'カウントは 0 から始まります。再生を押してエラトステネスの篩を開始してください。';

  @override
  String get endMatch => 'マッチ終了';

  @override
  String get endMatchDisbandTooltip => 'マッチを終了してルームを解散';

  @override
  String get gameHelpClose => '了解！プレイする';

  @override
  String get gameHelpError => 'ゲームのルールを読み込めませんでした。';

  @override
  String get gameHelpTitle => '遊び方';

  @override
  String get gameHelpTooltip => '遊び方 (ルール)';

  @override
  String get gridGo => 'スタート！';

  @override
  String get gridGuess => '予測';

  @override
  String get gridPrime => '素数';

  @override
  String get gridReady => '準備';

  @override
  String guessButtonActive(int number) {
    return '予測中 #$number';
  }

  @override
  String guessButtonInactive(int number) {
    return '次を予測 (#$number)';
  }

  @override
  String guessNextTooltip(int number) {
    return '次の #$number を素数と予測 (スペース)';
  }

  @override
  String get harmonicFrequency => '倍音周波数';

  @override
  String get harmonicsLabel => '倍音';

  @override
  String get harmonicsOffTooltip => '倍音をオフにする (4や8のような素数のべき乗は単音で再生されます)';

  @override
  String get harmonicsOnTooltip => '倍音をオンにする (4や8のような素数のべき乗は複数オクターブで再生されます)';

  @override
  String get heroGo => '1 - スタート！';

  @override
  String heroPrime(int number) {
    return '$number - 素数！';
  }

  @override
  String get heroReady => '0 - 準備...';

  @override
  String get highScore => 'ハイスコア';

  @override
  String hostControls(String roomCode) {
    return 'ホストコントロール (ルーム $roomCode)';
  }

  @override
  String get incorrectGuesses => '不正解';

  @override
  String get languageAuto => '自動 (システム)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get leaveMultiplayerContentGuest => '現在のルームを退出してシングルプレイモードに戻ります。';

  @override
  String get leaveMultiplayerContentHost => '退出すると全員のルームが終了し、シングルプレイモードに戻ります。';

  @override
  String get leaveMultiplayerTitleGuest => 'マルチプレイルームを退出しますか？';

  @override
  String get leaveMultiplayerTitleHost => 'マルチプレイマッチを終了しますか？';

  @override
  String get leaveRoom => 'ルームを退出';

  @override
  String get muteAudioTooltip => '音声をミュート';

  @override
  String get multiplayerCopyLink => 'リンクをコピー';

  @override
  String get multiplayerCreateRoom => '新しいルームを作成';

  @override
  String get multiplayerCreatingRoom => 'ルーム作成中...';

  @override
  String get multiplayerEnterCode => '4文字のルームコードを入力';

  @override
  String get multiplayerHostTab => 'ルームを作成';

  @override
  String get multiplayerJoinMatch => 'マッチに参加';

  @override
  String get multiplayerJoinTab => 'ルームに参加';

  @override
  String get multiplayerJoining => 'ルームに参加中...';

  @override
  String get multiplayerLockRoom => 'ルームをロック';

  @override
  String get multiplayerLocked => 'ルームロック中';

  @override
  String get multiplayerMatchTooltip => 'マルチプレイマッチ';

  @override
  String get multiplayerNicknameOptional => 'ニックネーム (任意)';

  @override
  String multiplayerPlayersHeader(int count) {
    return 'プレイヤー ($count)';
  }

  @override
  String multiplayerRejoin(String roomCode) {
    return '以前のルームに再参加 ($roomCode)';
  }

  @override
  String get multiplayerRoomCode => 'ルームコード';

  @override
  String get multiplayerYouTag => '(あなた)';

  @override
  String get newHighScoreBadge => '新記録！';

  @override
  String get nextNumberIsTwo => '次の数字は 2: 最初の素数！';

  @override
  String get numberStreamGrid => '数字ストリームグリッド';

  @override
  String get pauseTooltip => '一時停止 (P)';

  @override
  String get playTooltip => '再生 (P)';

  @override
  String get playbackControlledByHost => '再生はホストが制御しています。「ルームを退出」をタップして終了します。';

  @override
  String get playerStatsTitle => 'プレイヤーの統計と記録';

  @override
  String get pointsSubtext => 'ポイント';

  @override
  String get primeFactors => '素因数';

  @override
  String get primeNumberBadge => '素数';

  @override
  String get primesCaughtSubtext => '正解した素数';

  @override
  String primesDiscovered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個の素数を発見',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicyDialogTitle => 'プライバシーポリシー';

  @override
  String get proximityWaves => '接近波';

  @override
  String get quitDisbandTooltip => 'マッチを終了してルームを解散';

  @override
  String get quitLeaveTooltip => 'ゲームを終了してルームを退出';

  @override
  String get resetAllStatsConfirm => 'ハイスコア、連続記録、精度メトリクスが完全に削除されます。';

  @override
  String get resetAllStatsTitle => 'すべての統計をリセットしますか？';

  @override
  String get resetEverything => 'すべてリセット';

  @override
  String get resetMatchHostTooltip => 'マッチをリセット (ホスト)';

  @override
  String get resetSieveScoreTooltip => '篩とスコアをリセット';

  @override
  String get resetStatsButton => 'データをリセット';

  @override
  String get roomDismantledHostSnackbar => 'ルームが解散されました。シングルプレイに戻ります。';

  @override
  String get roomLeftGuestSnackbar => 'ルームを退出しました。シングルプレイに戻ります。';

  @override
  String scoreBest(int highScore) {
    return 'ベスト: $highScore';
  }

  @override
  String scoreDisplay(int score) {
    return 'スコア: $score';
  }

  @override
  String get soloOnlyHostReset => 'ホストのみがマッチをリセットできます。「ルームを退出」をタップして終了します。';

  @override
  String get startLabel => 'スタート';

  @override
  String get statsDialogTooltip => 'プレイヤーの統計と記録';

  @override
  String get stepForwardTooltip => '1ステップ進む';

  @override
  String get switchLanguageTooltip => '言語を切り替える';

  @override
  String tempoDisplay(String tempo, int bpm) {
    return 'テンポ: $tempo Hz ($bpm BPM)';
  }

  @override
  String get tempoHostSuffix => ' (ホスト)';

  @override
  String get tempoSyncTooltip => 'テンポはホストに同期されています';

  @override
  String get tempoTooltip => 'テンポ調節: 左 / 右 矢印キー';

  @override
  String get termsOfServiceDialogTitle => '利用規約';

  @override
  String totalGuesses(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total 回の予測',
    );
    return '$_temp0';
  }

  @override
  String get unmuteAudioTooltip => '音声をオン';

  @override
  String get upcomingLabel => '次へ';

  @override
  String volumeTooltip(int volume) {
    return '音量: $volume%';
  }

  @override
  String get themeLightTooltip => 'ライトモードに切り替え';

  @override
  String get themeDarkTooltip => 'ダークモードに切り替え';
}
