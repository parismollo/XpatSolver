(*creation des solitaires 
   ainsi que leurs methodes pour initialiser les regles *)

   (*le jeu global*)
   type solitaire

   (*les 4 differents solitaires*)
   type jeux

   (*creation des depots*)
   val create_depot : (unit -> solitaire) -> int list

   (*creation des registres*)
   val create_reg : string -> int list

   (*creation des colonnes qui auront une certaine distribution de cartes par colonne*)
   val create_cols : string -> int list list

   (*repartition des cartes par colonnes avec idx le nombre de cartes par colonne*)
   val create_fifo : int -> string -> int list