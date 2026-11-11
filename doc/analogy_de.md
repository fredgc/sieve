---
title: Die audiovisuelle Analogie (Sieb des Eratosthenes)
---

Die Anwendung **Sieb des Eratosthenes**übersetzt Primfaktorzerlegung und
Zahlentheorie in ein polyphones Hörerlebnis.

---

## 1. Primzahlen als atomare Töne

In der Zahlentheorie besagt der **Fundamentalsatz der Arithmetik**, dass jede
ganze Zahl größer als 1 entweder selbst eine Primzahl ist oder sich eindeutig
als Produkt von Primzahlen darstellen lässt.

In dieser Anwendung:

* Jeder neu entdeckten Primzahl wird eine einzigartige Tonhöhe aus der
  harmonischen Naturtonreihe zugeordnet:

  * **2** = C3 (130,81 Hz—das fundamentale Bassfundament)

  * **3** = G3 (196,00 Hz—die reine Quinte)

  * **5** = E4 (329,63 Hz—die große Terz)

  * **7** = B♭4 (466,16 Hz—die Naturseptime)

  * **11** = F♯5 (739,99 Hz—der Tritonus /übermäßige Quarte)

  * **13** = A5 (880,00 Hz—die große Sexte)

* **Stille bei Entdeckung:** Wird eine Primzahl zum ersten Mal in der Sequenz
  angetroffen, bleibt sie stumm. Ihr Ton erklingt erst dann, wenn sie als
  Faktor in nachfolgenden zusammengesetzten Zahlen auftritt.

---

## 2. Zusammengesetzte Zahlen als harmonische Akkorde

Trifft das Sieb auf eine zusammengesetzte Zahl, erklingen alle ihre
Primfaktoren gleichzeitig als musikalischer Akkord:

* **2** verankert den Bass ($C_3$).

* **3** führt die Quinte ein ($G_3$).

* **6 = 2×3** erklingt als offener Quint-Powerchord ($C_3 + G_3$).

* **5** fügt die warme große Terz hinzu ($E_4$).

* **30 = 2×3×5** löst sich in einen vollen C-Dur-Dreiklang auf ($C_3 + E_4 +
  G_3$).

---

## 3. Primzahlpotenzen als Oktav-Obertöne

Enthält eine Zahl mehrfache Faktoren derselben Primzahl:

* **4 = 2²** fügt einen höheren Oktav-Oberton hinzu ($C_4$).

* **8 = 2³** schichtet die nächsthöhere Oktave auf ($C_5$).

* **12 = 2²×3** kombiniert Basston, höhere Oktave und Quinte ($C_3 + C_4 +
  G_3$).

Das Kontrollkästchen **Obertöne** in der oberen Leiste ermöglicht das
Umschalten zwischen mehrschichtigen Oktav-Obertönen und reinen Grundtönen.

---

## 4. Kontinuierliche Annäherungswellen

Das Dashboard am unteren Rand verfolgt, wie nahe der kontinuierliche Zeiger
$t$ an einem Vielfachen jeder Primzahl $p$ liegt:

```
f(t) = | 2 × ((Geschwindigkeit × t) mod p) / p - 1.0 |
```

* **Spitzen bei 1,0:** Der Moment, in dem ein Vielfaches erreicht wird.

* **Täler bei 0,0:** Genau auf halber Strecke zwischen zwei Vielfachen.

* **Primzahlen vorhersagen:** Wenn alle Annäherungswellen deutlich unter 100 %
  liegen, hat die nächste Zahl keine bekannten Teiler—sie muss prim sein!
