open Card
open Fifo
(** In Xpat2, the index of the game is a seed used to shuffle
    pseudo-randomly the cards.
    The shuffle function emulates this permutation generator.
    The input number is the seed (between 1 and 999_999_999).
    The output list is of size 52, and contains all numbers in 0..51
    (hence without duplicates).

*)

(* The numbers manipulated below will be in [0..randmax[ *)
let randmax = 1_000_000_000

(* Converting an integer n in [0..randmax[ to an integer in [0..limit[ *)
let reduce n limit =
  Int.(of_float (to_float n /. to_float randmax *. to_float limit))


(** DESCRIPTION DE L'ALGORITHME DE GENERATION DES PERMUTATIONS

a) Créer tout d'abord les 55 premières paires suivantes:
  * premières composantes : 0 pour la premiere paire,
    puis ajouter 21 modulo 55 à chaque fois
  * secondes composantes : graine, puis 1, puis les "différences"
    successives entre les deux dernières secondes composantes.
    Par "différence" entre a et b on entend
      - Ou bien (a-b) si b<=a
      - Ou bien (a-b+randmax) si a<b
*)

let compute_diff prev_2 prev_1 = 
   if prev_2 >= prev_1 then 
      prev_2 - prev_1 
   else
      prev_2 - prev_1 + randmax

let compute_first_component = List.init 55 (fun i -> (i*21) mod 55)

let compute_second_component graine = 
   let rec compute counter prev_2 prev_1 tab = 
      let diff = compute_diff prev_2 prev_1 in 
      if counter > 0 then
         match counter with 
         | 55 -> let new_tab = prev_2 :: tab in compute (counter - 1) prev_2 prev_1 new_tab
         | 54 -> let new_tab = prev_1 :: tab in compute (counter - 1) prev_2 prev_1 new_tab
         | _ -> let new_tab = diff :: tab in compute (counter - 1) prev_1 diff new_tab
      else
         tab
   in List.rev (compute 55 graine 1 [])

(* a)  *)
let create_paires graine = 
   if graine < 0 || graine > randmax then
      raise (Invalid_argument "graine out of bounds")
   else 
      let first_comp = compute_first_component in 
      let second_comp = compute_second_component graine in
      List.combine first_comp second_comp
(*

b) Trier ces 55 paires par ordre croissant selon leurs premières composantes,
   puis séparer entre les 24 premières paires et les 31 suivantes.
   Pour les 31 paires, leurs secondes composantes sont à mettre dans
   une FIFO f1_init, dans cet ordre (voir `Fifo.of_list` documenté dans
   `Fifo.mli`). De même pour les 24 paires, leurs secondes composantes sont
   à mettre dans une FIFO f2_init, dans cet ordre.

   1. trier par odre croissant (premier comp) - OK
   2. split entre 24 (groupe a) et 31 (groupe b) - OK
   3. pour le groupe b et groupe a mettre dans un fifo. - Ok

*)

let compare_tuple t1 t2 = 
   let (c1_1, _) = t1 in 
   let (c1_2, _) = t2 in
   compare c1_1 c1_2

let sort_list_tuples l = List.sort compare_tuple l

let get_sections l = 
   (List.filteri (fun idx card -> if idx <= 23 then true else false) l, 
      List.filteri (fun idx card -> if idx > 23 then true else false) l)

(* b) *)

let sort_and_fifo l = 
   let sorted = sort_list_tuples l in
   let (a, b) = get_sections sorted in
   let (_, c2_1) = List.split a in
   let (_, c2_2) = List.split b in 
   (Fifo.of_list c2_2, Fifo.of_list c2_1)

(*
c) Un *tirage* à partir de deux FIFO (f1,f2) consiste à prendre
   leurs premières valeurs respectives n1 et n2 (cf `Fifo.pop`),
   puis calculer la "différence" de n1 et n2 (comme auparavant),
   nommons-la d. Ce d est alors le résultat du tirage, associé
   à deux nouvelles FIFO constituées des restes des anciennes FIFO
   auxquelles on a rajouté respectivement n2 et d (cf `Fifo.push`).
*)

(* c) *)   


let tirage f1 f2 =
   let (n1, new_f1) = Fifo.pop f1   in
   let (n2, new_f2) = Fifo.pop f2   in
   let d = compute_diff n1 n2  in 
   let new_f1 = Fifo.push n2 new_f1 in 
   let new_f2 = Fifo.push d new_f2  in
   (d, new_f1, new_f2);; 
 
(*
d) On commence alors par faire 165 tirages successifs en partant
   de (f1_init,f2_init). Ces tirages servent juste à mélanger encore
   les FIFO qui nous servent d'état de notre générateur pseudo-aléatoire,
   les entiers issus de ces 165 premiers tirages ne sont pas considérés.

*)

(* d) *)

let tirage_succ f1 f2 = 
   let rec tirer f1 f2 tab counter = 
      if counter > 0 
      then 
         let (x, new_f1, new_f2) = tirage f1 f2 in 
         tirer new_f1 new_f2 (x :: tab) (counter - 1)
      else 
         (List.rev (tab), f1, f2)
   in tirer f1 f2 [] 165

(*

e) La fonction de tirage vue précédemment produit un entier dans
   [0..randmax[. Pour en déduire un entier dans [0..limit[ (ou limit est
   un entier positif quelconque), on utilisera alors la fonction `reduce`
   fournie plus haut.
   Les tirages suivants nous servent à créer la permutation voulue des
   52 cartes. On commence avec une liste des nombres successifs entre 0 et 51.
   Un tirage dans [0..52[ nous donne alors la position du dernier nombre
   à mettre dans notre permutation. On enlève alors le nombre à cette position
   dans la liste. Puis un tirage dans [0..51[ nous donne la position
   (dans la liste restante) de l'avant-dernier nombre de notre permutation.
   On continue ainsi à tirer des positions valides dans la liste résiduelle,
   puis à retirer les nombres à ces positions tirées pour les ajouter devant
   la permutation, jusqu'à épuisement de la liste. Le dernier nombre retiré
   de la liste donne donc la tête de la permutation.

   NB: /!\ la version initiale de ce commentaire donnait par erreur
   la permutation dans l'ordre inverse).

Un exemple complet de génération d'une permutation (pour la graine 1)
est maintenant donné dans le fichier XpatRandomExemple.ml, étape par étape.

   1. use reduce
   2. l =  liste successifs des nombres entre 0 - 51
   3. tirage dans [0, ..., 52[ donne la derniere position de notre permutation.
   4. on enleve le nombre de la list l.
   5. tirage parmi [0, ....51[ - position du avant dernier.
   6. on continue à tirer des positions valides dans la liste résiduelle, jusqu'à 
   dernier element de la liste residuelle, qui est le premier de celui de la permutation
*)

(* e) *)

let generate_52_tirages f1 f2 = 
   (* 1. generate 52 tirages *)
   let rec generator f1 f2 counter tab =
      if counter > 0 then
         (* peut etre ici faut utiliser f1 et f2 *)
         let (x, new_f1, new_f2) = tirage f1 f2 in
         generator new_f1 new_f2 (counter - 1) (x::tab)
      else
         (List.rev(tab), f1, f2) 
   in generator f1 f2 52 []

let modify_element idx v = 
   reduce v (52-idx) 

let reduced_52 tab = 
   List.mapi (fun idx x -> modify_element idx x) tab

let gen_perm t1 =
   (* t1 contains positions of elements *)
   let t2 = List.init 52 (fun x -> x) in
   (* t2 contains elements to get at position from t1 *)
   let rec generate_perm_aux t1 t2 t3 counter idx = 
      if counter > 0 then
         let x = List.nth t1 idx in
         (*print_string "\nx: ";
         print_int  x;*)
         let e = List.nth t2 x in
         (*print_string " e: ";
         print_int  e;*)
         let new_t2 = List.filter (fun x -> if x = e then false else true) t2 in
         generate_perm_aux t1 new_t2 (e::t3) (counter -1) (idx+1)
      else 
         t3
   in generate_perm_aux t1 t2 [] (List.length t1) 0


(* For now, we provide a shuffle function that can handle a few examples.
   This can be kept later for testing your implementation. *)

let shuffle_test = function
  | 1 ->
     [13;32;33;35;30;46;7;29;9;48;38;36;51;41;26;20;23;43;27;
      42;4;21;37;39;2;15;34;28;25;17;16;18;31;3;0;10;50;49;
      14;6;24;1;22;5;40;44;11;8;45;19;12;47]
  | 12 ->
     [44;9;28;35;8;5;3;4;11;25;43;2;27;1;24;40;17;41;47;18;
      10;34;39;7;36;29;15;19;30;37;48;45;0;21;12;46;22;13;16;
      33;31;38;23;6;14;49;26;50;20;32;42;51]
  | 123 ->
     [16;51;44;27;11;37;33;50;48;13;17;38;7;28;39;15;4;5;3;6;
      42;25;19;34;20;49;23;0;8;26;30;29;47;36;9;24;40;45;14;
      22;32;10;1;18;12;31;35;2;21;43;46;41]
  | 1234 ->
     [36;37;44;26;9;10;23;30;29;18;4;35;15;50;33;43;28;2;45;
      6;3;31;27;20;7;51;39;5;14;8;38;17;49;0;40;42;13;19;34;
      1;46;22;25;24;12;48;16;21;32;11;41;47]
  | 12345 ->
     [10;12;6;23;50;29;28;24;7;37;49;32;38;30;31;18;13;2;15;4;
      5;47;16;1;0;35;43;40;42;44;46;39;48;20;36;34;8;14;33;11;
      25;45;41;19;3;17;21;51;26;22;27;9]
  | 123456 ->
     [1;7;39;47;5;15;50;49;37;44;29;10;4;23;17;20;0;11;24;14;
      28;35;3;48;8;41;19;46;13;12;36;34;27;9;33;22;43;32;25;30;
      38;6;31;16;51;21;26;18;45;40;42;2]
  | 1234567 ->
     [19;17;31;6;4;14;9;36;35;30;39;40;50;48;42;37;12;3;25;1;
      43;27;5;20;10;51;11;44;46;38;16;22;26;23;21;28;15;7;47;
      13;18;29;32;0;49;34;8;45;24;33;2;41]
  | 22222 ->
     [43;17;21;40;42;47;0;35;23;18;11;29;41;10;45;7;15;25;13;
      51;6;12;33;24;8;34;50;2;30;28;37;3;4;39;49;31;32;14;44;
      22;46;48;9;1;36;5;27;26;38;20;16;19]
  | 222222 ->
     [42;48;16;9;22;21;45;12;40;44;29;31;24;27;33;38;14;15;49;
      37;0;26;10;1;47;4;50;34;23;8;3;2;19;32;13;43;51;6;39;35;
      18;30;11;7;46;17;20;5;41;36;25;28]
  | 2222222 ->
     [17;45;5;4;33;23;10;42;39;3;24;46;6;29;44;27;0;43;2;7;20;
      14;34;8;11;18;15;28;25;49;40;47;48;21;41;9;31;30;36;12;
      51;1;35;26;50;38;32;19;13;37;22;16]
  | 999_999_999 ->
     [22;1;0;21;20;44;23;43;38;11;4;2;19;27;36;9;49;7;18;14;
      46;10;25;35;39;48;51;40;33;13;42;16;32;50;24;47;26;6;34;
      45;5;3;41;15;12;31;17;28;8;29;30;37]
  | _ -> failwith "shuffle : unsupported number (TODO)"


let shuffle n =
   let paires = create_paires n in
   let (f1_init, f2_init) = sort_and_fifo paires in
   let (res, new_f1, new_f2) = tirage_succ f1_init f2_init in
   let (result, _, _) = generate_52_tirages new_f1 new_f2 in
   let reduced_result = reduced_52 result in
   gen_perm reduced_result 
   