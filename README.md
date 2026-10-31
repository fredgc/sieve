# Sieve of Eratosthenes (v3.0.3+0)

An interactive, educational rhythm game and audio-visual mathematical demonstration of the **Sieve of Eratosthenes**, built with Flutter for Web and Android.

---

## 1. Project Overview & Motivation

The **Sieve of Eratosthenes** is an ancient algorithm dating back to the 3rd century BCE, formulated by Greek mathematician and chief librarian of Alexandria **Eratosthenes of Cyrene**. It is one of the most elegant and efficient algorithms for finding all prime numbers up to any limit by systematically marking multiples of each discovered prime as composite.

This project transforms the algorithm into a living, rhythmic, audio-visual experience and number-reflex game:
* **The Sieve Rhythm Clock:** The app counts forward at an adjustable tempo (default: $1.0\text{ Hz} = 60\text{ BPM}$).
* **Atomic Prime Tones:** Each discovered prime is assigned an atomic musical tone derived from the natural overtone series ($2 = C_3, 3 = G_3, 5 = E_4, 7 = B^\flat_4, 11 = F^\sharp_5, 13 = A_5$).
* **Composite Harmonic Chords:** When the rhythm reaches a composite number $N$, it sounds all of its prime factors simultaneously as a musical chord (e.g. $6 = 2 \times 3$ plays an open fifth chord $C - G$; $30 = 2 \times 3 \times 5$ resolves into a complete C Major triad $C - E - G$).
* **Prime Multiplicities (Powers) as Octaves:** Numbers with repeated factors ($4 = 2^2, 8 = 2^3, 12 = 2^2 \times 3$) layer higher octave harmonics, enriching the timbre.
* **Continuous Proximity Waves:** The bottom dashboard displays real-time progress bars for each discovered prime using the continuous triangle wave metric:
  $$f(t) = \left| 2 \cdot \frac{((\text{speed} \cdot t) \pmod p)}{p} - 1.0 \right|$$
  smoothly peaking at $1.0$ exactly at multiples of $p$ and falling to $0.0$ at midpoints.

---

## 2. Current Implementation Status

### Completed (Stage 1)
* [x] **Project Infrastructure & Tooling:**
  * Full Flutter Web & Android project configuration.
  * Custom `icon.xcf` based on the historical Eratosthenes profile engraving, color-matched with the deep purple (`#380C59`) and soft lavender (`#D4C2FC`) palette.
  * Automated icon generation pipeline via `icon-generate` and `flutter_launcher_icons`.
  * `Makefile` targets: `make ASSETS`, `make docs`, `make stage` (via `firebase_stage.pl`), and `make test`.
  * `setup.sh` script with host routing (`raven` port 5520, `jeeves` port 5008) and Chrome workspace hotkeys.
  * Firebase Hosting configuration (`.firebaserc` pointing to `fredgc-sieve` and `firebase.json` with web SPA headers).
* [x] **Mathematical Sieve Engine (`lib/models/sieve_engine.dart`):**
  * Deterministic prime discovery using trial division against known primes $p \le \sqrt{N}$.
  * Prime power multiplicity decomposition and formatting ($4 \implies 2^2, 12 \implies 2^2 \times 3$).
  * Triangle wave proximity calculation.
* [x] **Zero-Drift Beat Clock (`lib/models/beat_clock.dart`):**
  * Stopwatch-anchored beat generator preventing accumulated timing drift.
  * Continuous sub-millisecond fractional time $N(t)$ for 60/120 FPS animations.
  * Play, Pause, Single-Step, Reset, and Tempo slider ($0.2\text{ Hz}$ to $5.0\text{ Hz}$).
* [x] **Harmonic Palette (`lib/models/harmonic_palette.dart`):**
  * Curated colors and acoustic pitch frequencies for foundational primes.
  * Golden-ratio algorithmic HSL color distribution for higher primes.
* [x] **Interactive UI (`lib/main.dart` & `lib/widgets/`):**
  * Center hero display flashing on integer beats with prime badges and factor chips.
  * Scrolling horizontal number stream highlighting past, active, and upcoming numbers.
  * Continuous triangle-wave proximity dashboard.
  * Interactive Factor Inspector bottom sheet for examining any number.
  * In-app About/Help modal with direct link to the [Wikipedia Sieve of Eratosthenes article](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).
* [x] **Automated Testing:** 14 unit and widget tests covering the mathematical core, triangle wave continuity, beat clock timing, and UI smoke tests (`flutter test` passing with 0 warnings).

### Next Up (Stage 2 & Beyond)
* [ ] **Stage 2:** Polyphonic Piano Audio Synthesizer / Soundfont playback engine.
* [ ] **Stage 3:** Solo Reflex Challenge Game Mode (reaction buzzer, scoring, streak multipliers, local high score).
* [ ] **Stage 4:** Multiplayer room synchronization (Firebase Realtime Database free tier).
* [ ] **Stage 5:** Google Cast TV Web Receiver mode.

---

## 3. Architecture

```text
sieve/
├── assets/
│   ├── about.html            # Compiled documentation from doc/about.md
│   ├── css/doc_style.css     # Clean academic CSS styling
│   ├── dev/                  # Developer documentation (plan.html, README.html, GEMINI.html)
│   └── icons/                # Generated 512x512 icons (icon.png, background.png, foreground.png)
├── doc/
│   └── about.md              # Application guide & mathematical background
├── lib/
│   ├── main.dart             # Application root, theme, and main dashboard
│   ├── models/
│   │   ├── beat_clock.dart       # Precision beat timer and fractional interpolator
│   │   ├── harmonic_palette.dart # Musical notes, frequencies, and prime colors
│   │   └── sieve_engine.dart     # Sieve algorithm, prime cache, and proximity wave math
│   └── widgets/
│       ├── about_dialog.dart     # Help modal & Wikipedia integration
│       ├── factor_inspector.dart # Interactive prime factor inspection modal
│       ├── number_grid.dart      # Smoothly scrolling number stream
│       └── proximity_dashboard.dart # Continuous triangle wave progress gauges
├── test/
│   ├── beat_clock_test.dart   # Timing, stepping, and speed unit tests
│   ├── sieve_engine_test.dart # Mathematical sieve & continuity tests
│   └── widget_test.dart       # UI smoke tests
├── icon.xcf                  # Master GIMP icon with Background & Foreground layers
├── Makefile                  # Build, doc compilation, and staging automation
├── roll_build_number.sh      # Automated version & build bumper
├── setup.sh                  # Development environment launcher & hotkey binder
├── .firebaserc               # Firebase project: fredgc-sieve
└── firebase.json             # Firebase Hosting SPA routing & cache headers
```

---

## 4. Development & Running

### Starting Development Environment
```bash
./setup.sh
```

### Running Locally
```bash
# Debug mode on local port
./run-local-server.sh

# Or release build local server
./run-local-release.sh
```

### Building Assets & Documentation
```bash
make ASSETS
```

### Running Tests
```bash
flutter test
flutter analyze
```

### Staging to Firebase Hosting
```bash
make stage
```
Deploy the app to the staging channel on Firebase Hosting for project `fredgc-sieve`.
