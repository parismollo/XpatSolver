
(* FArray : Tableaux fonctionnels non-vides

   Version simlifiée des Flex-array pour en faire des tableaux
   fonctionnels de taille fixe (non nulle), à accès logarithmique.

   Reference : https://github.com/backtracking/flex-array
*)

type 'a t

val make : int -> 'a -> 'a t
val init : int -> (int -> 'a) -> 'a t

val length : 'a t -> int             (* Coût O(n) *)

val of_list : 'a list -> 'a t        (* Coût O(n.lg(n)) *)
val to_list : 'a t -> 'a list        (* Coût O(n.lg(n)) *)

val get : 'a t -> int -> 'a          (* Coût O(lg(n)) *)
val set : 'a t -> int -> 'a -> 'a t  (* Coût O(lg(n)) *)

(* Toutes les fonctions suivantes sont linéaires mais visitent
   les éléments dans un ordre arbitraires *)

val for_all : ('a -> bool) -> 'a t -> bool
val exists : ('a -> bool) -> 'a t -> bool
val map : ('a -> 'b) -> 'a t -> 'b t
val iter : ('a -> unit) -> 'a t -> unit
val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
val iteri : (int -> 'a -> unit) -> 'a t -> unit
val fold : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
val foldi : (int -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
