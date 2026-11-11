# Sieve Multiplayer Architecture: Scalability, Bandwidth & Cost Analysis

This document provides a comprehensive architectural and financial analysis of
running real-time multiplayer rooms for the **Sieve of Eratosthenes** on
Google Firebase.

---

## 1. Executive Summary & Cost Takeaways

* **Zero-Cost Baseline (Spark Plan):** Supports up to **100 concurrent
  players** and $\sim 200,000$ completed game sessions per month at **$0.00 /
  month forever**.

* **Blaze Plan (Pay-as-you-go Scale):**

  * Removes the 100-connection ceiling, supporting up to **200,000
    simultaneous connections** per database instance.

  * Google does **not** charge for connections, operations (reads/writes), or
    data uploads on Realtime Database.

  * You are only billed for download bandwidth exceeding the **10 GB monthly
    free allowance** at **$1.00 per GB**.

  * Even under massive daily play (e.g., 500 simultaneous players, 10,000
    matches per day), monthly costs will stay comfortably **under $5.00 /
    month**.

* **Per-Project Quota Separation:** Free tier allowances are calculated **per
  Firebase Project ID**, not per user account or billing account. Different
  games in separate Firebase projects do not share or reduce each other's free
  quotas.

---

## 2. Quota Isolation: Per Project vs. Per Account

### How Google Cloud & Firebase Quotas Work:

1. **Free Tier Allowances Are Evaluated Strictly PER PROJECT:**

   - Every Firebase project receives its own independent free tier quota each
     month, regardless of whether they are registered under the same email
     address:

     - **Project A (`fredgc-sieve`):** Gets its own 10 GB/month free egress, 1
       GB free storage, and 100 simultaneous connections (or 200k on Blaze).

     - **Project B (`another-game`):** Gets its own separate 10 GB/month free
       egress, 1 GB free storage, etc.

   - Project B's traffic will **never** consume, deplete, or reduce Project
     A's free monthly allowance.

2. **Shared Billing Account Scenario (Blaze Plan):**

   - On the Blaze plan, multiple Firebase projects can link to the same Google
     Cloud Billing Account (the same credit card) for convenience.

   - **Google evaluates each project's usage against its own free tier
     threshold first before generating any charge:**

     - *Example:* If Project A uses 4 GB of download bandwidth and Project B
       uses 6 GB in the same billing cycle, both projects are completely
       within their respective 10 GB free quotas. **Your credit card is billed
       $0.00.**

     - *Example 2:* If Project A uses 13 GB (3 GB over) and Project B uses 6
       GB (within 10 GB), you are only billed $3.00 (for Project A's 3 GB
       overage). Project B remains $0.00.

3. **Projects Tied to the Same Email:**

   - Having multiple games or projects tied to the same Google account/email
     does **not** pool, combine, or reduce quotas.

   - The only per-account limit is the total *number of projects* you can
     create (typically 30–50 projects per Google account, expandable upon
     request).

   - All runtime resource quotas (bandwidth, database storage, connections)
     remain completely isolated per Project ID.

---

## 3. Firebase Service Comparison: Realtime DB vs. Firestore

For a real-time reflex/rhythm game, **Firebase Realtime Database (RTDB)** is
substantially cheaper and faster than Cloud Firestore:

| Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close.       | Instantly handles dropped Wi-Fi/tab close.                                                                                                                      |
| ---------------------------- | ------------------------------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close.       | Instantly handles dropped Wi-Fi/tab close.                                                                                                                      |
| Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close.       | Instantly handles dropped Wi-Fi/tab close.                                                                                                                      |
| Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close.       | Instantly handles dropped Wi-Fi/tab close.                                                                                                                      |
| Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close.       | Instantly handles dropped Wi-Fi/tab close.                                                                                                                      |
| Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close. | Instantly handles dropped Wi-Fi/tab close.       | Instantly handles dropped Wi-Fi/tab close.                                                                                                                      |

---

## 4. Bandwidth Math: How Much Data Does One Game Use?

Because the Sieve app uses **deterministic clock synchronization**, the server
does **not** stream number ticks or beats over the network. Each device
independently computes the exact current integer $N(t)$ locally from
`startTime` and `tempoHz`.

