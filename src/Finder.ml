open Sys
open TypeSol
open Card
open XpatRandom
open Solver


(* Compare two solitaires. Return 0 si if equal, otherwise a number !=0 *)
let compare_solitaires (game1 : solitaire) (game2 : solitaire) : int = 
  let registers_equal = (Stdlib.compare game1.reg game2.reg) in
  if registers_equal = 0 then
    Stdlib.compare game1.cols game2.cols (* 0 if equal. Otherwise a number != 0 *)
  else
    registers_equal

module States = Set.Make (struct type t = solitaire let compare = compare_solitaires end);;

let copy_game (game:solitaire) : solitaire = 
  let cols_copy = Array.copy game.cols in
  let reg_copy = Array.copy game.reg in
  let dep_copy = Array.copy game.dep in
  {name = game.name; cols = cols_copy; reg = reg_copy; dep = dep_copy; hist = game.hist}

  
let get_score (game:solitaire) : int = 
  let dep = game.dep in
  let rec sum dep total =
    match dep with
    | [] -> total
    | -1 :: tl -> sum tl (total)
    | x :: tl -> let (value, rank) = of_num x in sum tl (total+value) 
  in sum (Array.to_list dep) 0

(* let update_visited_states visited_array new_visited_state = 
  (* [TODO] *)
  (* visited_array.append(new_visited_state) *)

let can_visit visited_array new_state_opt =
  (* [TODO] *)
  (* for visited in visited_array
      if new_state == visited then false
  return true *) *)

(* let update_move_history mv_hist new_move = 
  (* [TODO] *)
    (* // after taking a decision for a move
    // update this variable
    mv_hist.append(new_move) *) *)

let get_all_tops game = 
  (* Returns all top cards found in columns and registers in int format*)
  let all_cols = 
    List.filter (fun x -> if x = -1 then false else true)(Array.to_list (Array.map (fun x -> if List.length x > 0 then (to_num (List.hd x)) else -1) game.cols)) in
  let all_reg = 
    List.filter (fun x -> if x = -1 then false else true) (Array.to_list (Array.map (fun x -> if List.length x > 0 then (to_num (List.hd x)) else -1) game.reg)) in
  all_cols @ all_reg
  
let rec get_possible_moves game mvs_top results = 
  match mvs_top with
  | [] -> results
  | move :: tail -> 
      let game_cpy = copy_game game in
      let valid = execute_move move game_cpy in
      if valid = true then
        let score = get_score game_cpy in
        let n = normalize game_cpy in
        get_possible_moves game tail ((true, move, game_cpy, score) :: results)
      else 
        get_possible_moves game tail results


let get_mvs_top top_card_src game = 
  let all_cols = 
    List.filter (fun x -> if x = -1 then false else true)(Array.to_list (Array.map (fun x -> if List.length x > 0 then (to_num (List.hd x)) else -1) game.cols)) in
  let rec loop all_cols = 
    match all_cols with
    | [] -> []
    | top_card_target :: tail -> [{source=top_card_src; target= string_of_int top_card_target}] @ loop tail in
  loop all_cols

    
let apply_third_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) list = 
  (* 1. make a list of moves based on every top_card *)
  (* eg. for all columns we would have a list of {source=top_card; target=col.top_card} *)
  let top_card_src = string_of_int ((to_num top_card)) in
  let mvs_top = get_mvs_top top_card_src game in
  (* 2. then for each move, execute the move in a game and if valid store the (valid, move, game_cpy, score)*)
  let possible_moves = get_possible_moves game mvs_top [] in
  possible_moves
  
let apply_second_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) = 
  let top_card_int_str = string_of_int ((to_num top_card)) in
  let game_cpy = copy_game game in
  let move = {source=top_card_int_str; target="V"} in
  let valid= execute_move move game_cpy in
  if valid = true then
    let n = normalize game_cpy in
    let score = get_score game_cpy in
    (true, move, game_cpy, score)
  else 
    (false, move, game_cpy, 0)

let apply_first_move_type (top_card:card) (game:solitaire) : (bool * player_move * solitaire *  int) = 
  (* Towards empty register *)
  let top_card_int_str = string_of_int ((to_num top_card)) in
  let game_cpy = copy_game game in
  let move = {source=top_card_int_str; target="T"} in
  let valid = execute_move move game_cpy in
  if valid = true then
    let n = normalize game_cpy in
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
  let game_type = game.name in
  if game_type = "midnight" || game_type = "bakers" then 
      let third_result = apply_third_move_type top_card game in
      let all_results = third_result in 
      List.filter (fun x -> 
        let (bool, move, game, score) = x in
        if bool = false then false else true) all_results
  else 
    let first_result = apply_first_move_type top_card game in
    let second_result = apply_second_move_type top_card game in
    let third_result = apply_third_move_type top_card game in
    let all_results = [first_result] @ [second_result] @ third_result in 
    
    List.filter (fun x -> 
        let (bool, move, game, score) = x in
        if bool = false then false else true) all_results

