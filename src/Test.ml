(* this file tests the read and "execute" part of Solver.ml*)
(* more precisely it simulares the get player move part *)
(* It supposes to read a file and then for each line, interpret the line content *)
(* get the first and second values in the line and store in a player_move type*)

type player_move = {source: string ; target: string} 

(* Convert line into player_move type *)
let tokenize line =
  let tokens = String.split_on_char ' ' line in
  {source=List.nth tokens 0; target = List.nth tokens 1}

(* Open the file in read-only mode *)
let file = open_in "test.txt"

(* Read every line of the file and print it to the terminal *)
let rec print_lines file =
  try
    let line = input_line file in
    let move = tokenize line in
    print_endline move.source;
    print_endline move.target;
    print_lines file
  with
    End_of_file -> ()

(* Call the print_lines function *)
let () = print_lines file

(* Close the file *)
(* let () = close_in file *)