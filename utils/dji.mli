(* Disjoint intervals. Given (x,y) intervals, compute the
   non-overlapping intervals from a list of intervals. In the general
   case, intervals may overlap or contain each other. We are interested
   in non-overlapping intervals *)

type 'a t = float * 'a * float
(* An interval (x,y) with x < y and an associated value 'a *)

val disjoint : 'a t list -> 'a t list
(* Given a list of intervals, compute the subset of non-overlapping
   intervals and return them in insertion order (fifo) *)

val test : unit -> unit
(* Run internal test *)
