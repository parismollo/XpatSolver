
(** Cards *)

type rank = int (* 1 to 13, valet=11, dame=12, roi=13 *)
type suit = Trefle | Pique | Coeur | Carreau
type card = rank * suit

(** From 0..51 to cards and back (the Xpat2 way) *)

type cardnum = int (* 0..51 *)

val of_num : cardnum -> card
val to_num : card -> cardnum

(** Display of a card *)

val to_string : card -> string

(** The order of suits is the one of Xpat2

   List.map num_of_suit [Trefle;Pique;Coeur;Carreau] = [0;1;2;3]
*)

type suitnum = int (* 0..3 *)

val num_of_suit : suit -> suitnum
val suit_of_num : suitnum -> suit
