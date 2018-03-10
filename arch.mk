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
BUILD_HOST=Darwin
endif

CXX_STD?=-std=c++11

ifdef RELEASE
OPTDBG?=-O3
else
OPTDBG?=-g3 -O0
endif

include $(info arch.mk: $(dir $(realpath $(lastword ${MAKEFILE_LIST}))))

ifeq (${BUILD_HOST},Darwin)
############################################################
## Darwin Host
##
QCORE?=${HOME}/work/QInc/QCore
UKKO?=${HOME}/work/QInc/Ukko
AVPGH?=${HOME}/work/QInc/AVProGH

PROTOC=protoc
NANOPB_GENERATOR=nanopb_generator
NANOPB_FLAGS=-L "\#include <libnanopb/%s>"

APIGEN=${UKKO}/software/apigen/obj.Darwin/apigen
CIVETFS=${UKKO}/software/civetfs/obj.Darwin/civetfs

ifeq (${BUILD_TARGET},Darwin)
########################################
## Darwin Native
##
CROSS=
EXE=
#ARCH-Darwin?=-arch i386 -arch x86_64
ARCH-Darwin?=-arch x86_64
ARCH_FLAGS?=-mmacosx-version-min=10.13
#QMAKE=/opt/local/libexec/qt4/bin/qmake
#QMAKE?=/usr/local/bin/qmake
QMAKE?=${HOME}/Qt/5.9.1/clang_64/bin/qmake
#QMAKE_SPEC=-spec macx-clang-32

else ifeq (${BUILD_TARGET},Mingw)
########################################
## Mingw cross on Darwin
##
ifdef WIN_XP
ARCH-Mingw=-m32 -DWIN_XP
endif
CROSS=i686-w64-mingw32.static-
EXE=.exe
QMAKE=${CROSS}qmake-qt5
QMAKE_SPEC=

else ifeq (${BUILD_TARGET},Linux-arm)
########################################
## Linux-ARM cross on Darwin
##
ARCH-Linux-arm=
CROSS=armv7-qinc-linux-gnueabi-
EXE=
QMAKE=${CROSS}qmake-qt5
QMAKE_SPEC=

else ifeq (${BUILD_TARGET},Linux-rpi)
########################################
## Linux-ARM cross on Darwin
##
ARCH-Linux-arm=
CROSS=armv7-qinc-linux-gnueabi-
EXE=
QMAKE=${CROSS}qmake-qt5
QMAKE_SPEC=

else ifeq (${BUILD_TARGET},Linux-dart)
########################################
## Linux-ARM for imx6ul/dart cross on Darwin
##
ARCH-Linux-dart=
CROSS=arm-imx6_dart-linux-gnueabihf-
EXE=
QMAKE=${CROSS}qmake-qt5
QMAKE_SPEC=
#SYSROOT=${HOME}/work/QInc/Elac/DDP2/sysroots/imx6ul-var-dart
#ARCH_FLAGS=-nostdinc --sysroot ${SYSROOT} -isystem ${SYSROOT}/usr/include

else ifeq (${BUILD_TARGET},Linux-oe)
########################################
## Linux Open Empedded build
##
TOOLCHAIN_OK=1
LEX=flex
APIGEN=apigen
CIVETFS=civetfs

#CFLAGS-Linux-oe+=${TARGET_CFLAGS}
#CXXFLAGS-Linux-oe+=${TARGET_CXXFLAGS}

else
########################################
## Undefined on Darwin
##
$(warning unknown BUILD_TARGET=${BUILD_TARGET})
#don't screw up toolchain
TOOLCHAIN_OK=1
endif
RM=rm -f

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
endif

ARCH_FLAGS+=${ARCH-${BUILD_TARGET}}

UKKO_CONTRIB=${UKKO}/software/contrib
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
