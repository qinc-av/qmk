##################################################
## file: /Users/elhernes/Documents/Development/QInc/Projects/qmk/qinc.subdir.mk
##
## (C) Copyright Eric L. Hernes -- Tuesday, March 5, 2013
##
## Makefile to build something
##

$(info In qinc.subdir.mk)
$(info SUBDIR is ${SUBDIR})

SUFFIXES:

MAKETARGET = $(MAKE) -C $@ ${MAKECMDGOALS}

.PHONY: ${SUBDIR}
$(SUBDIR):
	+${MAKETARGET}

Makefile : ;
%.mk :: ;
%.qmk :: ;
GNUmakefile :: ;
QMakefile.inc :: ;
Makefile.inc :: ;

% :: ${SUBDIR} ; :

.PHONY: clean
clean:
	rm -rf obj.*

