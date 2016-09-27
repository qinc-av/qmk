##################################################
## file: //QInc/Ukko/mk/sw.qt.mk
##
## (C) Copyright Eric L. Hernes -- Saturday, March 5, 2016
##
## Makefile to build something
##

ifeq (${APP},)
PRO=$(lastword $(subst /, ,$(dir ${CURDIR})))
endif

SRCDIR=$(dir ${CURDIR})

include ${QMK}/arch.mk

all: ${CURDIR}/Makefile 
	${MAKE}

ifeq (${NO_ARTWORK},)
ARTWORK= ${SRCDIR}/Artwork/${PRO}-icon.icns
endif

${CURDIR}/Makefile: ${SRCDIR}/${PRO}.pro ${ARTWORK}
	${QMAKE} ${QMAKE_SPEC} QINC=${QINC} UKKO=${UKKO} AVPGH=${AVPGH} ${SRCDIR}

${SRCDIR}/Artwork/${PRO}-icon.icns: ${SRCDIR}/Artwork/${PRO}-icon.xcf
	${MAKE} -C ${SRCDIR}/Artwork

clean:
	-${MAKE} distclean
ifeq (${NO_ARTWORK},)
	${MAKE} -C ${SRCDIR}/Artwork clean
endif

