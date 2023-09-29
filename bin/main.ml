module C = Cmdliner

let build =
  Printf.sprintf "Commit: %s Built on: %s" Build.git_revision Build.build_time

let help =
  [
    `P "These options are common to all commands."
  ; `S "MORE HELP"
  ; `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command."
  ; `S "BUGS"
  ; `P "Check bug reports at https://github.com/lindig/hello/issues"
  ; `S "BUILD DETAILS"
  ; `P build
  ]

let name' =
  C.Arg.(
    value & pos 0 string "world"
    & info [] ~docv:"NAME"
        ~doc:"Name of person to greet; the default is 'world'.")

let hello =
  let doc = "Say hello to someone" in
  let info = C.Cmd.info "hello" ~doc ~man:help in
  C.Cmd.v info @@ C.Term.(const Hello.hello $ name')

let main () = C.Cmd.eval hello
let () = if !Sys.interactive then () else main () |> exit
