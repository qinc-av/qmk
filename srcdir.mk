##################################################
## file: /Users/elhernes/work/QInc/Ukko/software/mk/srcdir.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

BUILD_TARGETS-Darwin?=Darwin Mingw Linux-arm
BUILD_TARGETS-Windows?=Mingw

TEST?=test
RELEASE?=release

test: MK=${TEST}.mk
cleantest: MK=${TEST}.mk

release: MK=${RELEASE}.mk
cleanrelease: MK=${RELEASE}.mk

MK?=$(notdir ${CURDIR}).mk

objects := 

$(foreach t, $(wildcard ${QMK}/*.mk), $(eval $(notdir ${t})=${t}))

ifneq (${ProgramFiles},)
BUILD_HOST=Windows
else
BUILD_HOST=Darwin
endif

_BUILD_TARGETS=${BUILD_TARGETS-${BUILD_HOST}}

BUILD_TARGETS?=$(patsubst obj.%/.,%,$(foreach t, ${_BUILD_TARGETS}, $(wildcard obj.${t}/.)))

all clean test cleantest release cleanrelease install:
	$(foreach t, ${BUILD_TARGETS}, ${MAKE} -f ${CURDIR}/${MK} -I $(abspath ${QMK}) -C obj.${t} QMK=${QMK} BUILD_TARGET=${t} BUILD_HOST=${BUILD_HOST} DESTDIR=${DESTDIR} $@ && ) echo Done

