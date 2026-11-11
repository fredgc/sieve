# GEMINI.md - Developer Guide for Sieve of Eratosthenes

Welcome! This guide is designed to help future LLM agents and human developers
get up to speed quickly on the **Sieve of Eratosthenes** Flutter application.

---

## Developer Rules & Environment Configuration

All contributors and AI agents must follow the central rules defined in
`~/source/gemini/config/rules/`:

* **Task Management (`todo.md`)**: Project tasks and issues are tracked using
  `~/bin/todo.py`. When asked about tasks or what to work on next, execute:

  ```bash
  ~/bin/todo.py list
  ```

Before starting an item, mark it in progress (`~/bin/todo.py doing <N>`). Once
completed, mark it done (`~/bin/todo.py done <N>`). Do not archive completed
tasks until reviewed and verified.

* **Communication Style (`style.md`)**: Be blunt and direct. Avoid polite
  filler and superlatives. Keep responses concise, technical, and focused
  strictly on facts and instructions.

* **Documentation Formatting (`markdown.md`)**: Keep line lengths strictly
  under 80 characters. Always separate list items with a blank line. Always
  follow headers with a blank line. Visually align markdown table column
  borders (`|`).

* **Emacs Integration (`emacs.md`)**: When requested to send a file to Emacs,
  run `emacs-maybe-client -f <file>`.

* **Hardware & Testing (`devices.md`)**: On host `raven`, an Android device
  may be connected via `adb` for Android testing.

---

## 1. Project Purpose & Core Architecture

The **Sieve of Eratosthenes** app transforms prime number discovery into an
interactive audio-visual rhythm experience:

* Numbers count forward at an adjustable tempo ($0.2\text{ Hz}$ to $5.0\text{
  Hz}$).

* Discovered primes are assigned unique atomic musical notes from the overtone
  series and distinct vibrant colors; primes are silent when first discovered
  and only sound when they are part of a composite.

* Composite numbers sound all their prime factors simultaneously as musical
  chords.

* Prime powers ($4 = 2^2, 8 = 2^3, 12 = 2^2 \times 3$) layer higher octave
  harmonics.

* Bottom proximity dashboard renders continuous triangle waves:

  $$f(t) = \left| 2 \cdot \frac{((\text{speed} \cdot t) \pmod p)}{p} - 1.0 \right|$$

smoothly peaking at $1.0$ at multiples and reaching $0.0$ at midpoints.

---

## 2. Codebase Overview

```text
lib/
├── main.dart             # App entry, theme toggle, hero card & controls
├── firebase_options.dart # Firebase configuration for Web and Android
├── models/
│   ├── audio_engine.dart      # Universal audio facade with mute & harmonics toggles
│   ├── audio_engine_stub.dart # No-op audio implementation for tests/native
│   ├── audio_engine_web.dart  # Web Audio API polyphonic piano harmonic synthesizer & dynamics compressor
│   ├── beat_clock.dart        # Stopwatch-based zero-drift clock emitting beat & frame ticks
│   ├── game_stats.dart        # Persistent high scores, streaks, accuracy, and career statistics
│   ├── harmonic_palette.dart  # Note/frequency overtone definitions and golden-ratio color assignments
│   ├── multiplayer_engine.dart # Firebase RTDB room lifecycle, 10-room/10-player quota, session persistence
│   ├── sieve_engine.dart      # Sieve trial division, prime cache, and continuous proximity formula
│   └── theme_controller.dart  # Persistent light/dark ThemeMode notifier backed by SharedPreferences
└── widgets/
    ├── about_dialog.dart     # Help modal referencing Wikipedia, fredgc/sieve, and www.gchouse.org
    ├── factor_inspector.dart # Modal bottom sheet inspecting factors, octaves, and frequencies
    ├── game_help_dialog.dart # How-to-play modal explaining prime reflex game rules and scoring
    ├── multiplayer_dialog.dart # Room host/join dialog with QR code, share link, and reconnect banner
    ├── multiplayer_scoreboard.dart # In-game live multiplayer HUD displaying player scores & predictions
    ├── number_grid.dart      # Vertically expanding number stream with moving playhead cursor
    ├── proximity_dashboard.dart # Tight 104px triangle-wave progress bars (hides chord for 6-digit primes)
    └── stats_dialog.dart     # Player stats and records dialog with accuracy meter and reset option
```

---

## 3. Current Implementation Status

### Completed (Stages 1, 2, 3 & 4)

* **Mathematical Sieve Core:** Verified deterministic factorization, prime
  caching, and continuous proximity triangle wave calculation in
  `lib/models/sieve_engine.dart`.

