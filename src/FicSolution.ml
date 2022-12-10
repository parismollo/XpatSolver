
let is_valid_move_fc_st etat card1 card2 =
  match card2 with
  | "V" -> true
  | "T" -> true
  | _ -> true

let is_valid_move_mo_bc etat card1 card2 =
  match card2 with
  | "V" -> true
  | "T" -> false
  | _ -> true

let play_move etat card1 card2 =
  match card2 with
    | "V" -> etat (*deplacer la carte vers une colonne vide*)
    | "T" -> etat (*deplacer la carte vers un registre tempo vide*)
    | _ -> etat (*deplacer la carte vers la colonne ou card2 se trouve*)

let check_move etat game card1 card2 =
let is_valid =
    match game with
    | "freecell" -> is_valid_move_fc_st etat card1 card2
    | "seahaven" -> is_valid_move_fc_st etat card1 card2
    | "midnight" -> is_valid_move_mo_bc etat card1 card2
    | "baker" -> is_valid_move_mo_bc etat card1 card2
    | _ -> failwith "Invalid game name"
  in
    if is_valid then play_move etat game card1 card2
    else failwith "ECHEC" (*and return num of line*);;

let split_cards name =
  match String.split_on_char ' ' name with
  | [string1;string2] -> (string1,string2)
  | _ -> raise Not_found

let rec norm etat = etat;;

(*applique une ligne du file au sol*)
let rec play_line fic etat game =
  try
    let current_state = norm etat in
    let line = input_line fic in
    let (card1, card2) = split_cards line in
    let modified_state = check_move current_state game card1 card2 in
    play_line fic modified_state game 
    (* problème avec modified_state, voici le message de vscode :
    This expression has type 'a but an expression was expected of type string -> 'a
    The type variable 'a occurs inside string -> 'a   
    *)
  with
    | End_of_file -> etat
    | Failure _ -> failwith "Invalid file";;

(*Ouvre le fichier de solution et applique chaque ligne au sol et renvoie l'etat final*)
let check_file_solution filename etat game = 
  try
    let fic = open_in filename in
    let etat_final = play_line fic etat game in
    close_in fic;
    etat_final
  with Sys_error _ -> failwith "File not found";;