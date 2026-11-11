# Sieve of Eratosthenes

An interactive, educational rhythm game and audio-visual mathematical
demonstration of the **Sieve of Eratosthenes**, built with Flutter for Web and
Android.

---

## 1. Project Overview & Motivation

The **Sieve of Eratosthenes** is an ancient algorithm dating back to the 3rd
century BCE, formulated by Greek mathematician and chief librarian of
Alexandria **Eratosthenes of Cyrene**. It is one of the most elegant and
efficient algorithms for finding all prime numbers up to any limit by
systematically marking multiples of each discovered prime as composite.

This project transforms the algorithm into a living, rhythmic, audio-visual
experience and number-reflex game:

* **The Sieve Rhythm Clock:** The app counts forward at an adjustable tempo
  ($0.2\text{ Hz}$ to $5.0\text{ Hz}$, default $1.0\text{ Hz} = 60\text{
  BPM}$).

* **Atomic Prime Tones:** Each discovered prime is assigned an atomic musical
  tone derived from the natural overtone series ($2 = C_3, 3 = G_3, 5 = E_4, 7
  = B^\flat_4, 11 = F^\sharp_5, 13 = A_5$). Primes are silent when first
  discovered and only sound when they are part of a composite.

* **Composite Harmonic Chords:** When the rhythm reaches a composite number
  $N$, it sounds all of its prime factors simultaneously as a musical chord
  (e.g. $6 = 2 \times 3$ plays an open fifth chord $C - G$; $30 = 2 \times 3
  \times 5$ resolves into a complete C Major triad $C - E - G$).

* **Prime Multiplicities (Powers) as Octaves:** Numbers with repeated factors
  ($4 = 2^2, 8 = 2^3, 12 = 2^2 \times 3$) layer higher octave harmonics,
  enriching the timbre (toggleable in the top app bar).

* **Continuous Proximity Waves:** The bottom dashboard displays real-time
  progress bars for each discovered prime using the continuous triangle wave
  metric:

  $$f(t) = \left| 2 \cdot \frac{((\text{speed} \cdot t) \pmod p)}{p} - 1.0 \right|$$

smoothly peaking at $1.0$ exactly at multiples of $p$ and falling to $0.0$ at
midpoints.

---

## Documentation

Comprehensive documentation is available in the `doc/` directory:

* [doc/about.md](doc/about.md) : Algorithmic background, project history, and
  author attribution.

* [doc/analogy.md](doc/analogy.md) : Mathematical and musical analogy
  connecting prime factors to acoustic harmonies.

* [doc/how_to_play.md](doc/how_to_play.md) : Game mechanics, keyboard
  shortcuts, scoring rules, and speed controls.

* [doc/privacy.md](doc/privacy.md) : Application privacy policy and local
  storage disclosure.

* [doc/terms.md](doc/terms.md) : Terms of service.

---

## 2. Current Implementation Status

### Completed (Stages 1, 2, 3 & 4)

* [x] **Stage 1: Mathematical Sieve Core & Beat Clock:**

  * Deterministic prime discovery using trial division against known primes $p
    \le \sqrt{N}$.

  * Prime power multiplicity decomposition and formatting ($4 \implies 2^2, 12
    \implies 2^2 \times 3$).

  * Zero-drift beat generator using `Stopwatch` + `TickerProvider` to provide
    continuous sub-millisecond fractional time $N(t)$.

  * Continuous triangle-wave proximity metric calculation.

  * Curated colors and pitch frequencies for primes using golden-ratio
    algorithmic HSL color distribution.

* [x] **Stage 2: Polyphonic Acoustic Web Audio Synthesizer & Piano
      Soundfont:**

  * Web Audio API polyphonic engine with multi-octave acoustic grand piano
    samples (`C3`, `G3`, `C4`, `E4`, `C5`, `A5`, `C6` at ~1.2MB total).

  * Realtime pitch-shifting via `playbackRate` with seamless fallback to
    resonant overtone oscillators when offline.

  * Primes remain silent when first discovered, sounding only as factors of
    subsequent composite numbers.

  * Acoustic balancing boosting primes 2 ($+35\%$) and 3 ($+20\%$) for a
    strong bass root and fifth.

  * Dynamics compressor preventing digital distortion/clipping.

  * Master volume slider with percentage tooltip and instant mute/unmute
    toggle.

  * Harmonics toggle (defaults to OFF) to switch between full octave harmonics
    vs. fundamental notes.

* [x] **Stage 3: Solo Reflex Challenge Game Mode & Career Records:**

  * Silent **"Guess Next (#N+1)"** reflex action button and keyboard hotkey
    (**Spacebar**).

  * Scoring system with $+1$ for correct prime guesses and $-1$ penalty for
    composite guesses.

  * Persistent high score, best prime streak, accuracy meter, and career
    statistics via `SharedPreferences`.

  * Visual guess history border indicators on the number grid (green =
    correct, red = incorrect, amber = pending).

  * Dedicated **Player Stats & Records modal** with career metrics and reset
    option.

  * Dedicated **How to Play dialog** loading markdown rules from
    `doc/rules.md`.

  * Keyboard navigation: **P** (play/pause), **Spacebar** (guess next),
    **Left/Right arrows** (tempo $\pm 0.2\text{ Hz}$), **Up/Down arrows**
    (smooth scroll).

