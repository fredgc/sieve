# Sieve of Eratosthenes Development Notes

Build Version v3.0.3+0

Interactive audio-visual rhythm game and mathematical demonstration of the Sieve of Eratosthenes built with Flutter for Web and Android.

---

## 1. Project Purpose & Core Architecture

The **Sieve of Eratosthenes** app transforms prime number discovery into an interactive audio-visual rhythm experience:
* Numbers count forward at an adjustable tempo ($0.2\text{ Hz}$ to $5.0\text{ Hz}$).
* Discovered primes are assigned unique atomic musical notes from the overtone series and distinct vibrant colors; primes are silent when first discovered and only sound when they are part of a composite.
* Composite numbers sound all their prime factors simultaneously as musical chords.
* Prime powers ($4 = 2^2, 8 = 2^3, 12 = 2^2 \times 3$) layer higher octave harmonics.
* Bottom proximity dashboard renders continuous triangle waves:
  $$f(t) = \left| 2 \cdot \frac{((\text{speed} \cdot t) \pmod p)}{p} - 1.0 \right|$$
  smoothly peaking at $1.0$ at multiples and reaching $0.0$ at midpoints.

---

## 2. Codebase Overview

```text
lib/
├── main.dart             # App entry point, Dark/Purple Theme, Hero integer card, controls, harmonics toggle, & mute
├── models/
│   ├── audio_engine.dart      # Universal audio facade with mute & harmonics toggles
│   ├── audio_engine_stub.dart # No-op audio implementation for tests/native
│   ├── audio_engine_web.dart  # Web Audio API polyphonic piano harmonic synthesizer & dynamics compressor
│   ├── beat_clock.dart        # Stopwatch-based zero-drift clock emitting beat & frame ticks
│   ├── harmonic_palette.dart  # Note/frequency overtone definitions and golden-ratio color assignments
│   └── sieve_engine.dart      # Sieve trial division, prime cache, and continuous proximity formula
└── widgets/
    ├── about_dialog.dart     # Help modal referencing Wikipedia, fredgc/sieve, and www.gchouse.org
    ├── factor_inspector.dart # Modal bottom sheet inspecting factors, octaves, and frequencies
    ├── game_help_dialog.dart # How-to-play modal explaining prime reflex game rules and scoring
    ├── number_grid.dart      # Vertically expanding number stream with moving playhead cursor
    └── proximity_dashboard.dart # Tight 104px triangle-wave progress bars (hides chord for 6-digit primes)
```

---

## 3. Current Implementation Status

### Completed (Stages 1, 2 & 3)
* **Mathematical Sieve Core:** Verified deterministic factorization, prime caching, and continuous proximity triangle wave calculation in `lib/models/sieve_engine.dart`.
* **Zero-Drift Beat Clock:** Implemented `lib/models/beat_clock.dart` using `Stopwatch` + `TickerProvider` to prevent timer drift and provide continuous fractional time $N(t)$.
* **Polyphonic Acoustic Web Audio Synthesizer:** Implemented in `lib/models/audio_engine_web.dart` using Web Audio API:
  * Pure harmonic oscillators and resonant overtones emulating acoustic piano notes.
  * Primes are silent when first discovered, sounding their musical tones only when they are factors of subsequent composite numbers.
  * Composite chords sounding all prime factors simultaneously with octave harmonics for powers ($4 = 2^2, 8 = 2^3$).
  * Configurable Harmonics Checkbox in AppBar (defaults to **OFF**): toggle between full octave harmonics for prime powers vs. single fundamental note.
  * Master dynamics compressor preventing digital distortion/clipping.
  * Autoplay policy unlock handling on user interaction (Play, Step, Reset, Mute, or Tile click).
  * Audio mute/unmute control in AppBar.
* **Keyboard Navigation & Hotkeys:**
  * **P / p**: Toggle Play / Pause.
  * **Left / Right Arrow**: Decrease / Increase playback tempo ($0.2\text{ Hz}$ increments).
  * **Up / Down Arrow**: Smoothly scroll the number stream grid $1/2$ box up / down.
  * **Spacebar**: Guess next number ($N+1$) is prime.
* **Solo Reflex Challenge Game Mode (Stage 3):**
  * Silent **"Guess Next (#N+1)"** button positioned next to "Step Forward" allowing players to guess whether the upcoming number is prime before it plays.
  * Live **Score** display with 1-point increments ($+1$ for prime, $-1$ penalty for composite clamped at 0) and color-coded score updates.
  * **Visual Guess History & Indicator:** Number grid boxes display a green border for correct guesses, a red border for incorrect guesses, and an amber border for pending guesses.
  * **Anchored Controls:** Transport and game control bar anchored at the bottom of the layout to ensure UI stability when proximity waves appear or expand.
  * Dedicated **How-to-Play Rules Modal** (`lib/widgets/game_help_dialog.dart`) explaining next-number prime prediction strategies (proximity waves, silent cues, factor rules).
  * Streak tracking that resets on incorrect composite guesses or missed primes.
* **Harmonic Palette:** Complete pitch frequency and color mappings in `lib/models/harmonic_palette.dart`.
* **Interactive UI:**
  * Vertically expanding number stream grid filling available screen space with centered auto-scrolling playhead cursor.
  * Tightened proximity wave dashboard (~104px per bar) displaying 5-digit primes with notes and percentages, gracefully hiding chords for 6-digit primes.
  * Center hero flasher with factor composition chips and note frequencies.
  * Modal factor inspector sheet with interactive note playback.
* **Help & Educational Docs:**
  * `lib/widgets/about_dialog.dart` and `doc/about.md` referencing GitHub `fredgc/sieve`, Wikipedia, and `www.gchouse.org`.
* **Tooling & Infrastructure:**
  * `icon.xcf` (512x512 with `Background` and `Foreground` layers) and automated generation via `icon-generate` and `flutter_launcher_icons`.
  * `Makefile` targets: `make ASSETS`, `make docs`, `make stage`, `make stage-release`, `make test`.
  * `setup.sh` with workspace hotkeys and host routing (`raven`: 5520, `jeeves`: 5008).
  * Firebase project `fredgc-sieve` configured in `.firebaserc` and `firebase.json`.
* **Testing & Quality:**
  * 15 unit and widget tests passing cleanly (`test/sieve_engine_test.dart`, `test/beat_clock_test.dart`, `test/widget_test.dart`).
  * `flutter analyze` reports 0 issues.
  * `flutter build web` compiles with zero errors.

### Upcoming Stages
* **Stage 4:** Multiplayer room synchronization (Firebase Realtime Database free tier).
* **Stage 5:** Google Cast TV Web Receiver mode.

---

## 4. Key Developer Commands

```bash
# Start dev session (sets up emacs, hotkeys, chrome tabs)
./setup.sh

# Run local debug server
./run-local-server.sh

# Build all documentation and icons
make ASSETS

# Run tests and analysis
flutter test
flutter analyze

# Deploy to Firebase Hosting staging channel
make stage

# Increment version and build numbers
./roll_build_number.sh
```
