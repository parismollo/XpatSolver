Certaines configurations initiales, comme MidnightOil avec la graine 4, sont
faciles à résoudre :

  $ timeout 30 ../../src/XpatSolver.exe mo.4 -search out.sol | tail -n 1
  SUCCES

Dans le cas de Midnight Oil (et Baker's Dozen), le fichier solution ne doit
contenir que des lignes de deux entiers. Le test suivant affiche les lignes
qui n'ont pas le bon format (grep ne doit donc rien afficher, et renvoyer
le code d'erreur [1] car aucune ligne ne correspond). Dans les solutions pour
FreeCell et Seahaven, on pourra avoir aussi des V et T en seconde colonne.

  $ grep -v '^[0-9]\+ [0-9]\+$' out.sol
  [1]

Et enfin le fichier de sortie doit être une solution valide d'après votre
vérificateur de solutions:

  $ ../../src/XpatSolver.exe mo.4 -check out.sol | tail -n 1
  SUCCES

Voici d'autres graines dont il est facile de trouver une solution :

  $ timeout 30 ../../src/XpatSolver.exe st.8 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe st.8 -check out.sol | tail -n 1
  SUCCES

  $ timeout 30 ../../src/XpatSolver.exe st.10 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe st.10 -check out.sol | tail -n 1
  SUCCES

  $ timeout 30 ../../src/XpatSolver.exe bd.92 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe bd.92 -check out.sol | tail -n 1
  SUCCES

D'autres exemples de parties facilement gagnées :

mo.4 st.8 st.10 st.11 st.14 st.17 st.19 st.22 st.23 st.24 st.31 st.32 mo.32
st.34 st.44 st.50 st.52 st.53 st.55 st.57 st.61 st.62 st.65 st.66 st.67 st.70
st.72 st.74 st.75 st.78 st.83 st.86 st.89 st.90 st.92 bd.92 st.93 st.98


D'autres configurations ne peuvent pas être gagnées mais leur recherche
exhaustive est facile car il y a peu d'états accessibles :

  $ timeout 30 ../../src/XpatSolver.exe mo.1 -search out.sol | tail -n 1
  INSOLUBLE

  $ timeout 30 ../../src/XpatSolver.exe st.35 -search out.sol | tail -n 1
  INSOLUBLE

D'autres exemples de recherches exhaustives faciles :

mo.1 mo.2 mo.3 mo.9 mo.10 mo.11 mo.13 mo.17 mo.20 mo.21 mo.22 mo.23 mo.24 mo.25
mo.26 mo.27 mo.28 mo.31 mo.33 st.35 st.36 mo.40 st.41 st.43 mo.44 mo.48 mo.49
mo.50 mo.55 mo.57 mo.59 mo.60 mo.61 mo.63 mo.66 mo.69 mo.70 st.73 mo.73 mo.74
mo.75 mo.76 mo.77 mo.80 mo.81 mo.83 mo.84 mo.85 mo.86 st.88 mo.90 st.91 mo.92
mo.93 mo.94 mo.98
