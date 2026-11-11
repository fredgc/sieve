import 'dart:js_interop';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:web/web.dart' as web;

import 'harmonic_palette.dart';
import 'sieve_engine.dart';

class _PianoAnchor {
  final String noteName;
  final double frequency;
  const _PianoAnchor(this.noteName, this.frequency);
}

/// Web Audio API implementation providing acoustic grand piano sample playback
/// with seamless overtone oscillator fallback.
class AudioEngineImpl {
  web.AudioContext? _ctx;
  web.DynamicsCompressorNode? _compressor;
  web.GainNode? _masterGain;
  final Map<String, web.AudioBuffer> _sampleBuffers = {};
  bool _isLoadingSamples = false;
  bool _samplesLoaded = false;
  double _volume = 0.8;

  bool get isSampleLibraryLoaded => _samplesLoaded;

  void setVolume(double volume) {
    _volume = volume;
    if (_ctx != null && _masterGain != null) {
      try {
        final gainValue = (_volume * 0.70).clamp(0.0, 1.0);
        _masterGain!.gain.setValueAtTime(gainValue, _ctx!.currentTime);
      } catch (_) {}
    }
  }

  static const List<_PianoAnchor> _anchors = [
    _PianoAnchor('C3', 130.8128),
    _PianoAnchor('G3', 195.9977),
    _PianoAnchor('C4', 261.6256),
    _PianoAnchor('E4', 329.6276),
    _PianoAnchor('C5', 523.2511),
    _PianoAnchor('A5', 880.0000),
    _PianoAnchor('C6', 1046.502),
  ];

  /// Ensures AudioContext is active and preloads acoustic piano sample anchors.
  Future<void> initOrResume() async {
    try {
      if (_ctx == null) {
        _ctx = web.AudioContext();
        _compressor = _ctx!.createDynamicsCompressor();
        _compressor!.threshold.setValueAtTime(-18.0, _ctx!.currentTime);
        _compressor!.knee.setValueAtTime(12.0, _ctx!.currentTime);
        _compressor!.ratio.setValueAtTime(8.0, _ctx!.currentTime);
        _compressor!.attack.setValueAtTime(0.003, _ctx!.currentTime);
        _compressor!.release.setValueAtTime(0.25, _ctx!.currentTime);

        _masterGain = _ctx!.createGain();
        _masterGain!.gain.setValueAtTime(
          (_volume * 0.70).clamp(0.0, 1.0),
          _ctx!.currentTime,
        );

        _compressor!.connect(_masterGain!);
        _masterGain!.connect(_ctx!.destination);
      }

      if (_ctx!.state == 'suspended') {
        _ctx!.resume();
      }

      _preloadSamples();
    } catch (_) {}
  }

  /// Loads and decodes acoustic piano sample anchors in parallel.
  Future<void> _preloadSamples() async {
    if (_ctx == null || _isLoadingSamples || _samplesLoaded) return;
    _isLoadingSamples = true;
    for (final anchor in _anchors) {
      if (_sampleBuffers.containsKey(anchor.noteName)) continue;
      try {
        final data = await rootBundle.load(
          'assets/audio/${anchor.noteName}.mp3',
        );
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        final audioBuffer = await _ctx!
            .decodeAudioData(bytes.buffer.toJS)
            .toDart;
        _sampleBuffers[anchor.noteName] = audioBuffer;
      } catch (_) {}
    }
    _samplesLoaded = _sampleBuffers.isNotEmpty;
    _isLoadingSamples = false;
  }

  /// Finds the closest anchor sample in pitch space to minimize pitch-shift stretch.
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

