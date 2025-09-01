(* We want to represent non-overlapping float intervals with an
   associated value.  We add intervals to a map; this is rejected, when
   the new addition would overlap with an existing interval. Hence,
   order of insertion matters.  The result is presented in insertion
   order (fifo).
   *)

module M = Map.Make (Float)

(* An interval x,y is represented as a map from x to a ('a, y) tuple. So
   it is ordered by x; we also keep a list of intervals we accept to
   return as the result. This is the easiest way to maintain insertion
   order *)

type 'a t = float * 'a * float
type 'a m = { map : ('a * float) M.t; els : 'a t list }
(* map from x to (v, y) and accepted intervals *)

let empty = { map = M.empty; els = [] }

(* Before adding a new interval (x,y) with a value 'v', we need to
   check: the interval to the left ends before x and the interval to the
   right starts after y.  Otherwise we don't add (x,v,y) *)

let add m ((x, _, y) as xvy) =
  let add ((x, v, y) as xvy) m =
    { map = M.add x (v, y) m.map; els = xvy :: m.els }
  in
  assert (x < y);
  let before = M.find_first_opt (fun x' -> x' <= x) m.map in
  let after = M.find_first_opt (fun x' -> x' >= x) m.map in
  match (before, after) with
  | None, None -> add xvy m
  | Some (_, (_, y')), None when y' <= x -> add xvy m
  | None, Some (x', _) when y <= x' -> add xvy m
  | Some (_, (_, y')), Some (x', _) when y' <= x && y <= x' -> add xvy m
  | _ -> m

let from_list intervals = List.fold_left add empty intervals
let disjoint intervals = from_list intervals |> fun t -> List.rev t.els

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
    , [ (7., "a", 9.); (4., "b", 6.); (1., "c", 3.) ] )
  ]

let test () =
  tests
  |> List.iter (fun (intervals, expected) ->
         assert (expected = disjoint intervals))
