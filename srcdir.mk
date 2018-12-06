##################################################
## file: //QInc/qmk/srcdir.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

BUILD_TARGETS-Darwin?=Darwin Linux-arm Linux-dart Linux-rocko Linux-rpi Linux-rpi3 Mingw
BUILD_TARGETS-Windows?=Mingw
BUILD_TARGETS-Linux?=Linux oe

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
BUILD_HOST?=$(shell uname)
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

ifneq (PREFIX,)
 PREFIX_VAR=PREFIX=${PREFIX}
endif

ifeq (1,0)
# old non-makeish way...
all clean test cleantest release cleanrelease distro install qmake:
	@echo building for ${BUILD_TARGETS}
	@$(foreach t, ${BUILD_TARGETS}, \
		${_BUILD_ENV} echo $@ Begin; echo Entering directory \'obj.${t}\' && ${MAKE} -C obj.${t} -f ${MK_PATH}/${MK} -I${_QMK} QMK=${_QMK} BUILD_TARGET=${t} BUILD_HOST=${BUILD_HOST} ${PREFIX_VAR} $@ && echo Leaving directory \'obj.${t}\' && ) echo $@ Done
endif

COMMON_RECIPES=all clean test cleantest release cleanrelease install qmake qmake_all

define gen-common-deps
${1}: $(foreach t, ${BUILD_TARGETS}, ${t}-${1})
endef

define set-build-env
${BUILD_HOST}-${1}-env:=$(wildcard ${QMK}/cfg/${BUILD_HOST}-${1}.env)
endef

$(foreach r, ${COMMON_RECIPES}, $(eval $(call gen-common-deps,${r}) ) )
$(foreach t, ${BUILD_TARGETS}, $(eval $(call set-build-env,${t}) ) )

# make this a little less subtle...
source=.

define gen-rules
${1}-${2}:
	@echo Entering directory \'obj.${1}\'
	@$(if ${${BUILD_HOST}-${1}-env},${source} ${${BUILD_HOST}-${1}-env};,) ${MAKE} -C obj.${1} -f ${MK_PATH}/${MK} -I${_QMK} -I${CURDIR} QMK=${_QMK} BUILD_TARGET=${1} BUILD_HOST=${BUILD_HOST} ${_DESTDIR_VAR} ${2}
	echo Leaving directory \'obj.${1}\'
endef

$(foreach t, ${BUILD_TARGETS}, $(foreach r, ${COMMON_RECIPES}, $(eval $(call gen-rules,${t},${r}) ) ) )

objdirs:
	mkdir -p $(patsubst %,obj.%,${_BUILD_TARGETS})
