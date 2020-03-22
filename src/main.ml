module C = Cmdliner

let hello name = Printf.printf "Hello, %s!\n" name

module Command = struct
  let help =
    [
      `P "These options are common to all commands."
    ; `S "MORE HELP"
    ; `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command."
    ; `S "BUGS"
    ; `P "Check bug reports at https://github.com/lindig/hello/issues"
    ]

  let name' =
    C.Arg.(
      value & pos 0 string "world"
      & info [] ~docv:"NAME"
          ~doc:"Name of person to greet; the default is 'world'.")

  let hello =
    let doc = "Say hello to someone" in
    C.Term.(const hello $ name', info "hello" ~doc ~man:help)
end

let main () = C.Term.(exit @@ eval Command.hello)

let () = if !Sys.interactive then () else main ()
