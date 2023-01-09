open Sys
open TypeSol
open Card
open XpatRandom
open Solver

let update_visited_states visited_array new_visited_state = 
  (* visited_array.append(new_visited_state) *)

let can_visit visited_array new_state_opt =
  (* for visited in visited_array
      if new_state == visited then false
  return true *)

let update_move_history mv_hist new_move = 
    (* // after taking a decision for a move
    // update this variable
    mv_hist.append(new_move) *)
          
let get_all_tops game = 
  (* Returns all top cards found in columns and registers in int format*)
  let all_cols = 
    List.filter (fun x -> if x = -1 then false else true)(Array.to_list (Array.map (fun x -> if List.length x > 0 then (to_num (List.hd x)) else -1) game.cols)) in
  let all_reg = 
    List.filter (fun x -> if x = -1 then false else true) (Array.to_list (Array.map (fun x -> if List.length x > 0 then (to_num (List.hd x)) else -1) game.reg)) in
  all_cols @ all_reg;;
  
let apply_third_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) list = 
  (* let game_cpy = copy game in
  let list  = [] in
  for each col in game_cpy:
      if  col not empty:
          let move = {source=top_card; target=col.top_card}
          let res = execute_move move game_cpy 
          if res = true then 
              let score = get_score game
              list.add((true, move, game_cpy, score))
          else 
              list.add((false, ....))
        else
            list.add((false, ....)
  return filter(list, true) #return only true *)
  [(true, {source="12"; target="T"}, game, 2); (false, {source="15"; target="T"}, game, 10)];;
  
let apply_second_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) = 
  (* let game_cpy = copy game in
  let move = {source=card; target="V"} in
  let results = execute_move move game_cpy
  if results = true then
      let score = get_score game_cpy in
      (true, move, game_cpy, score)
  else 
      (false, move, game_cpy, 0) *)
  (true, {source="50"; target="T"}, game, 7);;
  
let apply_first_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) = 
  (* let game_cpy = copy game in
  let move = {source=card; target="T"} in
  let results = execute_move move game_cpy
  if results = true then
      let score = get_score game_cpy in
      (true, move, game_cpy, score)
else 
  (false, move, game_cpy, 0) *)
  (true, {source="10"; target="T"}, game, 50);;
  
let get_card_moves (game:solitaire) (top_card:card) : (bool * player_move * solitaire * int) list = 
  (* This function get all possible moves for a specific card
    For a card, there are 3 possible move types: 
      1. Move a card to an empty register
      2. Move a card to an empty column
      3. Move a card to a non-empty column
  *)  
  
  let first_result = apply_first_move_type top_card game in
  let second_result = apply_second_move_type top_card game in
  let third_result = apply_third_move_type top_card game in
  let all_results = [first_result] @ [second_result] @ third_result in 
  
  List.filter (fun x -> 
      let (bool, move, game, score) = x in
      if bool = false then false else true) all_results;;

let get_all_poss_moves game =
  (* ATTENTION: Array.append will return a new array!! *)
  (*
    This function will get all possible moves from the "game" current state
    It will return a list of tuples of the following type:
    [(player_move, game_variation, game_score); ....]
    This means that  we have a move, the resulting game with this move and the score of this game variation
  *)
  let list = get_all_tops game in
  let rec loop list = 
    match list with
    |[] -> []
    |top_card :: tl -> (get_card_moves game top_card) @ loop tl in
  loop (List.map (fun x -> of_num x) list);;

let write_solution (history:player_move list) (file:string) : unit = 
  (* let oc = open_out file in (*file open with write mode*)
  let write_move (move:player_move) : unit = (*write a move in a file followed by a newline*)
    output_string oc (move.source ^ " " ^ move.target "\n") in
    List.iter write_move history; close_out oc (*iterates over the list of words and writes each word to the file*)
  () *)


let find_solution (game:solitaire) : bool * player_move list =
  (* 1. Normalize game *)
  let result_normalize = normalize game in
  (* 2. Check if game is over *)
  let (is_game_over, _) = game_over game 0 in
  (* 3. Get all possible moves *)
  let possibile_moves = get_all_poss_moves game in
  (* 4. Take decision to move *)
  (* 4.1 Get all visited states *)
  (* 4.2 Get move history *)
  (* 5. Repeat or Stop - based on moves available, game over, etc.*)
  (* 6. Return results *)
  (true, [{source="-1"; target="-1"}])


let start_finder (permut:int list) (game_type:string) (file:string) : unit = 
  (* Get permutation p*)
  let p = permut in
  (* Create game g with p*)
  let game = create_game game_type p in 
  (* Start find_solution*)
  let (result, history) = find_solution game in 
  if result = true then
    (write_solution history file;
    Printf.printf "\nSUCCES\n")
  else
    (Printf.printf "\nINSOLUBLE\n"; exit 2);
  ()


(* To test this: *)
(* 1. Create a game *)
(* 2. Run find solution and check evolution of each variable*)