import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'sieve_engine.dart';

typedef OnBeatCallback = void Function(SieveNumber number);
typedef OnTickCallback = void Function(double fractionalN);

/// Manages high-precision beat timing, fractional interpolation, and tempo control.
class BeatClock {
  final SieveEngine engine;

  /// Beats per second (Hz). Default 1.0 (60 BPM).
  double _speedHz = 1.0;

  /// Playback running state.
  bool _isPlaying = false;

  /// Stopwatch for zero-drift time tracking.
  final Stopwatch _stopwatch = Stopwatch();

  /// Fractional accumulator (starts at 0.0).
  double _baseFractionalN = 0.0;

  /// Periodic frame ticker.
  Ticker? _ticker;

  /// Fallback timer for environments where Ticker is not active.
  Timer? _fallbackTimer;

  /// Callbacks
  OnBeatCallback? onBeat;
  OnTickCallback? onTick;

  BeatClock({
    required this.engine,
    TickerProvider? vsync,
    this.onBeat,
    this.onTick,
  }) {
    if (vsync != null) {
      _ticker = vsync.createTicker(_handleTick);
    }
  }

  double get speedHz => _speedHz;
  set speedHz(double value) {
    if (value <= 0.05) value = 0.05;
    if (_isPlaying) {
      // Re-anchor time before changing speed to prevent jumps
      _baseFractionalN = currentFractionalN;
      _stopwatch.reset();
      _stopwatch.start();
    }
    _speedHz = value;
  }

  bool get isPlaying => _isPlaying;

  /// The current smooth fractional number N(t).
  double get currentFractionalN {
    if (!_isPlaying) {
      return _baseFractionalN;
    }
    final elapsedSec = _stopwatch.elapsedMicroseconds / 1000000.0;
    return _baseFractionalN + (elapsedSec * _speedHz);
  }

  /// Start or resume clock.
  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _stopwatch.reset();
    _stopwatch.start();

    if (_ticker != null) {
      _ticker!.start();
    } else {
      _fallbackTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
        _handleTick(Duration(microseconds: _stopwatch.elapsedMicroseconds));
      });
    }
  }

  /// Pause the clock.
  void pause() {
    if (!_isPlaying) return;
    _baseFractionalN = currentFractionalN;
    _stopwatch.stop();
    _isPlaying = false;
    _ticker?.stop();
    _fallbackTimer?.cancel();
    _fallbackTimer = null;
    onTick?.call(_baseFractionalN);
  }

  /// Toggle play / pause.
  void toggle() {
    if (_isPlaying) {
      pause();
    } else {
      start();
    }
  }

  /// Reset the clock and sieve to initial state at 0.
  void reset() {
    pause();
    engine.reset();
    _baseFractionalN = 0.0;
    _stopwatch.reset();
    onTick?.call(_baseFractionalN);
  }

  /// Advance by a single integer beat (useful when paused or in step-by-step mode).
  SieveNumber stepForward() {
    final wasPlaying = _isPlaying;
    if (wasPlaying) pause();

    final nextNumber = engine.step();
    _baseFractionalN = nextNumber.number.toDouble();
    onBeat?.call(nextNumber);
    onTick?.call(_baseFractionalN);
    return nextNumber;
  }

  /// Internal frame tick handler.
  void _handleTick(Duration _) {
    if (!_isPlaying) return;

    final fracN = currentFractionalN;
    final int targetInt = fracN.floor();

    // Trigger onBeat for every whole number reached
    while (engine.currentNumber < targetInt) {
      final sieveNum = engine.step();
      onBeat?.call(sieveNum);
    }

    onTick?.call(fracN);
  }

  void dispose() {
    pause();
    _ticker?.dispose();
    _ticker = null;
  }
}
