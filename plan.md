# Sieve of Eratosthenes

This document outlines the strategic roadmap, architecture goals, and
milestones for the **Sieve of Eratosthenes** Flutter project.

> **Note**: Active day-to-day tasks and issue tracking are managed dynamically
> using `~/bin/todo.py`. Run `~/bin/todo.py list` to view active tasks.

---

## 1. Project Concept & Core Mechanics

The Sieve of Eratosthenes is an ancient, elegant algorithm for finding all
prime numbers up to a given limit by iteratively marking the multiples of each
prime as composite. This project turns the algorithm into a living, rhythmic,
audio-visual experience and competitive reflex/number-sense game.

### 1.1 The Sieve Rhythm Engine

* **Beat Clock:** The engine counts forward at an adjustable rate (default:
  $1.0\text{ Hz} = 60\text{ BPM}$).

* **State & Factorization:**

  * Maintains an ordered set of discovered primes $\mathcal{P} = \{p_1, p_2,
    \dots\}$.

  * For each current integer $N \ge 2$:

    * Test $N$ against all known primes $p \in \mathcal{P}$ where $p \le
      \sqrt{N}$ (or trial division).

    * If $N$ has prime factors, decompose $N$ into its prime factorization:

      $$N = p_1^{a_1} \cdot p_2^{a_2} \cdots p_k^{a_k}$$

    * If $N$ is divisible by no known prime, $N$ is prime! $N$ is added to
      $\mathcal{P}$ and triggers a new prime arrival event.

* **Audio-Visual Emission on Beat:**

  * For composite $N$: Trigger audio tones for all prime factors $p_i$,
    sounding simultaneously as a harmonic chord.

  * For prime $N$: Introduce a distinct, prominent new sound and visual
    celebratory flare.

  * For prime powers ($a_i > 1$): Play the base prime note along with upper
    octaves ($2\times, 4\times$) or higher velocity/gain per factor
    multiplicity.

---

## 2. Audio Design & Harmonic Piano Chords

### 2.1 Acoustic Grand Piano Samples

Rather than purely synthetic beeps, the app uses real acoustic piano samples
to create rich, organic chords.

#### Open Source Piano Sample Libraries:

* **Tone.js Instruments / Soundfont Piano (MIT / CC0 License):**

  * Lightweight, beautifully recorded acoustic grand piano samples.

  * Stored in compressed `.mp3` or `.ogg` format with key note anchors across
    4–5 octaves (e.g., $C_2$ to $C_6$).

  * Total asset size is under $1.5\text{ MB}$, making it instantaneous to
    download on mobile web.

* **Salamander Grand Piano (CC-BY 3.0):**

  * Captured from a Yamaha C5 grand piano. Pristine acoustic tone with natural
    hammer strike and room resonance.

* **Playback & Scaling Architecture:**

  * Anchor samples (e.g., $C_2, E_2, G_2, C_3, \dots$) are pre-decoded into
    memory buffers.

  * Intermediate pitches or higher primes are dynamically pitch-shifted using
    Web Audio buffer playback rate (`playbackRate.value = targetFreq /
    baseFreq`) or native audio resamplers, eliminating latency and memory
    bloat.

### 2.2 The Harmonic Prime Spectrum

In music theory and physics, the natural overtone series is built from integer
multiples of a fundamental frequency. We map primes to musical intervals so
that composite numbers produce natural, pleasant piano chords:

* **Prime 2 (The Octave / Root Fundamental):**

  * Pitch: $C_3$ ($130.81\text{ Hz}$).

  * Role: The rhythmic bass heartbeat and lowest acoustic anchor.

* **Prime 3 (The Perfect Fifth):**

  * Pitch: $G_3$ ($196.00\text{ Hz}$, $3/2$ ratio).

  * Together with 2 ($N=6$): Forms an open, resonant **Power Chord** ($C -
    G$).

* **Prime 5 (The Major Third):**

  * Pitch: $E_4$ ($329.63\text{ Hz}$, $5/4$ ratio).

  * Together with 2 & 3 ($N=30 = 2 \cdot 3 \cdot 5$): Resolves into a bright,
    consonant **C Major Triad** ($C - E - G$).

  * $N=10 = 2 \cdot 5$: Major Tenth ($C - E$).

  * $N=15 = 3 \cdot 5$: Minor Third interval ($E - G$).

