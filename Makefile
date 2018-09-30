#
# This Makefile is not called from Opam but only used for 
# convenience during development
#

DUNE 	= dune
SRC   = find . -not \( -path ./_build -prune \) -type f -name '*ml*'

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
	$(SRC) | xargs ocamlformat -i

