import 'sieve_engine.dart';

/// Fallback / mock audio implementation for non-web environments (unit tests, host CLI).
class AudioEngineImpl {
  Future<void> initOrResume() async {}

  void playNumber(int number, bool isPrime, List<PrimeFactor> factors, {bool playHarmonics = false}) {}

  void stopAll() {}
}