* **Zero-Drift Beat Clock:** Implemented `lib/models/beat_clock.dart` using
  `Stopwatch` + `TickerProvider` to prevent timer drift and provide continuous
  fractional time $N(t)$.

* **Polyphonic Acoustic Web Audio Synthesizer & Piano Soundfont:** Implemented
  in `lib/models/audio_engine_web.dart` using Web Audio API:

  * **Acoustic Grand Piano Sample Library:** Multi-octave piano audio anchors
    (`C3`, `G3`, `C4`, `E4`, `C5`, `A5`, `C6` at ~1.2MB total) pre-decoded
    into memory with zero-latency realtime pitch shifting via `playbackRate`.

  * **Seamless Fallback:** Pure harmonic oscillators and resonant overtones
    activate seamlessly if sample buffers are loading or offline.

  * Primes are silent when first discovered, sounding their musical tones only
    when they are factors of subsequent composite numbers.

  * Composite chords sounding all prime factors simultaneously with octave
    harmonics for powers ($4 = 2^2, 8 = 2^3$).

  * **Acoustic Balancing:** Primes 2 ($+35\%$) and 3 ($+20\%$) are boosted in
    gain so the fundamental bass root ($C_3$) and perfect fifth ($G_3$)
    provide a strong, warm harmonic anchor.

  * Configurable Harmonics Checkbox in AppBar (defaults to **OFF**): toggle
    between full octave harmonics for prime powers vs. single fundamental
    note.

  * Master dynamics compressor preventing digital distortion/clipping.

  * Autoplay policy unlock handling on user interaction (Play, Step, Reset,
    Mute, or Tile click).

  * **Master Volume Slider & Mute Toggle:** Interactive volume slider with
    percentage tooltip positioned directly alongside dynamic mute/unmute
    control in AppBar.

* **Keyboard Navigation & Hotkeys:**

  * **P / p**: Toggle Play / Pause.

  * **Left / Right Arrow**: Decrease / Increase playback tempo ($0.2\text{
    Hz}$ increments).

  * **Up / Down Arrow**: Smoothly scroll the number stream grid $1/2$ box up /
    down.

  * **Spacebar**: Guess next number ($N+1$) is prime.

* **Solo Reflex Challenge Game Mode (Stage 3):**

  * Silent **"Guess Next (#N+1)"** button positioned next to "Step Forward"
    allowing players to guess whether the upcoming number is prime before it
    plays.

  * Live **Score** display with 1-point increments ($+1$ for prime, $-1$
    penalty for composite; score can be negative) and color-coded score
    updates.

  * **Persistent High Scores & Career Player Stats:** Local storage
    persistence for high score, best prime streak, total correct/incorrect
    guesses, and accuracy percentage via `lib/models/game_stats.dart`.

  * Live **High Score** badge (`Best: X`) and `NEW!` celebration in the score
    bar.

  * Dedicated **Player Stats & Records modal**
    (`lib/widgets/stats_dialog.dart`) with accuracy meter and confirmation to
    reset records.

  * **Visual Guess History & Indicator:** Number grid boxes display a green
    border for correct guesses, a red border for incorrect guesses, and an
    amber border for pending guesses.

  * **Anchored Controls:** Transport and game control bar anchored at the
    bottom of the layout to ensure UI stability when proximity waves appear or
    expand.

  * Dedicated **How-to-Play Rules Modal**
    (`lib/widgets/game_help_dialog.dart`) explaining next-number prime
    prediction strategies (proximity waves, silent cues, factor rules).

  * Streak tracking that resets on incorrect composite guesses.

* **Realtime Multiplayer Challenge (Stage 4):**

  * **Firebase Realtime Database Integration:** Lightweight presence, room
    lifecycle, and score sync backed by `fredgc-sieve-default-rtdb`.

  * **Strict Quota Clamping:** Hard limit of 10 rooms project-wide and 10
    players per room ($10 \times 10 = 100$ max concurrent connections, well
    within Spark free tier).

  * **Inactivity Auto-Pruning:** Automatic cleanup of stale rooms inactive for
    $\ge 10$ minutes.

  * **QR Code & Shareable Link:** Dynamic QR code generation via `qr_flutter`
    and one-click link sharing (`/?room=CODE`). Automatic URL parameter
    detection on app load pre-fills and opens join modal.

  * **Network Dropout Recovery:** Persistent session credentials with a
    3-minute grace period allowing disconnected players to rejoin without
    score or streak loss.

  * **Synchronized Beat Clock & Catch-Up:** Clock synchronization using
    `/.info/serverTimeOffset` and timestamp alignment to eliminate timer
    drift; `BeatClock.syncTo` allows joining or reconnecting guests to catch
    up to the host's exact position without audio bursts.

  * **Host Authority & Desync Prevention:** Host holds sole authority over
    Play/Pause, Reset, and Tempo adjustments, syncing changes instantly across
    all clients. Guests have transport buttons replaced by a dedicated "Leave
    Room" button and "Host Controls" badge, preserving perfect
    synchronization.

  * **Multiplayer HUD Scoreboard:** Live leaderboard above the number stream
    showing active players, live scores, streaks, prime guess predictions, and
    a quick-leave button.

