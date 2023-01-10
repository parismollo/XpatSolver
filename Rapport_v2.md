# Rapport PF5
- [Rapport PF5](#rapport-pf5)
  - [Identifiants](#identifiants)
  - [Fonctionnalités](#fonctionnalités)
    - [Création d'un jeu du type solitaire.](#création-dun-jeu-du-type-solitaire)
    - [Simulation d'une partie.](#simulation-dune-partie)
    - [Vérification d'un fichier solution.](#vérification-dun-fichier-solution)
    - [Recherche d'une solution pour un jeu solitaire.](#recherche-dune-solution-pour-un-jeu-solitaire)
  - [Compilation et exécution](#compilation-et-exécution)
  - [Découpage modulaire](#découpage-modulaire)
    - [TypeSol](#typesol)
    - [XpatRandom](#xpatrandom)
    - [Solver](#solver)
    - [Finder](#finder)
  - [Organisation du travail](#organisation-du-travail)
    - [Repartition des tâches](#repartition-des-tâches)
    - [Chronologie](#chronologie)
    - [Évolution du projet](#évolution-du-projet)
  - [Misc](#misc)
    - [Bugs et tests non passés.](#bugs-et-tests-non-passés)
    - [Possibles modifications.](#possibles-modifications)
    - [Remarques.](#remarques)

## Identifiants
| Nom | Prénom | Identifiant | Numéro d'étudiant |
| ----------|---------|-------------|-------------------|
| Cortial | Jade | @cortial | 22007013 |
| Mollo Christondis | Felipe Paris | @mollochr | 22006343 |

---
## Fonctionnalités

### Création d'un jeu du type solitaire.
Dans ce projet, vous pourrez créer une variante (Freecell, Seahaven, Bakers, Midnight oil) de jeu solitaire en utilisant n'importe quelle graine de votre choix, les classes et les méthodes responsables pour cette fonctionnalité sont principalement définies sur `TypeSol.ml`, `Card.ml` et `XpatRandom.ml`.

### Simulation d'une partie.
Tous les mouvements, règles et fonctionnalités de jeu d'un jeu de solitaire sont également implémentés dans ce projet, vous pouvez tous les trouver dans le fichier `Solver.ml`.

### Vérification d'un fichier solution.
Une autre fonctionnalité implémentée dans ce projet consiste en une vérification de fichier qui consiste en un programme capable de recevoir un fichier en entrée et de vérifier si ce fichier contient une solution valide pour un jeu de Solitaire (`-check`). Ce fichier est censé être rempli de mouvements de jeu qui seront interprétés par le programme, après cela, le programme évaluera si l'ensemble des mouvements de jeu amène le jeu à une solution ou non. Les méthodes et les définitions de cette fonctionnalité sont également implémentées sur `Solver.ml`

### Recherche d'une solution pour un jeu solitaire.
Enfin, la dernière fonctionnalité implémentée et malheureusement pas complètement fonctionnelle mais très probablement à un bogue près d'être corrigée est la fonctionnalité `- search`. Cette fonctionnalité est capable de prendre un jeu de solitaire et sa graine, pour ensuite analyser si ce jeu a une solution possible. Si le jeu a une solution, le programme affichera l'ensemble des mouvements qui mèneront à un jeu réussi dans un fichier `out.sol`. Les méthodes et les définitions de cette fonctionnalité sont dans le fichier `Finder.ml`

---
## Compilation et exécution
Pour compiler le projet, vous pouvez executer la commande suivante:

```bash
dune build
```
Ensuite pour tester

```bash
dune test
```
On pourrait aussi tester un jeu et un type de graine spécifique, par example:

```bash
./run FreeCell.123 -check tests/I/fc123.sol
```
Cela va indiquer si le fichier `fc123.sol` est une solution ou pas pour le jeu `FreeCell`, initialisé avec la graine `123`.

---
## Découpage modulaire
En plus des fichiers existants dans le projet, tels que `Card.ml` et `XpatSolver.ml`, le projet est principalement défini par 4 modules.

Un module chargé par la définition et la création d'un jeu de solitaire `(TypeSol.ml)`. Après cela, afin de générer toute variation de solitaire, nous avons le module responsable par la génération de permurtations aléatoires (`XpatRandom.ml`). Une fois que nous avons les modules de création et de variation de jeux, nous avons le module responsable par les mécanismes et des règles du jeu (`Solver.ml`). En plus de cela, le module `Solver.ml` contient également les méthodes nécessaires pour vérifier une solution de fichier comme expliqué [ci-dessus](#vérification-dun-fichier-solution). Enfin, nous avons le module `Finder.ml` responsable par le processus de recherche de solutions pour un jeu.

Des modules tels que `TypeSol` et `XpatRandom` finissent par être des fondations / dépendances pour les autres modules de niveau supérieur. Voici une image montrant comment ils communiquent entre eux.

### TypeSol
Dans le fichier TypeSol, les définitions de ce qu'est une structure de jeu et de ce que représente un mouvement de jeu sont définies. En plus des définitions de structure de jeu, ce fichier se compose principalement de trois ensembles de fonctions.

```ocaml

type solitaire = {
  name : string;
  cols : card list Array.t;
  reg : card list Array.t;
  dep : int Array.t;
  hist : player_move list;
}

val prepare_game :
  string -> int list -> int -> int list -> int -> int -> solitaire = <fun>

val create_game : string -> int list -> solitaire = <fun>

val fill_game_attrib : solitaire -> int list -> int list -> solitaire = <fun>

```

Initialement la fonction `create_game()`, chargée de renvoyer un type de solitaire avec sa configuration et son jeu de cartes.

`prepare_game()` qui gère la configuration initiale d'un type solitaire et enfin les fonctions auxiliaires utilisées à `fill_game_attrib()` où toutes les structures de données sont remplies selon la règle du jeu et sa nature.

### XpatRandom
Le module `XpatRandom.ml` est chargé de renvoyer une permutation aléatoire basée sur une graine passée en paramètre. Ce module suit l'ordre indiqué dans le fichier. Voici un aperçu de la fonction principale de lecture aléatoire.

```ocaml
let shuffle n =
   let paires = create_paires n in
   let (f1_init, f2_init) = sort_and_fifo paires in
   let (res, new_f1, new_f2) = tirage_succ f1_init f2_init in
   let (result, _, _) = generate_52_tirages new_f1 new_f2 in
   let reduced_result = reduced_52 result in
   gen_perm reduced_result 
```
La fonction de lecture aléatoire comporte 6 étapes principales.
- `create_paires()` se charge d'appliquer l'algorithme défini au point (a), donc la création des 55 premiers tuples.
- `sort_and_fifo()` est responsable du point (b), triant et renvoyant deux structures de données fifos.
- `tirage_succ()` gère le processus de "shuffling" défini aux points (c) et (d).

Jusqu'à la dernière fonction `gen_perm()` qui appliquera tous les points ci-dessus et les autres non mentionnés ici afin de retourner une permutation aléatoire pour le jeu.

```ocaml
val gen_perm : int list -> int list = <fun>
val shuffle : int -> int list = <fun>
val tirage_succ : int list -> int list -> int list * int list * int list =
  <fun>
val sort_and_fifo : ('a * 'b) list -> 'b list * 'b list = <fun>
val create_paires : int -> (int * int) list = <fun>
val generate_52_tirages :
  int list -> int list -> int list * int list * int list = <fun>
val reduced_52 : int list -> int list = <fun>
```

### Solver
`Solver.ml` contient 4 fonctions principales, ces fonctions sont responsables de l'ouverture, de la lecture, de la validation et de l'exécution de chaque mouvement indiqué dans un fichier passé en paramètre.

```ocaml
val validate : player_move -> solitaire -> bool = <fun>
val execute_move : player_move -> solitaire -> bool = <fun>
val start_game : int list -> string -> string -> unit = <fun>
val solver_routine : solitaire -> string -> bool * int = <fun>
val read_and_execute : in_channel -> solitaire -> int -> bool * int = <fun>
```

- `start_game` lancera le jeu et la routine de résolution.
- `read_and_execute` bouclera chaque ligne du fichier et exécutera chaque mouvement.
- `execute_move` passera par les validations des règles et la structure du jeu, enfin il s'appliquera pour que le jeu s'envole après chaque coup.


### Finder 

---
## Organisation du travail

### Repartition des tâches
### Chronologie
### Évolution du projet

---
## Misc

### Bugs et tests non passés.
### Possibles modifications.
### Remarques.

---