* [x] **Stage 4: Realtime Multiplayer Challenge:**

  * Firebase Realtime Database backing lightweight synchronized rooms
    (`fredgc-sieve-default-rtdb`).

  * **Strict Quota Clamping:** Max 10 rooms project-wide, max 10 players per
    room ($10 \times 10 = 100$ connections max, strictly within Spark free
    tier limits).

  * **Inactivity Auto-Pruning:** Automatic cleanup of rooms inactive for $\ge
    10$ minutes.

  * **QR Code & Shareable Link:** Dynamic QR codes via `qr_flutter` and
    one-click URL sharing (`/?room=CODE`) with automatic query parameter
    detection on load.

  * **Dropout & Reconnection Recovery:** Persistent session tokens in local
    storage with a 3-minute grace period allowing disconnected players to
    rejoin without score or streak loss.

  * **Synchronized Beat Clock & Catch-Up:** Clock synchronization using
    `/.info/serverTimeOffset` and timestamp alignment to eliminate timer
    drift; late-joining or reconnecting guests automatically catch up to the
    host's exact beat.

  * **Host Authority & Room Playback Sync:** Only the room host can pause,
    resume, reset, or change tempo, synchronizing changes in real-time across
    all clients. Guests have transport buttons replaced by a dedicated "Leave
    Room" button and a locked tempo display, preventing accidental desync.

  * **Live Scoreboard HUD:** In-game multiplayer leaderboard showing all
    players, scores, streaks, prime predictions, and a quick-leave action.

### Upcoming Stages

* [ ] **Stage 5:** Google Cast TV Web Receiver mode.

---

## 3. Architecture

```text
sieve/
├── assets/
│   ├── about.html            # Compiled documentation from doc/about.md
│   ├── css/doc_style.css     # Academic CSS styling
│   ├── dev/                  # Developer documentation (plan.html, README.html, GEMINI.html)
│   └── icons/                # Generated 512x512 icons (icon.png, background.png, foreground.png)
├── database.rules.json       # Firebase Realtime Database security rules
├── doc/
│   ├── about.md              # Application guide & mathematical background
│   ├── privacy.md            # Privacy policy (zero tracking, ephemeral data)
│   └── rules.md              # How-to-play prime reflex rules
├── lib/
│   ├── firebase_options.dart # Firebase configuration for Web and Android
│   ├── main.dart             # Application root, theme, keyboard shortcuts, and HUD
│   ├── models/
│   │   ├── audio_engine.dart      # Audio interface facade with mute & harmonics toggles
│   │   ├── audio_engine_stub.dart # No-op audio implementation for native/tests
│   │   ├── audio_engine_web.dart  # Web Audio API polyphonic piano synthesizer
│   │   ├── beat_clock.dart        # Precision beat timer and fractional interpolator
│   │   ├── game_stats.dart        # Persistent local high scores, streaks, and accuracy
│   │   ├── harmonic_palette.dart  # Musical notes, frequencies, and prime colors
│   │   ├── multiplayer_engine.dart # RTDB room lifecycle, 10-room quota, session persistence
│   │   └── sieve_engine.dart      # Sieve algorithm, prime cache, and proximity wave math
│   └── widgets/
│       ├── about_dialog.dart     # Help modal loading doc/about.md and doc/privacy.md
│       ├── factor_inspector.dart # Interactive prime factor inspection modal
│       ├── game_help_dialog.dart # How-to-play modal loading doc/rules.md
│       ├── multiplayer_dialog.dart # Room host/join dialog with QR code & share link
│       ├── multiplayer_scoreboard.dart # In-game live multiplayer HUD
│       ├── number_grid.dart      # Smoothly scrolling number stream with cursor
│       ├── proximity_dashboard.dart # Continuous triangle wave progress gauges
│       └── stats_dialog.dart     # Player stats and records dialog with accuracy meter
├── test/
│   ├── beat_clock_test.dart        # Timing, stepping, and speed unit tests
│   ├── game_stats_test.dart        # High score, streak, and career stats unit tests
│   ├── multiplayer_engine_test.dart # RTDB quota clamps and serialization unit tests
│   ├── sieve_engine_test.dart      # Mathematical sieve & continuity tests
│   └── widget_test.dart            # UI smoke and modal interaction tests
├── icon.xcf                  # Master GIMP icon with Background & Foreground layers
├── Makefile                  # Build, doc compilation, and staging automation
├── roll_build_number.sh      # Automated version & build bumper
├── setup.sh                  # Development environment launcher & hotkey binder
├── .firebaserc               # Firebase project: fredgc-sieve
└── firebase.json             # Firebase Hosting SPA routing & database rules mapping
```

---

## 4. Development & Running

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24+
  recommended)

* `make` and [Pandoc](https://pandoc.org/) (for compiling documentation)

### Forking and Cloning

1. Fork the repository on GitHub to your account.

2. Clone your fork locally:

   ```bash
   git clone https://github.com/<your-username>/sieve.git
   cd sieve
   ```

3. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

4. Compile documentation assets:

   ```bash
   make docs
   ```

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

### Running Tests & Static Analysis

```bash
flutter test
flutter analyze
```

### Staging to Firebase Hosting

```bash
make stage
```

Deploys the web application to the staging channel on Firebase Hosting for
project `fredgc-sieve`.
