(** A library for 2D vector operations.

    This module provides types and functions to perform common vector operations
    in a 2D Cartesian coordinate system. Vectors are represented as a pair of
    floats, (x, y). *)

type t = float * float
(** 2D vector represented as a pair of floats (x, y). *)

val get : t -> float * float
(** [get v] returns the components of the vector [v] as a tuple (x, y). *)

val zero : t
(** The zero vector (0.0, 0.0). *)

val add : t -> t -> t
(** [add v1 v2] returns the vector sum of [v1] and [v2]. *)

val mul : float -> t -> t
(** [mul c v] returns the vector [v] scaled by the scalar [c]. *)

val neg : t -> t
(** [neg v] returns the negation of vector [v], ( -x, -y ). *)

val sub : t -> t -> t
(** [sub v1 v2] returns the vector difference [v1 - v2]. *)

val distance : t -> t -> float
(** [distance p1 p2] returns the Euclidean distance between two points [p1] and
    [p2]. *)

val norm : t -> float
(** [norm v] returns the Euclidean norm (magnitude) of vector [v]. *)

val prod : t -> t -> float
(** [prod v1 v2] returns the dot product of vectors [v1] and [v2]. *)

val proj : t -> t -> float
(** [proj base p] returns the scalar projection of vector [p] onto vector
    [base]. This value represents the length of the projected vector. *)

val radius : t -> t -> t -> float
(** [radius a b c] calculates the radius of the unique circle that passes
    through three points [a], [b], and [c]. Returns [Float.max_float] if the
    points are collinear (on a line). *)
