
(* Persistent Arrays : tableaux OCaml vus via une interface fonctionnelle

  En interne, 'a t = 'a array, mais toute écriture dans
  ces tableaux (via [set], [mset], ou [sort]) entraîne une recopie.
  Grâce à cela et au type abstrait 'a t, ces tableaux sont donc garantis
  d'être immutables.

  Voir aussi des tableaux persistents plus évolués ici :
  https://www.lri.fr/~filliatr/puf/
*)

type 'a t = 'a array

let make = Array.make
let init = Array.init
let length = Array.length
let of_list = Array.of_list
let to_list = Array.to_list
let append = Array.append
let get = Array.get
let for_all = Array.for_all
let exists = Array.exists
let map = Array.map
let mapi = Array.mapi
let iter = Array.iter
let iteri = Array.iteri
let fold = Array.fold_right

(* Modification d'une case (après recopie). Coût O(n). *)
let set t i a =
  let t = Array.copy t in t.(i) <- a; t

(* Multiple modifications de cases (après une recopie).
   Pour un tableau de taille n et m changements, le coût est O(n+m) *)

let mset t l =
  let t = Array.copy t in
  List.iter (fun (i,a) -> t.(i) <- a) l;
  t

(* Tri. coût O(n.lg n) *)

let sort cmp t =
  let t = Array.copy t in
  Array.sort cmp t;
  t

(* Conversions depuis / vers un tableau usuel.
   Une recopie est nécessaire dans les deux cas pour éviter qu'une future
   écriture côté Array n'affecte aussi le tableau immutable. Coût O(n). *)

let to_array = Array.copy
let of_array = Array.copy
