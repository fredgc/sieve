import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/multiplayer_engine.dart';
import '../l10n/l10n_extension.dart';

/// Shows the multiplayer lobby, join, and host dialog.
void showMultiplayerDialog(
  BuildContext context, {
  String? initialRoomCode,
  VoidCallback? onStartGame,
}) {
  showDialog(
    context: context,
    builder: (context) => MultiplayerDialog(
      initialRoomCode: initialRoomCode,
      onStartGame: onStartGame,
    ),
  );
}

class MultiplayerDialog extends StatefulWidget {
  final String? initialRoomCode;
  final VoidCallback? onStartGame;

  const MultiplayerDialog({super.key, this.initialRoomCode, this.onStartGame});

  @override
  State<MultiplayerDialog> createState() => _MultiplayerDialogState();
}

class _MultiplayerDialogState extends State<MultiplayerDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _joinCodeController = TextEditingController();
  final TextEditingController _joinNameController = TextEditingController();
  final TextEditingController _hostNameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, String>? _cachedSession;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialRoomCode != null && widget.initialRoomCode!.isNotEmpty) {
      _joinCodeController.text = widget.initialRoomCode!;
    }
    _checkRejoinSession();
  }

  Future<void> _checkRejoinSession() async {
    final cached = await MultiplayerEngine.instance.getCachedSession();
    if (mounted && cached != null && !MultiplayerEngine.instance.isInRoom) {
      setState(() {
        _cachedSession = cached;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _joinCodeController.dispose();
    _joinNameController.dispose();
    _hostNameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateRoom() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final name = _hostNameController.text.trim();
      await MultiplayerEngine.instance.createRoom(
        nickname: name.isEmpty ? 'Host' : name,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleJoinRoom() async {
    final code = _joinCodeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Please enter a 4-character room code.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final name = _joinNameController.text.trim();
      await MultiplayerEngine.instance.joinRoom(
        roomCode: code,
        nickname: name.isEmpty ? 'Player' : name,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleRejoin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await MultiplayerEngine.instance.rejoinActiveSession();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (!success) {
          _cachedSession = null;
          _errorMessage = 'Session expired or room is no longer active.';
        }
      });
    }
  }

  String _buildJoinUrl(String roomCode) {
    final origin = Uri.base.origin;
    return '$origin/?room=$roomCode';
  }

  void _copyInviteLink(String roomCode) {
    final url = _buildJoinUrl(roomCode);
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied invite link: $url'),
        backgroundColor: const Color(0xFF7B2CBF),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = (screenSize.width * 0.9).clamp(320.0, 560.0);

    return StreamBuilder<RoomState?>(
      stream: MultiplayerEngine.instance.roomStream,
      initialData: null,
      builder: (context, snapshot) {
        final room = snapshot.data;
        final isInRoom = MultiplayerEngine.instance.isInRoom && room != null;

        return AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF1E152A)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDark ? const Color(0xFF531183) : const Color(0xFFD1C4E9),
              width: 1.5,
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          title: Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: isDark
                    ? const Color(0xFF00B4D8)
                    : const Color(0xFF0284C7),
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                isInRoom ? 'Lobby: Room ${room.code}' : 'Multiplayer Challenge',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFFE0D0FF)
                      : const Color(0xFF2E1065),
                ),
              ),
              const Spacer(),
              if (isInRoom)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF240046)
                        : const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF7B2CBF)
                          : const Color(0xFFB39DDB),
                    ),
                  ),
                  child: Text(
                    '${room.players.length}/'
                    '${MultiplayerEngine.maxPlayersPerRoom} Players',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFD4C2FC)
                          : const Color(0xFF5B21B6),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          content: SizedBox(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (!isInRoom && _cachedSession != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06D6A0).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF06D6A0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.wifi_protected_setup_rounded,
                                color: Color(0xFF06D6A0),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Interrupted Game Found',
                                style: TextStyle(
                                  color: Color(0xFF06D6A0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You were recently connected to Room '
                            '${_cachedSession!['roomCode']} as '
                            '"${_cachedSession!['nickname']}".',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  MultiplayerEngine.instance
                                      .clearCachedSession();
                                  setState(() => _cachedSession = null);
                                },
                                child: const Text(
                                  'Dismiss',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleRejoin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF06D6A0),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Rejoin Match',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (isInRoom) ...[
                    _buildLobbyView(room, isDark),
                  ] else ...[
                    _buildJoinHostTabs(isDark),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            if (isInRoom) ...[
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  MultiplayerEngine.instance.leaveRoom();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: Colors.redAccent,
                ),
                label: Text(
                  MultiplayerEngine.instance.isHost
                      ? 'End Room (Host)'
                      : 'Leave Room',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (MultiplayerEngine.instance.isHost) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    MultiplayerEngine.instance.startMatch();
                    widget.onStartGame?.call();
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Match'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B2CBF),
                    foregroundColor: Colors.white,
                  ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close Lobby',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFD4C2FC)
                          : const Color(0xFF5B21B6),
                    ),
                  ),
                ),
              ],
            ] else ...[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFD4C2FC)
                        : const Color(0xFF5B21B6),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildJoinHostTabs(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: isDark
              ? const Color(0xFF00B4D8)
              : const Color(0xFF0284C7),
          labelColor: isDark
              ? const Color(0xFFE0D0FF)
              : const Color(0xFF2E1065),
          unselectedLabelColor:
              isDark ? Colors.white54 : const Color(0xFF6B7280),
          tabs: [
            Tab(
              icon: const Icon(Icons.login_rounded, size: 18),
              text: context.l10n.multiplayerJoinTab,
            ),
            Tab(
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              text: context.l10n.multiplayerHostTab,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Join View
              SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _joinCodeController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 4,
                      decoration: InputDecoration(
                        labelText: 'Room Code (4 Characters)',
                        hintText: 'e.g. 7K3W',
                        prefixIcon: Icon(
                          Icons.tag_rounded,
                          color: isDark
                              ? const Color(0xFF00B4D8)
                              : const Color(0xFF0284C7),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF13091F)
                            : const Color(0xFFF3F0F8),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _joinNameController,
                      decoration: InputDecoration(
                        labelText: 'Screen Name / Nickname',
                        hintText: 'e.g. Alice',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: isDark
                              ? const Color(0xFFD4C2FC)
                              : const Color(0xFF5B21B6),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF13091F)
                            : const Color(0xFFF3F0F8),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleJoinRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF00B4D8)
                            : const Color(0xFF0284C7),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            )
                          : Text(
                              context.l10n.multiplayerJoinMatch,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // Host View
              SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _hostNameController,
                      decoration: InputDecoration(
                        labelText: 'Host Screen Name',
                        hintText: 'e.g. Room Master',
                        prefixIcon: Icon(
                          Icons.stars_rounded,
                          color: isDark
                              ? const Color(0xFFFFD166)
                              : const Color(0xFFD97706),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF13091F)
                            : const Color(0xFFF3F0F8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Creates an ephemeral room (max 10 players) with '
                      'instant QR code sharing.',
                      style: TextStyle(
                        color:
                            isDark ? Colors.white54 : const Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleCreateRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2CBF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              context.l10n.multiplayerCreateRoom,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLobbyView(RoomState room, bool isDark) {
    final joinUrl = _buildJoinUrl(room.code);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Room Code Badge & Copy
        Center(
          child: Column(
            children: [
              Text(
                context.l10n.multiplayerRoomCode,
                style: TextStyle(
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                room.code,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: isDark
                      ? const Color(0xFFFFD166)
                      : const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // QR Code & Sharing Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF531183)
                      : const Color(0xFFD1C4E9),
                  width: 2,
                ),
              ),
              child: QrImageView(
                data: joinUrl,
                version: QrVersions.auto,
                size: 130.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _copyInviteLink(room.code),
                  icon: const Icon(Icons.link_rounded, size: 16),
                  label: Text(
                    context.l10n.multiplayerCopyLink,
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? const Color(0xFF00B4D8)
                        : const Color(0xFF0284C7),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF00B4D8)
                          : const Color(0xFF0284C7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (MultiplayerEngine.instance.isHost)
                  OutlinedButton.icon(
                    onPressed: () =>
                        MultiplayerEngine.instance.toggleLock(!room.isLocked),
                    icon: Icon(
                      room.isLocked ? Icons.lock : Icons.lock_open,
                      size: 16,
                    ),
                    label: Text(
                      room.isLocked
                          ? context.l10n.multiplayerLocked
                          : context.l10n.multiplayerLockRoom,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: room.isLocked
                          ? (isDark ? Colors.amber : const Color(0xFFD97706))
                          : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                      side: BorderSide(
                        color: room.isLocked
                            ? (isDark ? Colors.amber : const Color(0xFFD97706))
                            : (isDark
                                ? Colors.white38
                                : const Color(0xFFD1C4E9)),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(
          color: isDark ? const Color(0xFF380C59) : const Color(0xFFE5E7EB),
        ),
        const SizedBox(height: 8),
        Text(
          'CONNECTED PLAYERS',
          style: TextStyle(
            color: isDark ? const Color(0xFFD4C2FC) : const Color(0xFF5B21B6),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 150),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF13091F) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF531183) : const Color(0xFFE5E7EB),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: room.players.values.map((player) {
              final isMe =
                  player.id == MultiplayerEngine.instance.currentPlayerId;

              return ListTile(
                dense: true,
                leading: Icon(
                  player.isHost ? Icons.stars_rounded : Icons.person_rounded,
                  color: player.isHost
                      ? (isDark
                            ? const Color(0xFFFFD166)
                            : const Color(0xFFD97706))
                      : (isDark
                            ? const Color(0xFF00B4D8)
                            : const Color(0xFF0284C7)),
                  size: 20,
                ),
                title: Row(
                  children: [
                    Text(
                      player.name,
                      style: TextStyle(
                        color: isMe
                            ? (isDark
                                  ? const Color(0xFF06D6A0)
                                  : const Color(0xFF059669))
                            : (isDark
                                  ? Colors.white
                                  : const Color(0xFF1F2937)),
                        fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      Text(
                        context.l10n.multiplayerYouTag,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF06D6A0)
                              : const Color(0xFF059669),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: player.isOnline
                            ? (isDark
                                  ? const Color(0xFF06D6A0)
                                  : const Color(0xFF059669))
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Score: ${player.score}',
                      style: TextStyle(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF4B5563),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
