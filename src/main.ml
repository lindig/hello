
module C = Cmdliner

type config =
  { args: string list
  }

let config =
  { args = Sys.argv |> Array.to_list |> List.tl
  }

let hello name =
  Printf.printf "Hello, %s!\n" name

let help =
  [ `P "These options are common to all commands."
  ; `S "MORE HELP"
  ; `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command."
  ; `S "BUGS"
  ; `P "Check bug reports at https://github.com/lindig/hello/issues"
  ]

module Command = struct
  let name' =
    C.Arg.(value
           & pos 0 string "world"
           & info [] 
             ~docv:"NAME" 
             ~doc:"Name of person to greet; the default is 'world'." 
          )

  let hello =
    let doc = "Say hello to someone" in
    C.Term.
      ( const hello $ name'
      , info "hello" ~doc ~man:help
      )

end

let main () =
  try match C.Term.eval Command.hello ~catch:false with
    | `Error _  -> exit 1
    | _         -> exit 0
  with exn -> 
    Printf.eprintf "error: %s\n" (Printexc.to_string exn); 
    exit 1

let () = if !Sys.interactive then () else main ()
