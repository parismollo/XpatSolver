(** A FIFO structure (First-In First-Out),
    implemented in functional style
    (NB: the Queue module of OCaml stdlib is imperative)

    NE PAS CHANGER CE FICHIER INTERFACE

*)

(** Fifo.t is an abstract type, see Fifo.ml for the concrete implementation *)
type 'a t

(** Empty fifo *)
val empty : 'a t

(** Add an element to the fifo.
    It is placed last in the order of future retrievals *)
val push : 'a -> 'a t -> 'a t

(** Retrieve and remove the first element in the fifo,
    or raise Not_found if empty *)
val pop : 'a t -> 'a * 'a t

(** Add all elements of a list in an empty fifo.
    The head of the list is added last. *)
val of_list : 'a list -> 'a t

(** Retrieve all the elements of a fifo.
    The first element out of the fifo is the head of the output list. *)
val to_list : 'a t -> 'a list
