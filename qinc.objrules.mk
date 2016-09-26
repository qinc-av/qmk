##################################################
## file: QInc/Project/qmk/qinc.objrules.mk
##
## (C) Copyright Eric L. Hernes -- Monday, March 4, 2013
##
## Makefile rules to build object stuff
##

CPP=${CROSS}cpp
CC=${CROSS}gcc
CXX=${CROSS}c++
AR=${CROSS}ar
LD=${CROSS}ld
RANLIB=${CROSS}ranlib

VPATH+= ${SRCDIR}

OPT_DBG?=-O

LDADD=  ${PROJ_LDADD} ${SYS_LDADD}

.SUFFIXES:

%.o : %.cpp
	${CXX} ${OPT_DEBUG} ${CPPFLAGS} ${CXXFLAGS} -c -o $@ $<

%.o : %.c
	${CC} ${OPT_DEBUG} ${CPPFLAGS} ${CXXFLAGS} -c -o $@ $<

lib${LIB}.a: ${OBJS}
	${AR} rv $@ ${OBJS}
	${RANLIB} $@

${PROG}: ${OBJS}
	${LD} ${LDFLAGS} -o $@ ${OBJS} ${LDADD}
