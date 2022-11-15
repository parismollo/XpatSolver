
(* Persistent Arrays : tableaux OCaml vus via une interface fonctionnelle

  En interne, 'a t = 'a array, mais toute écriture dans
  ces tableaux (via [set], [mset], ou [sort]) entraîne une recopie.
  Grâce à cela et au type abstrait 'a t, ces tableaux sont donc garantis
  d'être immutables.

  Voir aussi des tableaux persistents plus évolués ici :
  https://www.lri.fr/~filliatr/puf/
*)

type 'a t

(* Fonctions reprises du module Array (en particulier, mêmes complexités) *)

val make : int -> 'a -> 'a t
val init : int -> (int -> 'a) -> 'a t
val length : 'a t -> int
val of_list : 'a list -> 'a t
val to_list : 'a t -> 'a list
val append : 'a t -> 'a t -> 'a t
val get : 'a t -> int -> 'a
val for_all : ('a -> bool) -> 'a t -> bool
val exists : ('a -> bool) -> 'a t -> bool
val map : ('a -> 'b) -> 'a t -> 'b t
val iter : ('a -> unit) -> 'a t -> unit
val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
val iteri : (int -> 'a -> unit) -> 'a t -> unit
val fold : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b

(* Modification d'une case (après recopie). Coût O(n). *)
val set : 'a t -> int -> 'a -> 'a t

(* Multiples modifications de cases (après une recopie).
   Pour un tableau de taille n et m changements, le coût est O(n+m) *)
val mset : 'a t -> (int * 'a) list -> 'a t

(* Tri. coût O(n.lg n) *)
val sort : ('a -> 'a -> int) -> 'a t -> 'a t

(* Conversions depuis / vers un tableau usuel.
   Une recopie est nécessaire dans les deux cas pour éviter qu'une future
   écriture côté Array n'affecte aussi le tableau immutable. Coût O(n). *)

val to_array : 'a t -> 'a array
val of_array : 'a array -> 'a t
