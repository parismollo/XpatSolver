# Rapport de Paris Mollo et de Jade Cortial :
<!-- 
4. Donnez une description des traitements pris en charge par chaque module de votre projet. Précisez le rôle et la nécessité de chaque module ajouté au dépôt initial.
-->
## Identifiants
| Nom | Prénom | Identifiant | Numéro d'étudiant |
| ----------|---------|-------------|-------------------|
| Cortial | Jade | @cortial | 22007013 |
| Mollo Christondis | Felipe Paris | @mollochr | 22006343 |

## Fonctionnalités
Pour le sujet minimal nous avons implémentés la première parties qui consiste à simuler une partie et valider une solution existante. Pour la deuxième partie nous avons implémentés la méthode de recherche avec le codage d'ensemble d'états mais le comportement attendu pour l'option `-search` n'a pas pu être implémenté à temps et nous n'avons pas implémentés d'extensions au sujet minimal.

## Compilation et exécution

### Compilation
Pour compiler le projet, vous pouvez executer la commande suivante:
```bash
dune build
```
Vous pouvez également utiliser le `Makefile`:
```bash
make
```
### Execution
Pour lancer le projet, vous pouvez executer le fichier `run`. Il faudra alors lui passer
plusieurs paramètres. Voici un exemple de la page d'aide:
```bash
XpatSolver <game>.<number> : search solution for Xpat2 game <number>
-check <filename>: Validate a solution file
-search <filename>: Search a solution and write it to a solution file (pas encore fonctionnel)
```
Voici un exemple pour chercher une solution et l'écrire dans le fichier `test.sol` si elle existe:
```bash
./run FreeCell.123456 -search test.sol
```Enfin, un deuxième exemple pour vérifier si un fichier solution est correcte:
```bash
./run FreeCell.123 -check tests/I/fc123.sol
```
## Découpage modulaire
Nous avons utilisé dans notre projet ces modules qui existait de base dans le projet :
### Card.ml
Le module `Card` nous permet d'utiliser ces fonctions dans la manipulation du solitaire pour illustrer les cartes du jeu.
### XpatRandom.ml
Le module `XpatRandom` nous permet de résoudre un jeu de solitaire appelé Xpat2. Le programme prend en entrée un nom de jeu et un numéro de graine et peut être exécuté soit pour valider une solution existante en utiisant l'option "-check". Soit pour chercher une solution et l'écrire dans un fichier en utilisant l'option.

Également nous avons eu besoin de créer plusieurs modules. Notamment un module
**TypeSol.ml** , **Finder.ml** , **Solver.ml** , **Test.ml** et **XpatSolver.ml** .

