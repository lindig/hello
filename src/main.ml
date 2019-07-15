module C = Cmdliner

let hello _name =
  let stack = Printexc.(get_callstack 6 |> raw_backtrace_to_string) in
  Printf.printf "Hello, %s!\n" stack

module Command = struct
  let help =
    [ `P "These options are common to all commands."
    ; `S "MORE HELP"
    ; `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command."
    ; `S "BUGS"
    ; `P "Check bug reports at https://github.com/lindig/hello/issues" ]

  let name' =
    C.Arg.(
      value & pos 0 string "world"
      & info [] ~docv:"NAME"
          ~doc:"Name of person to greet; the default is 'world'.")

  let hello =
    let doc = "Say hello to someone" in
    C.Term.(const hello $ name', info "hello" ~doc ~man:help)
end

let main () =
  try
    match C.Term.eval Command.hello ~catch:false with
    | `Error _ -> exit 1
    | _ -> exit 0
  with exn ->
    Printf.eprintf "error: %s\n" (Printexc.to_string exn) ;
    exit 1

let () = if !Sys.interactive then () else main ()