* **Prime 7 (The Harmonic / Dominant 7th):**

  * Pitch: $B^\flat_4$ ($466.16\text{ Hz}$, $7/4$ ratio).

  * Together with 2, 3, 5 ($N=210$): Creates a rich **Dominant 7th chord** ($C - E - G - B^\flat$).

* **Prime 11 (The Augmented 11th / Lydian Fourth):**

  * Pitch: $F^\sharp_5$ ($739.99\text{ Hz}$, $11/8$ ratio).

* **Prime 13 (The Natural 13th / Major Sixth):**

  * Pitch: $A_5$ ($880.00\text{ Hz}$, $13/8$ ratio).

* **Higher Primes ($p \ge 17$):**

  * Mapped algorithmically into natural scale positions across the higher
    piano octaves ($C_5 - C_7$) so the instrument continues sounding musical
    and coherent as high primes appear.

### 2.3 Factor Multiplicity (Higher Powers)

When a prime factor appears multiple times ($N = p^k, k \ge 2$):

* **Octave Stacking:** For each additional exponent power, add the
  corresponding octave harmonic ($f \cdot 2^{k-1}$). For instance:

  * $4 = 2^2 \implies C_3 + C_4$

  * $8 = 2^3 \implies C_3 + C_4 + C_5$

  * $12 = 2^2 \cdot 3 \implies C_3 + C_4 + G_3$

* **Velocity & Accent:** Apply $+2.0\text{ dB}$ volume boost and slightly
  stronger acoustic strike per multiplicity.

---

## 3. Visual Interface & Continuous Proximity Waves

### 3.1 The Scrolling Number Matrix

* **Layout:** Vertical or horizontal flowing grid showing numbers preceding,
  current, and upcoming.

* **Scroll Animation:** Continuous smooth scrolling interpolation based on
  fractional time $t$, not jarring jumps.

* **Visual States:**

  * **Upcoming:** Muted slate gray / subtle borders.

  * **Current ($N$):** Center spotlight, pulsing scale animation $(1.0 \to
    1.15 \to 1.0)$, flashing color corresponding to factors.

  * **Composite Played:** Rings radiate outwards colored by the contributing
    prime factor colors.

  * **Prime Discovered:** Golden / electric amber flare with particle burst.

  * **Historical (Passed):** Retains color-coded badge indicating prime status
    or factor breakdown.

### 3.2 Mathematical Verification of the Proximity Function

The plan proposed a progress bar metric:

$$f(t) = \left| 2 \cdot \frac{((\text{speed} \cdot t) \pmod p)}{p} - 1.0 \right|$$

#### Continuity Proof & Analysis:

1. Let $x(t) = (\text{speed} \cdot t) \pmod p$, where $x(t) \in [0, p)$.

2. Inside the open interval $(k p, (k+1) p)$, $x(t)$ is linear and continuous.

3. At the boundary where $t \to \left(\frac{k p}{\text{speed}}\right)^-$:

   * $x(t) \to p^-$

   * $\frac{2 x(t)}{p} - 1.0 \to \frac{2 p}{p} - 1.0 = +1.0$

   * $\left| +1.0 \right| = 1.0$

4. At the boundary where $t = \frac{k p}{\text{speed}}$ (from the right, $t
   \to^+$):

   * $x(t) = 0$

   * $\frac{2(0)}{p} - 1.0 = -1.0$

   * $\left| -1.0 \right| = 1.0$

5. **Conclusion:** Because $\lim_{t \to t_0^-} f(t) = \lim_{t \to t_0^+} f(t)
   = f(t_0) = 1.0$, **the function is mathematically continuous for all $t \in
   \mathbb{R}$!**

6. **Waveform Shape:** It is an exact inverted triangle wave bounded between
   $[0.0, 1.0]$:

   * Value is **$1.0$** (Maximum bar height/width) exactly when $\text{speed}
     \cdot t$ is a multiple of $p$ ($N \equiv 0 \pmod p$).

   * Value drops smoothly to **$0.0$** at the midpoint between multiples ($N
     \equiv p/2 \pmod p$).

   * It rises smoothly back to **$1.0$** as $N$ approaches the next multiple.

### 3.3 Dynamic Bottom Progress Bars

