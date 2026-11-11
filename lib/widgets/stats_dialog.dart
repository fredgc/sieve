import 'package:flutter/material.dart';

import '../models/game_stats.dart';
import '../l10n/l10n_extension.dart';

/// Modal dialog displaying player performance metrics, high score,
/// and career stats.
void showGameStatsDialog(
  BuildContext context,
  GameStats stats, {
  VoidCallback? onStatsReset,
}) {
  showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          final total = stats.totalCorrect + stats.totalIncorrect;
          final accuracy = stats.accuracyPercent;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF531183)
                    : const Color(0xFFC7B7E5),
                width: 1.5,
              ),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: isDark
                      ? const Color(0xFFFFD166)
                      : const Color(0xFFD97706),
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  context.l10n.playerStatsTitle,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFE0D0FF)
                        : const Color(0xFF2E1065),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Highlights row: High Score & Best Streak
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: context.l10n.highScore,
                            value: '${stats.highScore}',
                            icon: Icons.military_tech_rounded,
                            iconColor: isDark
                                ? const Color(0xFFFFD166)
                                : const Color(0xFFD97706),
                            subtext: context.l10n.pointsSubtext,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildMetricCard(
                            title: context.l10n.bestStreak,
                            value: '${stats.bestStreak}',
                            icon: Icons.local_fire_department_rounded,
                            iconColor: const Color(0xFFFF8500),
                            subtext: context.l10n.bestStreakSubtext,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Breakdown Row: Correct, Incorrect, Accuracy
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: context.l10n.correctGuesses,
                            value: '${stats.totalCorrect}',
                            icon: Icons.check_circle_outline,
                            iconColor: isDark
                                ? const Color(0xFF06D6A0)
                                : const Color(0xFF059669),
                            subtext: context.l10n.primesCaughtSubtext,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildMetricCard(
                            title: context.l10n.incorrectGuesses,
                            value: '${stats.totalIncorrect}',
                            icon: Icons.cancel_outlined,
                            iconColor: const Color(0xFFEF476F),
                            subtext: context.l10n.compositesGuessedSubtext,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Accuracy Progress Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF130722)
                            : const Color(0xFFF7F5FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF380C59)
                              : const Color(0xFFE2D9F3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.allTimeAccuracy,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFA08FC2)
                                      : const Color(0xFF5A4974),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                context.l10n.accuracyPercent(
                                  accuracy.toStringAsFixed(1),
                                ),
                                style: TextStyle(
                                  color: accuracy >= 70.0
                                      ? (isDark
                                          ? const Color(0xFF06D6A0)
                                          : const Color(0xFF059669))
                                      : (accuracy >= 40.0
                                            ? (isDark
                                                ? const Color(0xFFFFD166)
                                                : const Color(0xFFD97706))
                                            : const Color(0xFFEF476F)),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: total == 0 ? 0.0 : (accuracy / 100.0),
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? const Color(0xFF240046)
                                  : const Color(0xFFE2D9F3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                accuracy >= 70.0
                                    ? (isDark
                                        ? const Color(0xFF06D6A0)
                                        : const Color(0xFF059669))
                                    : (accuracy >= 40.0
                                          ? (isDark
                                              ? const Color(0xFFFFD166)
                                              : const Color(0xFFD97706))
                                          : const Color(0xFFEF476F)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            total == 0
                                ? 'No prime predictions recorded yet.'
                                : context.l10n.totalGuesses(total),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF5A4974),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: isDark
                          ? const Color(0xFF1E152A)
                          : Colors.white,
                      title: Text(context.l10n.resetAllStatsTitle),
                      content: Text(context.l10n.resetAllStatsConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(context.l10n.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFEF476F),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.l10n.resetEverything),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await stats.clearAll();
                    setDialogState(() {});
                    onStatsReset?.call();
                  }
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Color(0xFFEF476F),
                ),
                label: Text(
                  context.l10n.resetStatsButton,
                  style: const TextStyle(
                    color: Color(0xFFEF476F),
                    fontSize: 12,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  context.l10n.aboutDialogClose,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildMetricCard({
  required String title,
  required String value,
  required IconData icon,
  required Color iconColor,
  required String subtext,
  required bool isDark,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF130722) : const Color(0xFFF7F5FA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF380C59) : const Color(0xFFE2D9F3),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFA08FC2)
                    : const Color(0xFF5A4974),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            Icon(icon, color: iconColor, size: 16),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: iconColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          subtext,
          style: TextStyle(
            color: isDark ? Colors.white54 : const Color(0xFF5A4974),
            fontSize: 10.5,
          ),
        ),
      ],
    ),
  );
}
