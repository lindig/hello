type t = float * float
(** 2D vector *)

let get = Fun.id
let sq x = x *. x
let zero = (0.0, 0.0)
let add (x0, y0) (x1, y1) = (x0 +. x1, y0 +. y1)
let mul c (x0, y0) = (c *. x0, c *. y0)
let neg (x0, y0) = (~-.x0, ~-.y0)
let sub p1 p2 = add p1 (neg p2)
let distance (x0, y0) (x1, y1) = Float.sqrt (sq (x0 -. x1) +. sq (y0 -. y1))
let norm p = distance p zero
let prod (x0, y0) (x1, y1) = (x0 *. x1) +. (y0 *. y1)

(** Two vectors, [base] and [p]; [proj] projects [p] onto [base] and returns a
    vector representing the projection. We use this to find the point closest to
    p when going along the base vector *)
let proj base p = prod base p /. norm base

let _area a b c =
  let ab = norm (sub b a) in
  let bc = norm (sub c b) in
  let ac = norm (sub c b) in
  let s = 0.5 *. (ab +. bc +. ac) in
  Float.sqrt ((s -. ab) *. (s -. bc) *. (s -. ac) *. s)

(** radius of circle going trough a, b, c which must not be on a line *)
let radius a b c =
  let ab = norm (sub b a) in
  let bc = norm (sub c b) in
  let ac = norm (sub c a) in
  let s = 0.5 *. (ab +. bc +. ac) in
  let area = Float.sqrt ((s -. ab) *. (s -. bc) *. (s -. ac) *. s) in
  if area = 0.0 then Float.max_float else ab *. bc *. ac /. (4.0 *. area)
