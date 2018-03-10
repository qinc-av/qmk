##################################################
## file: //QInc/qmk/arch.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

ifneq (${ProgramFiles},)
BUILD_HOST=Windows
else
BUILD_HOST=$(shell uname)
endif

CXX_STD?=-std=c++11

ifdef RELEASE
OPTDBG?=-O3
else
OPTDBG?=-g3 -O0
endif

#
# Build Host details -
#  paths and programs
ifneq (,$(filter ${BUILD_HOST}, Linux Darwin))
############################################################
## Darwin/Linux Host
##
QCORE?=${HOME}/work/QInc/QCore
UKKO?=${HOME}/work/QInc/Ukko
AVPGH?=${HOME}/work/QInc/AVProGH

PROTOC=protoc
NANOPB_GENERATOR=nanopb_generator
NANOPB_FLAGS=-L "\#include <libnanopb/%s>"

APIGEN?=${UKKO}/software/apigen/obj.Darwin/apigen
CIVETFS?=${UKKO}/software/civetfs/obj.Darwin/civetfs

VERILATOR=verilator

RM=rm -rf
MKDIR=mkdir -p
CP=cp

else ifeq (${BUILD_HOST},Windows)
QCORE?=${USERPROFILE}\Documents\QInc\Projects\QCore
UKKO?=${USERPROFILE}\Documents\QInc\Projects\Ukko
AVPGH?=${USERPROFILE}\Documents\QInc\Projects\AVProGH
CONTRIB?=${QCORE}\contrib

ifdef WIN_XP
ARCH-Mingw?=-m32 -DWIN_XP
endif
BUILD_TARGET?=Mingw
CROSS=c:/TDM-GCC-64/bin/
EXE=.exe
RM=del
LDFLAGS+=-static

endif # BUILD_HOSTS

ifeq ($(wildcard ${QMK}/cfg/${BUILD_HOST}-${BUILD_TARGET}.mk),)
$(warning unknown build config=${BUILD_HOST}-${BUILD_TARGET})
TOOLCHAIN_OK=1
else
include ${QMK}/cfg/${BUILD_HOST}-${BUILD_TARGET}.mk
endif

ARCH_FLAGS+=${ARCH-${BUILD_TARGET}}

UKKO_CONTRIB=${UKKO}/software/contrib
UKKO_SW=${UKKO}/software
UKKO_FW=${UKKO}/firmware/libs
CONTRIB=${QCORE}/contrib

ifeq (${TOOLCHAIN_OK},)
CC=${CROSS}gcc ${ARCH_FLAGS}
CXX=${CROSS}c++ ${ARCH_FLAGS}
LD=${CROSS}ld
AR=${CROSS}ar
RANLIB=${CROSS}ranlib
AS=${CROSS}as
PKG_CONFIG=${CROSS}pkg-config
STRIP=${CROSS}strip
endif

DEFINES+=HOST_SOFTWARE

##
## Defines for OEM stuffs
PREFIX-AVPGH=${AVPGH}/QInc