* **Layout:** A unified multi-tier dashboard pinned to the bottom.

* **Proximity Gauge:** Each discovered prime gets a color-coded bar whose fill
  corresponds to $f(t)$.

* **Adaptive Scaling & Density Management:**

  * As the prime list grows to 20, 50, 100+ primes, showing all bars
    simultaneously would cause unreadable visual noise.

  * **Visibility Filter:**

    * Display the primary small primes ($2, 3, 5, 7, 11, 13$) as persistent
      tracks.

    * For larger primes, only render bars for primes that are currently within
      the active window:

      $$f(t) \ge 0.70 \quad \text{(i.e., imminent multiples within 15\% of arrival)}$$

    * Display prime number badge inside the bar when width $> 28\text{px}$.

---

## 4. Single-Player Game Experience (Immediate Focus)

### 4.1 Zen / Exploration Mode

* **Tempo Slider:** Smoothly adjust speed from $0.2\text{ Hz}$ ($1\text{ beat
  per 5 seconds}$) up to $10.0\text{ Hz}$.

* **Factor Inspector:** Tap on any number on the board (past, present, or
  future) to inspect its prime factorization and hear its piano chord
  isolated.

* **Mute/Solo Prime Tracks:** Toggle individual primes to isolate their rhythm
  and hear how the sieve weaves together.

### 4.2 Solo Reflex Challenge

* **The "PRIME!" Buzzer Button:** A prominent button at the bottom of the
  screen.

* **Timing Window:** The player must press the button when the next
  approaching number is prime (within a configurable reaction window before/at
  the beat).

* **Scoring Rules:**

  * Tap on Prime: **$+100 \text{ points} \times \text{speed multiplier}$**.

  * Tap on Composite: **$-75 \text{ points}$ penalty** (visual screen shake
    and low thud sound).

  * Missed Prime: Streak resets to 0.

* **Streak Multiplier:** Consecutive correct prime identifications build a
  combo multiplier ($1.5\times, 2.0\times, 3.0\times$).

* **Local High Scores:** Stored locally in browser `localStorage` or device
  preferences.

---

## 5. Future Multiplayer Architecture & Cost Analysis

*(To be implemented after the single-player experience is complete and
reviewed)*

### 5.1 Technology Selection

* **Wi-Fi Direct / P2P Wi-Fi:** Android-only, requires invasive
  location/nearby permissions, breaks internet connectivity, and is completely
  unsupported on Web and iOS Safari.

* **Bluetooth (BLE):** Does not support peripheral/hosting mode on Web
  browsers; requires native OS permissions.

* **Recommended: Firebase Realtime Database (Room Codes):**

  * Instant room code join (e.g., room code `7351` or QR code).

  * Works on every platform (Android, iOS Safari, Chrome, Edge, desktop).

  * Sub-50ms synchronization with NTP server timestamp clock sync.

### 5.2 Cost Analysis & Scalability

* Comprehensive analysis, bandwidth math, quota isolation rules, and budget
  safeguards are documented in [`pricing.md`](pricing.md) (and compiled to
  `assets/dev/pricing.html`).

* **Firebase Spark Plan (Free Tier):**

  * **Cost: $0.00 / month forever (No credit card required).**

  * **Realtime Database Limits:**

    * 1 GB stored data (a room state is only ~2 KB).

    * 10 GB/month network download.

    * 100 simultaneous active client connections.

* **Blaze Plan Scale (<$5/month):**

  * First 10 GB free; $1.00/GB thereafter. Connections, operations, and
    uploads are free.

  * Deterministic clock sync uses only $\sim 50\text{ KB}$ per 10-minute game,
    supporting over 200,000 matches/month before exceeding free allowances.

* **Firebase Hosting Limits:**

  * 10 GB storage, 360 MB/day data transfer, free SSL on custom domain.

---

## 6. Future Casting Architecture (TV / Chromecast)

*(To be implemented after multiplayer review)*

### 6.1 How Google Cast Works

Google Cast separates the system into two applications:

1. **The Sender Application:** Runs on the user's mobile device or desktop
   Chrome browser.

2. **The Web Receiver Application:** A web application (HTML5/Canvas/WebAudio)
   hosted on Firebase Hosting that executes inside the Chromecast / Google
   TV's embedded Chromium browser.

