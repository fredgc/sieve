---
title: About Sieve of Eratosthenes (v3.0.3+0)
---

# About Sieve of Eratosthenes (v3.0.3+0)

The **Sieve of Eratosthenes** is an interactive educational and rhythmic application designed to transform number theory and prime discovery into a living audio-visual experience.

## History & Motivation

Created in the 3rd century BCE by the Greek mathematician, geographer, and chief librarian of Alexandria, **Eratosthenes of Cyrene** (c. 276 – c. 195 BCE), the Sieve is one of the most ancient, efficient, and elegant algorithms in mathematics for finding all prime numbers up to any given limit.

For more historical context and algorithmic theory, read the [Wikipedia article on the Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).

## The Audio-Visual Analogy

1. **Primes as Atomic Tones**:
   In number theory, the Fundamental Theorem of Arithmetic states that every integer greater than 1 is either a prime itself or can be uniquely factored into a product of primes. In this application, each prime number discovered is assigned an atomic musical tone derived from the natural overtone series ($2 = C_3, 3 = G_3, 5 = E_4, 7 = B^\flat_4, 11 = F^\sharp_5, 13 = A_5$). When a prime is first encountered, it remains silent; its tone is only sounded when it appears as a factor in subsequent composite numbers.

2. **Composites as Harmonic Chords**:
   When the sieve encounters a composite number, it sounds all of its prime factors simultaneously as a musical chord:
   - $2$ plays the fundamental bass anchor ($C_3$).
   - $3$ plays the perfect fifth ($G_3$).
   - $6 = 2 \times 3$ plays an open power chord ($C_3 + G_3$).
   - $5$ plays the major third ($E_4$).
   - $30 = 2 \times 3 \times 5$ resolves into a complete C Major triad ($C - E - G$).

3. **Prime Multiplicities (Powers) as Octaves**:
   When a number contains multiple factors of the same prime ($4 = 2^2, 8 = 2^3, 12 = 2^2 \times 3$), the sound engine layers higher octave harmonics, enriching the timbre and acoustic intensity.

4. **Continuous Proximity Waves**:
   The bottom dashboard tracks how close the current beat is to being a multiple of each discovered prime using the continuous triangle wave metric:
   $$f(t) = \left| 2 \cdot \frac{((\text{speed} \cdot t) \pmod p)}{p} - 1.0 \right|$$
   Reaching peak $1.0$ at the exact arrival of each multiple.

## Source Code & Bug Reports

The source code for this project and issue tracker are hosted on GitHub:
* Repository: [https://github.com/fredgc/sieve](https://github.com/fredgc/sieve)

Please file any bug reports, suggestions, or feature requests in the GitHub issue tracker.

## More Apps by Fred Gylys-Colwell

Visit [www.gchouse.org](http://www.gchouse.org) to explore other interactive mathematics, physics, and computer science applications created by Fred Gylys-Colwell, including:
* **CAT Scan:** Radon Transform and CT image reconstruction tool.
* **Polytope:** Interactive 4-dimensional regular polytope slicer and visualizer.
* **Spacetime:** Relativistic spacetime intervals and Lorentz transformation explorer.
* **Daylight:** Planetary day/night solar terminator simulation.

## Privacy and Data Retention

This application stores gameplay high scores and tempo preferences locally on your device using `shared_preferences`. No personal data or user analytics are collected, tracked, or transmitted.