  /// Plays an acoustic grand piano sample dynamically pitch-shifted to target frequency.
  bool _playSampleTone(
    double targetFreq,
    double gain,
    num startTime, {
    bool isPrime = false,
  }) {
    if (_ctx == null || _compressor == null || _sampleBuffers.isEmpty)
      return false;

    final anchor = _findClosestAnchor(targetFreq);
    final buffer = _sampleBuffers[anchor.noteName];
    if (buffer == null) return false;

    try {
      final source = _ctx!.createBufferSource();
      source.buffer = buffer;

      // Realtime pitch shift using Web Audio playbackRate
      final playbackRate = targetFreq / anchor.frequency;
      source.playbackRate.setValueAtTime(playbackRate, startTime);

      final noteGain = _ctx!.createGain();
      final duration = isPrime ? 1.6 : 1.25;

      noteGain.gain.setValueAtTime(gain, startTime);
      noteGain.gain.setValueAtTime(gain * 0.7, startTime + duration - 0.2);
      noteGain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);

      source.connect(noteGain);
      noteGain.connect(_compressor!);

      source.start(startTime);
      source.stop(startTime + duration + 0.05);
      return true;
    } catch (_) {
      return false;
    }
  }

  void playNumber(
    int number,
    bool isPrime,
    List<PrimeFactor> factors, {
    bool playHarmonics = false,
  }) {
    if (_ctx == null) {
      initOrResume();
    }
    if (_ctx == null || _ctx!.state == 'suspended') return;

    final now = _ctx!.currentTime;

    if (number == 0) {
      // "Ready..." subtle low percussion knock
      _playTransient(220.0, 0.15, now, 'triangle');
      return;
    }
    if (number == 1) {
      // "Go!" bright upbeat click
      _playTransient(440.0, 0.2, now, 'sine');
      return;
    }

    if (isPrime) {
      // The first time we see a prime, do not play its tone.
      // Primes are silent and only played when they are part of a composite.
      return;
    } else {
      // Composite: Play all prime factors simultaneously as an acoustic chord
      final factorCount = factors.length;
      final gainPerFactor = (0.55 / math.sqrt(factorCount.toDouble())).clamp(
        0.14,
        0.50,
      );

      for (final f in factors) {
        final baseFreq = HarmonicPalette.getNote(f.prime).frequency;

        // Boost primes 2 and 3 so the fundamental bass root (C3) and perfect fifth (G3) are slightly louder
        double primeGain = gainPerFactor;
        if (f.prime == 2) {
          primeGain = (gainPerFactor * 1.35).clamp(0.18, 0.70);
        } else if (f.prime == 3) {
          primeGain = (gainPerFactor * 1.20).clamp(0.16, 0.65);
        }

        // Sound base prime note
        _playPianoTone(baseFreq, primeGain, now);

        // For prime powers (e.g. 4 = 2², 8 = 2³), sound higher octave harmonics if enabled
        if (playHarmonics && f.power > 1) {
          for (int p = 2; p <= f.power; p++) {
            final octaveFreq = baseFreq * math.pow(2.0, (p - 1).toDouble());
            final octaveGain = primeGain * (0.6 / p);
            _playPianoTone(octaveFreq, octaveGain, now, isOctave: true);
          }
        }
      }
    }
  }

  /// Plays an acoustic grand piano sample tone, or falls back to synthesized harmonic overtone oscillator.
  void _playPianoTone(
    double frequency,
    double targetGain,
    num startTime, {
    bool isPrime = false,
    bool isOctave = false,
  }) {
    if (_ctx == null || _compressor == null) return;

    // 1. Try real acoustic piano sample first
    final playedSample = _playSampleTone(
      frequency,
      targetGain,
      startTime,
      isPrime: isPrime,
    );
    if (playedSample) return;

    // 2. Synthesized harmonic overtone fallback if sample buffer is not yet decoded
    try {
      final osc = _ctx!.createOscillator();
      osc.type = isPrime ? 'sine' : 'triangle';
      osc.frequency.setValueAtTime(frequency, startTime);

      final overtone = _ctx!.createOscillator();
      overtone.type = 'sine';
      overtone.frequency.setValueAtTime(frequency * 2.0, startTime);

      final noteGain = _ctx!.createGain();
      final overtoneGain = _ctx!.createGain();

      const attackTime = 0.012;
      final duration = isPrime ? 1.2 : 0.85;

      noteGain.gain.setValueAtTime(0.0001, startTime);
      noteGain.gain.exponentialRampToValueAtTime(
        targetGain,
        startTime + attackTime,
      );
      noteGain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);

      overtoneGain.gain.setValueAtTime(0.0001, startTime);
      overtoneGain.gain.exponentialRampToValueAtTime(
        targetGain * 0.35,
        startTime + attackTime,
      );
      overtoneGain.gain.exponentialRampToValueAtTime(
        0.0001,
        startTime + (duration * 0.7),
      );

      osc.connect(noteGain);
      overtone.connect(overtoneGain);

      noteGain.connect(_compressor!);
      overtoneGain.connect(_compressor!);

      osc.start(startTime);
      overtone.start(startTime);

      osc.stop(startTime + duration + 0.05);
      overtone.stop(startTime + duration + 0.05);
    } catch (_) {}
  }

  /// Plays a quick acoustic click/transient (for clicks, primes, and countdown).
  void _playTransient(
    double frequency,
    double gain,
    num startTime,
    String waveType,
  ) {
    if (_ctx == null || _compressor == null) return;
    try {
      final osc = _ctx!.createOscillator();
      osc.type = waveType;
      osc.frequency.setValueAtTime(frequency, startTime);

      final g = _ctx!.createGain();
      g.gain.setValueAtTime(gain, startTime);
      g.gain.exponentialRampToValueAtTime(0.0001, startTime + 0.18);

      osc.connect(g);
      g.connect(_compressor!);

      osc.start(startTime);
      osc.stop(startTime + 0.2);
    } catch (_) {}
  }

  void stopAll() {
    try {
      _ctx?.suspend();
    } catch (_) {}
  }
}
