Projet PF5 2022 : XpatSolver
============================

## Sujet de projet

Voir [SUJET.md](SUJET.md)

Une version pdf peut s'obtenir via : `pandoc SUJET.md -o sujet.pdf`

## Modalités du projet, des rendus et de l'évaluation

Voir [CONSIGNES.md](CONSIGNES.md)

## Usage de git et GitLab

Voir [GIT.md](GIT.md)

## Prérequis à installer

Voir [INSTALL.md](https://gaufre.informatique.univ-paris-diderot.fr/letouzey/pf5/blob/master/INSTALL.md) sur le site du cours.

  - ocaml évidemment
  - dune et make

## Compilation et lancement

Par défaut, `make` est seulement utilisé pour abréger les commandes `dune` (voir `Makefile` pour plus de détails):

  - `make` sans argument lancera la compilation `dune` de `XpatSolver.exe`,
    c'est-à-dire votre programme en code natif.

  - `make clean` pour effacer le répertoire provisoire `_build` 
    produit par `dune` lors de ses compilations.

Enfin pour lancer votre programme: `./run arg1 arg2 ...`

  
