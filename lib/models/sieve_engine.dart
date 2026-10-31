/// Represents a single prime factor and its multiplicity (e.g., 2³ -> prime 2, power 3).
class PrimeFactor {
  final int prime;
  final int power;

  const PrimeFactor({required this.prime, required this.power});

  String toSuperscript() {
    if (power == 1) return '$prime';
    const superscripts = {
      '0': '⁰',
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
    };
    final powerStr = power.toString().split('').map((c) => superscripts[c] ?? c).join();
    return '$prime$powerStr';
  }

  @override
  String toString() => toSuperscript();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrimeFactor && runtimeType == other.runtimeType && prime == other.prime && power == other.power;

  @override
  int get hashCode => prime.hashCode ^ power.hashCode;
}

/// Represents the mathematical classification and factorization of a number in the sieve.
class SieveNumber {
  final int number;
  final bool isPrime;
  final List<PrimeFactor> factors;
  final String? specialStatus;

  const SieveNumber({
    required this.number,
    required this.isPrime,
    required this.factors,
    this.specialStatus,
  });

  /// Human-readable factorization: "Ready...", "Go!", "Prime!", or "2² × 3".
  String get factorizationDisplay {
    if (specialStatus != null) return specialStatus!;
    if (isPrime) return 'Prime!';
    if (factors.isEmpty) return '$number';
    return factors.map((f) => f.toSuperscript()).join(' × ');
  }

  /// Compact representation for grid cells: "Ready", "Go!", "PRIME", "2²·3"
  String get compactComposition {
    if (number == 0) return 'Ready...';
    if (number == 1) return 'Go!';
    if (isPrime) return 'PRIME';
    if (factors.isEmpty) return '';
    return factors.map((f) => f.toSuperscript()).join('·');
  }

  /// List of distinct prime factors without multiplicities.
  List<int> get distinctPrimes => factors.map((f) => f.prime).toList();

  @override
  String toString() => 'SieveNumber($number, isPrime: $isPrime, factors: $factorizationDisplay)';
}

/// Core deterministic Sieve of Eratosthenes engine.
class SieveEngine {
  /// Ordered list of primes discovered so far up to currentNumber.
  final List<int> _discoveredPrimes = [];

  /// Current integer position in the sieve (starts at 0).
  int _currentNumber = 0;

  /// Cache of evaluated numbers up to currentNumber.
  final Map<int, SieveNumber> _cache = {};

  SieveEngine() {
    reset();
  }

  /// Unmodifiable view of all primes discovered so far.
  List<int> get discoveredPrimes => List.unmodifiable(_discoveredPrimes);

  /// The current integer number.
  int get currentNumber => _currentNumber;

  /// The most recently evaluated number info.
  SieveNumber? get currentSieveNumber => _cache[_currentNumber];

  /// Reset the sieve back to initial state at 0.
  void reset() {
    _discoveredPrimes.clear();
    _cache.clear();
    _currentNumber = 0;
    _cache[0] = const SieveNumber(
      number: 0,
      isPrime: false,
      factors: [],
      specialStatus: 'Ready...',
    );
    _cache[1] = const SieveNumber(
      number: 1,
      isPrime: false,
      factors: [],
      specialStatus: 'Go!',
    );
  }

  /// Advance to the next integer in rhythm and evaluate it.
  SieveNumber step() {
    _currentNumber++;
    return _evaluateNumberAtCurrent(_currentNumber);
  }

  /// Evaluates an integer as the sieve reaches it.
  SieveNumber _evaluateNumberAtCurrent(int n) {
    if (_cache.containsKey(n)) {
      return _cache[n]!;
    }
    if (n == 0) {
      const res = SieveNumber(number: 0, isPrime: false, factors: [], specialStatus: 'Ready...');
      _cache[0] = res;
      return res;
    }
    if (n == 1) {
      const res = SieveNumber(number: 1, isPrime: false, factors: [], specialStatus: 'Go!');
      _cache[1] = res;
      return res;
    }

    final factors = <PrimeFactor>[];
    int remaining = n;

    // Trial division using primes discovered so far
    for (final p in _discoveredPrimes) {
      if (p * p > remaining) break;
      if (remaining % p == 0) {
        int count = 0;
        while (remaining % p == 0) {
          count++;
          remaining ~/= p;
        }
        factors.add(PrimeFactor(prime: p, power: count));
      }
    }

    if (remaining > 1) {
      if (factors.isEmpty && remaining == n) {
        // No prime factor <= sqrt(n) divides n -> n is a newly discovered Prime!
        _discoveredPrimes.add(n);
        final result = SieveNumber(
          number: n,
          isPrime: true,
          factors: [PrimeFactor(prime: n, power: 1)],
        );
        _cache[n] = result;
        return result;
      } else {
        // Remaining part is prime factor > sqrt(n)
        factors.add(PrimeFactor(prime: remaining, power: 1));
      }
    }

    final isPrime = factors.length == 1 && factors.first.power == 1 && factors.first.prime == n;
    if (isPrime && !_discoveredPrimes.contains(n)) {
      _discoveredPrimes.add(n);
    }
    final result = SieveNumber(number: n, isPrime: isPrime, factors: factors);
    _cache[n] = result;
    return result;
  }

  /// Returns information for an already played number (n <= currentNumber).
  /// Returns null if the number has not been played yet.
  SieveNumber? getPlayedNumber(int n) {
    if (n <= _currentNumber && _cache.containsKey(n)) {
      return _cache[n];
    }
    return null;
  }

  /// Whether a number has already been played.
  bool isNumberPlayed(int n) => n <= _currentNumber;

  /// Pure mathematical factorization helper for factor inspector or testing.
  /// Does NOT modify the active sieve state or discovered primes.
  static SieveNumber factorizeStatic(int n) {
    if (n == 0) return const SieveNumber(number: 0, isPrime: false, factors: [], specialStatus: 'Ready...');
    if (n == 1) return const SieveNumber(number: 1, isPrime: false, factors: [], specialStatus: 'Go!');

    final factors = <PrimeFactor>[];
    int remaining = n;
    int d = 2;
    while (d * d <= remaining) {
      if (remaining % d == 0) {
        int count = 0;
        while (remaining % d == 0) {
          count++;
          remaining ~/= d;
        }
        factors.add(PrimeFactor(prime: d, power: count));
      }
      d = (d == 2) ? 3 : d + 2;
    }
    if (remaining > 1) {
      factors.add(PrimeFactor(prime: remaining, power: 1));
    }
    final isPrime = factors.length == 1 && factors.first.power == 1 && factors.first.prime == n;
    return SieveNumber(number: n, isPrime: isPrime, factors: factors);
  }

  /// Continuous proximity triangle wave function:
  /// f(t) = | 2 * ((speed * t) % p) / p - 1.0 |
  /// Bounded in [0.0, 1.0].
  /// Equal to 1.0 when fractionalN is an exact multiple of p.
  /// Drops smoothly to 0.0 when fractionalN is midway between multiples (p / 2).
  static double getProximity(int prime, double fractionalN) {
    if (prime <= 0) return 0.0;
    final double mod = fractionalN % prime;
    final double normalized = (2.0 * mod / prime) - 1.0;
    return normalized.abs().clamp(0.0, 1.0);
  }
}
