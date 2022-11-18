Ce fichier de test est au format CRAM.
Voir https://dune.readthedocs.io/en/stable/tests.html#cram-tests

Fichier solution vide:

  $ ../../src/XpatSolver.exe FreeCell.123 -check empty.sol | tail -n 1
  ECHEC 1

Idem, mais cette fois-ci essayons le code d'erreur

  $ ../../src/XpatSolver.exe FreeCell.123 -check empty.sol > /dev/null
  [1]

Fichier solution d'une seul ligne (non adaptée à la partie)

  $ ../../src/XpatSolver.exe FreeCell.123 -check oneline.sol | tail -n 1
  ECHEC 1

Fichier solution correct

  $ ../../src/XpatSolver.exe FreeCell.123 -check fc123.sol | tail -n 1
  SUCCES

D'autres règles du jeu:

  $ ../../src/XpatSolver.exe Seahaven.12345 -check st12345.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe BakersDozen.123456 -check bd123456.sol | tail -n 1
  SUCCES

Un numero de partie non accepté initialement par XpatRandom.shuffle:

  $ ../../src/XpatSolver.exe MidnightOil.12345678 -check mo12345678.sol | tail -n 1
  SUCCES

Solution incomplète de 9 coups :

  $ ../../src/XpatSolver.exe FreeCell.123 -check fc123-incomplete.sol | tail -n 1
  ECHEC 10

Il est interdit de déplacer une carte (6Tr) cachée par une autre (RoPi) après un
mouvement légal (8Ca -> 9Pi):

  $ ../../src/XpatSolver.exe FreeCell.123 -check fc123-hiddencard.sol | tail -n 1
  ECHEC 2

Il est interdit de déplacer un valet sur un roi :

  $ ../../src/XpatSolver.exe FreeCell.123 -check VaPi-RoPi.sol | tail -n 1
  ECHEC 1

Il est autorisé de déplacer un valet noir sur une dame rouge :

  $ ../../src/XpatSolver.exe FreeCell.123 -check VaPi-DaCa.sol | tail -n 1
  ECHEC 2

Il est interdit de déplacer un 2 de trèfle sur un 3 de pique :

  $ ../../src/XpatSolver.exe FreeCell.12345 -check 2Tr-3Pi.sol | tail -n 1
  ECHEC 1

TODO: tester d'autres fichiers solutions (corrects / incomplets / mauvais coup / trop longs)
et plus de variété de jeux et de numeros.
