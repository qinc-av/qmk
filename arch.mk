##################################################
## file: //QInc/Projects/qmk/arch.mk
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

CXX_STD?=c++11

ifdef RELEASE
OPTDBG?=-O3
else
OPTDBG?=-g3 -O0
endif

UKKO?=${HOME}/work/QInc/Ukko
QINC?=${HOME}/work/QInc/Projects
AVPGH?=${HOME}/work/QInc/AVProGH
CONTRIB=${QINC}/contrib

ifeq (${BUILD_HOST},Darwin)
############################################################
## Darwin Host
##

ifeq (${BUILD_TARGET},Darwin)
########################################
## Darwin Native
##
CROSS=
EXE=
ARCH-Darwin?=-arch i386 -arch x86_64
ARCH_FLAGS?=-mmacosx-version-min=10.7 
#QMAKE=/opt/local/libexec/qt4/bin/qmake
QMAKE=/opt/local/libexec/qt5/bin/qmake
QMAKE_SPEC=-spec macx-clang-32

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

else
########################################
## Undefined on Darwin
##
$(warning ignoring invalid BUILD_TARGET=${BUILD_TARGET})
endif
RM=rm -f

else ifeq (${BUILD_HOST},Windows)
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

CC=${CROSS}gcc ${ARCH_FLAGS}
CXX=${CROSS}c++ ${ARCH_FLAGS}
LD=${CROSS}ld
AR=${CROSS}ar
RANLIB=${CROSS}ranlib
AS=${CROSS}as
PKG_CONFIG=${CROSS}pkg-config

DEFINES+=HOST_SOFTWARE

##
## Defines for OEM stuffs
DESTDIR-AVPGH=${AVPGH}/QInc
