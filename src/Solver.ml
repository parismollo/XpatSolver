
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


let send_card card target game =
  (* target: V *)
  (* target: T *)
  (* target: int *)


let run_move move game = 
  (* This function supposes that the move is valid *)
  (*1. find card (move.source) at the top of cols or registers *)
  (*2. store card in variable and remove it from current position *)
  let find_results = find_card move.source game in 
  let (found, card) = find_results in
  (* [TODO]: 3. move card to target based on move.target *)
  send_card card move.target game
  
let execute_move move game = 
  (* [TODO]: normalize *)
  let result_normalize = normalize in
  (* [TODO]: validate move according to game *)
  let result_validate = validate move game in
  (* [TODO]: run move *)
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