* **Harmonic Palette:** Complete pitch frequency and color mappings in
  `lib/models/harmonic_palette.dart`.

* **Interactive UI:**

  * Vertically expanding number stream grid filling available screen space
    with centered auto-scrolling playhead cursor.

  * Tightened proximity wave dashboard (~104px per bar) displaying 5-digit
    primes with notes and percentages, gracefully hiding chords for 6-digit
    primes.

  * Center hero flasher with factor composition chips and note frequencies.

  * Modal factor inspector sheet with interactive note playback.

* **Help, Privacy & Educational Docs:**

  * `lib/widgets/about_dialog.dart` dynamically renders markdown from
    `assets/about.html` / `doc/about.md` with links to GitHub `fredgc/sieve`,
    Wikipedia, and `www.gchouse.org`.

  * Dedicated **Privacy Policy** modal dynamically loading `doc/privacy.md`
    emphasizing zero accounts, zero tracking, and privacy-by-design with
    GitHub issue contact routing.

  * Dedicated **How-to-Play Rules Modal**
    (`lib/widgets/game_help_dialog.dart`) dynamically loading `doc/rules.md`
    explaining prime reflex prediction strategies (proximity waves, silent
    cues, factor rules).

* **Tooling & Infrastructure:**

  * `icon.xcf` (512x512 with `Background` and `Foreground` layers) and
    automated generation via `icon-generate` and `flutter_launcher_icons`.

  * `Makefile` targets: `make ASSETS`, `make docs`, `make stage`, `make
    stage-release`, `make test`.

  * `setup.sh` with workspace hotkeys and host routing (`raven`: 5520,
    `jeeves`: 5008).

  * Firebase project `fredgc-sieve` configured in `.firebaserc` and
    `firebase.json`.

* **Testing & Quality:**

  * 33 unit and widget tests passing cleanly (`test/sieve_engine_test.dart`,
    `test/beat_clock_test.dart`, `test/game_stats_test.dart`,
    `test/multiplayer_engine_test.dart`, `test/widget_test.dart`).

  * `flutter analyze` reports 0 issues.

  * `flutter build web` compiles with zero errors.

### Upcoming Stages

* **Stage 5:** Google Cast TV Web Receiver mode.

---

## 4. Build, Test & Deployment Workflow

### Build and Asset Automation (`Makefile`)

The project uses `make` targets to coordinate asset compilation and builds:

* `make docs`: Compiles user markdown docs from `doc/*.md` into
  `assets/*.html` and developer docs (`plan.md`, `README.md`, `GEMINI.md`)
  into `assets/dev/*.html` via `pandoc`.

* `make ASSETS`: Generates icons, favicons, version metadata, and docs.

* `make test`: Runs standard Flutter unit, widget, and ARB localization parity
  tests on every commit (`flutter test --exclude-tags release_audit`). Fast
  execution (~2-5 seconds).

* `make audit`: Runs exhaustive pre-release accessibility and multi-locale
  layout audits (`flutter test test/audit_test.dart`). Tests all supported
  locales, compact mobile/tablet/desktop viewports, 1.5x/2.0x font scaling,
  and WCAG AA guidelines (`labeledTapTargetGuideline`). Required automatically
  by `make stage-release` and `make release`.

* `make stage`: Builds web app with debug flags and deploys to Firebase
  staging channel.

* `make stage-release`: Builds production web bundle and runs
  `firebase_stage.pl`.

* `make release`: Rolls version number (`--release`), runs full build, and
  deploys via Firebase (`sieve.gchouse.org`).

### Key Developer Commands

```bash
# Start dev session (sets up emacs, hotkeys, chrome tabs)
./setup.sh

# Run local debug server
./run-local-server.sh

# Build all documentation and icons
make ASSETS

# Run tests on every commit
make test

# Run exhaustive pre-release audit
make audit

# Deploy to Firebase Hosting staging channel
make stage

# Increment version and build numbers
./roll_build_number.sh
```
