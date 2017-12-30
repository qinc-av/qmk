##################################################
## file: //QInc/qmk/srcdir.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

BUILD_TARGETS-Darwin?=Darwin Linux-arm Linux-dart Linux-rpi
BUILD_TARGETS-Windows?=Mingw

TEST?=test
RELEASE?=release
DISTRO?=distro

test: MK:=${TEST}.mk
cleantest: MK:=${TEST}.mk

release: MK:=${RELEASE}.mk
cleanrelease: MK:=${RELEASE}.mk
distro: MK:=${DISTRO}.mk

MK_PATH=${CURDIR}

ifeq (${MK},)
  MK=$(notdir ${CURDIR}).mk
endif

PRO?=$(notdir ${CURDIR}).pro

objects := 

#
# this sets things up so you can use:
# include ${xxxx.mk}
$(foreach t, $(wildcard ${QMK}/*.mk), $(eval $(notdir ${t})=${t}))

ifneq (${ProgramFiles},)
BUILD_HOST?=Windows
else
#BUILD_HOST?=$(shell uname)
BUILD_HOST?=Darwin
endif

_BUILD_TARGETS=${BUILD_TARGETS-${BUILD_HOST}}

BUILD_TARGETS?=$(patsubst obj.%/.,%,$(foreach t, ${_BUILD_TARGETS}, $(wildcard obj.${t}/.)))

ifneq ($(wildcard ${PRO}),)
$(info using qmake: ${PRO})
MK=sw.qt.mk PRO=${PRO}
MK_PATH=${_QMK}
else ifneq ($(wildcard ${MK}),)
$(info using gnumake: ${MK_PATH}/${MK})
endif

ifneq (DESTDIR,)
 _DESTDIR_VAR=_DESTDIR=${DESTDIR}
endif

all clean test cleantest release cleanrelease distro install qmake:
	@echo building for ${BUILD_TARGETS}
	@$(foreach t, ${BUILD_TARGETS}, \
		${_BUILD_ENV} echo $@ Begin; echo Entering directory \'obj.${t}\' && ${MAKE} -C obj.${t} -f ${MK_PATH}/${MK} -I${_QMK} QMK=${_QMK} BUILD_TARGET=${t} BUILD_HOST=${BUILD_HOST} ${_DESTDIR_VAR} $@ && echo Leaving directory \'obj.${t}\' && ) echo $@ Done

objdirs:
	mkdir -p $(patsubst %,obj.%,${_BUILD_TARGETS})
