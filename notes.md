# POA

## Partie II

### II.1 Comportement attendu
#### Overview
- [ ] 1. Programme devra accepter l'option `-search` suivi d'un nom de fichier, (toujours en plus d'un argument du style `FreeCell.123456`. e.g `XpatSolver -search file.sol FreeCell.123`. **Le programme doit chercher une solution pour le jeu.**
- [ ] 2. Si solution trouvé
   - [ ] 2.1. Ecrire solution (historique de coups) dans le fichier au nom indiqué après `-search`, dans le format des fichiers solution vu en Partie I.
   - [ ] 2.2. Ecrire dans le fichier au nom indiqué après `-search`, dans le format des fichiers solution vu en Partie I
   - [ ] 2.3. Programme devra afficher ensuite `SUCCES` seul sur une dernière ligne de sa sortie standard, puis exécuter un `exit 0`.

### II.2 Méthode de recherche
- [ ] 1. A tout moment, on a un ensemble d'états restant à visiter (au début juste l'état initial), et un ensemble d'états déjà traités (au début vide). La visite d'un état consiste à calculer les états atteignables par des coups légaux à partir de cet état, puis mettre ces nouveaux états parmi ceux à visiter (sauf ceux qui ne sont pas si nouveaux que cela mais au contraire sont déjà parmi les traités), puis mettre l'état qui vient d'être visité parmi les traités.
  - [ ] 1.1 On rappelle que les états qu'on manipule devront toujours être normalisés
    - [ ] 1.1.1 Debut de partie
    - [ ] 1.1.2 Apres chaque coup
  - [ ] 1.2 Score: le nombre de cartes qu'il a dans son dépôt. Configuration gagnant - score de 52. 
    - [ ] 1.2.1 Si la recherche rencontre cet état, une solution existe, et on arrête la recherche
  - [ ] 1.3 Historique: l'historique des coups de l'état gagnant donne alors une solution à la partie explorée.
    - **ATTENTION:** Cette approche nécessite par contre d'utiliser une comparaison particulière entre états, et non `Stdlib.compare`
  - [ ] 1.4 Si on ne rencontre jamais l'état gagnant, et que l'ensemble des états restant à visiter devient vide, c'est que la recherche est terminée sans solution
  - [ ] 1.5 Méthode: Une autre méthode possible est de s'intéresser aux scores des états, et de visiter d'abord les états ayant les scores les plus élevés.Les scores étant entre 0 et 52, on pourra ranger les états encore à visiter selon leurs scores. Attention, un tel parcours peut souvent passer par des "impasses" (états aux scores élevés mais sans coups légaux restants, ou seulement vers des états déjà vus). Il faut alors retourner à des états restants à visiter mais ayant des scores un peu moins bon. **Pour indiquer à l'utilisateur où en est la recherche, quelques affichages intermédiaires pourront être utiles, ni trop ni trop peu.**


### II.3 Codage d'ensemble d'états
- [ ] Déterminer si un état a déjà été rencontré, pour éviter les cycles.
  - [ ] Pour cela, on utilise ici des ensembles d'états, et on tester l'appartenance à un tel ensemble. L'usage du module `Set` d'OCaml (Voir sujet.md)
  - [ ] Les résultats de ces appels à `compare_state` doivent être stables : si on compare deux états deux fois, on doit avoir le même résultat.
  - [ ] Pour le bon fonctionnement de l'algorithme de recherche, il est alors crucial que dans ce cas `compare_state` réponde une égalité (code `0`). Bref, pour `compare_state`, au lieu de comparer deux états entiers directement via `Stdlib.compare`, on pourra comparer leurs zones de registres respectives (p.ex. par `Stdlib.compare`), et en cas d'égalité seulement comparer leurs zones de colonnes respectives (via un autre `Stdlib.compare`). Et rien de plus.


### Conseils 
- [ ] Ne pas distinguer l'ordre des cartes dans les registres (ce qui revient p.ex. à trier ces registres), si on a plusieurs colonnes vides, pas besoin de considérer le déplacement d'une carte vers toutes ces colonnes vides, le faire vers la première suffira.
- [ ] De même, lors de la recherche, certains coups pourtant légaux pourront être ignorés, car ils n'apporteront rien de plus. Par exemple si une colonne est constituée d'une seule carte, ce n'est pas utile de considérer le déplacement de cette carte vers une colonne vide, on se retrouverait alors dans une situation équivalente.
- [ ] La remarque suivante concerne spécifiquement les parties qui empilent des cartes de même couleur (Seahaven et Midnight Oil). Comme en plus ces parties ont un usage contraint des colonnes vides, alors une longue séquence de cartes décroissantes de même couleur ne pourra plus être déplacée, et ne pourra évoluer que via une mise au dépôt. Par "longue", on entend ici (n+2) cartes au moins si l'on a n registres. Dans cette même colonne, si enfin une "petite" carte de la même couleur se trouve bloquée quelque part sous la "longue" séquence, alors la mise au dépôt de ces cartes sera toujours impossible. On pourra donc chercher en sommet de colonnes de telles "longues séquences bloquées", et supprimer de la recherche les états qui en contiennent, car ils sont insolubles.