* **Dual Experience:**

  * TV displays the full-screen 4K scrolling number grid, particle explosions,
    proximity bars, and plays the rich piano chords through the TV sound
    system.

  * Mobile phone acts as a low-latency handheld controller and buzzer.

---

## 7. Educational Content & Help

* **In-App Tutorial & Help Modal:**

  * Interactive explanation of the Sieve of Eratosthenes algorithm.

  * Visual guide explaining how prime numbers are the "atoms" of integers, and
    how composite numbers are chords of those atomic frequencies.

  * Direct clickable link to the
    [Wikipedia article on Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes)
    .

---

## 8. Staged Implementation Plan

```mermaid
flowchart TD
    subgraph Milestone 1: Single-Player Experience
        A1["Phase 1: Project Setup & Sieve Core Engine"] --> A2["Phase 2: Polyphonic Audio Engine"]
        A2 --> A3["Phase 3: Smooth Grid & Proximity Waves"]
        A3 --> A4["Phase 4: Solo Reflex Challenge (N+1 Guessing)"]
        A4 --> A5["Phase 5: Keyboard Hotkeys & Bottom Controls"]
        A5 --> A6["Phase 5b: Persistent High Scores & Player Stats (IN PROGRESS)"]
        A6 --> A7["Phase 5c: Acoustic Piano Soundfont Library (Backlog)"]
    end
    subgraph Milestone 2: Multiplayer & Review
        B1["Phase 6: Firebase Free Tier Setup & Room Sync (Backlog)"]
    end
    subgraph Milestone 3: Casting
        C1["Phase 7: Google Cast Web Receiver & Controller Mode (Backlog)"]
    end
    A7 --> B1
    B1 --> C1
```

### Milestone 1 Tasks (Single-Player Experience):

* [x] **Phase 1: Project Scaffolding & Core Engine (COMPLETED):**

  * Initialized Flutter project configured for Web and Android.

  * Implemented deterministic mathematical sieve state generator and prime
    cache in `lib/models/sieve_engine.dart`.

  * Implemented sub-millisecond precision zero-drift stopwatch beat timer in
    `lib/models/beat_clock.dart`.

  * Set up development tooling: `setup.sh`, `Makefile` (`make ASSETS`, `make
    stage`), `icon.xcf`, and launcher icons.

  * Created unit test suites in `test/sieve_engine_test.dart` and
    `test/beat_clock_test.dart`.

* [x] **Phase 2: Audio Engine (COMPLETED):**

  * Integrated zero-latency polyphonic Web Audio API synthesis in
    `lib/models/audio_engine_web.dart` with stub fallback in
    `lib/models/audio_engine_stub.dart`.

  * Polyphonic audio engine sounding simultaneous prime factor chords for
    composites and octave overtones for prime powers.

  * Primes are silent when first discovered and only sound when part of
    subsequent composites.

  * Percussive countdown clicks for 0 and 1.

  * Harmonics toggle in AppBar (defaults to **OFF**).

  * Browser Autoplay Policy unlock handling on any user click or button press.

  * Audio mute toggle control in AppBar.

* [x] **Phase 3: Visual Interface & Anchored Controls (COMPLETED):**

  * Built smooth-scrolling number stream (`lib/widgets/number_grid.dart`) with
    prime glow and composite factor badges.

  * Implemented bottom proximity dashboard
    (`lib/widgets/proximity_dashboard.dart`) using the continuous triangle
    wave formula $f(t) = |2 \cdot ((speed \cdot t) \pmod p)/p - 1.0|$.

  * Tightened proximity wave bars to ~104px displaying 5-digit primes with
    notes and percentages, gracefully hiding chords for 6-digit primes.

  * Implemented interactive Factor Inspector modal sheet
    (`lib/widgets/factor_inspector.dart`).

  * Anchored transport and game control bar at the very bottom of the layout
    to prevent UI jumping when proximity bars appear.

* [x] **Phase 4: Solo Reflex Challenge & Guess History (COMPLETED):**

  * Silent **"Guess Next (#N+1)"** button positioned next to "Step Forward"
    allowing players to guess whether the upcoming number is prime before it
    plays.

  * Live **Score** display with 1-point increments ($+1$ for prime, $-1$
    penalty for composite clamped at 0) and color-coded score updates.

  * **Visual Guess History & Indicator:** Number grid boxes display a green
    border for correct guesses, a red border for incorrect guesses, and an
    amber border for pending guesses.

  * Dedicated **How-to-Play Rules Modal**
    (`lib/widgets/game_help_dialog.dart`) explaining next-number prime
    prediction strategies (proximity waves, silent cues, factor rules).

