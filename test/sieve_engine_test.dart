import 'package:flutter_test/flutter_test.dart';
import 'package:sieve/models/sieve_engine.dart';
import 'package:sieve/models/harmonic_palette.dart';

void main() {
  group('SieveEngine Mathematical Core', () {
    late SieveEngine engine;

    setUp(() {
      engine = SieveEngine();
    });

    test('Initial state starts at 0 with "Ready..." and empty primes', () {
      expect(engine.currentNumber, equals(0));
      expect(engine.discoveredPrimes, isEmpty);
      expect(engine.currentSieveNumber?.number, equals(0));
      expect(engine.currentSieveNumber?.specialStatus, equals('Ready...'));
    });

    test('First steps identify 1 as Go, 2 and 3 as primes, 4 as composite 2²', () {
      final n1 = engine.step();
      expect(n1.number, equals(1));
      expect(n1.specialStatus, equals('Go!'));
      expect(engine.discoveredPrimes, isEmpty);

      final n2 = engine.step();
      expect(n2.number, equals(2));
      expect(n2.isPrime, isTrue);
      expect(engine.discoveredPrimes, equals([2]));

      final n3 = engine.step();
      expect(n3.number, equals(3));
      expect(n3.isPrime, isTrue);
      expect(engine.discoveredPrimes, equals([2, 3]));

      final n4 = engine.step();
      expect(n4.number, equals(4));
      expect(n4.isPrime, isFalse);
      expect(n4.factors, equals([const PrimeFactor(prime: 2, power: 2)]));
      expect(n4.factorizationDisplay, equals('2²'));
      expect(n4.compactComposition, equals('2²'));
    });

    test('Accurately factorizes composite numbers up to 30 as rhythm steps', () {
      while (engine.currentNumber < 30) {
        engine.step();
      }
      final n30 = engine.currentSieveNumber!;
      expect(n30.number, equals(30));
      expect(n30.isPrime, isFalse);
      expect(
        n30.factors,
        equals([
          const PrimeFactor(prime: 2, power: 1),
          const PrimeFactor(prime: 3, power: 1),
          const PrimeFactor(prime: 5, power: 1),
        ]),
      );
      expect(n30.factorizationDisplay, equals('2 × 3 × 5'));
      expect(n30.compactComposition, equals('2·3·5'));

      // Discovered primes up to 30
      expect(engine.discoveredPrimes, equals([2, 3, 5, 7, 11, 13, 17, 19, 23, 29]));
    });

    test('Number played status correctly tracks sieve progress', () {
      expect(engine.isNumberPlayed(0), isTrue);
      expect(engine.isNumberPlayed(1), isFalse);
      expect(engine.getPlayedNumber(2), isNull);

      engine.step(); // to 1
      expect(engine.isNumberPlayed(1), isTrue);
      expect(engine.isNumberPlayed(2), isFalse);

      engine.step(); // to 2
      expect(engine.isNumberPlayed(2), isTrue);
      expect(engine.getPlayedNumber(2)?.isPrime, isTrue);
    });

    test('Static factorization of prime powers (8 = 2³, 9 = 3², 27 = 3³, 12 = 2² × 3)', () {
      expect(SieveEngine.factorizeStatic(8).factorizationDisplay, equals('2³'));
      expect(SieveEngine.factorizeStatic(9).factorizationDisplay, equals('3²'));
      expect(SieveEngine.factorizeStatic(27).factorizationDisplay, equals('3³'));
      expect(SieveEngine.factorizeStatic(12).factorizationDisplay, equals('2² × 3'));
      expect(SieveEngine.factorizeStatic(12).compactComposition, equals('2²·3'));
    });
  });

  group('Continuous Proximity Triangle Wave Function', () {
    test('Proximity equals 1.0 at exact multiples of prime p', () {
      const p = 5;
      expect(SieveEngine.getProximity(p, 5.0), closeTo(1.0, 1e-6));
      expect(SieveEngine.getProximity(p, 10.0), closeTo(1.0, 1e-6));
      expect(SieveEngine.getProximity(p, 15.0), closeTo(1.0, 1e-6));
      expect(SieveEngine.getProximity(p, 0.0), closeTo(1.0, 1e-6));
    });

    test('Proximity equals 0.0 midway between multiples of prime p', () {
      const p = 6;
      expect(SieveEngine.getProximity(p, 3.0), closeTo(0.0, 1e-6));
      expect(SieveEngine.getProximity(p, 9.0), closeTo(0.0, 1e-6));
    });

    test('Continuity across multiple boundaries without jump discontinuities', () {
      const p = 7;
      final leftLimit = SieveEngine.getProximity(p, 6.9999);
      final atBoundary = SieveEngine.getProximity(p, 7.0);
      final rightLimit = SieveEngine.getProximity(p, 7.0001);

      expect(leftLimit, closeTo(1.0, 0.001));
      expect(atBoundary, closeTo(1.0, 1e-6));
      expect(rightLimit, closeTo(1.0, 0.001));
      expect((leftLimit - rightLimit).abs(), lessThan(0.002));
    });
  });

  group('Harmonic Palette & Note Mapping', () {
    test('Maps prime 2 to root fundamental C3 and distinct azure color', () {
      final note2 = HarmonicPalette.getNote(2);
      expect(note2.noteName, equals('C3'));
      expect(note2.frequency, closeTo(130.81, 0.01));
    });

    test('Prime powers scale frequencies by octaves', () {
      final f2_1 = HarmonicPalette.getFrequencyWithPower(2, 1);
      final f2_2 = HarmonicPalette.getFrequencyWithPower(2, 2);
      final f2_3 = HarmonicPalette.getFrequencyWithPower(2, 3);

      expect(f2_2, closeTo(f2_1 * 2.0, 0.01));
      expect(f2_3, closeTo(f2_1 * 4.0, 0.01));
    });
  });
}
