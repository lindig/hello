#
# This Makefile is not called from Opam but only used for 
# convenience during development
#

JB 	= jbuilder

all: 
	$(JB) build

install:
	$(JB) install

clean:
	$(JB) clean

