import 'package:shared_preferences/shared_preferences.dart';

/// Manages persistence and metrics for the player's prime reflex challenge.
class GameStats {
  static const String _keyHighScore = 'sieve_high_score';
  static const String _keyBestStreak = 'sieve_best_streak';
  static const String _keyTotalCorrect = 'sieve_total_correct';
  static const String _keyTotalIncorrect = 'sieve_total_incorrect';

  int highScore = 0;
  int bestStreak = 0;
  int currentStreak = 0;
  int totalCorrect = 0;
  int totalIncorrect = 0;

  bool _isNewHighScore = false;
  bool get isNewHighScore => _isNewHighScore;

  /// Loads persisted stats from local storage.
  static Future<GameStats> load() async {
    final stats = GameStats();
    try {
      final prefs = await SharedPreferences.getInstance();
      stats.highScore = prefs.getInt(_keyHighScore) ?? 0;
      stats.bestStreak = prefs.getInt(_keyBestStreak) ?? 0;
      stats.totalCorrect = prefs.getInt(_keyTotalCorrect) ?? 0;
      stats.totalIncorrect = prefs.getInt(_keyTotalIncorrect) ?? 0;
    } catch (_) {}
    return stats;
  }

  /// Evaluates a guess for prime number. Returns whether the guess was correct.
  bool recordGuess({required bool isCorrect}) {
    if (isCorrect) {
      currentStreak++;
      totalCorrect++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
        _saveInt(_keyBestStreak, bestStreak);
      }
      _saveInt(_keyTotalCorrect, totalCorrect);
    } else {
      currentStreak = 0;
      totalIncorrect++;
      _saveInt(_keyTotalIncorrect, totalIncorrect);
    }
    return isCorrect;
  }

  /// Updates current game score and updates high score if beaten.
  void checkHighScore(int currentScore) {
    if (currentScore > highScore) {
      highScore = currentScore;
      _isNewHighScore = true;
      _saveInt(_keyHighScore, highScore);
    }
  }

  /// Resets session streak (e.g. on game replay).
  void resetSession() {
    currentStreak = 0;
    _isNewHighScore = false;
  }

  /// Clears all stored stats and high scores.
  Future<void> clearAll() async {
    highScore = 0;
    bestStreak = 0;
    currentStreak = 0;
    totalCorrect = 0;
    totalIncorrect = 0;
    _isNewHighScore = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyHighScore);
      await prefs.remove(_keyBestStreak);
      await prefs.remove(_keyTotalCorrect);
      await prefs.remove(_keyTotalIncorrect);
    } catch (_) {}
  }

  double get accuracyPercent {
    final total = totalCorrect + totalIncorrect;
    if (total == 0) return 0.0;
    return (totalCorrect / total) * 100.0;
  }

  void _saveInt(String key, int value) {
    SharedPreferences.getInstance()
        .then((prefs) {
          prefs.setInt(key, value);
        })
        .catchError((_) {});
  }
}