### TypeSol.ml
Le module `TypeSol` contient toutes les fonctions pour un solitaire parmis les différents solitaire demandés. Voici une description des différentes fonctions de notre module:
#### 1. display : permet d'afficher les registres et les colonnes en appelant display_list_list et d'afficher les dépots en appelant display_depo. 
#### 2. display_depo : si l'élément courant est différent de -1, il utilise la fonction of_num pour convertir cet élément en une carte, puis utilise la fonction to_string pour obtenir une chaîne de caractères représentant cette carte.  Il affiche ensuite cette chaîne de caractères à l'aide de Printf.printf et appelle récursivement display_depo sur le reste de la liste.
#### 3.  display_list_list : pour chaque liste, il affiche d'abord une nouvelle ligne et le caractère " | " à l'aide de Printf.printf, puis appelle récursivement display_list sur cette liste.
#### 4. display_list : pour chaque élément, il utilise la fonction to_string pour obtenir une chaîne de caractères représentant cette carte, puis l'affiche à l'aide de Printf.printf. Il appelle ensuite récursivement display_list sur le reste de la liste
#### 5. create_game : en fonction du nom du solitaire, on va appeler prepare_game
#### 6. prepare_game : initialise chaque élément du solitaire et crée game avec tout ces attributs et appele fill_game
#### 7. fill_game_attrib : appele la fonction fill_cols pour remplir chaque colonne du solitaire avec les cartes et renvoie un tuple contenant les colonnes remplies et les cartes qui restent.
Puis si name est `Seahaven` alors on prend la 1ère carte de cards_left et on met dans registre 0 et on prend la dernière carte de cards_left et on met dans registre 1. 
Si name est bakers alors appelle de dethronement sur les colonnes remplies avant de mettre à jour les colonnes du jeu avec le resultat de la fonction. Si ni seahave ni bakers alors fill_game_attrib met à jour les colonnes du jeu avec les colonnes remplies sans modifications. Puis retourne un nouvel objet game avec les colonnes mise à jour.
#### 8. dethronement : met les rois au fond de la colonne (que pour bakers). Cette fonction appele la fonction update_kings qui s'occupe de modifier les rois de place.
#### 9. update_kings : regarder dans la colonne s'il y a un roi et s'il y en a un alors la taille de kings qui était à 0 alors il n'y a pas de roi dans la colonne donc on la laisse intacte. Sinon s'il y en a un alors on va regarder chaque carte de la col si c'est pas un roi on va l'ajouter à la liste kings (ce qui fera en sorte que le roi soit bien au fond du paquet)
#### 10. fill_cols : va remplir chaque colonne du solitaire avec les cartes. cardsPerCol est une liste d'entiers représentant la taille de chaque col. Si cardsPerCol est une liste vide alors on retourne un tuple contenant cols et cards. Sinon si cardsPerCol n'est pas vide alors on appelle fill_col pour remplir la colonne courante et on appelle récursivement fill_cols avec le tableau cols qui a été mise à jour, cards_left retourné par fill_col, la queue de la liste cardsPerCol et index incrémenté. On continue jusqu'à que cardsPerCol soit une liste vide.
#### 11. fill_col : trie cards en 2 listes (target_cards qui se compose des premiers éléments col_size de cards et cards_left qui se compose des éléments restant de cards). Puis convertit target_cards en list de card à l'aide de Card.of_num et définit l'index-ième élément de cols sur la liste inversée des cartes. Enfin la fonction retourne un tuple contenant cols mise à jour et cards_left.

### Finder.ml
Le module `Finder` contient toutes les fonctions pour effectuer
### Solver.ml
Le module `Search` contient toutes les fonctions pour effectuer 
### Test.ml
Le module `Test` contient toutes les fonctions pour effectuer la lecture et l'exécution de Solver.ml. Voici une description des différentes fonctions de notre module :
### XpatSolver.ml 
Le module `XpatSolver` contient toutes les fonctions pour effectuer un programme qui résout un jeu de solitaire appelé Xpat2. Le programme prend en entrée un nom de jeu et un numéro de graine et peut être exécuté de 2 manières différentes. Soit pour valider une solution existante en utilisant l'option "-check". Soit pour chercher une solution et l'écrire dans un fichier en utilisant l'option "-search". Voici une description des différentes fonctions de notre module:
#### 1. getgame : prend entrée une chaine de caractères et renvoie la valeur du type game correspondante. Si aucune valeur du type game ne correspond à la chaine donnée, la fonction lève une exception Not_found.
#### 2. split_on_dot : prend en entrée une chaine de caractères et renvoie un tuple de 2 chaine séparées par un point. Si la chaine ne contient pas de point, la fonction lève une exception Not_found.
#### 3. set_game_seed : prend en entrée une chaine de caractères et met à jour les champs game et seed de l'objet config en utilisant les fonctions split_on_dot et getname. Si une erreur se produit lors de l'utilisation de ces fonctions, la fonction affiche un message d'erreur.
#### 4. get_game : prend en entrée un paramètre game qui est un type de jeu (Freecell, Baker, Midnight ou Seahaven) et renvoie une chaîne de caractères correspondante.
#### 5. treat_game : commence par utiliser la graine de génération aléatoire pour créer une permutation de nombres, puis l'affiche. Ensuite, elle utilise cette permutation pour jouer au jeu en utilisant la fonction start_game ou start_finder, selon le mode de jeu spécifié dans la configuration. Enfin, elle utilise la fonction exit pour quitter le programme.
#### 6. main :  gère les arguments de ligne de commande et de configurer la configuration de jeu en fonction de ces arguments. Il utilise la fonction Arg.parse pour gérer les options -check et -search, qui définissent le mode de jeu et le nom de fichier à utiliser (si nécessaire). Il utilise ensuite la fonction set_game_seed pour configurer la graine de génération aléatoire, puis appelle la fonction treat_game pour démarrer le jeu.


## Organisation du travail
<!--- Répartition des tâches entre les membres au cours du temps
- Brève chronologie de notre travail
-->

## Misc 
<!--Remarques, suggestions, questions...-->

