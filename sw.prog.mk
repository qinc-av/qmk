##################################################
## file: /Users/elhernes/work/QInc/Ukko/mk/sw.prog.mk
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

include ${QMK}/arch.mk

#INCLUDES+=${UKKO}/software/contrib ${UKKO}/software ${UKKO}/software/Prisma
INCLUDES+=${QINC}/Libs ${CONTRIB} ${UKKO}/software ${SRCDIR}/..

INCLUDES+=${INCLUDES-${BUILD_TARGET}}
DEFINES+=${DEFINES-${BUILD_TARGET}}

_Cxx_FLAGS=$(patsubst %,-D%,${DEFINES}) $(patsubst %,-I%,${INCLUDES})
CFLAGS+=${_Cxx_FLAGS} ${OPTDBG}
CFLAGS+=${CFLAGS-${BUILD_TARGET}}
CXXFLAGS+=-std=${CXX_STD} ${_Cxx_FLAGS} ${OPTDBG}
CXXFLAGS+=${CXXFLAGS-${BUILD_TARGET}}

# find all the software libraries:
define findlibs
  $(foreach l,$(patsubst lib%,%,$(notdir $(wildcard ${1}/lib*))),$(eval lib_${l}=${1}/lib${l}/obj.${BUILD_TARGET}/lib${l}.a))
endef

define printlibs
  $(foreach l,$(patsubst lib%,%,$(notdir $(wildcard ${1}/lib*))),$(info lib_${l} :: ${lib_${l}}))
endef

$(foreach ld,${QINC}/Libs ${QINC}/contrib ${UKKO}/software ${UKKO}/software/contrib ${AVPGH}, $(call findlibs,${ld}))
#$(foreach ld,${QINC}/Libs ${QINC}/contrib ${UKKO}/software ${AVPGH}, $(call printlibs,${ld}))

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

lib_ColorAnalyzer-Darwin=-F ${QINC}/Libs/libColorAnalyzer/Frameworks -framework SipFrame -framework i1d3SDK
lib_ColorAnalyzer-Mingw =${QINC}/Libs/libColorAnalyzer/XRite/Win32/i386/SipCal.lib
lib_ColorAnalyzer-Mingw+=${QINC}/Libs/libColorAnalyzer/XRite/Win32/i386/i1d3SDK.lib

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

LDFLAGS+=${_LIBS} ${LIBS-${BUILD_TARGET}} ${LDFLAGS-${BUILD_TARGET}}

LDFLAGS+=${LDFLAGS-${BUILD_TARGET}}

lib_PRISMA=${QINC}/Libs/prisma-sdk/obj.${BUILD_TARGET}/libprisma.a
lib_SIXGIO=${MURIDEO/libSixGIo/obj.${BUILD_TARGET}/libSixGIo.a

all: ${PROG}${EXE}

${PROG}${EXE}: ${OBJS} ${_LIBS}
	${CXX} -o $@ ${OBJS} ${LDFLAGS} ${LDADD} ${LDADD-${BUILD_TARGET}}

clean:
	${RM} ${PROG}${EXE} ${OBJS} ${CLEANFILES}
