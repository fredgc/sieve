import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'harmonic_palette.dart';
import 'sieve_engine.dart';

class _PianoAnchor {
  final String noteName;
  final double frequency;
  const _PianoAnchor(this.noteName, this.frequency);
}

/// Native platform audio implementation using Android SoundPool via MethodChannel.
/// Safely no-ops on platforms without a native handler (e.g., host unit tests).
class AudioEngineImpl {
  static const MethodChannel _channel = MethodChannel(
    'org.gchouse.sieve/audio',
  );

  static const List<_PianoAnchor> _anchors = [
    _PianoAnchor('C3', 130.8128),
    _PianoAnchor('G3', 195.9977),
    _PianoAnchor('C4', 261.6256),
    _PianoAnchor('E4', 329.6276),
    _PianoAnchor('C5', 523.2511),
    _PianoAnchor('A5', 880.0000),
    _PianoAnchor('C6', 1046.502),
  ];

  bool _initialized = false;
  bool _samplesLoaded = false;
  double _volume = 0.8;

  bool get isSampleLibraryLoaded => _samplesLoaded;

  bool get _isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> initOrResume() async {
    if (!_isSupportedPlatform) return;
    try {
      final loaded = await _channel.invokeMethod<bool>('init');
      _initialized = true;
      if (loaded == true) {
        _samplesLoaded = true;
      }
      await _channel.invokeMethod<void>('setVolume', {'volume': _volume});
    } catch (_) {
      // Ignore if running in an environment without the native plugin.
    }
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    if (!_isSupportedPlatform) return;
    _channel.invokeMethod<void>('setVolume', {'volume': _volume}).catchError((
      _,
    ) {});
  }

  _PianoAnchor _findClosestAnchor(double targetFreq) {
    _PianoAnchor best = _anchors.first;
    double minDistance = (math.log(targetFreq / best.frequency)).abs();
    for (int i = 1; i < _anchors.length; i++) {
      final candidate = _anchors[i];
      final dist = (math.log(targetFreq / candidate.frequency)).abs();
      if (dist < minDistance) {
        minDistance = dist;
        best = candidate;
      }
    }
    return best;
  }

  Map<String, Object> _buildNotePayload(
    double targetFreq,
    double gain, {
    int durationMs = 1250,
  }) {
    final anchor = _findClosestAnchor(targetFreq);
    final rate = (targetFreq / anchor.frequency).clamp(0.5, 2.0);
    return <String, Object>{
      'anchor': anchor.noteName,
      'rate': rate,
      'gain': gain.clamp(0.0, 1.0),
      'durationMs': durationMs,
    };
  }

  void playNumber(
    int number,
    bool isPrime,
    List<PrimeFactor> factors, {
    bool playHarmonics = false,
  }) {
    if (!_isSupportedPlatform) return;
    if (!_initialized) {
      initOrResume();
    }

    final notes = <Map<String, Object>>[];

    if (number == 0) {
      notes.add(_buildNotePayload(220.0, 0.25, durationMs: 220));
    } else if (number == 1) {
      notes.add(_buildNotePayload(440.0, 0.30, durationMs: 220));
    } else if (isPrime) {
      return;
    } else {
      final factorCount = factors.length;
      if (factorCount == 0) return;

      final gainPerFactor = (0.55 / math.sqrt(factorCount.toDouble())).clamp(
        0.14,
        0.50,
      );

      for (final f in factors) {
        final baseFreq = HarmonicPalette.getNote(f.prime).frequency;

        double primeGain = gainPerFactor;
        if (f.prime == 2) {
          primeGain = (gainPerFactor * 1.35).clamp(0.18, 0.70);
        } else if (f.prime == 3) {
          primeGain = (gainPerFactor * 1.20).clamp(0.16, 0.65);
        }

        notes.add(_buildNotePayload(baseFreq, primeGain));

        if (playHarmonics && f.power > 1) {
          for (int p = 2; p <= f.power; p++) {
            final octaveFreq = baseFreq * math.pow(2.0, (p - 1).toDouble());
            final octaveGain = primeGain * (0.6 / p);
            notes.add(_buildNotePayload(octaveFreq, octaveGain));
          }
        }
      }
    }

    if (notes.isEmpty) return;
    _channel.invokeMethod<void>('playNotes', {'notes': notes}).catchError((
      _,
    ) {});
  }

  void stopAll() {
    if (!_isSupportedPlatform) return;
    _channel.invokeMethod<void>('stopAll').catchError((_) {});
  }
}
