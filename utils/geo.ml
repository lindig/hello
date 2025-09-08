type t = { lat : float; lon : float }

let google_maps t =
  Printf.sprintf "https://www.google.com/maps/@%f,%f,17z" t.lat t.lon

let hash t = Int.logxor (Float.hash t.lat) (Float.hash t.lon)

let _json t =
  `O
    [
      ("lat", `Float t.lat)
    ; ("lon", `Float t.lon)
    ; ("url", `String (google_maps t))
    ]

let earth_radius = 6378140.0 (* meter *)

(** return [degrees] as a radian angle *)
let radians deg = deg *. Float.pi /. 180.0

(** [deggrees r] converts angle [r] to degrees *)
let degrees rad = rad *. 180.0 /. Float.pi

let sin x = Float.sin (radians x)
let cos x = Float.cos (radians x)

let to_xy ?(origin = { lat = 52.0; lon = 0.0 }) t =
  (* transforming to cartesian coordinates with meter unit. To keep
     distortions small, the origin is at latitude 52 degrees *)
  let radius = earth_radius in
  let lat0 = radians origin.lat in
  let lon0 = radians origin.lon in
  let x = radius *. (radians t.lon -. lon0) *. cos t.lat in
  let y = radius *. (radians t.lat -. lat0) in
  (x, y)

(** [distance] in meters between two points *)
let distance p1 p2 =
  let c = radians (p2.lat +. p1.lat) /. 2.0 in
  let x = radians (p2.lon -. p1.lon) *. Float.cos c in
  let y = radians (p2.lat -. p1.lat) in
  Float.sqrt ((x *. x) +. (y *. y)) *. earth_radius

(** [bearing] in degrees for going from [p1] to [p2] *)
let bearing p1 p2 =
  let y = sin (p2.lon -. p1.lon) *. cos p2.lat in
  let x =
    (cos p1.lat *. sin p2.lat)
    -. (sin p1.lat *. cos p2.lat *. cos (p2.lon -. p1.lon))
  in
  let b = degrees (Float.atan2 y x) in
  if b < 0.0 then b +. 360.0 else b

let destination p ~dist ~bearing =
  let angle = bearing in
  let radius = earth_radius in
  let delta = dist /. radius in
  let lat =
    Float.asin
      ((sin p.lat *. Float.cos delta)
      +. (cos p.lat *. Float.sin delta *. cos angle))
  in
  let lon =
    radians p.lon
    +. Float.atan2
         (sin angle *. Float.sin delta *. cos p.lat)
         (Float.cos delta -. (sin p.lat *. Float.sin lat))
  in
  { lat = degrees lat; lon = degrees lon }
