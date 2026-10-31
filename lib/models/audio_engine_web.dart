import 'dart:math' as math;
import 'package:web/web.dart' as web;
import 'harmonic_palette.dart';
import 'sieve_engine.dart';

/// Web Audio API implementation providing zero-latency polyphonic harmonic synthesis.
class AudioEngineImpl {
  web.AudioContext? _ctx;
  web.DynamicsCompressorNode? _compressor;
  web.GainNode? _masterGain;

  /// Ensures AudioContext is active and resumed.
  /// Chrome blocks audio until a user gesture occurs; calling this inside any click/tap unlocks it.
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
        _masterGain!.gain.setValueAtTime(0.65, _ctx!.currentTime);

        _compressor!.connect(_masterGain!);
        _masterGain!.connect(_ctx!.destination);
      }

      if (_ctx!.state == 'suspended') {
        _ctx!.resume();
      }
    } catch (_) {}
  }

  void playNumber(int number, bool isPrime, List<PrimeFactor> factors, {bool playHarmonics = false}) {
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
      // Composite: Play all prime factors simultaneously as a musical chord
      final factorCount = factors.length;
      final gainPerFactor = (0.5 / math.sqrt(factorCount.toDouble())).clamp(0.12, 0.45);

      for (final f in factors) {
        final baseFreq = HarmonicPalette.getNote(f.prime).frequency;

        // Sound base prime note
        _playPianoTone(baseFreq, gainPerFactor, now);

        // For prime powers (e.g. 4 = 2², 8 = 2³), sound higher octave harmonics if enabled
        if (playHarmonics && f.power > 1) {
          for (int p = 2; p <= f.power; p++) {
            final octaveFreq = baseFreq * math.pow(2.0, (p - 1).toDouble());
            final octaveGain = gainPerFactor * (0.6 / p);
            _playPianoTone(octaveFreq, octaveGain, now, isOctave: true);
          }
        }
      }
    }
  }

  /// Plays a warm acoustic piano-style synthesized note with attack, body, and decay.
  void _playPianoTone(double frequency, double targetGain, num startTime, {bool isPrime = false, bool isOctave = false}) {
    if (_ctx == null || _compressor == null) return;

    try {
      // Warm fundamental oscillator (triangle gives wooden/acoustic hammer timbre)
      final osc = _ctx!.createOscillator();
      osc.type = isPrime ? 'sine' : 'triangle';
      osc.frequency.setValueAtTime(frequency, startTime);

      // Subtle second harmonic overtone for natural acoustic string resonance
      final overtone = _ctx!.createOscillator();
      overtone.type = 'sine';
      overtone.frequency.setValueAtTime(frequency * 2.0, startTime);

      final noteGain = _ctx!.createGain();
      final overtoneGain = _ctx!.createGain();

      // Envelope: instant 10ms hammer attack, natural exponential decay
      const attackTime = 0.012;
      final duration = isPrime ? 1.2 : 0.85;

      noteGain.gain.setValueAtTime(0.0001, startTime);
      noteGain.gain.exponentialRampToValueAtTime(targetGain, startTime + attackTime);
      noteGain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);

      overtoneGain.gain.setValueAtTime(0.0001, startTime);
      overtoneGain.gain.exponentialRampToValueAtTime(targetGain * 0.35, startTime + attackTime);
      overtoneGain.gain.exponentialRampToValueAtTime(0.0001, startTime + (duration * 0.7));

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
  void _playTransient(double frequency, double gain, num startTime, String waveType) {
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
