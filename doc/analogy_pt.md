---
title: A Analogia Audiovisual (Crivo de Eratóstenes)
---

O aplicativo **Crivo de Eratóstenes** traduz a fatoração em primos e a teoria
dos números em uma experiência polifônica sensorial.

---

## 1. Primos como Tons Atômicos

Na teoria dos números, o **Teorema Fundamental da Aritmética** estabelece que
todo número inteiro maior que 1 ouéprimo por si mesmo ou pode ser fatorado de
formaúnica como produto de números primos.

Neste aplicativo:

* Cada número primo descoberto recebe uma altura musical atômica derivada da
  série harmônica natural:

  * **2** = Dó3 (130,81 Hz—o alicerce fundamental do baixo)

  * **3** = Sol3 (196,00 Hz—a quinta justa)

  * **5** = Mi4 (329,63 Hz—a terça maior)

  * **7** = Si♭4 (466,16 Hz—a sétima harmônica)

  * **11** = Fá♯5 (739,99 Hz—a quarta aumentada / trítono)

  * **13** = Lá5 (880,00 Hz—a sexta maior)

* **Silêncio na descoberta:** Quando um número primoéencontrado pela primeira
  vez na sequência, ele permanece em silêncio. Seu tom ressoa apenas quando
  ele aparece como fator em números compostos subsequentes.

---

## 2. Compostos como Acordes Harmônicos

Quando o crivo atinge um número inteiro composto, ele faz soar todos os seus
fatores primos simultaneamente formando um acorde musical:

* **2** ancora o baixo ($Dó_3$).

* **3** introduz a quinta ($Sol_3$).

* **6 = 2×3** soa um acorde de quinta aberta ($Dó_3 + Sol_3$).

* **5** adiciona a calorosa terça maior ($Mi_4$).

* **30 = 2×3×5** resolve em uma tríade completa de DóMaior ($Dó_3 + Mi_4 +
  Sol_3$).

---

## 3. Potências de Primos como Harmônicos de Oitava

Quando um número contém fatores repetidos do mesmo primo:

* **4 = 2²** adiciona um harmônico de oitava superior ($Dó_4$).

* **8 = 2³** sobrepõe a próxima oitava ($Dó_5$).

* **12 = 2²×3** sobrepõe a nota fundamental de baixo, a oitava superior e a
  quinta ($Dó_3 + Dó_4 + Sol_3$).

A caixa de seleção **Harmônicos** na barra superior permite alternar entre
ricas camadas harmônicas multioitava e notas fundamentais puras.

---

## 4. Ondas de Proximidade Contínuas

O painel inferior acompanha a proximidade da posição contínua de reprodução
$t$ em relação a um múltiplo de cada número primo $p$:

```
f(t) = | 2 × ((velocidade × t) mod p) / p - 1.0 |
```

* **Picos em 1,0:** O instante exato em que um múltiplo chega.

* **Vales em 0,0:** Exatamente na metade do caminho entre múltiplos.

* **Previsão de Primos:** Se todas as ondas de proximidade estiverem bem
  abaixo de 100%, o próximo número não possui fatores anteriores—ele deve ser
  primo!
