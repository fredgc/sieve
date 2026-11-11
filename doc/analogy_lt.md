---
title: Garso ir vaizdo analogija (Eratosteno rėtis)
---

Programėlė**Eratosteno rėtis** paverčia skaidymąpirminiais daugikliais ir
skaičiųteorijąpolifonine muzikine patirtimi.

---

## 1. Pirminiai skaičiai kaip atominiai tonai

Skaičiųteorijoje **pagrindinėaritmetikos teorema** teigia, kad kiekvienas
sveikasis skaičius, didesnis už1, arba pats yra pirminis, arba gali būti
vieninteliu būdu išreikštas pirminiųskaičiųsandauga.

Šioje programoje:

* Kiekvienam atrastam pirminiam skaičiui priskiriamas unikalus muzikinis tonas
  išnatūraliosios harmoninės obertonųeilės:

  * **2** = C3 (130,81 Hz—žemasis boso pamatas)

  * **3** = G3 (196,00 Hz—grynoji kvinta)

  * **5** = E4 (329,63 Hz—didžioji tercija)

  * **7** = B♭4 (466,16 Hz—natūralioji septima)

  * **11** = F♯5 (739,99 Hz—padidintoji kvarta / tritonis)

  * **13** = A5 (880,00 Hz—didžioji seksta)

* **Tyla atradus:** Pirmąkartąsekos eigoje sutiktas pirminis skaičius lieka
  tylus. Jo tonas nuskamba tik tada, kai jis tampa vėlesniųsudėtiniųskaičių
  daugikliu.

---

## 2. Sudėtiniai skaičiai kaip harmoniniai akordai

Kai rėtis pasiekia sudėtinįskaičių, vienu metu suskamba visi jo pirminiai
daugikliai kaip muzikinis akordas:

* **2** laiko bosą($C_3$).

* **3** prideda kvintą($G_3$).

* **6 = 2×3** suskamba kaip atviras kvintos galios akordas ($C_3 + G_3$).

* **5**įnešašiltądidžiąjąterciją($E_4$).

* **30 = 2×3×5** suskamba kaip pilnas C-dur trigarsis ($C_3 + E_4 + G_3$).

---

## 3. Pirminių laipsniai kaip oktavų obertonai

Kai skaičius turi kelis to paties pirminio skaičiaus daugiklius:

* **4 = 2²** prideda aukštesnės oktavos obertoną($C_4$).

* **8 = 2³** prideda dar vienąaukštesnęoktavą($C_5$).

* **12 = 2²×3** sujungia bosinįtoną, aukštesnęoktavąir kvintą($C_3 + C_4 +
  G_3$).

Viršutinėje juostoje esantisžymimasis langelis **Harmonikos** leidžia
perjungti daugiasluoksnius oktavųobertonus arba grynus pagrindinius tonus.

---

## 4. Tolydžios artumo bangos

Apatinėje skydelio dalyje stebima, kaip arti tolydusis rodyklės taškas $t$ yra
prie kiekvieno pirminio skaičiaus $p$ kartotinio:

```
f(t) = | 2 × ((greitis × t) mod p) / p - 1.0 |
```

* **Viršūnės ties 1,0:** Momentas, kai pasiekiamas kartotinis.

* **Slėniai ties 0,0:** Tiksliai pusiaukelėje tarp dviejųkartotinių.

* **Pirminiųskaičiųnuspėjimas:** Jei visos artumo bangos yra gerokaižemiau 100
  %, būsimas skaičius neturižinomųdaliklių—jis privalo būti pirminis!
