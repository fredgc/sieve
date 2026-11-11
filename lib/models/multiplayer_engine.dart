import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';

/// Representation of a player in a multiplayer room.
class RoomPlayer {
  final String id;
  final String name;
  final String sessionToken;
  final bool isHost;
  final bool isOnline;
  final int score;
  final int streak;
  final bool guessForNext;
  final int lastSeen;

  const RoomPlayer({
    required this.id,
    required this.name,
    required this.sessionToken,
    required this.isHost,
    this.isOnline = true,
    this.score = 0,
    this.streak = 0,
    this.guessForNext = false,
    this.lastSeen = 0,
  });

  factory RoomPlayer.fromMap(String id, Map<dynamic, dynamic> map) {
    return RoomPlayer(
      id: id,
      name: map['name'] as String? ?? 'Player',
      sessionToken: map['sessionToken'] as String? ?? '',
      isHost: map['isHost'] as bool? ?? false,
      isOnline: map['isOnline'] as bool? ?? true,
      score: (map['score'] as num?)?.toInt() ?? 0,
      streak: (map['streak'] as num?)?.toInt() ?? 0,
      guessForNext: map['guessForNext'] as bool? ?? false,
      lastSeen: (map['lastSeen'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sessionToken': sessionToken,
      'isHost': isHost,
      'isOnline': isOnline,
      'score': score,
      'streak': streak,
      'guessForNext': guessForNext,
      'lastSeen': lastSeen,
    };
  }
}

/// Representation of the overall room state.
class RoomState {
  final String code;
  final String status; // 'waiting', 'playing', 'paused', 'finished'
  final String hostId;
  final double tempoHz;
  final int startServerTime;
  final double startFracN;
  final double? pausedAtFracN;
  final int createdAt;
  final int lastActivity;
  final bool isLocked;
  final Map<String, RoomPlayer> players;

  const RoomState({
    required this.code,
    required this.status,
    required this.hostId,
    required this.tempoHz,
    required this.startServerTime,
    this.startFracN = 0.0,
    this.pausedAtFracN,
    required this.createdAt,
    required this.lastActivity,
    this.isLocked = false,
    required this.players,
  });

  bool get isPlaying => status == 'playing';
  bool get isWaiting => status == 'waiting';
  bool get isPaused => status == 'paused';

  /// Computes expected fractional number N from synchronized server time.
  double computeExpectedFracN(int currentServerTimeMs) {
    if (isPaused) {
      return pausedAtFracN ?? startFracN;
    }
    if (isWaiting || startServerTime <= 0) {
      return 0.0;
    }
    if (currentServerTimeMs < startServerTime) {
      return startFracN;
    }
    final elapsedSec = (currentServerTimeMs - startServerTime) / 1000.0;
    return startFracN + (elapsedSec * tempoHz);
  }

  factory RoomState.fromMap(String code, Map<dynamic, dynamic> map) {
    final playersMap = <String, RoomPlayer>{};
    if (map['players'] is Map) {
      final rawPlayers = map['players'] as Map<dynamic, dynamic>;
      rawPlayers.forEach((key, val) {
        if (val is Map) {
          playersMap[key.toString()] = RoomPlayer.fromMap(key.toString(), val);
        }
      });
    }

    return RoomState(
      code: code,
      status: map['status'] as String? ?? 'waiting',
      hostId: map['hostId'] as String? ?? '',
      tempoHz: (map['tempoHz'] as num?)?.toDouble() ?? 1.0,
      startServerTime: (map['startServerTime'] as num?)?.toInt() ?? 0,
      startFracN: (map['startFracN'] as num?)?.toDouble() ?? 0.0,
      pausedAtFracN: (map['pausedAtFracN'] as num?)?.toDouble(),
      createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
      lastActivity: (map['lastActivity'] as num?)?.toInt() ?? 0,
      isLocked: map['isLocked'] as bool? ?? false,
      players: playersMap,
    );
  }
}

/// Engine managing Firebase Realtime Database multiplayer rooms,
/// quota safety limits (max 10 rooms, max 10 players), and dropout recovery.
class MultiplayerEngine {
  static final MultiplayerEngine instance = MultiplayerEngine._internal();
  MultiplayerEngine._internal();

  static const int maxRoomsLimit = 10;
  static const int maxPlayersPerRoom = 10;
  static const int roomInactivityLimitMs = 10 * 60 * 1000; // 10 minutes
  static const int reconnectGracePeriodMs = 3 * 60 * 1000; // 3 minutes

  static const String _prefKeyRoomCode = 'sieve_multi_room_code';
  static const String _prefKeyPlayerId = 'sieve_multi_player_id';
  static const String _prefKeySessionToken = 'sieve_multi_session_token';
  static const String _prefKeyNickname = 'sieve_multi_nickname';

  FirebaseDatabase? _database;
  bool _isFirebaseAvailable = false;
  int _serverTimeOffsetMs = 0;

  String? _currentRoomCode;
  String? _currentPlayerId;
  String? _currentSessionToken;
  String? _currentNickname;
  bool _isHost = false;
  RoomState? _currentRoomState;

  StreamSubscription<DatabaseEvent>? _roomSubscription;
  StreamSubscription<DatabaseEvent>? _offsetSubscription;
  final StreamController<RoomState?> _roomController =
      StreamController<RoomState?>.broadcast();

  bool get isFirebaseAvailable => _isFirebaseAvailable;
  String? get currentRoomCode => _currentRoomCode;
  String? get currentPlayerId => _currentPlayerId;
  String? get currentSessionToken => _currentSessionToken;
  String? get currentNickname => _currentNickname;
  bool get isHost => _isHost;
  bool get isInRoom => _currentRoomCode != null;
  RoomState? get currentRoomState => _currentRoomState;
  int get serverTimeOffsetMs => _serverTimeOffsetMs;
  Stream<RoomState?> get roomStream => _roomController.stream;

  @visibleForTesting
  void setTestState({
    String? roomCode,
    String? playerId,
    bool isHost = false,
    RoomState? roomState,
  }) {
    _currentRoomCode = roomCode;
    _currentPlayerId = playerId;
    _isHost = isHost;
    _currentRoomState = roomState;
    _roomController.add(roomState);
  }

  /// Approximate current UTC timestamp synchronized with Firebase server time.
  int get synchronizedServerTimeMs =>
      DateTime.now().millisecondsSinceEpoch + _serverTimeOffsetMs;

  /// Initializes Firebase and listens to server time offset.
  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _database = FirebaseDatabase.instance;
      _isFirebaseAvailable = true;

      // Listen to clock offset
      _offsetSubscription?.cancel();
      _offsetSubscription = _database
          ?.ref('.info/serverTimeOffset')
          .onValue
          .listen((event) {
            final offset = (event.snapshot.value as num?)?.toInt() ?? 0;
            _serverTimeOffsetMs = offset;
          });
    } catch (e) {
      _isFirebaseAvailable = false;
      debugPrint(
        'MultiplayerEngine: Firebase initialization skipped/failed: $e',
      );
    }
  }

