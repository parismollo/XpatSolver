(* type solitaire: nom, colonnes, registres, depot et historique *)
type solitaire = {
  name : string;
  cols : int list Array.t;
  reg : int list Array.t;
  dep : int Array.t;
  hist: int
}
(* TODO: creer un type pour chaque jeu contentant leurs configurations (fait partie du procesus
   de generalisation des methods pour tous types) *)

(* type jeux soit c'est Freecell, soir Seahaven, soit Bakers, soit Midnight *)
type jeu = 
    |Seahaven of solitaire
    |Freecell of solitaire
    |Bakers   of solitaire
    |Midnight of solitaire

let fill_col cols col_size index cards =
  let target_cards = List.filteri (fun idx card -> if idx < col_size then true else false) cards in
  let cards_left = List.filteri (fun idx card -> if idx >= col_size then true else false) cards in
  let results = Array.set cols index target_cards in
  (cols, cards_left)
  

let rec fill_cols cols cards cardsPerCol index = 
  (*set each col in columns*)
  match cardsPerCol with
  | [] -> (cols, cards)
  | col_size :: t_cardsPerCol -> let (updated_cols, cards_left) = fill_col cols col_size index cards in
  fill_cols updated_cols cards_left t_cardsPerCol (index+1)


let fill_game_attrib game cards cardsPerCol = 
  let (cols, cards_left) = fill_cols game.cols cards cardsPerCol 0 in
  let game = {game with cols = cols} in game




let prepare_game game_name cards nbcols cardsPerCol nbReg nbDepot= 
  let name = game_name in
  let history = 0 in
  let dep = Array.make nbDepot 0 in
  let registers = Array.make nbReg [] in
  let columns = Array.make nbcols [] in 
  let game = {name=name; cols=columns; reg=registers; dep=dep; hist=history} in
  fill_game_attrib game cards cardsPerCol


let create_game game_name cards = 
  match game_name with 
    | "freecell" -> prepare_game game_name cards 8 [7; 6; 7; 6; 7; 6; 7; 6] 4 4
    (* | "seahaven" -> prepare_game game_name cards 10 (List.init 10 (fun x -> 5)) 4 2
    | "bakers" -> prepare_game game_name cards 13 (List.init 13 (fun x -> 4)) 0 4
    | "midnight" -> prepare_game game_name cards 18 (List.init 18 (fun x -> 3)) 0 4 *)
    | _ -> raise Not_found
