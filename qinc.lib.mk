##################################################
## file: QInc/Project/qmk/qinc.lib.mk
##
## (C) Copyright Eric L. Hernes -- Monday, November 26, 2012
##
## Makefile to build something
##

QMK?=${HOME}/Documents/Development/QInc/Projects/qmk
#QMK?=${HOME}/Documents/Development/gmk

BUILD_TARGET?=$(shell uname)

-include ${QMK}/${BUILD_TARGET}.mk
-include ${CURDIR}/local.mk

OBJDIR?=${CURDIR}/obj.${BUILD_TARGET}

ifeq (,$(filter obj.%,$(notdir ${CURDIR})))
  LIB?=$(patsubst lib%,%,$(notdir ${CURDIR}))
  SUBMAKEVARS=LIB=${LIB}
  include ${QMK}/qinc.srcdir.mk
else
  include ${SRCDIR}/../QMakefile.inc
  include ${QMK}/qinc.libobj.mk
endif
