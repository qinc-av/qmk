##################################################
## file: //QInc/Projects/qmk/sw.prog.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

ifeq (${PROG},)
PROG=$(lastword $(subst /, ,$(dir ${CURDIR})))
endif

SRCDIR=$(dir ${CURDIR})
VPATH+=${SRCDIR}

SRCS+=${SRCS-${BUILD_TARGET}}

OBJS=$(patsubst %,%.o,$(basename $(notdir ${SRCS})))
$(info OBJS= ${OBJS})

include ${QMK}/arch.mk

#INCLUDES+=${UKKO}/software/contrib ${UKKO}/software ${UKKO}/software/Prisma
INCLUDES+=${QINC}/software/Libs ${CONTRIB} ${UKKO}/software ${AVPGH}/Murideo ${SRCDIR}/..

INCLUDES+=${INCLUDES-${BUILD_TARGET}}
DEFINES+=${DEFINES-${BUILD_TARGET}}

_Cxx_FLAGS=$(patsubst %,-D%,${DEFINES}) $(patsubst %,-I%,${INCLUDES})
CFLAGS+=${_Cxx_FLAGS} ${OPTDBG}
CFLAGS+=${CFLAGS-${BUILD_TARGET}}
CXXFLAGS+=-std=${CXX_STD} ${_Cxx_FLAGS} ${OPTDBG}
CXXFLAGS+=${CXXFLAGS-${BUILD_TARGET}}

# find all the software libraries:
define findlibs
  $(foreach l,$(patsubst lib%,%,$(notdir $(wildcard ${1}/lib*))),$(eval lib_${l}?=${1}/lib${l}/obj.${BUILD_TARGET}/lib${l}.a))
endef

define printlibs
  $(foreach l,$(patsubst lib%,%,$(notdir $(wildcard ${1}/lib*))),$(info lib_${l} :: ${lib_${l}}))
endef

XLIB_PATH+=${SRCDIR}/.. ${QINC}/software/Libs ${QINC}/contrib ${UKKO}/software ${UKKO}/software/contrib 

$(foreach ld,${XLIB_PATH}, $(call findlibs,${ld}))

ifeq (${QMK_DEBUG},debug)
$(foreach ld,${XLIB_PATH}, $(call printlibs,${ld}))
endif

#  
# # contrib libs
lib_sqlite=${UKKO}/software/contrib/sqlite3/obj.${BUILD_TARGET}/libsqlite3.a

#
# Arch/Platform specific additional libs
lib_hidapi-Darwin=-framework CoreFoundation -framework IOKit
lib_hidapi-Mingw=-lsetupapi
lib_httpclient-Mingw=-lws2_32
lib_curlpp-Darwin=${lib_curl}
lib_curlpp-Mingw=${lib_curl}

lib_ColorAnalyzer-Darwin=-F ${QINC}/software/Libs/libColorAnalyzer/Frameworks -framework SipFrame -framework i1d3SDK
lib_ColorAnalyzer-Mingw =${QINC}/software/Libs/libColorAnalyzer/XRite/Win32/i386/SipCal.lib
lib_ColorAnalyzer-Mingw+=${QINC}/software/Libs/libColorAnalyzer/XRite/Win32/i386/i1d3SDK.lib

#
# Other pre-installed libs
lib_png = $(shell ${PKG_CONFIG} --libs libpng)
lib_ft = $(shell ${PKG_CONFIG} --libs freetype2)
lib_jpeg = -ljpeg
lib_curl = $(shell ${PKG_CONFIG} --libs libcurl)
lib_magick = $(shell ${PKG_CONFIG} --libs ImageMagick++)
lib_usb = $(shell ${PKG_CONFIG} --libs libusb-1.0)

_LIBS=$(foreach l,${LIBS},${lib_${l}})
LIBS-${BUILD_TARGET}+=$(foreach l,${LIBS},${lib_${l}-${BUILD_TARGET}})

LDFLAGS+=-std=${CXX_STD} ${_LIBS} ${LIBS-${BUILD_TARGET}} ${LDFLAGS-${BUILD_TARGET}}

LDFLAGS+=${LDFLAGS-${BUILD_TARGET}}

lib_PRISMA=${QINC}/software/Libs/prisma-sdk/obj.${BUILD_TARGET}/libprisma.a

all: ${PROG}${EXE}

${PROG}${EXE}: ${OBJS} ${_LIBS}
	echo ${OBJS}
	${CXX} -o $@ ${OBJS} ${LDFLAGS} ${LDADD-${BUILD_TARGET}} ${LDADD}

clean:
	${RM} ${PROG}${EXE} ${OBJS} ${CLEANFILES}
