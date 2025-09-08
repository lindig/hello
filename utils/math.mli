(** A module for mathematical utility functions. *)

val round : int -> float -> float
(** [round d f] rounds the float to fractional digits. *)

val round0 : float -> float
(** [round0 f] rounds the float to the nearest integer. This is an alias for
    [Float.round]. *)

val round1 : float -> float
(** [round1 f] rounds the float to one fractional digit. *)

val round2 : float -> float
(** [round2 f] rounds the float to two fractional digits. *)
