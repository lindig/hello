#
# This Makefile is not called from Opam but only used for 
# convenience during development
#

JB 	= jbuilder

.PHONY: all install test clean

all: 
	$(JB) build

install:
	$(JB) install

test:
	$(JB) runtest

clean:
	$(JB) clean

