open Card
(* type solitaire: nom, colonnes, registres, depot et historique *)
type player_move = {source: string ; target: string} 

type solitaire = {
  (*convert cols and registers into card list Array.t *)
  name : string;
  cols : card list Array.t;
  reg : card list Array.t;
  dep : int Array.t;
  hist: player_move list
}
(* Attention to hist, I have to append every time! *)

type game_config = {
  nbcols : int;
  nbreg : int;
  nbdep : int
}

let free_config = {nbcols=8; nbreg=4; nbdep=4}
let sea_config = {nbcols=10; nbreg=4; nbdep=4}
let midnight_config = {nbcols=18; nbreg=0; nbdep=4}
let bakers_config = {nbcols=13; nbreg=0; nbdep=4}

type game = 
  | Seahaven of solitaire
  | Freecell of solitaire
  | Bakers   of solitaire
  | Midnight of solitaire

let fill_col cols col_size index cards =
  let target_cards = List.filteri (fun idx card -> if idx < col_size then true else false) cards in
  let cards_left = List.filteri (fun idx card -> if idx >= col_size then true else false) cards in
  (*convert target_cards into list of cards *)
  let results = Array.set cols index (List.rev(List.map (fun value -> Card.of_num value) target_cards)) in
  (cols, cards_left)
  
let rec fill_cols cols cards cardsPerCol index = 
  (*set each col in columns*)
  match cardsPerCol with
  | [] -> (cols, cards)
  | col_size :: t_cardsPerCol -> let (updated_cols, cards_left) = fill_col cols col_size index cards in
  fill_cols updated_cols cards_left t_cardsPerCol (index+1)

let update_kings col = 
  let kings = List.filter (
    fun x -> let (number, color) = x in
    if number = 13 then true else false
  ) col 
  in 
  if List.length kings > 0 then
    let no_kings = List.filter (
      fun x -> let (number, color) = x in
      if number <> 13 then true else false
    ) col
    in
    List.append no_kings kings 
  else
    col

let dethronement cols = 
  (* this function put alls kings to the bottom of the column (this is only applied for bakers) *)
  Array.map (fun x -> update_kings x) cols

let fill_game_attrib game cards cardsPerCol = 
  (* fill_game : return game solitaire *)
  (* this filling pipeline changes according to each game *)
  (* freecell: 52 cards to cols*)
  (* seahaven: 50 cards to cols 2 to registers*)
  (* midnight: 52 cards to cols*)
  (* bakers:  52 cards to cols*)
  let (cols, cards_left) = fill_cols game.cols cards cardsPerCol 0 in
  if (game.name = "seahaven") then 
    (* convert cards_left into cards list *)
    let _ = Array.set game.reg 0 [(Card.of_num (List.hd cards_left))] in
    let _ = Array.set game.reg 1 [(Card.of_num(List.hd (List.rev cards_left)))] in
    {game with cols = cols}
  else
    (* if bakers rearrange kings *)
    if (game.name = "bakers") then
      {game with cols = dethronement cols}
    else
      {game with cols = cols}



let prepare_game game_name cards nbcols cardsPerCol nbreg nbdepot= 
  (* prepare_game : return game solitaire *)
  (* initiate all attributes and call fill_gamme_attrib function *)
  let name = game_name in
  let history = [] in
  let dep = Array.make nbdepot (-1) in (*ATTENTION WITH -1 MAY BREAK SOMETHING LATER*)
  let registers = Array.make nbreg [] in
  let columns = Array.make nbcols [] in 
  let game = {name=name; cols=columns; reg=registers; dep=dep; hist=history} in
  fill_game_attrib game cards cardsPerCol


let create_game game_name cards = 
  (* create_game : returns game solitaire*)
  (* for each type, return game with correct configurations *)
  match game_name with 
    | "freecell" -> prepare_game game_name cards free_config.nbcols [7; 6; 7; 6; 7; 6; 7; 6] free_config.nbreg free_config.nbdep
    | "seahaven" -> prepare_game game_name cards sea_config.nbcols (List.init 10 (fun x -> 5)) sea_config.nbreg sea_config.nbdep
    | "bakers" -> prepare_game game_name cards bakers_config.nbcols (List.init 13 (fun x -> 4)) bakers_config.nbreg bakers_config.nbdep
    | "midnight" -> prepare_game game_name cards midnight_config.nbcols ((List.init 17 (fun x -> 3))@ [1]) midnight_config.nbreg midnight_config.nbdep
    | _ -> raise Not_found


let game_1 = create_game "freecell" [13; 32; 33; 35; 30; 46; 7; 29; 9; 48; 38; 36; 51; 41; 26; 20; 23; 43; 27; 42; 4; 21; 37; 39; 2;
15; 34; 28; 25; 17; 16; 18; 31; 3; 0; 10; 50; 49; 14; 6; 24; 1; 22; 5; 40; 44; 11; 8; 45; 19; 12; 47]

let game_2 = create_game "seahaven" [13; 32; 33; 35; 30; 46; 7; 29; 9; 48; 38; 36; 51; 41; 26; 20; 23; 43; 27; 42; 4; 21; 37; 39; 2;
15; 34; 28; 25; 17; 16; 18; 31; 3; 0; 10; 50; 49; 14; 6; 24; 1; 22; 5; 40; 44; 11; 8; 45; 19; 12; 47]

let game_3 = create_game "bakers" [13; 32; 33; 35; 30; 46; 7; 29; 9; 48; 38; 36; 51; 41; 26; 20; 23; 43; 27; 42; 4; 21; 37; 39; 2;
15; 34; 28; 25; 17; 16; 18; 31; 3; 0; 10; 50; 49; 14; 6; 24; 1; 22; 5; 40; 44; 11; 8; 45; 19; 12; 47]

let game_4 = create_game "midnight" [13; 32; 33; 35; 30; 46; 7; 29; 9; 48; 38; 36; 51; 41; 26; 20; 23; 43; 27; 42; 4; 21; 37; 39; 2;
15; 34; 28; 25; 17; 16; 18; 31; 3; 0; 10; 50; 49; 14; 6; 24; 1; 22; 5; 40; 44; 11; 8; 45; 19; 12; 47]


let rec display_depo lst = 
  match lst with
  | [] -> ()
  | hd::tl ->
      if hd != -1 then
        let card = of_num hd in
        Printf.printf "%s " (to_string card); 
        display_depo tl 
      else 
        display_depo tl 
      
  
let rec display_list list =
  match list with 
  | [] -> ()
  | card :: sub_list ->
      Printf.printf "%s ;%!" (to_string card);
      display_list sub_list;;
  
let rec display_list_list col_or_depots = 
  match col_or_depots with
  | [] -> ()
  | col :: sub -> Printf.printf "\n | "; display_list col; display_list_list sub ;;

  
let display game = 
  let registers_list = Array.to_list game.reg in
  let columns_list = Array.to_list game.cols in 
  let depots_list = Array.to_list game.dep in
  Printf.printf "Registers : \n";
  display_list_list registers_list;
  Printf.printf "\nColumns : \n";
  display_list_list columns_list;
  Printf.printf "\nDepots : \n";
  display_depo depots_list;;