The network is only used for **player events** (joining, buzzing, and
pausing).

### Data Payload Breakdown:

1. **Room State & Join:**

   - Room metadata (`roomId`, `startTime`, `speedHz`, `status`): $\approx
     150\text{ bytes}$

   - Player entries (name, score, streak, status): $\approx 80\text{ bytes per
     player}$

   - Total initial payload for a 4-player room: **$\sim 0.5 \text{ KB}$**

2. **Guess Event:**

   - A player presses "Guess Next #17":

     ```json
     {"p": "alice", "n": 17, "t": 1730412345678}
     ```

Payload size: $\approx 60\text{ bytes}$

   - Broadcast to 4 room participants: $60 \text{ bytes} \times 4 = 240\text{
     bytes}$

3. **Full 10-Minute Match Session (4 Players, 1.0 Hz tempo):**

   - 600 numbers played, $\sim 110$ primes encountered.

   - Total guesses by all players: $\sim 150\text{ guesses}$.

   - Broadcast traffic: $150 \times 240\text{ bytes} \approx 36\text{ KB}$.

   - Connection overhead & presence heartbeats: $\approx 14\text{ KB}$.

   - **Total bandwidth per full 10-minute game: $\approx 50 \text{ KB}$!**

### Monthly Game Capacity on 10 GB Free Bandwidth:

$$\frac{10\text{ GB}}{50\text{ KB / game}} = \frac{10,000,000\text{ KB}}{50\text{ KB}} \approx \mathbf{200,000 \text{ completed matches / month}}$$

---

## 5. Cost Scaling Projections (Blaze Plan)

Firebase Blaze pricing beyond free limits:

* **Connections:** **$0.00** (up to 200,000 per DB instance)

* **Operations:** **$0.00** (unlimited)

* **Bandwidth:** **$1.00 per GB** (after first 10 GB free)

* **Storage:** **$5.00 per GB** (after first 1 GB free; 1,000 active rooms is
  $<2\text{ MB}$)

| **$0.00**                             | **$0.00**            | **$0.00**           | **$0.00**             | **$0.00**              |
| ------------------------------------- | -------------------- | ------------------- | --------------------- | ---------------------- |
| **$0.00**                             | **$0.00**            | **$0.00**           | **$0.00**             | **$0.00**              |
| **$0.00**                             | **$0.00**            | **$0.00**           | **$0.00**             | **$0.00**              |
| **$0.00**                             | **$0.00**            | **$0.00**           | **$0.00**             | **$0.00**              |
| **$0.00**                             | **$0.00**            | **$0.00**           | **$0.00**             | **$0.00**              |
| **$0.00**                             | **$0.00**            | **$0.00**           | **$0.00**             | **$0.00**              |

---

## 6. Recommended Safeguards & Hard Clamps ($5/Month Ceiling)

To ensure the game never incurs unexpected charges, the following safeguards
can be configured:

1. **Google Cloud Billing Budget & Alerts:**

   - Set a hard budget alert at **$5.00 / month** in the Google Cloud Console.

   - Receive immediate automated email notifications if monthly expenditure
     reaches $2.50, $4.00, or $5.00.

2. **Room Size Clamping (Application & Rules Layer):**

   - Limit standard rooms to **6 players max** (1 host + 5 guests).

   - In Firebase Security Rules: reject `join` attempts if `room.players.count
     >= 6`.

3. **Active Rooms System Clamp:**

   - Limit total concurrent active rooms to a safe ceiling (e.g., 50 active
     rooms simultaneously).

4. **Aggressive Auto-Cleanup (Inactivity Pruning):**

   - Automatically delete room nodes when the host leaves or if the game has
     been inactive for $>10\text{ minutes}$.

   - Guarantees stale data and idle connections do not linger in memory.

5. **Session Reconnection Security:**

   - 4-character Base-32 room codes (`7K3W`) offering $1,048,576$
     combinations.

   - Host lock button to prevent uninvited walk-ins once friends have
     assembled.

   - 3-minute grace period with stored `sessionToken` so players can
     seamlessly rejoin after brief Wi-Fi or cellular dropouts without losing
     their score or slot.
