
let create_depot sol = match sol with
  |_  -> List.init 4 (fun x -> 0)

let create_reg sol = match sol with
  |"freecell"  -> List.init 4 (fun x -> -1);
  |"seahaven"  -> List.init 4 (fun x -> -1);
  |"bakers"    -> List.init 0 (fun x -> -1);
  |"midnight"  -> List.init 0 (fun x -> -1);
  | _ -> List.init 0 (fun x -> 0)

let create_fifo idx sol = match sol with
  |"freecell" -> if (idx mod 2) = 0 then List.init 7 (fun x -> -1) 
    else List.init 6 (fun x -> -1) 
  |"seahaven" -> List.init 5 (fun x -> -1)
  |"bakers" -> List.init 4 (fun x -> -1)
  |"midnight" -> List.init 3 (fun x -> -1)
  | _ -> List.init 0 (fun x -> 0)

let create_cols sol = match sol with 
  |"freecell" -> List.init 8 (fun x -> create_fifo x sol)
  |"seahaven" -> List.init 10 (fun x -> create_fifo x sol)
  |"bakers" -> List.init 13 (fun x -> create_fifo x sol)
  |"midnight" -> List.init 18 (fun x -> create_fifo x sol)
  | _ -> List.init 0 (fun x -> create_fifo 0 "0")

type solitaire = {
  nom : string;
  col : int list list;
  reg : int list;
  dep : int list;
  hist: int
} 

type jeux = 
  |Seahaven of solitaire
  |Freecell of solitaire
  |Bakers   of solitaire
  |Midnight of solitaire


let example_freecell = Freecell {nom = "freecell" ; col = create_cols "freecell"; reg = create_reg "freecell"; dep = create_depot "freecell"; hist = 0 } ;;
let example_seahaven  = Seahaven {nom = "seahaven" ; col = create_cols "seahaven"; reg = create_reg "seahaven"; dep = create_depot "seahaven"; hist = 0 } ;;
let example_midnight = Midnight {nom = "midnight" ; col = create_cols "midnight"; reg = create_reg "midnight"; dep = create_depot "midnight"; hist = 0 } ;;
let example_bakers  = Bakers {nom = "bakers" ; col = create_cols "bakers"; reg = create_reg "bakers"; dep = create_depot "bakers"; hist = 0 } ;;

