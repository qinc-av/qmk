##################################################
## file: //QInc/Projects/qmk/sw.qt.mk
##
## (C) Copyright Eric L. Hernes -- Saturday, March 5, 2016
##
## Makefile to build something
##

ifeq (${APP},)
PRO=$(lastword $(subst /, ,$(dir ${CURDIR})))
endif

SRCDIR=$(abspath $(dir ${CURDIR}))

include ${QMK}/arch.mk

all: ${CURDIR}/Makefile 
	${MAKE}

ARTWORK=$(wildcard ${SRCDIR}/Artwork)
ifneq (${ARTWORK},)
ARTWORK_ICN=${ARTWORK}/${PRO}-icon.icns
ARTWORK_XCF=${ARTWORK}/${PRO}-icon.xcf
endif

ifneq (${QMAKESPEC},)
QMAKE_SPEC=-spec ${QMAKESPEC}
endif

ifeq (${RELEASE},)
QMAKE_OPT+="CONFIG+=debug"
endif

unexport DESTDIR

#
# http://doc.qt.io/qt-5/qmake-advanced-usage.html
# QMAKEPATH looks for features in ${QMK}/mkspecs/features/*.prf
#
${CURDIR}/Makefile: ${SRCDIR}/${PRO} ${ARTWORK}
	${_BUILD_ENV} QMAKEPATH=${QMK} ${QMAKE} ${QMAKE_SPEC} ${QMAKE_OPT} ${SRCDIR}

qmake::
	${_BUILD_ENV} QMAKEPATH=${QMK} ${QMAKE} ${QMAKE_SPEC} ${QMAKE_OPT} ${SRCDIR}

ifneq (${ARTWORK},)
${ARTWORK_ICN}: ${ARTWORK_XCF}
	${MAKE} -C ${ARTWORK}
endif

clean:
	-${MAKE} distclean
ifneq (${ARTWORK},)
	${MAKE} -C ${ARTWORK} clean
endif
