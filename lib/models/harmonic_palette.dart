import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Musical pitch information for a prime factor.
class PrimeNote {
  final int prime;
  final String noteName;
  final double frequency; // Frequency in Hz
  final int octave;

  const PrimeNote({
    required this.prime,
    required this.noteName,
    required this.frequency,
    required this.octave,
  });
}

/// Provides harmonious color mapping and acoustic overtone pitch mapping for primes.
class HarmonicPalette {
  /// Curated palette for the earliest foundational primes.
  static const Map<int, Color> _basePrimeColors = {
    2: Color(0xFF00B4D8), // Vibrant Azure / Cyan (Fundamental root)
    3: Color(0xFF06D6A0), // Emerald Green (Fifth)
    5: Color(0xFFFFD166), // Golden Amber (Major Third)
    7: Color(0xFFEF476F), // Radiant Coral / Red (Dominant Seventh)
    11: Color(0xFF9D4EDD), // Royal Electric Violet (Lydian 11th)
    13: Color(0xFFF72585), // Magenta / Neon Pink (13th)
    17: Color(0xFF4895EF), // Sky Blue
    19: Color(0xFFF77F00), // Deep Tangerine
    23: Color(0xFF4CC9F0), // Turquoise
    29: Color(0xFF52B788), // Sea Green
    31: Color(0xFFFFB703), // Marigold
  };

  /// Predefined overtone scale notes for small primes.
  static const Map<int, PrimeNote> _basePrimeNotes = {
    2: PrimeNote(prime: 2, noteName: 'C3', frequency: 130.81, octave: 3),
    3: PrimeNote(prime: 3, noteName: 'G3', frequency: 196.00, octave: 3),
    5: PrimeNote(prime: 5, noteName: 'E4', frequency: 329.63, octave: 4),
    7: PrimeNote(prime: 7, noteName: 'B♭4', frequency: 466.16, octave: 4),
    11: PrimeNote(prime: 11, noteName: 'F♯5', frequency: 739.99, octave: 5),
    13: PrimeNote(prime: 13, noteName: 'A5', frequency: 880.00, octave: 5),
  };

  /// Returns a consistent, vibrant color for any prime number.
  static Color getColor(int prime) {
    if (_basePrimeColors.containsKey(prime)) {
      return _basePrimeColors[prime]!;
    }

    // Golden ratio hue generation for higher primes to distribute hues evenly.
    final goldenRatioConjugate = 0.618033988749895;
    double h = ((prime * goldenRatioConjugate) % 1.0) * 360.0;
    return HSLColor.fromAHSL(1.0, h, 0.85, 0.60).toColor();
  }

  /// Returns musical pitch and note data for any prime.
  static PrimeNote getNote(int prime) {
    if (_basePrimeNotes.containsKey(prime)) {
      return _basePrimeNotes[prime]!;
    }

    // Calculate microtonal frequency using overtone just-intonation folded into octaves
    const double fundamentalC = 130.81; // C3
    double ratio = prime.toDouble();
    while (ratio >= 2.0) {
      ratio /= 2.0;
    }
    // Shift up to octaves 4-6
    final freq = fundamentalC * ratio * 4.0;
    final octave = 3 + (math.log(prime) / math.ln2).floor();

    return PrimeNote(
      prime: prime,
      noteName: 'P$prime',
      frequency: freq,
      octave: octave,
    );
  }

  /// Calculates frequency for a prime with multiplicity: f * 2^(power - 1).
  static double getFrequencyWithPower(int prime, int power) {
    final baseNote = getNote(prime);
    final multiplier = math.pow(2.0, (power - 1).toDouble()).toDouble();
    return baseNote.frequency * multiplier;
  }
}
