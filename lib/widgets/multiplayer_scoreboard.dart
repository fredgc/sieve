import 'package:flutter/material.dart';

import '../models/multiplayer_engine.dart';
import '../l10n/l10n_extension.dart';
import 'multiplayer_dialog.dart';

/// Compact HUD displaying real-time multiplayer leaderboard during gameplay.
class MultiplayerScoreboard extends StatelessWidget {
  const MultiplayerScoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoomState?>(
      stream: MultiplayerEngine.instance.roomStream,
      initialData: MultiplayerEngine.instance.currentRoomState,
      builder: (context, snapshot) {
        final room = snapshot.data;
        if (!MultiplayerEngine.instance.isInRoom || room == null) {
          return const SizedBox.shrink();
        }

        final sortedPlayers = room.players.values.toList()
          ..sort((a, b) => b.score.compareTo(a.score));

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF1E152A) : Colors.white)
                .withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF531183)
                  : const Color(0xFFC7B7E5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : const Color(0xFF9D4EDD).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => showMultiplayerDialog(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF240046)
                        : const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF00B4D8)
                          : const Color(0xFF0284C7),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: 14,
                        color: isDark
                            ? const Color(0xFF00B4D8)
                            : const Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        room.code,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE0D0FF)
                              : const Color(0xFF0369A1),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: sortedPlayers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final player = sortedPlayers[index];
                      final isMe =
                          player.id ==
                          MultiplayerEngine.instance.currentPlayerId;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? (isDark
                                  ? const Color(0xFF06D6A0)
                                      .withValues(alpha: 0.15)
                                  : const Color(0xFFDCFCE7))
                              : (isDark
                                  ? const Color(0xFF13091F)
                                  : const Color(0xFFF3EDFC)),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: player.guessForNext
                                ? (isDark
                                    ? const Color(0xFFFFD166)
                                    : const Color(0xFFD97706))
                                : (isMe
                                      ? (isDark
                                          ? const Color(0xFF06D6A0)
                                          : const Color(0xFF059669))
                                      : (isDark
                                          ? const Color(0xFF380C59)
                                          : const Color(0xFFDDD2EF))),
                            width: player.guessForNext ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (player.guessForNext) ...[
                              Icon(
                                Icons.bolt,
                                size: 12,
                                color: isDark
                                    ? const Color(0xFFFFD166)
                                    : const Color(0xFFD97706),
                              ),
                              const SizedBox(width: 2),
                            ],
                            Text(
                              player.name,
                              style: TextStyle(
                                color: isMe
                                    ? (isDark
                                        ? const Color(0xFF06D6A0)
                                        : const Color(0xFF059669))
                                    : (isDark
                                        ? Colors.white
                                        : const Color(0xFF1F1135)),
                                fontWeight: isMe
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${player.score}',
                              style: TextStyle(
                                color: player.score >= 0
                                    ? (isDark
                                        ? const Color(0xFF06D6A0)
                                        : const Color(0xFF059669))
                                    : const Color(0xFFDC2626),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                              ),
                            ),
                            if (player.streak > 1) ...[
                              const SizedBox(width: 4),
                              Text(
                                '🔥${player.streak}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: MultiplayerEngine.instance.isHost
                    ? context.l10n.endMatchDisbandTooltip
                    : context.l10n.leaveRoom,
                child: InkWell(
                  onTap: () async {
                    final wasHost = MultiplayerEngine.instance.isHost;
                    final l10n = context.l10n;
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: isDark
                            ? const Color(0xFF1E1035)
                            : Colors.white,
                        title: Text(
                          wasHost
                              ? l10n.leaveMultiplayerTitleHost
                              : l10n.leaveMultiplayerTitleGuest,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F1135),
                          ),
                        ),
                        content: Text(
                          wasHost
                              ? l10n.leaveMultiplayerContentHost
                              : l10n.leaveMultiplayerContentGuest,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFD4C2FC)
                                : const Color(0xFF5A4974),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(
                              l10n.cancel,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF5A4974),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE63946),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              wasHost ? l10n.endMatch : l10n.leaveRoom,
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await MultiplayerEngine.instance.leaveRoom();
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE63946).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFE63946),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      size: 14,
                      color: Color(0xFFE63946),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