  /// Checks local storage to see if an active session can be reconnected.
  Future<Map<String, String>?> getCachedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKeyRoomCode);
    final pid = prefs.getString(_prefKeyPlayerId);
    final token = prefs.getString(_prefKeySessionToken);
    final name = prefs.getString(_prefKeyNickname);

    if (code != null && pid != null && token != null) {
      return {
        'roomCode': code,
        'playerId': pid,
        'sessionToken': token,
        'nickname': name ?? 'Player',
      };
    }
    return null;
  }

  /// Clears stored session tokens from local storage.
  Future<void> clearCachedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyRoomCode);
    await prefs.remove(_prefKeyPlayerId);
    await prefs.remove(_prefKeySessionToken);
    await prefs.remove(_prefKeyNickname);
  }

  /// Saves session credentials for disconnect recovery.
  Future<void> _saveSession(
    String code,
    String pid,
    String token,
    String name,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyRoomCode, code);
    await prefs.setString(_prefKeyPlayerId, pid);
    await prefs.setString(_prefKeySessionToken, token);
    await prefs.setString(_prefKeyNickname, name);
  }

  /// Generates a random, unambiguous 4-character Base-32 alphanumeric room code.
  String _generateRoomCode() {
    const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    final rand = Random.secure();
    return List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  /// Generates a cryptographic session token.
  String _generateToken() {
    final rand = Random.secure();
    return List.generate(
      16,
      (_) => rand.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  /// Creates a new multiplayer room, enforcing the max 10 rooms limit.
  Future<String> createRoom({
    required String nickname,
    double tempoHz = 1.0,
  }) async {
    if (!_isFirebaseAvailable || _database == null) {
      throw Exception('Multiplayer database is not available.');
    }

    final roomsRef = _database!.ref('rooms');
    final snapshot = await roomsRef.get();

    // Check active rooms count and prune expired rooms
    if (snapshot.exists && snapshot.value is Map) {
      final existingRooms = snapshot.value as Map<dynamic, dynamic>;
      final now = synchronizedServerTimeMs;
      int activeCount = 0;

      for (final entry in existingRooms.entries) {
        if (entry.value is Map) {
          final room = entry.value as Map<dynamic, dynamic>;
          final lastActivity = (room['lastActivity'] as num?)?.toInt() ?? 0;
          if (now - lastActivity > roomInactivityLimitMs) {
            // Prune expired room
            roomsRef.child(entry.key.toString()).remove();
          } else {
            activeCount++;
          }
        }
      }

      if (activeCount >= maxRoomsLimit) {
        throw Exception(
          'Maximum room limit ($maxRoomsLimit active rooms) reached. Please try again later or join an existing room.',
        );
      }
    }

    final roomCode = _generateRoomCode();
    final playerId = 'host_${_generateToken().substring(0, 8)}';
    final sessionToken = _generateToken();
    final now = synchronizedServerTimeMs;

    final roomRef = roomsRef.child(roomCode);
    final roomData = {
      'code': roomCode,
      'status': 'waiting',
      'hostId': playerId,
      'tempoHz': tempoHz,
      'startServerTime': 0,
      'createdAt': now,
      'lastActivity': now,
      'isLocked': false,
      'players': {
        playerId: {
          'name': nickname.trim().isEmpty ? 'Host' : nickname.trim(),
          'sessionToken': sessionToken,
          'isHost': true,
          'isOnline': true,
          'score': 0,
          'streak': 0,
          'guessForNext': false,
          'lastSeen': now,
        },
      },
    };

    await roomRef.set(roomData);

    // Setup disconnect hook
    final playerRef = roomRef.child('players/$playerId');
    playerRef.onDisconnect().update({
      'isOnline': false,
      'lastSeen': ServerValue.timestamp,
    });

    _currentRoomCode = roomCode;
    _currentPlayerId = playerId;
    _currentSessionToken = sessionToken;
    _currentNickname = nickname;
    _isHost = true;

    await _saveSession(roomCode, playerId, sessionToken, nickname);
    _listenToRoom(roomCode);

    return roomCode;
  }

  /// Joins an existing room, enforcing max 10 players.
  Future<void> joinRoom({
    required String roomCode,
    required String nickname,
  }) async {
    if (!_isFirebaseAvailable || _database == null) {
      throw Exception('Multiplayer database is not available.');
    }

    final code = roomCode.trim().toUpperCase();
    final roomRef = _database!.ref('rooms/$code');
    final snapshot = await roomRef.get();

    if (!snapshot.exists || snapshot.value == null) {
      throw Exception('Room $code does not exist.');
    }

    final roomData = snapshot.value as Map<dynamic, dynamic>;
    if (roomData['isLocked'] == true) {
      throw Exception('Room $code is locked by the host.');
    }

    final playersMap = (roomData['players'] as Map<dynamic, dynamic>?) ?? {};
    if (playersMap.length >= maxPlayersPerRoom) {
      throw Exception('Room is full (max $maxPlayersPerRoom players).');
    }

    final playerId = 'player_${_generateToken().substring(0, 8)}';
    final sessionToken = _generateToken();
    final now = synchronizedServerTimeMs;

    final playerRef = roomRef.child('players/$playerId');
    await playerRef.set({
      'name': nickname.trim().isEmpty ? 'Player' : nickname.trim(),
      'sessionToken': sessionToken,
      'isHost': false,
      'isOnline': true,
      'score': 0,
      'streak': 0,
      'guessForNext': false,
      'lastSeen': now,
    });

    // Update room activity
    roomRef.update({'lastActivity': now});

    // Disconnect handling
    playerRef.onDisconnect().update({
      'isOnline': false,
      'lastSeen': ServerValue.timestamp,
    });

    _currentRoomCode = code;
    _currentPlayerId = playerId;
    _currentSessionToken = sessionToken;
    _currentNickname = nickname;
    _isHost = false;

    await _saveSession(code, playerId, sessionToken, nickname);
    _listenToRoom(code);
  }

  /// Reconnects to an active room after a network drop using the stored session token.
  Future<bool> rejoinActiveSession() async {
    final cached = await getCachedSession();
    if (cached == null || !_isFirebaseAvailable || _database == null) {
      return false;
    }

    final code = cached['roomCode']!;
    final pid = cached['playerId']!;
    final token = cached['sessionToken']!;

    try {
      final roomRef = _database!.ref('rooms/$code');
      final snapshot = await roomRef.get();

      if (!snapshot.exists || snapshot.value == null) {
        await clearCachedSession();
        return false;
      }

      final roomData = snapshot.value as Map<dynamic, dynamic>;
      final players = (roomData['players'] as Map<dynamic, dynamic>?) ?? {};
      final playerNode = players[pid] as Map<dynamic, dynamic>?;

      if (playerNode == null || playerNode['sessionToken'] != token) {
        await clearCachedSession();
        return false;
      }

      // Check inactivity
      final now = synchronizedServerTimeMs;
      final lastActivity = (roomData['lastActivity'] as num?)?.toInt() ?? 0;
      if (now - lastActivity > roomInactivityLimitMs) {
        await clearCachedSession();
        return false;
      }

      // Reconnect accepted! Update presence
      final playerRef = roomRef.child('players/$pid');
      await playerRef.update({'isOnline': true, 'lastSeen': now});

      playerRef.onDisconnect().update({
        'isOnline': false,
        'lastSeen': ServerValue.timestamp,
      });

      _currentRoomCode = code;
      _currentPlayerId = pid;
      _currentSessionToken = token;
      _currentNickname = cached['nickname'];
      _isHost = playerNode['isHost'] == true;

      _listenToRoom(code);
      return true;
    } catch (e) {
      debugPrint('Rejoin failed: $e');
      return false;
    }
  }

  /// Subscribes to live room state changes.
  void _listenToRoom(String code) {
    _roomSubscription?.cancel();
    _roomSubscription = _database!.ref('rooms/$code').onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        final state = RoomState.fromMap(
          code,
          event.snapshot.value as Map<dynamic, dynamic>,
        );
        _currentRoomState = state;
        _roomController.add(state);
      } else {
        _currentRoomState = null;
        _roomController.add(null);
        leaveRoom();
      }
    });
  }

  /// Starts the game with a 2-second countdown anchor.
  Future<void> startMatch({double tempoHz = 1.0}) async {
    if (!_isHost || _currentRoomCode == null || _database == null) return;
    final now = synchronizedServerTimeMs;
    final startTime = now + 2000; // 2 seconds in the future for countdown sync

    await _database!.ref('rooms/$_currentRoomCode').update({
      'status': 'playing',
      'tempoHz': tempoHz,
      'startServerTime': startTime,
      'startFracN': 0.0,
      'pausedAtFracN': null,
      'lastActivity': now,
    });
  }

  /// Pauses the current match.
  Future<void> pauseMatch({double? currentFracN}) async {
    if (!_isHost || _currentRoomCode == null || _database == null) return;
    final now = synchronizedServerTimeMs;
    await _database!.ref('rooms/$_currentRoomCode').update({
      'status': 'paused',
      'pausedAtFracN': ?currentFracN,
      'lastActivity': now,
    });
  }

  /// Resumes the current match.
  Future<void> resumeMatch({double? resumeFromFracN, double? tempoHz}) async {
    if (!_isHost || _currentRoomCode == null || _database == null) return;
    final now = synchronizedServerTimeMs;
    await _database!.ref('rooms/$_currentRoomCode').update({
      'status': 'playing',
      'startServerTime': now,
      'startFracN': ?resumeFromFracN,
      'pausedAtFracN': null,
      'tempoHz': ?tempoHz,
      'lastActivity': now,
    });
  }

  /// Resets the current match back to waiting with position 0 (host only).
  Future<void> resetMatch() async {
    if (!_isHost || _currentRoomCode == null || _database == null) return;
    final now = synchronizedServerTimeMs;
    await _database!.ref('rooms/$_currentRoomCode').update({
      'status': 'waiting',
      'startServerTime': 0,
      'startFracN': 0.0,
      'pausedAtFracN': null,
      'lastActivity': now,
    });
  }

  /// Updates room playback tempo and re-anchors time if provided (host only).
  Future<void> updateTempo(double tempoHz, {double? currentFracN}) async {
    if (!_isHost || _currentRoomCode == null || _database == null) return;
    final now = synchronizedServerTimeMs;
    await _database!.ref('rooms/$_currentRoomCode').update({
      'tempoHz': tempoHz,
      if (currentFracN != null) ...{
        'startServerTime': now,
        'startFracN': currentFracN,
      },
      'lastActivity': now,
    });
  }

  /// Toggles room lock to prevent unwanted walk-ins.
  Future<void> toggleLock(bool locked) async {
    if (!_isHost || _currentRoomCode == null || _database == null) return;
    await _database!.ref('rooms/$_currentRoomCode').update({
      'isLocked': locked,
      'lastActivity': synchronizedServerTimeMs,
    });
  }

  /// Submits the current player's prime prediction guess.
  Future<void> submitGuess({required bool guess}) async {
    if (_currentRoomCode == null ||
        _currentPlayerId == null ||
        _database == null)
      return;
    await _database!
        .ref('rooms/$_currentRoomCode/players/$_currentPlayerId')
        .update({'guessForNext': guess, 'lastSeen': synchronizedServerTimeMs});
  }

  /// Updates the player's score and streak in the room.
  Future<void> updateScore({required int score, required int streak}) async {
    if (_currentRoomCode == null ||
        _currentPlayerId == null ||
        _database == null)
      return;
    await _database!
        .ref('rooms/$_currentRoomCode/players/$_currentPlayerId')
        .update({
          'score': score,
          'streak': streak,
          'guessForNext': false,
          'lastSeen': synchronizedServerTimeMs,
        });
  }

  /// Leaves the current room and cleans up.
  Future<void> leaveRoom() async {
    final code = _currentRoomCode;
    final pid = _currentPlayerId;
    final db = _database;
    final isHostPlayer = _isHost;

    // Immediately cancel room stream listener so incoming Firebase events don't resurrect state
    _roomSubscription?.cancel();
    _roomSubscription = null;

    // Synchronously clear local state so UI updates instantaneously
    _currentRoomCode = null;
    _currentPlayerId = null;
    _currentSessionToken = null;
    _isHost = false;
    _currentRoomState = null;
    _roomController.add(null);

    // Clear saved session token
    await clearCachedSession();

    // Safely perform remote Firebase cleanup
    if (code != null && pid != null && db != null) {
      try {
        final roomRef = db.ref('rooms/$code');
        if (isHostPlayer) {
          await roomRef.remove();
        } else {
          await roomRef.child('players/$pid').remove();
        }
      } catch (e) {
        debugPrint('Error cleaning up room on Firebase: $e');
      }
    }
  }

  void dispose() {
    _roomSubscription?.cancel();
    _offsetSubscription?.cancel();
    _roomController.close();
  }
}
