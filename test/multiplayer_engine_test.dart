import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sieve/models/multiplayer_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MultiplayerEngine Unit & Data Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Room limits are clamped to 10 rooms and 10 players', () {
      expect(MultiplayerEngine.maxRoomsLimit, equals(10));
      expect(MultiplayerEngine.maxPlayersPerRoom, equals(10));
    });

    test('RoomPlayer serializes and deserializes correctly', () {
      final playerMap = {
        'name': 'Alice',
        'sessionToken': 'tok_123',
        'isHost': true,
        'isOnline': true,
        'score': 15,
        'streak': 4,
        'guessForNext': true,
        'lastSeen': 1730412000000,
      };

      final player = RoomPlayer.fromMap('player_1', playerMap);
      expect(player.id, equals('player_1'));
      expect(player.name, equals('Alice'));
      expect(player.isHost, isTrue);
      expect(player.score, equals(15));
      expect(player.streak, equals(4));
      expect(player.guessForNext, isTrue);

      final serialized = player.toMap();
      expect(serialized['name'], equals('Alice'));
      expect(serialized['score'], equals(15));
      expect(serialized['streak'], equals(4));
    });

    test('RoomState correctly computes status and player mapping', () {
      final roomMap = {
        'code': '7K3W',
        'status': 'playing',
        'hostId': 'host_1',
        'tempoHz': 1.5,
        'startServerTime': 1730412350000,
        'createdAt': 1730412340000,
        'lastActivity': 1730412345000,
        'isLocked': false,
        'players': {
          'host_1': {
            'name': 'Host Alice',
            'sessionToken': 'tok_host',
            'isHost': true,
            'isOnline': true,
            'score': 10,
            'streak': 3,
            'guessForNext': false,
            'lastSeen': 1730412345000,
          },
          'guest_2': {
            'name': 'Guest Bob',
            'sessionToken': 'tok_guest',
            'isHost': false,
            'isOnline': true,
            'score': 5,
            'streak': 1,
            'guessForNext': true,
            'lastSeen': 1730412345000,
          },
        },
      };

      final room = RoomState.fromMap('7K3W', roomMap);
      expect(room.code, equals('7K3W'));
      expect(room.isPlaying, isTrue);
      expect(room.isWaiting, isFalse);
      expect(room.isLocked, isFalse);
      expect(room.tempoHz, equals(1.5));
      expect(room.players.length, equals(2));
      expect(room.players['host_1']?.name, equals('Host Alice'));
      expect(room.players['guest_2']?.guessForNext, isTrue);
    });

    test(
      'Local session caching properly stores and clears session credentials',
      () async {
        final engine = MultiplayerEngine.instance;

        expect(await engine.getCachedSession(), isNull);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('sieve_multi_room_code', '7K3W');
        await prefs.setString('sieve_multi_player_id', 'player_abc');
        await prefs.setString('sieve_multi_session_token', 'token_secret');
        await prefs.setString('sieve_multi_nickname', 'Charlie');

        final cached = await engine.getCachedSession();
        expect(cached, isNotNull);
        expect(cached!['roomCode'], equals('7K3W'));
        expect(cached['playerId'], equals('player_abc'));
        expect(cached['sessionToken'], equals('token_secret'));
        expect(cached['nickname'], equals('Charlie'));

        await engine.clearCachedSession();
        expect(await engine.getCachedSession(), isNull);
      },
    );

    test('RoomState correctly calculates computeExpectedFracN during play and pause', () {
      final roomMapPlaying = {
        'code': '8X9Z',
        'status': 'playing',
        'hostId': 'h1',
        'tempoHz': 2.0,
        'startServerTime': 10000,
        'startFracN': 5.0,
        'createdAt': 8000,
        'lastActivity': 10000,
      };

      final playingRoom = RoomState.fromMap('8X9Z', roomMapPlaying);
      // Before startServerTime (in countdown)
      expect(playingRoom.computeExpectedFracN(9000), equals(5.0));
      // Exactly at startServerTime
      expect(playingRoom.computeExpectedFracN(10000), equals(5.0));
      // 2 seconds later at 2.0 Hz: 5.0 + 2.0 * 2.0 = 9.0
      expect(playingRoom.computeExpectedFracN(12000), equals(9.0));

      final roomMapPaused = {
        'code': '8X9Z',
        'status': 'paused',
        'hostId': 'h1',
        'tempoHz': 2.0,
        'startServerTime': 10000,
        'startFracN': 5.0,
        'pausedAtFracN': 12.5,
        'createdAt': 8000,
        'lastActivity': 14000,
      };

      final pausedRoom = RoomState.fromMap('8X9Z', roomMapPaused);
      expect(pausedRoom.computeExpectedFracN(20000), equals(12.5));
    });
  });
}
