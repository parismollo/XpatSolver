open Sys
open TypeSol
open Card
open XpatRandom
open Solver


module States = Set.Make (struct type t = solitaire let compare = compare_solitaires end);;

(* Compare two solitaires. Return 0 si if equal, otherwise a number !=0 *)
let compare_solitaires (game1 : solitaire) (game2 : solitaire) : int = 
  let registers_equal = (Stdlib.compare game1.reg game2.reg) in
  if registers_equal = 0 then
    Stdlib.compare game1.cols game2.cols (* 0 if equal. Otherwise a number != 0 *)
  else
    registers_equal;;

let copy_game (game:solitaire) : solitaire = 
  let cols_copy = Array.copy sol.cols in
  let reg_copy = Array.copy sol.reg in
  let dep_copy = Array.copy sol.dep in
  {name = sol.name; cols = cols_copy; reg = reg_copy; dep = dep_copy; hist = sol.hist}
  
let get_score (game:solitaire) : int = 
  let dep = game.dep in
  let rec sum dep total =
    match dep with
    | [] -> total
    | -1 :: tl -> sum tl (total)
    | x :: tl -> sum tl (total+x) 
  in sum (Array.to_list dep) 0

let update_visited_states visited_array new_visited_state = 
  (* [TODO] *)
  (* visited_array.append(new_visited_state) *)

let can_visit visited_array new_state_opt =
  (* [TODO] *)
  (* for visited in visited_array
      if new_state == visited then false
  return true *)

let update_move_history mv_hist new_move = 
  (* [TODO] *)
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
  
let rec get_possible_moves game mvs_top results = 
  match mvs_top with
  | [] -> results
  | move :: tail -> 
      let game_cpy = copy_game game in
      let valid = execute_move move game_cpy in
      if valid = true then
        let score = get_score game_cpy in
        get_possible_moves game tail ((true, move, game_cpy, score) :: results)
      else 
        get_possible_moves game tail results
;;

let get_mvs_top top_card_src game = 
  let all_cols = 
    List.filter (fun x -> if x = -1 then false else true)(Array.to_list (Array.map (fun x -> if List.length x > 0 then (to_num (List.hd x)) else -1) game.cols)) in
  let rec loop all_cols = 
    match all_cols with
    | [] -> []
    | top_card_target :: tail -> [{source=top_card_src; target= string_of_int top_card_target}] @ loop tail in
  loop all_cols
;;
   
let apply_third_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) list = 
  (* 1. make a list of moves based on every top_card *)
  (* eg. for all columns we would have a list of {source=top_card; target=col.top_card} *)
  let top_card_src = string_of_int ((to_num top_card)) in
  let mvs_top = get_mvs_top top_card_src game in
  (* 2. then for each move, execute the move in a game and if valid store the (valid, move, game_cpy, score)*)
  let possible_moves = get_possible_moves game mvs_top in
  possible_moves
  
let apply_second_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) = 
  let top_card_int_str = string_of_int ((to_num top_card)) in
  let game_cpy = copy_game game in
  let move = {source=top_card_int_str; target="V"} in
  let valid= execute_move move game_cpy in
  if valid = true then
    let score = get_score game_cpy in
    (true, move, game_cpy, score)
  else 
    (false, move, game_cpy, 0)

let apply_first_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) = 
  (* Towards empty register *)
  let top_card_int_str = string_of_int ((to_num top_card)) in
  let game_cpy = copy_game game in
  let move = {source=top_card_int_str; target="T"} in
  let valid= execute_move move game_cpy in
  if valid = true then
    let score = get_score game_cpy in
    (true, move, game_cpy, score)
  else 
    (false, move, game_cpy, 0)
  
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
  (* [TODO] *)
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