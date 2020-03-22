#
# This Makefile is not called from Opam but only used for 
# convenience during development
#

DUNE 	= dune

.PHONY: all install test clean

all: 
	$(DUNE) build

install:
	$(DUNE) install

test:
	$(DUNE) runtest

clean:
	$(DUNE) clean

format:
	ocamlformat -i $$(git ls-files '*.ml*')

