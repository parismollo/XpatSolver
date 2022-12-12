
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
  (* [TODO]: 3. move card to target based on move.target *)
  send_card (Card.of_num card) move.target game
  
let execute_move move game = 
  (* [TODO]: normalize *)
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
