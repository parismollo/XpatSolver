1. Faire un fichier `TypeSol.ml` et `TypeSol.mli`
2. Faire 4 types de Sol
   1. Freecell
      1. 8 cols - regles (voir sujet)
      2. 4 registres temp - vide de base
      3. 4 depot - chaque famille de carte
   2. Seahaven
      1. 10 cols de 5 cartes
      2. 4 registres temp
      3. Cartes restantes dans chaque registre (2 registres seront occupée)
      4. 2 depots, un depot pour le trefle et pour le pique
   3. Midnight Oil
      1. 18 cols (regles) 3 par tout
      2. pas de registre
      3. pas depot
   4. Baker's Dozen
      1. 13 cols (4 cartes chaque)
      2. pas de registre
      3. 4 depots comme freecell

```python
def bouge(TypedeJeu jeu, Action a):
    switch(jeu):
      case Freecell:
        jeu.bouge(a)
```