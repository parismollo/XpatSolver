open Sys
open TypeSol
open Card
open XpatRandom

(* source: card to move *)
(* target: card destination *)
type player_move = {source: string ; target: string} 

(* Convert line into player_move type *)
let tokenize line =
  let tokens = String.split_on_char ' ' line in
  {source=List.nth tokens 0; target = List.nth tokens 1}

let rec search_cols card cols col_no = 
  if col_no >= Array.length cols
  then
    (false, card)
  else
    if(List.length cols.(col_no) > 0)
      then
        (* find card *)
        let top_card = Card.to_num (List.hd (cols.(col_no))) in
        if top_card = card 
          then
            (* update list *)
            let _ = Array.set cols col_no (List.tl cols.(col_no)) in
            (true, card)
        else
          search_cols card cols (col_no+1)
      else
        search_cols card cols (col_no+1)

let find_card card game = 
  (* search card in cols *)
  let card_no = Card.to_num card in
  let cols = game.cols in 
  let (found, card) = search_cols card_no cols 0 in
  if found = true
  then
    (found, card)
  else
    (* search card in reg *)
    let reg = game.reg in
    let results = search_cols card_no reg 0 in
    results


let send_card_V card game is_cols = 
  (* if is_cols true then look into columns else look into registers *)
  (* mouvement vers la première colonne vide disponible *)
  let cols = if is_cols = true then game.cols else game.reg in
  let rec loop card cols col_no = 
    if col_no >= Array.length cols
      then
        (false, card)
    else
      if List.length cols.(col_no) = 0
        then
          let _ = Array.set cols col_no [card] in
          (true, card)
      else
        loop card cols (col_no+1)
  in loop card cols 0 
      

let send_card_T card game = 
  (* mouvement vers un registre temporaire inoccupé *)
  send_card_V card game false

let send_card_int card game c_destination = 
  (* c_destination indicates a card in the top of a column, it is in this column that we have to add our card *)
  let cols = game.cols in
  (* card: card to add; c_destination: number of card that we looking for; cols: game cols; col_no: auxiliary variable *)
  let rec search_dest card c_destination cols col_no = 
    if col_no >= Array.length cols
    then
      (false, card)
    else
      if(List.length cols.(col_no) > 0)
        then
          (* find card_destination column *)
          let top_card = Card.to_num (List.hd (cols.(col_no))) in
          if top_card = c_destination 
            then
              (* add to list *)
              let _ = Array.set cols col_no (card :: cols.(col_no)) in
              (true, card)
          else
            search_dest card c_destination cols (col_no+1)
      else
        search_dest card c_destination cols (col_no+1)
  in search_dest card c_destination cols 0 


let send_card card target game =
  match target with 
  (* target: V *)
  | "V" -> send_card_V card game true
  (* target: T *)
  | "T" -> send_card_T card game
  (* target: int *)
  | num -> send_card_int card game (int_of_string num)
  
  
let run_move move game = 
  (* This function supposes that the move is valid *)
  (*1. find card (move.source) at the top of cols or registers *)
  (*2. store card in variable and remove it from current position *)
  let source_card = Card.of_num (int_of_string (move.source)) in
  let find_results = find_card source_card game in 
  let (found, card) = find_results in
  (*3. move card to target based on move.target *)
  if found = false then (false, Card.of_num card)
  else send_card (Card.of_num card) move.target game

(* 1 to 13, valet=11, dame=12, roi=13 *)
(* [Trefle;Pique;Coeur;Carreau] *)
let next_aux idx = 
  match idx with 
  | 0 -> (1, Trefle)
  | 1 -> (1, Pique)
  | 2 -> (1, Coeur)
  | 3 -> (1, Carreau)
  (* [ATTENTION] *)
  | _ -> (-1, Trefle)


let next idx card_no = 
  if card_no = -1 then 
    next_aux idx
  else 
    let number, rank = of_num card_no in
    if number < 13
    then
      (number+1, rank)
    else
      (* Attention to this case - it may brake later*)
      (-1, rank)

let get_next_tab game = 
  (* 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 and 13*)
  (* 0 for clubs 1 for diamonds 2 for hearts 3 for spades *)
  Array.mapi (fun x y -> next x y) game.dep


let check_match next_tab card = 
  let rec loop next_tab card counter = 
    if counter >= Array.length next_tab then
      (false, (-1, Trefle))
    else
      let current_card = next_tab.(counter) in
      let current_card_no = Card.to_num current_card in
      let card_no = Card.to_num card in
      if card_no = current_card_no then
        (true, card)
      else 
        loop next_tab card (counter+1)
  in loop next_tab card 0 

