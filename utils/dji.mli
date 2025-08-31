(* Given (x,y) intervals, compute the non-overlapping intervals from a
   list of intervals *)

type 'a t = float * 'a * float
(* An interval (x,y) with x < y and an associated value 'a *)

val disjoint : 'a t list -> 'a t list
(* Given a list of intervals, compute the subset of non-overlapping
   intervals and return them in increasing order. An interval from the
   argument list is not in the result if it overlaps with another
   interval earlier in the list. As such, the order of intervals in the
   argument matters. Note that the result does *not* maintain that order
   but returns intervals in increasing order. Because intervals in the
   result are not overlapping, this order is well defined. *)

val test : unit -> unit
(* Run internal test *)
