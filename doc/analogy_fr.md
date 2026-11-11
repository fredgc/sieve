---
title: L'analogie audiovisuelle (Crible d'Ératosthène)
---

L'application **Crible d'Ératosthène** transforme la factorisation première et
la théorie des nombres en une expérience polyphonique.

---

## 1. Les nombres premiers comme tonalités atomiques

En arithmétique, le **théorème fondamental de l'arithmétique** stipule que
tout entier strictement supérieurà1 est soit premier, soit décomposable de
manière unique en produit de facteurs premiers.

Dans cette application :

* Chaque nombre premier découvert se voit attribuer une hauteur musicale
  atomique issue de la série harmonique naturelle :

  * **2** = Do3 (130,81 Hz—la fondamentale de basse)

  * **3** = Sol3 (196,00 Hz—la quinte juste)

  * **5** = Mi4 (329,63 Hz—la tierce majeure)

  * **7** = Si♭4 (466,16 Hz—la septième harmonique)

  * **11** = Fa♯5 (739,99 Hz—la quarte augmentée / triton)

  * **13** = La5 (880,00 Hz—la sixte majeure)

* **Silence lors de la découverte :** Lorsqu'un nombre premier apparaît pour
  la première fois dans la séquence, il reste silencieux. Sa note ne retentit
  que lorsqu'il intervient comme facteur dans un nombre composéultérieur.

---

## 2. Les nombres composés comme accords harmoniques

Lorsque le crible atteint un entier composé, il fait résonner simultanément
tous ses facteurs premiers sous forme d'accord musical :

* **2** ancre la basse ($Do_3$).

* **3** introduit la quinte ($Sol_3$).

* **6 = 2×3** fait résonner une quinte ouverte ($Do_3 + Sol_3$).

* **5** apporte la chaleur de la tierce majeure ($Mi_4$).

* **30 = 2×3×5** se résout en un accord parfait de Do majeur ($Do_3 + Mi_4 +
  Sol_3$).

---

## 3. Puissances de nombres premiers comme harmoniques d'octave

Lorsqu'un nombre comporte des facteurs répétés d'un même nombre premier :

* **4 = 2²** ajoute une harmoniqueàl'octave supérieure ($Do_4$).

* **8 = 2³** superpose l'octave suivante ($Do_5$).

* **12 = 2²×3** combine la basse fondamentale, l'octave supérieure et la
  quinte ($Do_3 + Do_4 + Sol_3$).

La case **Harmoniques** dans la barre supérieure permet de basculer entre des
harmoniques riches sur plusieurs octaves et des notes fondamentales pures.

---

## 4. Ondes de proximité continues

Le tableau de bord inférieur mesure la proximitédu curseur de lecture $t$ avec
un multiple de chaque nombre premier $p$ :

```
f(t) = | 2 × ((vitesse × t) mod p) / p - 1.0 |
```

* **Picsà1,0 :** Le moment exact oùun multiple arrive.

* **Creuxà0,0 :**Àmi-chemin entre deux multiples.

* **Prédire les nombres premiers :** Si toutes les ondes de proximitérestent
  largement inférieuresà100 %, le nombre suivant n'a aucun facteur antérieur—
  il est donc premier !