let scan_cols game next_tab is_cols = 
  (* card t <- for each column get the top  *)
  let cols = if is_cols = true then game.cols else game.reg in
  let rec loop cols next_tab counter = 
    (* loop and for each element in top see if there is a match *)
    if counter >= Array.length cols
      then
        (false, (-1, Trefle))
    else
      if(List.length cols.(counter) > 0)
        then
          let card = List.hd (cols.(counter)) in
          let (matched, card) = check_match next_tab card in
          if matched = true
            then
              (* if there is a match, then remove card from colum and return card *)
              let _ = Array.set cols counter (List.tl cols.(counter)) in
              (true, card)
            else
              loop cols next_tab (counter+1) 
      else
        loop cols next_tab (counter+1)
  in loop cols next_tab 0

let scan game next_tab = 
  let (found_cols, card) = scan_cols game next_tab true in
  if found_cols = true
    then
      (found_cols, card)
  else 
    scan_cols game next_tab false


let place_candidate game candidate =
  (* Attention, I used the word rank before to design the card type but maybe *)
  (* the best word for that is suit *)
  let (_, suit) = candidate in
  let card_no = (Card.to_num candidate) in
  match suit with 
  (* maybe return the card? *)
  | Trefle -> let _ = Array.set game.dep 0 card_no in true
  | Pique -> let _ = Array.set game.dep 1 card_no in true
  | Coeur -> let _ = Array.set game.dep 2 card_no in true
  | Carreau -> let _ = Array.set game.dep 3 card_no in true


let normalize_aux game = 
(*Get next tab *)
let next_tab = get_next_tab game in
(*Scan for candidate *)
let results = scan game next_tab in
let (found, candidate) = results in
if found = true then
  place_candidate game candidate
else 
  false

let rec normalize game = 
  let results = normalize_aux game in
  if results = false then false
  else normalize game


let get_color suit = 
  match suit with 
  |Pique|Trefle -> "Noir"
  |Carreau|Coeur -> "Rouge"

let verify_conditions source_card target_card any_color same_color = 
  (* [TODO: ?BUG?]: same color or same type ....???? *)
  let (s_number, s_type) = source_card in
  let (t_number, t_type) = target_card in
  let first_condition = if s_number = t_number - 1 then true else false in
  let second_condition = 
    (* let s_color = get_color s_type in
    let t_color = get_color t_type in *)
    if any_color = true then
      true
    else
    (* 2 Couleurs. Noir = Piques, Trefle. Rouge= Coeur, Carre *)
    if same_color = true then
      if s_type = t_type then true else false
    else 
    if s_type <> t_type then true else false
  in first_condition && second_condition


let verify_conditions_freecell source_card target_card any_color same_color = 
  (* [TODO: ?BUG?]: same color or same type ....???? *)
  let (s_number, s_type) = source_card in
  let (t_number, t_type) = target_card in
  let first_condition = if s_number = t_number - 1 then true else false in
  let second_condition = 
    (* let s_color = get_color s_type in
    let t_color = get_color t_type in *)
    if any_color = true then
      true
    else
    (* 2 Couleurs. Noir = Piques, Trefle. Rouge= Coeur, Carre *)
    if same_color = true then
      if s_type = t_type then true else false
    else 
    if s_type <> t_type then true else false
  in first_condition && second_condition

let general_rule_1 move game any_color same_color = 
  (* [Attention]: It supposes that move is for a specific card in column *)
  (* [Attention]: This rule only apply if move is to a specific column *)
  let target_card = Card.of_num (int_of_string (move.target)) in
  let source_card = Card.of_num (int_of_string (move.source)) in
  (* Check if source_card is valid according to the top_card value and color*)
  verify_conditions source_card target_card any_color same_color

let general_rule_1_freecell move game any_color same_color = 
  (* [Attention]: It supposes that move is for a specific card in column *)
  (* [Attention]: This rule only apply if move is to a specific column *)
  let target_card = Card.of_num (int_of_string (move.target)) in
  let source_card = Card.of_num (int_of_string (move.source)) in
  (* Check if source_card is valid according to the top_card value and color*)
  verify_conditions source_card target_card any_color same_color

let validate_freecell move game = 
  (*  
  Rule #1: Une colonne non vide ne peut recevoir qu'une carte immédiatement inférieure, et de couleur alternée.
  Par exemple une colonne ayant un 3 de coeur à son sommet ne pourra recevoir qu'un 2 de pique ou un 2 de trèfle.
  Rule #2: Une colonne vide peut recevoir n'importe quelle carte, de même pour un registre.  
 *)
  match move.target with 
  | "V" -> true
  | "T" -> true
  | _ -> general_rule_1_freecell move game false false 

