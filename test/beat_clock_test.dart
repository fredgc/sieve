import 'package:flutter_test/flutter_test.dart';
import 'package:sieve/models/beat_clock.dart';
import 'package:sieve/models/sieve_engine.dart';

void main() {
  group('BeatClock Unit Tests', () {
    late SieveEngine engine;
    late BeatClock clock;

    setUp(() {
      engine = SieveEngine();
      clock = BeatClock(engine: engine);
    });

    tearDown(() {
      clock.dispose();
    });

    test('Initial clock state is paused at 0.0 with 1.0 Hz', () {
      expect(clock.isPlaying, isFalse);
      expect(clock.speedHz, equals(1.0));
      expect(clock.currentFractionalN, equals(0.0));
    });

    test('Step forward advances engine by 1 integer and emits callbacks', () {
      SieveNumber? beatNumber;
      double? tickFraction;

      clock.onBeat = (n) => beatNumber = n;
      clock.onTick = (f) => tickFraction = f;

      final n1 = clock.stepForward();
      expect(n1.number, equals(1));
      expect(n1.specialStatus, equals('Go!'));
      expect(beatNumber?.number, equals(1));
      expect(tickFraction, equals(1.0));
      expect(clock.currentFractionalN, equals(1.0));

      final n2 = clock.stepForward();
      expect(n2.number, equals(2));
      expect(n2.isPrime, isTrue);
      expect(beatNumber?.number, equals(2));
      expect(clock.currentFractionalN, equals(2.0));
    });

    test('Reset resets clock position back to 0.0 and engine to 0', () {
      clock.stepForward();
      clock.stepForward();
      expect(clock.currentFractionalN, equals(2.0));

      clock.reset();
      expect(clock.currentFractionalN, equals(0.0));
      expect(engine.currentNumber, equals(0));
      expect(engine.discoveredPrimes, isEmpty);
    });

    test('Setting speed maintains non-negative valid rate', () {
      clock.speedHz = 2.5;
      expect(clock.speedHz, equals(2.5));

      clock.speedHz = -1.0;
      expect(clock.speedHz, greaterThan(0.0));
    });
  });
}
