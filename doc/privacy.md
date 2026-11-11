# Privacy Policy for Sieve of Eratosthenes

*Last Updated: October 31, 2026*

---

## Zero-PII & Privacy by Design

The **Sieve of Eratosthenes** ("the App") is an interactive educational math
game and rhythm demonstration. We believe in strict **Privacy by Design**: we
do not collect personal information, we do not require user accounts, we do
not track you across the web, and we do not sell or monetize your data.

This App is built for students, educators, and math/music enthusiasts of all
ages.

---

## Information We Do NOT Collect

To maintain a zero-PII (Personal Identifiable Information) architecture:

* **No User Accounts:** We never ask for or store your name, email address,
  phone number, or password.

* **No Device Sensors or Permissions:** We do not access your device location
  (GPS), camera, microphone, photo library, contacts, or local files.

* **No Third-Party Trackers or Advertisements:** The App is 100% ad-free and
  contains no advertising SDKs, marketing trackers, or cross-site tracking
  cookies (no Google Analytics, Facebook Pixel, etc.).

---

## Information Handled During Gameplay

### Single-Player Mode (100% On-Device)

* All single-player statistics—including all-time high scores, longest prime
  streaks, guess accuracy, tempo settings, and audio preferences—are saved
  exclusively in your browser's local storage (`localStorage` / device
  `SharedPreferences`).

* This data remains strictly on your device and is never uploaded to any
  server.

### Multiplayer Mode (Ephemeral / Self-Destructing)

When you create or join a multiplayer room:

* **Screen Name:** You may provide a temporary nickname (e.g., "Alice" or
  "Player 1") to identify yourself to other players in the room.

* **Gameplay State:** Live scores, streaks, prime prediction guesses, and the
  4-character room code are transmitted over an encrypted WebSocket connection
  solely to synchronize the match in real time.

* **Automatic Deletion:** Multiplayer room data is strictly temporary. The
  entire room and all player entries are automatically deleted immediately
  upon match completion or after 10 minutes of inactivity.

---

## Third-Party Infrastructure

The App uses **Google Firebase** (Google LLC) for static web hosting and
real-time multiplayer message synchronization:

* Google processes standard technical connection metadata (such as IP
  addresses and network routing headers) as necessary to establish encrypted
  WebSocket connections and protect against denial-of-service attacks.

* For more information on Google's privacy practices, refer to
  [Google's Privacy Policy](https://policies.google.com/privacy) .

---

## Children & Classroom Safe (COPPA & FERPA)

The App is designed to be fully safe for children and classroom environments:

* We comply with the **Children’s Online Privacy Protection Act (COPPA)** and
  the **Family Educational Rights and Privacy Act (FERPA)**.

* Because the App does not request, collect, or store any personal information
  from users of any age, it does not require parental consent and can be
  safely deployed on school devices and in educational settings.

---

## Questions & Contact

The Sieve of Eratosthenes is an open-source project. If you have any
questions, feedback, or concerns regarding this Privacy Policy:

* **File an Issue on GitHub:**
  [https://github.com/fredgc/sieve/issues](https://github.com/fredgc/sieve/issues)

* **Visit the Project Website:**
  [https://www.gchouse.org](https://www.gchouse.org)
