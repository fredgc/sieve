import 'sieve_engine.dart';

/// Fallback / mock audio implementation for non-web environments (unit tests, host CLI).
class AudioEngineImpl {
  bool get isSampleLibraryLoaded => false;

  Future<void> initOrResume() async {}

  void setVolume(double volume) {}

  void playNumber(
    int number,
    bool isPrime,
    List<PrimeFactor> factors, {
    bool playHarmonics = false,
  }) {}

  void stopAll() {}
}