let get_next_moves (game:solitaire) : (bool * player_move * solitaire * int) list =
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
  loop (List.map (fun x -> of_num x) list)


let filter_next_steps next_steps visited_games : (bool * player_move * solitaire * int) list = 
  (* Filter out unvalid moves that will lead to an already visited state *)
  (* Remove from next steps all visited states *)
  (* Apply filter for each element that compare if inside visited_states and send false if that's the case *)
  List.filter (fun x -> 
      let (valid, move, game_state, score) = x in
      if States.mem game_state visited_games = true then false else true
    ) next_steps

let sort_by_score filtered_nxt_stps = 
  (* [ATTENTION: not tested] *)
  let compare_tuples2 t1 t2 = 
    let (valid1, move1, game_state1, score1) = t1 in
    let (valid2, move2, game_state2, score2) = t2 in
    compare score1 score2 
  in List.sort compare_tuples2 filtered_nxt_stps

let rec find_solution (game:solitaire) visited_game_history (visited_seq:solitaire list) (move_history:player_move list) : bool * player_move list =
  (* 1. Normalize game *)
  let normalized = normalize game in
  (* 2. Check if game is over *)
  let (over, _ ) = game_over game 0 in
    (* A) if is over return results (bool, move history) *)
  if over = true then 
    (* B) if not continue program *)
    (true, move_history)
  else
    (*let _ = Printf.printf "hello 1\n" in*)
    (* 3. Get all possible moves from this state *)
    let next_steps = get_next_moves game in
    (* 4. Filter out unvalid moves that will lead to a already visited state *)
    let filtered_nxt_stps = filter_next_steps next_steps visited_game_history in
    (* A) if filtered list empty, undo the current/prev move. *)
    if List.length filtered_nxt_stps <= 0 then
      (* A) if filtered list empty, undo the current/prev move. *)
      (*let _ = Printf.printf "hello 2\n" in*)
      if List.length visited_seq > 1 then
        (*let _ = Printf.printf "hello 3\n" in*)
          (* Remove last move from from history *)
        let removed_lst_mv_hist = List.tl move_history in
          (* Remove last visited_seq *)
        let removed_lst_vst_seq = List.tl visited_seq in
          (* call recursive function *)
        let prev_game = List.hd visited_seq in
        find_solution prev_game visited_game_history removed_lst_vst_seq removed_lst_mv_hist
      else 
        (*let _ = Printf.printf "hello 4\n" in*)
        (* a) if nothing to undo, then over and  return results *)
        (false, move_history)
    (* B) if not continue program *)
    else
      (*let _ = Printf.printf "hello 5\n" in*)
      (* 5. Among filtered options, pick highest score. *)
      let higest_option = List.hd (sort_by_score filtered_nxt_stps) in
      (* 6. move forward with highest score. *)
      let (next_valid, next_move, next_game, next_score) = higest_option in
      (*  A) add visited_game_history *)
      let new_visited_game_history = States.add next_game visited_game_history in
      (*  B) add move_history *)
      let new_move_history = [next_move] @ move_history in
      (*  C) add visited_seq  *)
      let new_visited_seq = [next_game] @ visited_seq in
      find_solution next_game new_visited_game_history new_visited_seq new_move_history
      
(* [TODO]: update mv_hist variable containing perfect move history that ends with solution *)
  (* possible solution is to add to the game it self, so it will update correclty. *)

let rec write_solution (history:player_move list) file  = 
  match history with 
  | [] -> close_out file;
  | move :: tl_moves -> 
    (Printf.fprintf file "%s %s\n" (move.source) (move.target)); 
    write_solution tl_moves file

(* Start game with config type *)
let start_finder permut game_type mode =
  (* Create game g with p*)
  let file = open_out mode in
  let game = create_game game_type permut in
  let first_state = States.add game States.empty in
  let (result, history) = (find_solution game first_state [game] []) in
  if result = true then
    (write_solution history file;
    Printf.printf "\nSUCCES\n";)
  else 
    (Printf.printf "\nINSOLUBLE\n" ; exit 2);
  ()