##################################################
## file: QInc/Project/qmk/qinc.srcdir.mk
##
## (C) Copyright Eric L. Hernes -- Monday, March 4, 2013
##
## Makefile for the source directory
##

SUFFIXES:
TLM:=$(notdir $(firstword $(MAKEFILE_LIST)))

MAKETARGET = $(MAKE) -C $@ -f ${CURDIR}/${TLM} SRCDIR=${CURDIR} ${SUBMAKEVARS} ${MAKECMDGOALS}

.PHONY: ${OBJDIR}
$(OBJDIR):
	+@[ -d $@ ] || mkdir -p $@
	+@${MAKETARGET}

Makefile : ;
%.mk :: ;
%.qmk :: ;
GNUmakefile :: ;
QMakefile.inc :: ;
Makefile.inc :: ;

% :: ${OBJDIR} ; :

.PHONY: clean
clean:
	rm -rf obj.*

