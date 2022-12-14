
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
  send_card (Card.of_num card) move.target game

(* 1 to 13, valet=11, dame=12, roi=13 *)
(* [Trefle;Pique;Coeur;Carreau] *)
let next_aux idx = 
  match idx with 
  | 0 -> (1, Trefle)
  | 1 -> (1, Pique)
  | 2 -> (1, Coeur)
  | 3 -> (1, Carreau)


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
          (* [TODO]: check_math: see if there is any match with top return boolean and card*)
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
(* [TODO]: Place candidate  *)
if found = true then
  place_candidate game candidate
else 
  false

let rec normalize game = 
  let results = normalize_aux game in
  if results = false then false
  else normalize game

let execute_move move game = 
  (* [TODO]: normalize. Attention: this might have to
    happen many times until no more normalizes - maybe rec *)
  let result_normalize = normalize in
  (* [TODO]: validate move according to game *)
  let result_validate = validate move game in
  run_move move game
  

(* Read file and execute each line *)
let rec read_and_execute file game =
  try
    let line = input_line file in
    let player_move = get_player_move line in
    let result = execute_move player_move game in
    (* [TODO]: if result = "Bad" then close and exit result*)
    (* [TODO]: if result = "Good" then close and exit result  *)
    read_and_execute file
  with 
    End_of_file -> ()

(* Open solutions file and call read_and_execute *)
let solver_routine game config = 
  (* Open solutions file *)
  let solutions = open_in config.mode in
  (* Read and execute file content *)
  let read_and_execute solutions game


(* Start game with config type *)
let start_game config =
  (* Create permutation p*)
  let p = shuffle config.seed in
  (* Create game g with p*)
  let g = create_game config.game p in
  (* Start solver_routine sr *)
  let result = solver_routine g config
