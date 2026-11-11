import 'sieve_engine.dart';
import 'audio_engine_stub.dart'
    if (dart.library.js_interop) 'audio_engine_web.dart';

/// Universal Audio Engine singleton for polyphonic harmonic sieve playback.
class AudioEngine {
  static final AudioEngine instance = AudioEngine._();
  AudioEngine._();

  final AudioEngineImpl _impl = AudioEngineImpl();

  /// User mute preference. Default false (sound ON).
  bool isMuted = false;

  /// Master volume level (0.0 to 1.0). Default 0.8.
  double volume = 0.8;

  /// Whether to play octave harmonics for prime powers (e.g. 4 = 2², 8 = 2³).
  /// Default false. When false, only the single fundamental prime note is sounded.
  bool playHarmonics = false;

  /// Whether acoustic grand piano samples are loaded and ready.
  bool get isSampleLibraryLoaded => _impl.isSampleLibraryLoaded;

  /// Sets master volume and updates audio output gain.
  void setVolume(double val) {
    volume = val.clamp(0.0, 1.0);
    if (volume == 0.0) {
      isMuted = true;
    } else {
      isMuted = false;
    }
    _impl.setVolume(isMuted ? 0.0 : volume);
  }

  /// Toggle mute state.
  void toggleMute() {
    isMuted = !isMuted;
    if (!isMuted && volume == 0.0) {
      volume = 0.8;
    }
    _impl.setVolume(isMuted ? 0.0 : volume);
  }

  /// Initializes or unlocks audio on first user gesture (satisfying browser Autoplay Policy).
  Future<void> initOrResume() async {
    await _impl.initOrResume();
  }

  /// Plays the acoustic harmonic chord corresponding to this number.
  /// Primes are silent when first discovered and only play when part of a composite.
  void playNumber(SieveNumber sieveNum) {
    if (isMuted) return;
    if (sieveNum.isPrime) {
      // Primes are silent when first encountered; their tones are only sounded as factor voices in composites.
      return;
    }
    _impl.playNumber(
      sieveNum.number,
      sieveNum.isPrime,
      sieveNum.factors,
      playHarmonics: playHarmonics,
    );
  }

  /// Toggle harmonics state.
  void toggleHarmonics() {
    playHarmonics = !playHarmonics;
  }

  void stopAll() {
    _impl.stopAll();
  }
}