let validate_sea move game = 
  (*   
  Rule #1: Une colonne non vide ne peut recevoir que la carte immédiatement inférieure et de même couleur. 
  Par exemple une colonne ayant un 3 de coeur à son sommet ne pourra recevoir qu'un 2 de coeur.
  Rule #2: Une colonne vide ne peut recevoir qu'un Roi.
  *)
  match move.target with
  | "V" -> let (value, color) = Card.of_num (int_of_string move.source) in 
    if value = 13 then true else false
  | "T" -> true (*[ATTENTION]: not sure about this*)
  | _ -> general_rule_1 move game false true

let validate_midnight move game = 
  (* 
  Rule #1: Comme pour Seahaven, une colonne ne peut recevoir que la carte immédiatement inférieure et de même couleur.
  Rule #2: Par contre ici une colonne vide n'est *pas* remplissable.  
  *)
  match move.target with
  | "V" -> false
  | "T" -> false
  | _ -> general_rule_1 move game false true

let validate_bakers move game = 
  (*  
  Rule #1: Une colonne peut recevoir une carte immédiatement inférieure, peu importe sa couleur.
  Rule #2: Une colonne vide n'est *pas* remplissable.
  *)
  match move.target with
  | "V" -> false
  | "T" -> false
  | _ -> general_rule_1 move game true false

let validate move game = 
  let game_name = game.name in
  match game_name with 
    | "freecell" -> validate_freecell move game
    | "seahaven" -> validate_sea move game
    | "bakers" -> validate_bakers move game
    | "midnight" -> validate_midnight move game
    | _ -> validate_midnight move game

let execute_move move game = 
  (*normalize*)
  let result_normalize = normalize game in
  (* validate move according to game *)
  let result_validate = validate move game in
  if result_validate = true then
    (* let _ = (Printf.printf "VALIDATE IS TRUE";) in *)
    let (results, card) = run_move move game in
    if results = true then 
      (* let _ = (Printf.printf "RUN MOVE IS TRUE";) in *)
      results 
    else 
      (* let _ = (Printf.printf "RUN MOVE IS FALSE";) in  *)
      results
  else 
    (* let _ = (Printf.printf "VALIDATE IS FALSE";) in *)
    false
  
let all_cols_empty game = 
  (* [TODO:OPT] use for all instead*)
  let cols = game.cols in
  let not_empty =  Array.exists (fun x -> if List.length x > 0 then true else false) cols in
  if not_empty then false else true

let all_regs_empty game =
  (* [TODO:OPT]: replicated code -> extends all_cols_empty *)
  let regs = game.reg in
  let not_empty =  Array.exists (fun x -> if List.length x > 0 then true else false) regs in
  if not_empty then false else true


let is_the_king card_no = 
  let (number, rank) = Card.of_num card_no in
  if number = 13 then true else false

let check_depots game =
  (* for each depot get card and check card number if != 13 not complete, i.e the top card must be the 13 of something*)
  let depot = game.dep in
  Array.for_all (fun x -> is_the_king x) depot

let game_over game counter = 
  let _ = normalize game in
  let results_from_cols = all_cols_empty game in
  if results_from_cols = false then (false, counter)
  else let results_from_regs = all_regs_empty game in
  if results_from_regs = false then (false, counter)
  else
    let res = check_depots game in
    (res, counter)
  


let print_player_move move = 
  let _ = Printf.printf "MOVE: {source: %s; target: %s} \n" move.source move.target in 
  ()
(* Read file and execute each line *)
let rec read_and_execute file game counter =
  try
    let line = input_line file in
    (* let _ = Printf.printf "LINE: %s " line in  *)
    let player_move = tokenize line in
    let _ = print_player_move player_move in
    (* TODO: à la fin normalizer *)
    let result = execute_move player_move game in
    if result = false then
      let _ = Printf.printf "EXECUTE FALSE" in
      (false, counter)
      (* [TODO] add N value for echec *)
      (* print_string "ECHEC"; *)
      (* exit 1; *)
    else
      (* let _ = Printf.printf "NEXT " in *)
      read_and_execute file game (counter+1)
  with 
    End_of_file -> game_over game counter

(* Open solutions file and call read_and_execute *)
let solver_routine game mode =
  (* Open solutions file *)
  let solutions = open_in mode in
  (* print_string mode; *)
  (* Read and execute file content *)
  read_and_execute solutions game 1

(* Start game with config type *)
let start_game seed game mode =
  (* Create permutation p*)
  let p = seed in
  (* Create game g with p*)
  let g = create_game game p in
  (* Start solver_routine sr *)
  (* [TODO]: show game config *)
  let (result, counter) = solver_routine g mode in
  if result = true then
    (Printf.printf "\nSUCCES\n";)
  else 
    (Printf.printf "\nECHEC %n\n" counter; exit 1);
  ()