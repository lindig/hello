let defer finally = Fun.protect ~finally

let content =
  let buffer = Buffer.create 1024 in
  let rec loop = function
    | 0 -> Buffer.contents buffer
    | n ->
        Buffer.add_string buffer (Printf.sprintf "%04d\n" n);
        loop (n - 1)
  in
  loop 100

let copy src dst =
  let size = 1024 in
  let buffer = Bytes.create size in
  let rec loop () =
    match Unix.read src buffer 0 size with
    | 0 -> ()
    | n ->
        ignore (Unix.write dst buffer 0 n);
        loop ()
  in
  loop ()

let exec cmd =
  try Unix.execvp cmd.(0) cmd
  with Unix.Unix_error (e, _, _) ->
    Printf.eprintf "Cannot execute %s: %s\n" cmd.(0) Unix.(error_message e);
    exit 255

let write fd str =
  let bytes = Bytes.of_string str in
  Unix.write fd bytes 0 (Bytes.length bytes)

let with_file file mode perms f =
  let fd = Unix.openfile file mode perms in
  defer (fun () -> Unix.close fd) @@ fun () -> f fd

let write_content path =
  with_file path Unix.[ O_CREAT; O_TRUNC; O_WRONLY ] 0o664 @@ fun fd ->
  write fd content |> ignore

let read_file path =
  with_file path Unix.[ O_RDONLY ] 0o664 @@ fun fd -> copy fd Unix.stdout

let hello' path =
  write_content path;
  read_file path;
  exec [| "ls"; "/proc/self" |]

let hello path =
  write_content path;
  copy Unix.stdin Unix.stdout
