open Sys
open TypeSol
open Card
open XpatRandom
open Solver

let write_solution (history:player_move list) (file:string) : unit = 
  (* TEMPORARY *)
  ()

let find_solution (game_type:string) (file:string)  =
  (* TEMPORARY *)
  (true, [{source="-1"; target="-1"}])


let start_finder (permut:int list) (game_type:string) (file:string) = 
  (* Create permutation p*)
  let p = permut in
  (* Create game g with p*)
  let g = create_game game_type p in 
  (* Start find_solution*)
  let (result, history) = find_solution game_type file in 
  if result = true then
    (write_solution history file;
    Printf.printf "\nSUCCES\n")
  else
    (Printf.printf "\nINSOLUBLE\n"; exit 2);
  ()