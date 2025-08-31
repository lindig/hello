(* We want to represent non-overlapping float intervals with an associated value.
   We add intervals to a map; this is rejected, when the new addition would
   overlap with an existing interval. Hence, order of insertion matters.
   The result is presented in increasing order (not in insertion order).
   *)

module M = Map.Make (Float)

(* An interval x,y is represented as a map from x to a ('a, y) tuple. So it is ordered by x *)

type 'a t = float * 'a * float

let empty = M.empty

(* Before adding a new interval (x,y) with a value 'v', we need to check: the interval to
   the left ends before x and the interval to the right starts after y.
   Otherwise we don't add (x,v,y) *)
let add t (x, v, y) =
  assert (x < y);
  let before = M.find_first_opt (fun x' -> x' <= x) t in
  let after = M.find_first_opt (fun x' -> x' >= x) t in
  match (before, after) with
  | None, None -> M.add x (v, y) t
  | Some (_, (_, y')), None when y' <= x -> M.add x (v, y) t
  | None, Some (x', _) when y <= x' -> M.add x (v, y) t
  | Some (_, (_, y')), Some (x', _) when y' <= x && y <= x' -> M.add x (v, y) t
  | _ -> t

let from_list intervals = List.fold_left add empty intervals

let disjoint intervals =
  from_list intervals |> M.bindings |> List.map (fun (x, (v, y)) -> (x, v, y))

let tests =
  [
    (* 1: No overlaps *)
    ( [ (1., "a", 3.); (4., "b", 6.); (7., "c", 9.) ]
    , [ (1., "a", 3.); (4., "b", 6.); (7., "c", 9.) ] )
  ; (* 2.: Simple overlap at start *)
    ( [ (1., "a", 5.); (2., "b", 4.); (6., "c", 8.) ]
    , [ (1., "a", 5.); (6., "c", 8.) ] )
  ; (* 3.: Simple overlap at end *)
    ( [ (1., "a", 3.); (2., "b", 5.); (6., "c", 8.) ]
    , [ (1., "a", 3.); (6., "c", 8.) ] )
  ; (* 4.: Adjacent intervals, not an overlap *)
    ( [ (1., "a", 3.); (3., "b", 5.); (6., "c", 8.) ]
    , [ (1., "a", 3.); (3., "b", 5.); (6., "c", 8.) ] )
  ; (* 5.: A sub-interval completely contained within another *)
    ( [ (1., "a", 10.); (3., "b", 7.); (12., "c", 15.) ]
    , [ (1., "a", 10.); (12., "c", 15.) ] )
  ; (* 6.: Multiple overlapping intervals *)
    ( [ (1., "a", 5.); (2., "b", 6.); (3., "c", 7.); (8., "d", 9.) ]
    , [ (1., "a", 5.); (8., "d", 9.) ] )
  ; (* 7.: Empty list *)
    ([], [])
  ; (* 8.: List with a single element *)
    ([ (10., "a", 20.) ], [ (10., "a", 20.) ])
  ; (* 9.: Overlapping intervals that are processed in order *)
    ( [ (5., "a", 10.); (1., "b", 6.); (11., "c", 15.) ]
    , [ (5., "a", 10.); (11., "c", 15.) ] )
  ; (* 10.: Reverse order of the first case, to check order dependency *)
    ( [ (7., "a", 9.); (4., "b", 6.); (1., "c", 3.) ]
    , [ (1., "c", 3.); (4., "b", 6.); (7., "a", 9.) ] )
  ]

let test () =
  tests
  |> List.iter (fun (intervals, expected) ->
         assert (expected = disjoint intervals))
