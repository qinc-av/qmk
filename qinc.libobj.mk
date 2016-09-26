##################################################
## file: QInc/Project/qmk/qinc.libobj.mk
##
## (C) Copyright Eric L. Hernes -- Monday, March 4, 2013
##
## Makefile for the object directory in a library build
##

#$(info "object directory [$(notdir ${CURDIR})]: LIB is lib${LIB}.a")

OBJS=$(addsuffix .o, $(basename ${SRCS}))

include ${QMK}/qinc.objrules.mk

all: lib${LIB}.a

