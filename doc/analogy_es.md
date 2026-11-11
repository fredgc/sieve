---
title: La Analogía Audiovisual (Criba de Eratóstenes)
---

La aplicación **Criba de Eratóstenes** traduce la factorización de números
primos y la teoría de números en una experiencia sensorial y polifónica.

---

## 1. Primos como Tonos Atómicos

En teoría de números, el **Teorema Fundamental de la Aritmética** establece
que todo número entero mayor que 1 o bien es primo por símismo o puede
descomponerse de formaúnica como producto de números primos.

En esta aplicación:

* A cada número primo descubierto se le asigna un tono musical atómicoúnico
  derivado de la serie armónica natural:

  * **2** = Do3 (130.81 Hz—la base fundamental de bajo)

  * **3** = Sol3 (196.00 Hz—la quinta justa)

  * **5** = Mi4 (329.63 Hz—la tercera mayor)

  * **7** = Si♭4 (466.16 Hz—la séptima armónica)

  * **11** = Fa♯5 (739.99 Hz—la cuarta aumentada)

  * **13** = La5 (880.00 Hz—la sexta mayor)

* **Silencio al Descubrimiento:** Cuando se encuentra un número primo por
  primera vez en la secuencia, permanece en silencio. Su tono suenaúnicamente
  cuando aparece como factor en números compuestos posteriores.

---

## 2. Compuestos como Acordes Armónicos

Cuando la criba se detiene en un número entero compuesto, hace sonar todos sus
factores primos simultáneamente formando un acorde musical:

* **2** ancla el bajo ($Do_3$).

* **3** introduce la quinta ($Sol_3$).

* **6 = 2×3** hace sonar un acorde de quinta abierta ($Do_3 + Sol_3$).

* **5** añade la cálida tercera mayor ($Mi_4$).

* **30 = 2×3×5** se resuelve en una tríada completa de Do Mayor ($Do_3 + Mi_4 + Sol_3$).

---

## 3. Potencias de Primos como Armónicos de Octava

Cuando un número contiene factores repetidos del mismo primo:

* **4 = 2²** añade un armónico de octava superior ($Do_4$).

* **8 = 2³** superpone la siguiente octava más alta ($Do_5$).

* **12 = 2²×3** superpone la fundamental de bajo, la octava superior y la
  quinta ($Do_3 + Do_4 + Sol_3$).

Los jugadores pueden activar o desactivar la casilla de verificación
**Armónicos** en la barra superior para alternar entre ricas capas armónicas
multioctava y notas fundamentales individuales.

---

## 4. Ondas de Proximidad Continuas

El panel inferior registra la cercanía del cabezal de reproducción continuo
$t$ respecto a un múltiplo de cada número primo $p$. Calcula una métrica de
onda triangular continua:

```
f(t) = | 2 × ((velocidad × t) mod p) / p - 1.0 |
```

* **Picos en 1.0:** El momento exacto en que llega un múltiplo (por ejemplo,
  en cada número par para $p=2$, o cada tres números para $p=3$).

* **Valles en 0.0:** Justo a mitad de camino entre múltiplos.

* **Predicción de Primos:** Si todas las ondas de proximidad se encuentran muy
  por debajo del 100%, el próximo número no tiene factores previos, lo que
  significa que¡debe ser primo!
