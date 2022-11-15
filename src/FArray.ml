
(* FArray : Tableaux fonctionnels non-vides

   Version simlifiée des Flex-array pour en faire des tableaux
   fonctionnels de taille fixe (non nulle), à accès logarithmique.

   Reference : https://github.com/backtracking/flex-array
   Modifications : données aux feuilles pour simplifier les calculs
   pairs/impairs (mais on perd l'accès O(1) au premier element de la
   sequence, pas grave ici).
*)

type 'a t =
 | Leaf of 'a
 | Node of 'a t * 'a t

let rec length = function Leaf _ -> 1 | Node(g,d) -> length g + length d

(* Remarque: par construction length (Node (_,_)) >= 2

   Invariant :
   length g = length d (si length paire) ou
   length g = length d + 1 (si length impaire)
   Bref, length g = (n+1)/2 (arrondi supérieur)
         length d = n/2 (arrondi inférieur)
*)

let rec make n v =
  if n = 0 then failwith "FlexArray.make : empty"
  else if n = 1 then Leaf v
  else Node (make ((n+1)/2) v, make (n/2) v)

let rec init_gen n scale shift f =
  if n = 0 then failwith "FlexArray.make : empty"
  else if n = 1 then Leaf (f shift)
  else Node (init_gen ((n+1)/2) (2*scale) shift f,
             init_gen (n/2) (2*scale) (scale+shift) f)

let init n f = init_gen n 1 0 f

let rec mix l1 l2 =
  match l1, l2 with
  | [], _ -> l2
  | _, [] -> l1
  | x1::l1, x2::l2 -> x1::x2::mix l1 l2

let rec to_list = function
  | Leaf x -> [x]
  | Node (evens,odds) -> mix (to_list evens) (to_list odds)

(* Cout : n + 2 * n/2 + 4 * n/4 + ... = n log n *)

let rec split l =
  match l with
  | x::y::l -> let u,v = split l in x::u, y::v
  | l -> l,[]

let rec of_list = function
  | [] -> failwith "FlexArray.of_list : empty"
  | [x] -> Leaf x
  | l ->
     let evens,odds = split l in
     Node (of_list evens, of_list odds)

(* Cout : n + 2 * n/2 + ... = n log n *)

let rec get t i =
  match t with
  | Leaf x -> if i = 0 then x else raise Not_found
  | Node(evens,odds) ->
     if i mod 2 = 0 then get evens (i/2) else get odds (i/2)

(* Attention dans cette version simplifiée, head t = get t 0
   n'est pas en temps constant *)

let rec set t i x =
  match t with
  | Leaf _ -> if i = 0 then Leaf x else raise Not_found
  | Node(evens,odds) ->
     if i mod 2 = 0 then Node (set evens (i/2) x, odds)
     else Node (evens, set odds (i/2) x)

let rec map f t = match t with
  | Leaf x -> Leaf (f x)
  | Node (evens, odds) -> Node (map f evens, map f odds)

let rec iter f t = match t with
  | Leaf x -> f x
  | Node (evens, odds) -> iter f evens; iter f odds

let rec mapi_gen f scale shift t = match t with
  | Leaf x -> Leaf (f shift x)
  | Node (evens, odds) ->
     Node (mapi_gen f (2*scale) shift evens,
           mapi_gen f (2*scale) (scale+shift) odds)

let mapi f t = mapi_gen f 1 0 t

let rec iteri_gen f scale shift t = match t with
  | Leaf x -> f shift x
  | Node (evens, odds) ->
     iteri_gen f (2*scale) shift evens;
     iteri_gen f (2*scale) (scale+shift) odds

let iteri f t = iteri_gen f 1 0 t

let rec fold f t a = match t with
  | Leaf x -> f x a
  | Node(evens,odds) -> fold f evens (fold f odds a)

let rec foldi_gen f scale shift t a = match t with
  | Leaf x -> f shift x a
  | Node (evens, odds) ->
     foldi_gen f (2*scale) shift evens
      (foldi_gen f (2*scale) (scale+shift) odds a)

let foldi f t a = foldi_gen f 1 0 t a

let rec for_all f = function
  | Leaf x -> f x
  | Node (odds, evens) -> for_all f odds && for_all f evens

let rec exists f = function
  | Leaf x -> f x
  | Node (odds, evens) -> exists f odds || exists f evens
