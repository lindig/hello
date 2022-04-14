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
    value & pos 0 string "hello"
    & info [] ~docv:"FILE" ~doc:"File name to use for tests")

let hello =
  let doc = "Test compression and uncompression" in
  C.Term.(const Hello.hello $ name', info "hello" ~doc ~man:help)

let main () = C.Term.(exit @@ eval hello)

let () = if !Sys.interactive then () else main ()
