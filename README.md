RushHour
========

Course: Artificial Intelligence
Assignemt: Use DFS and BFS to solve Rush hour puzzles

Úlohou je nájsť riešenie hlavolamu Bláznivá križovatka. Hlavolam je reprezentovaný mriežkou, ktorá má rozmery 6 krát 6 políčok a obsahuje niekoľko vozidiel (áut a nákladiakov) rozložených na mriežke tak, aby sa neprekrývali. Všetky vozidlá majú šírku 1 políčko, autá sú dlhé 2 a nákladiaky sú dlhé 3 políčka. V prípade, že vozidlo nie je blokované iným vozidlom alebo okrajom mriežky, môže sa posúvať dopredu alebo dozadu, nie však do strany, ani sa nemôže otáčať. V jednom kroku sa môže pohybovať len jedno vozidlo. V prípade, že je pred (za) vozidlom voľných n políčok, môže sa vozidlo pohnúť o 1 až n políčok dopredu (dozadu). Ak sú napríklad pred vozidlom voľné 3 políčka (napr. oranžové vozidlo na počiatočnej pozícii, obr. 1), to sa môže posunúť buď o 1, 2, alebo 3 políčka.

![alt text](http://www2.fiit.stuba.sk/~kapustik/krizovatky.gif "Úvodná konfigurácia")
![alt text](http://www2.fiit.stuba.sk/~kapustik/krizovatky_ciel.gif "Cieľová konfigurácia")


Hlavolam je vyriešený, keď je červené auto (v smere jeho jazdy) na okraji križovatky a môže z nej teda dostať von. Predpokladajte, že červené auto je vždy otočené horizontálne a smeruje doprava. Je potrebné nájsť postupnosť posunov vozidiel (nie pre všetky počiatočné pozície táto postupnosť existuje) tak, aby sa červené auto dostalo von z križovatky alebo vypísať, že úloha nemá riešenie. Príklad možnej počiatočnej a cieľovej pozície je na obr. 1.

Keď chceme túto úlohu riešiť algoritmami prehľadávania stavového priestoru, musíme si konkretizovať niektoré pojmy. Uvádzame príklad reprezentácie stavu, opis operátorov a cieľového stavu.

STAV
------

Stav predstavuje aktuálne rozloženie vozidiel. Potrebujeme si pamätať farbu každého vozidla, jeho veľkosť, pozíciu vozidla a či sa môže posúvať vertikálne alebo horizontálne. <br>
Počiatočný stav môžeme zapísať napríklad
((cervene 2 3 2 h)(oranzove 2 1 1 h)(zlte 3 2 1 v)(fialove 2 5 1 v)<br>
(zelene 3 2 4 v)(svetlomodre 3 6 3 h)(sive 2 5 5 h)(tmavomodre 3 1 6 v))

V tomto zápise je prvé vozidlo červené auto, ktoré sa má dostať ku bráne. Farba vozidla sa môže vynechať, ak ho konkrétna implementácia nevyžaduje. Veľkosť je vždy 2 alebo 3. Súradnice zodpovedajú ľavému hornému rohu automobilu a v tomto príklade sú súradnice počítané od ľavého horného rohu križovatky a začínajú od jednotky, prvá určuje riadok. Smer možného pohybu automobilu určuje h (horizontálny) pre pohyb vľavo a vpravo a v (vertikálny) pre pohyb hore a dole.
Vstupom algoritmov je začiatočný stav. Cieľový stav je definovaný tak, že červené auto je na najpravejšej pozícii v riadku. To vo všeobecnosti definuje celú množinu cieľových stavov a nás nezaujíma, ktorý z nich bude vo výslednom riešení.

OPERÁTORY
------

Operátory sú len štyri:
(VPRAVO stav vozidlo  počet) (VLAVO stav vozidlo počet) (DOLE stav vozidlo počet) a
(HORE stav vozidlo počet)
Operátor dostane nejaký stav, farbu (poradie) vozidla a počet políčok, o ktoré sa má vozidlo posunúť. Ak je možné vozidlo s danou farbou o zadaný počet políčok posnúť, vráti nový stav. Ak operátor na vstup nie je možné použiť, výstup nie je definovaný. V konkrétnej implementácii je potrebné výstup buď vhodne dodefinovať, alebo zabrániť volaniu nepoužiteľného operátora. Všetky operátory pre tento problém majú rovnakú váhu.
Príklad použitia operátora VPRAVO, pre oranzove auto a posun o 1:

Vstupný stav:

((cervene 2 3 2 h)(oranzove 2 1 1 h)(zlte 3 2 1 v)(fialove 2 5 1 v)
(zelene 3 2 4 v)(svetlomodre 3 6 3 h)(sive 2 5 5 h)(tmavomodre 3 1 6 v))

Výstupný stav:

((cervene 2 3 2 h)(oranzove 2 1 2 h)(zlte 3 2 1 v)(fialove 2 5 1 v)
(zelene 3 2 4 v)(svetlomodre 3 6 3 h)(sive 2 5 5 h)(tmavomodre 3 1 6 v))

UZOL
------

Stav predstavuje nejaký bod v stavovom priestore. My však od algoritmov požadujeme, aby nám ukázali cestu. Preto musíme zo stavového priestoru vytvoriť graf. Našťastie to nie je zložitá úloha. Stavy jednoducho nahradíme uzlami.
Čo obsahuje typický uzol?
Musí minimálne obsahovať

_STAV_ (to, čo uzol reprezentuje) a<br>
_ODKAZ NA PREDCHODCU_ (pre nás zaujímavá hrana grafu, reprezentovaná čo najefektívnejšie).<br>

Okrem toho môže obsahovať ďalšie informácie, ako

_POSLEDNE POUŽITÝ OPERÁTOR_<br>
_PREDCHÁDZAJÚCE OPERÁTORY_<br>
_HĹBKA UZLA_<br>
_CENA PREJDENEJ CESTY_<br>
_ODHAD CENY CESTY DO CIEĽA_<br>

Iné vhodné informácie o uzle

Uzol by však nemal obsahovať údaje, ktoré sú nadbytočné a príslušný algoritmus ich nepotrebuje. Pri zložitých úlohách sa generuje veľké množstvo uzlov a každý zbytočný bajt v uzle dokáže spotrebovať množstvo pamäti a znížiť rozsah prehľadávania algoritmu. Nedostatok informácií môže zase extrémne zvýšiť časové nároky algoritmu. Použité údaje zdôvodnite.

ALGORITMUS
------

Každé zadanie používa svoj algoritmus, ale algoritmy majú mnohé spoločné črty. Každý z nich potrebuje udržiavať informácie o uzloch, ktoré už kompletne spracoval a o uzloch, ktoré už vygeneroval, ale zatiaľ sa nedostali na spracovanie. Algoritmy majú tendenciu generovať množstvo stavov, ktoré už boli raz vygenerované. S týmto problémom je tiež potrebné sa vhodne vysporiadať, zvlášť u algoritmov, kde rovnaký stav neznamená rovnako dobrý uzol.
Činnosť nasledujúcich algoritmov sa dá z implementačného hľadiska opísať nasledujúcimi všeobecnými krokmi:

1.Vytvor počiatočný uzol a umiestni medzi vytvorené a zatiaľ nespracované uzly<br>
2.Ak neexistuje žiadny vytvorený a zatiaľ nespracovaný uzol, skonči s neúspechom - riešenie neexistuje<br>
3.Vyber najvhodnejší uzol z vytvorených a zatiaľ nespracovaných, označ ho aktuálny<br>
4.Ak tento uzol predstavuje cieľový stav, skonči s úspechom - vypíš riešenie<br>
5.Vytvor nasledovníkov aktuálneho uzla a zaraď ho medzi spracované uzly<br>
6.Vytrieď nasledovníkov a ulož ich medzi vytvorené a zatiaľ nespracované<br>
7.Choď na krok 2.<br>

