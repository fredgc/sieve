import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sieve/models/audio_engine_native.dart';
import 'package:sieve/models/sieve_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('org.gchouse.sieve/audio');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          calls.add(call);
          if (call.method == 'init') return true;
          return null;
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initOrResume initializes SoundPool and sets initial volume', () async {
    final engine = AudioEngineImpl();
    await engine.initOrResume();

    expect(engine.isSampleLibraryLoaded, isTrue);
    expect(calls.map((c) => c.method), ['init', 'setVolume']);
    expect(calls[1].arguments, {'volume': 0.8});
  });

  test('playNumber sends polyphonic chord with harmonics for 12 = 2^2 * 3', () async {
    final engine = AudioEngineImpl();
    await engine.initOrResume();
    calls.clear();

    engine.playNumber(
      12,
      false,
      const [
        PrimeFactor(prime: 2, power: 2),
        PrimeFactor(prime: 3, power: 1),
      ],
      playHarmonics: true,
    );

    expect(calls.length, 1);
    expect(calls.first.method, 'playNotes');
    final args = calls.first.arguments as Map<Object?, Object?>;
    final notes = (args['notes'] as List<Object?>).cast<Map<Object?, Object?>>();

    // Base C3 (2), octave C4 (2^2), and G3 (3)
    expect(notes.length, 3);
    expect(notes[0]['anchor'], 'C3');
    expect(notes[0]['rate'] as double, closeTo(1.0, 0.01));
    expect(notes[1]['anchor'], 'C4');
    expect(notes[1]['rate'] as double, closeTo(1.0, 0.01));
    expect(notes[2]['anchor'], 'G3');
    expect(notes[2]['rate'] as double, closeTo(1.0, 0.01));
  });

  test('playNumber is silent for prime numbers', () async {
    final engine = AudioEngineImpl();
    await engine.initOrResume();
    calls.clear();

    engine.playNumber(7, true, const [PrimeFactor(prime: 7, power: 1)]);
    expect(calls, isEmpty);
  });

  test('setVolume and stopAll forward to native channel', () async {
    final engine = AudioEngineImpl();
    await engine.initOrResume();
    calls.clear();

    engine.setVolume(0.4);
    engine.stopAll();

    expect(calls.map((c) => c.method), ['setVolume', 'stopAll']);
    expect(calls.first.arguments, {'volume': 0.4});
  });
}
