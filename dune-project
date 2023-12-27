(lang dune 2.0)

(name hello)

(generate_opam_files true)

(source
 (github lindig/hello))

(license Unlicense)

(authors "Christian Lindig <lindig@gmail.com>")

(maintainers "Christian Lindig <lindig@gmail.com>")

(package
 (name hello)
 (synopsis "Minimal OCaml project for starting a new one")
 (description
  "Hello is the classic hello world but organised as a proper OCaml project incuding command-line parsing and online help. It serves as a starting point for new projects.")
 (depends
  (dune
   (>= "2.0"))
  (ocaml
   (>= 4.08.0))
  (cmdliner
   (>= 1.1.0))))
