(*creation des solitaires 
   ainsi que leurs methodes pour initialiser les regles *)

   (*le jeu global*)
   type solitaire

   (*initialiser le nombre de colonnes, registre et depots*)
   type game_config

   (*les 4 differents solitaires*)
   type game

   (*initialiser game_config pour le type de game freecell*)
   val free_config : game_config
   (*initialiser game_config pour le type de game seahaven*)
   val sea_config : game_config 
   (*initialiser game_config pour le type de game midnight*)
   val midnight_config : game_config 
   (*initialiser game_config pour le type de game bakers*)
   val bakers_config : game_config 

   (*remplit les colonnes par les cartes de la permutation*)
   val fill_col : 'a list array -> int -> int -> 'a list -> 'a list array * 'a list

   (**)
   val fill_cols : 'a list array -> 'a list -> int list -> int -> 'a list array * 'a list

   (**)
   val fill_game_attrib : solitaire -> int list -> int list -> solitaire

   (**)
   val prepare_game : string -> int list -> int -> int list -> int -> int -> solitaire

   (**)
   val create_game : string -> int list -> solitaire