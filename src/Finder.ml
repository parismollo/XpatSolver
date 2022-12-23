open Sys
open TypeSol
open Card
open XpatRandom

let write_solution (history:move list) (file:string) =

let find_solution (game_type:string) (file:string) =

let start_finder (permut:int list) (game_type:string) (file:string) = 
  (* Create permutation p*)
  let p = permut in
  (* Create game g with p*)
  let g = create_game game_type p in 
  (* Start find_solution*)
  let (result, history) = find_solution game_type file in 
  if result = true then
    (write_solution history file; Printf.printf "\nSUCCES\n")
  else
    (Printf.printf "\nINSOLUBLE %n\n"; exit 2);
  ()