import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sieve/models/game_stats.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('GameStats starts with empty metrics', () async {
    final stats = await GameStats.load();
    expect(stats.highScore, equals(0));
    expect(stats.bestStreak, equals(0));
    expect(stats.currentStreak, equals(0));
    expect(stats.totalCorrect, equals(0));
    expect(stats.totalIncorrect, equals(0));
    expect(stats.accuracyPercent, equals(0.0));
  });

  test('GameStats tracks correct guesses and streaks', () async {
    final stats = await GameStats.load();

    stats.recordGuess(isCorrect: true);
    expect(stats.currentStreak, equals(1));
    expect(stats.bestStreak, equals(1));
    expect(stats.totalCorrect, equals(1));
    expect(stats.totalIncorrect, equals(0));
    expect(stats.accuracyPercent, equals(100.0));

    stats.recordGuess(isCorrect: true);
    expect(stats.currentStreak, equals(2));
    expect(stats.bestStreak, equals(2));

    // Incorrect guess resets streak
    stats.recordGuess(isCorrect: false);
    expect(stats.currentStreak, equals(0));
    expect(stats.bestStreak, equals(2));
    expect(stats.totalCorrect, equals(2));
    expect(stats.totalIncorrect, equals(1));
    expect(stats.accuracyPercent, closeTo(66.66, 0.1));
  });

  test(
    'GameStats checkHighScore updates high score and sets new best flag',
    () async {
      final stats = await GameStats.load();

      stats.checkHighScore(5);
      expect(stats.highScore, equals(5));
      expect(stats.isNewHighScore, isTrue);

      // Score equal or lower doesn't update
      stats.checkHighScore(4);
      expect(stats.highScore, equals(5));
    },
  );

  test('GameStats clearAll wipes all metrics and stored values', () async {
    final stats = await GameStats.load();
    stats.recordGuess(isCorrect: true);
    stats.checkHighScore(10);

    await stats.clearAll();
    expect(stats.highScore, equals(0));
    expect(stats.bestStreak, equals(0));
    expect(stats.totalCorrect, equals(0));
    expect(stats.accuracyPercent, equals(0.0));
  });
}
