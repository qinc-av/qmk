##################################################
## file: //QInc/qmk/sw.lib.mk
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

##
## would be nice but doesn't work
#define obj_rule
#$(info $(patsubst %,%.o,$(basename $(notdir ${1}))): ${1})
#$(patsubst %,%.o,$(basename $(notdir ${1}))): ${1}
#endef
#$(foreach s,${SRCS},$(eval $(call obj_rule, ${SRCDIR}${s})))

include ${QMK}/arch.mk

include ${QMK}/sw.obj.mk

JPEG_INC ?= -I/opt/local/include #$(shell pkg-config --cflags freetype2)
USB_INC = $(shell ${PKG_CONFIG} --cflags libusb-1.0)
FT_INC = $(shell ${PKG_CONFIG} --cflags freetype2)

all: ${BUILD_DEPENDS} lib${LIB}.a

lib${LIB}.a: ${OBJS}
	rm -f lib${LIB}.a
	${AR} rv lib${LIB}.a ${OBJS}
	${RANLIB} lib${LIB}.a

clean:
	${RM} lib${LIB}.a ${OBJS} ${CLEANFILES}

LIBDIR?=${PREFIX}/lib/obj.${BUILD_TARGET}
INCLUDEDIR?=${PREFIX}/include

install: lib${LIB}.a
	@for d in $(patsubst %/,%,$(sort $(dir ${PUBLIC_HEADER}))); do test -d ${INCLUDEDIR}/lib${LIB}/$${d} || mkdir -p ${INCLUDEDIR}/lib${LIB}/$${d}; done
	@echo install public header: ${PUBLIC_HEADER} ${INCLUDEDIR}/lib${LIB}
	@s=${SRCDIR}; for h in ${PUBLIC_HEADER}; do cp $${s}/$${h} ${INCLUDEDIR}/lib${LIB}/$${h}; done
	@test -d ${LIBDIR} || mkdir -p ${LIBDIR}
	@echo install library: ${LIBDIR}/lib${LIB}.a
	@cp lib${LIB}.a ${LIBDIR}

