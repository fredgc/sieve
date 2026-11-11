---
title: The Audio-Visual Analogy (Sieve of Eratosthenes)
---

The **Sieve of Eratosthenes** application translates prime factorization and
number theory into a sensory, polyphonic experience.

---

## 1. Primes as Atomic Tones

In number theory, the **Fundamental Theorem of Arithmetic** states that every
integer greater than 1 is either prime itself or can be uniquely factored into
a product of prime numbers.

In this application:

* Each prime number discovered is assigned a unique atomic musical pitch
  derived from the natural harmonic overtone series:

  * **2** = C3 (130.81 Hz—the fundamental bass anchor)

  * **3** = G3 (196.00 Hz—the perfect fifth)

  * **5** = E4 (329.63 Hz—the major third)

  * **7** = B♭4 (466.16 Hz—the harmonic seventh)

  * **11** = F♯5 (739.99 Hz—the augmented fourth)

  * **13** = A5 (880.00 Hz—the natural sixth)

* **Silent on Discovery:** When a prime number is first encountered in the
  sequence, it remains silent. Its tone sounds only when it appears as a
  factor in subsequent composite numbers.

---

## 2. Composites as Harmonic Chords

When the sieve lands on a composite integer, it sounds all of its prime
factors simultaneously as a musical chord:

* **2** anchors the bass ($C_3$).

* **3** introduces the fifth ($G_3$).

* **6 = 2×3** sounds an open fifth power chord ($C_3 + G_3$).

* **5** introduces the warm major third ($E_4$).

* **30 = 2×3×5** resolves into a full C Major triad ($C_3 + E_4 + G_3$).

---

## 3. Prime Powers as Octave Harmonics

When a number contains repeated factors of the same prime:

* **4 = 2²** adds an upper octave harmonic ($C_4$).

* **8 = 2³** layers the next higher octave ($C_5$).

* **12 = 2²×3** layers both the bass root, upper octave, and fifth ($C_3 + C_4 + G_3$).

Players can toggle the **Harmonics** checkbox in the top app bar to switch
between rich multi-octave harmonic layering and single fundamental notes.

---

## 4. Continuous Proximity Waves

The dashboard at the bottom tracks how close the current fractional playhead
$t$ is to a multiple of each prime $p$. It computes a continuous triangle wave
metric:

```
f(t) = | 2 × ((speed × t) mod p) / p - 1.0 |
```

* **Peaks at 1.0:** The moment a multiple arrives (e.g. at every even number
  for $p=2$, or every third number for $p=3$).

* **Troughs at 0.0:** Exactly halfway between multiples.

* **Predicting Primes:** If all proximity waves are well below 100%, the
  upcoming number has no existing factors—meaning it must be prime!
