open Sys
open TypeSol
open Card
open XpatRandom
open Solver

let write_solution (history:player_move list) (file:string) : unit = 
  (* TEMPORARY *)
  ()

let find_solution (game:solitaire) : bool * player_move list =
  (*  *)
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