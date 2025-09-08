(* Calculation for coordinates in latitude, longitude; each value is in
   degree *)

type t = { lat : float; lon : float }

val hash : t -> int
(* A simple hash *)

val earth_radius : float
(* radius of planet earch in meters *)

val distance : t -> t -> float
(* distance in meter between two coordinates *)

val bearing : t -> t -> float
(* bearing in degree for going from one point to a another *)

val destination : t -> dist:float -> bearing:float -> t
(* Starting from a point, where do we end up when going [dist] meters in
   direction [bearing] in degrees. *)

val to_xy : ?origin:t -> t -> float * float
(* approximate location to cartesian coordinates in meter with given
   origin. To minimise errors, the origin should be local *)