* [x] **Phase 5: Keyboard Shortcuts & Harmonics Default (COMPLETED):**

  * Added global hotkeys: `P` (Play/Pause), `Left`/`Right` arrow (tempo
    adjust), `Up`/`Down` arrow (scroll grid 1/2 box), and `Spacebar` (guess
    next number).

  * Defaulted Harmonics toggle to **OFF**.

* [x] **Phase 5b: Persistent High Scores & Player Stats (COMPLETED):**

  * Persist all-time high score and longest correct prime streak using
    `shared_preferences` across browser/device reloads.

  * Track career stats: total predictions made, primes correctly identified,
    composites correctly identified/avoided, and accuracy percentage.

  * UI badge displaying **High Score: X** next to current score.

  * Stats dialog accessible via a stats button or through the Game Rules
    modal, with an option to reset personal best scores.

* [x] **Phase 5c: Acoustic Grand Piano Soundfont Library (COMPLETED):**

  * Integrated multi-octave acoustic grand piano audio samples (`C3`, `G3`,
    `C4`, `E4`, `C5`, `A5`, `C6` from Tone.js Instruments / Salamander,
    $<1.5\text{ MB}$).

  * Zero-latency realtime pitch-shifting via Web Audio buffer playback rate
    for intermediate primes and octaves.

  * Authentic acoustic piano hammer strike, string resonance, and natural
    decay with seamless synthesized fallback.

---

### Milestone 2: Realtime Multiplayer Rooms (FUTURE / BACKLOG):

* [ ] **Phase 6: Firebase Realtime Database Free-Tier Sync:**

  * Instant room code join (e.g., room code `7351` or QR code).

  * NTP server timestamp clock synchronization for sub-50ms synchronized beat
    clock across all devices.

  * Live head-to-head prime reflex race with multi-player real-time
    leaderboards.

  * Zero-cost architecture under Firebase Spark free-tier limits.

---

### Milestone 3: Google Cast TV Receiver (FUTURE / BACKLOG):

* [ ] **Phase 7: Google Cast Web Receiver & Controller Mode:**

  * Standalone Cast Web Receiver hosted on Firebase Hosting for Chromecast /
    Google TV.

  * 4K full-screen scrolling number grid, particle explosions, proximity wave
    dashboard, and stereo piano audio played through TV sound system.

  * Mobile phone functions as a low-latency handheld controller and buzzer.

---

## Visual & Accessibility Verification Checklist

Perform these manual checks across supported locales (`en`, `es`, `de`, `fr`,
`ja`, `lt`, `pt`, `zh`) on mobile and desktop viewports:

* **Prime Number Grid & Game Animation**:

  * [ ] Verify the grid cells, crossed-out composites, and highlighted primes
        display high-contrast borders and colors in both light and dark modes.

  * [ ] Verify prime elimination animations, proximity waves, and score
        increments execute smoothly without frame drops.

* **Audio, Speed & Game Controls**:

  * [ ] Test the speed slider and maximum number slider, ensuring labels and
        current values fit without line wrapping on narrow screens.

  * [ ] Verify audio mute toggle, piano soundfont playback, and haptic
        feedback triggers operate as intended.

* **Game Rules, Stats & Modals**:

  * [ ] Open the Rules and Stats dialogs and confirm all mathematical
        explanations and career statistics are fully localized.

  * [ ] Verify that high-score badges and accuracy percentages render cleanly
        without overflow in German and French.

* **Language Menu & Settings**:

  * [ ] Switch to each language from the top bar language menu and confirm all
        UI labels, button tooltips, and dialog text update immediately.

  * [ ] Switch to **Auto** and verify the app reverts cleanly to the system
        default locale.

* **Touch Targets & Screen Readers**:

  * [ ] Verify grid cells and buzzer buttons have adequate touch target sizing
        for rapid mobile gameplay.

  * [ ] Enable TalkBack (Android) or VoiceOver (iOS/macOS) and confirm screen
        reader announcements for prime predictions, streaks, and game over.
