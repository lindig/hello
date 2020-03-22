#
# This Makefile is not called from Opam but only used for 
# convenience during development
#

DUNE 	= dune

.PHONY: all install test clean uninstall format

all: 
	$(DUNE) build

install: all
	$(DUNE) install

uninstall:
	$(DUNE) uninstall

test:
	$(DUNE) runtest

clean:
	$(DUNE) clean

format:
	ocamlformat -i $$(git ls-files '*.ml*')
	for f in $$(git ls-files '**/dune'); do \
		dune format-dune-file $$f > $$f.tmp && mv $$f.tmp $$f; done
