##################################################
## file: //QInc/Projects/qmk/sw.lib.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

ifeq (${LIB},)
LIB=$(patsubst lib%,%,$(lastword $(subst /, ,$(dir ${CURDIR}))))
endif

ifeq (${PUBLIC_HEADER},)
PUBLIC_HEADER=${LIB}.h
endif

SRCDIR=$(dir ${CURDIR})
VPATH+=${SRCDIR}

SRCS+=${SRCS-${BUILD_TARGET}}

OBJS=$(patsubst %,%.o,$(basename $(notdir ${SRCS})))

include ${QMK}/arch.mk

INCLUDES+=${QINC}/software/Libs ${UKKO}/software ${CONTRIB} ${AVPGH}/Murideo

INCLUDES+=${INCLUDES-${BUILD_TARGET}}
DEFINES+=${DEFINES-${BUILD_TARGET}}

_Cxx_FLAGS=$(patsubst %,-D%,${DEFINES}) $(patsubst %,-I%,${INCLUDES})
CFLAGS+=${_Cxx_FLAGS} ${OPTDBG}
CFLAGS+=${CFLAGS-${BUILD_TARGET}}
CXXFLAGS+=-std=${CXX_STD} ${_Cxx_FLAGS} ${OPTDBG}
CXXFLAGS+=${CXXFLAGS-${BUILD_TARGET}}

PNG_INC = $(shell pkg-config --cflags libpng)
FT_INC = $(shell pkg-config --cflags freetype2)

JPEG_INC ?= -I/opt/local/include #$(shell pkg-config --cflags freetype2)
USB_INC = $(shell ${PKG_CONFIG} --cflags libusb-1.0)

all: lib${LIB}.a

lib${LIB}.a: ${OBJS}
	rm -f lib${LIB}.a
	${AR} rv lib${LIB}.a ${OBJS}
	${RANLIB} lib${LIB}.a

clean:
	${RM} lib${LIB}.a ${OBJS} ${CLEANFILES}

install: lib${LIB}.a
	@for d in $(patsubst %/,%,$(sort $(dir ${PUBLIC_HEADER}))); do test -d ${DESTDIR}/include/lib${LIB}/$${d} || mkdir -p ${DESTDIR}/include/lib${LIB}/$${d}; done
	@echo install public header: ${PUBLIC_HEADER} ${DESTDIR}/include/lib${LIB}
	@s=${SRCDIR}; for h in ${PUBLIC_HEADER}; do cp $${s}/$${h} ${DESTDIR}/include/lib${LIB}/$${h}; done
	@test -d ${DESTDIR}/lib/obj.${BUILD_TARGET} || mkdir -p ${DESTDIR}/lib/obj.${BUILD_TARGET}
	@echo install library: ${DESTDIR}/lib/obj.${BUILD_TARGET}/lib${LIB}.a
	@cp lib${LIB}.a ${DESTDIR}/lib/obj.${BUILD_TARGET}

