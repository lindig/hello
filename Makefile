#
# This Makefile is not called from Opam but only used for
# convenience during development
#

DUNE 	= dune
PROFILE = dev

.PHONY: all install test clean format lint release

all:
	$(DUNE) build --profile=$(PROFILE)

install:
	$(DUNE) install --profile=$(PROFILE)

clean:
	$(DUNE) clean

format:
	dune build @fmt --auto-promote

lint:
	opam lint hello.opam
	opam lint --normalise hello.opam > hello.tmp && mv hello.tmp hello.opam

release:
	dune-release tag
	dune-release distrib
	dune-release opam pkg

# vim:ts=8:noet:
