(** round float f to d fractional digits *)
let round d f =
  let factor = 10.0 ** float d in
  let shifted = f *. factor in
  let rounded = Float.round shifted in
  rounded /. factor

let round0 = Float.round
let round1 = round 1
let round2 = round 2
