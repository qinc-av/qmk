########################################
## file: //QInc/Projects/qmk/sw.obj.mk
## born-on: Wednesday, January 1, 2014
## creator: Eric L. Hernes
##
## Makefile to build something
##

SRCDIR=$(dir ${CURDIR})
#VPATH+=${SRCDIR}

#
# Add any platform specific sources
SRCS+=${SRCS-${BUILD_TARGET}} ${SRCS-${BASE_PLATFORM}}

OBJS=$(patsubst %,%.o,$(basename $(notdir ${SRCS})))
ifneq (${QMK_DEBUG},)
$(info SRCS are ${SRCS})
$(info OBJS are ${OBJS})
endif

_SRC_DIRS=$(sort $(foreach s,${SRCS},$(dir ${s})))
VPATH=$(patsubst %,${SRCDIR}/%,${_SRC_DIRS})

INCLUDES+=${SRCDIR}/..

INCLUDES+=${INCLUDES-${BUILD_TARGET}}
DEFINES+=${DEFINES-${BUILD_TARGET}}

ifneq (${QMK_DEBUG},)
$(info includes ${INCLUDES})
$(info VPATH is ${VPATH})
endif

_CPP_FLAGS=$(patsubst %,-D%,${DEFINES}) $(patsubst %,-I%,${INCLUDES})
CFLAGS+=${OPTDBG} ${_CPP_FLAGS}
CFLAGS+=${CFLAGS-${BUILD_TARGET}}
CXXFLAGS+=${CXX_STD} ${OPTDBG} ${_CPP_FLAGS} 
CXXFLAGS+=${CXXFLAGS-${BUILD_TARGET}}

#
# Local Variables:
# mode: Makefile
# mode: font-lock
# tab-width: 8
# compile-command: "make"
# End:
#
