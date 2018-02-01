######################################
## file: //QInc/qmk/sw.obj.mk
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

# special case for linux variants
ifeq (Linux-,$(findstring Linux-,${BUILD_TARGET}))
SRCS+=${SRCS-Linux}
endif

ifneq (${PROTO},)
PROTO_GENSRC=$(patsubst %,%.pb.c,${PROTO})
PROTO_GENHDR=$(patsubst %,%.pb.h,${PROTO})
CLEANFILES+=${PROTO_GENSRC} ${PROTO_GENHDR} $(patsubst %,%.pb,${PROTO})
endif

OBJS=$(patsubst %,%.pb.o,${PROTO})
OBJS+=$(patsubst %,%.o,$(basename $(notdir ${SRCS})))
ifneq (${QMK_DEBUG},)
$(info SRCS are ${SRCS})
$(info OBJS are ${OBJS})
endif

_SRC_DIRS=$(sort $(foreach s,${SRCS},$(dir ${s})))
VPATH+=$(patsubst %,${SRCDIR}/%,${_SRC_DIRS})

ifeq (${NO_Q_INCLUDES},)
INCLUDES+=${QCORE}/software/libs ${QCORE}/contrib ${UKKO_SW} ${UKKO_FW} ${UKKO_CONTRIB}
endif

INCLUDES+=${SRCDIR}/..

INCLUDES+=${INCLUDES-${BUILD_TARGET}}
DEFINES+=${DEFINES-${BUILD_TARGET}}

ifneq (${QMK_DEBUG},)
$(info includes ${INCLUDES})
$(info VPATH is ${VPATH})
endif

ifeq (${NO_DEPS},)
DEPFLAGS?=-MT $@ -MMD -MP -MF $*.Td
DEPFILES=$(patsubst %,%.Td,$(basename $(notdir ${SRCS})))
CLEANFILES+=${DEPFILES}
endif

_CPP_FLAGS=$(patsubst %,-D%,${DEFINES}) $(patsubst %,-I%,${INCLUDES})
CFLAGS+=${OPTDBG} ${_CPP_FLAGS} ${DEPFLAGS}
CFLAGS+=${CFLAGS-${BUILD_TARGET}}
CXXFLAGS+=${CXX_STD} ${OPTDBG} ${_CPP_FLAGS} ${DEPFLAGS}
CXXFLAGS+=${CXXFLAGS-${BUILD_TARGET}}

%.pb : %.proto
	${PROTOC} ${PROTO_FLAGS} --proto_path ${SRCDIR} -o $@ $(notdir $<)

%.pb.h %.pb.c : %.pb
	${NANOPB_GENERATOR} ${NANOPB_FLAGS} $<

%_civet.h : %.api
	${APIGEN} -i server-civet-h $<

%_api.js: %.api
	${APIGEN} -i js $<

%.o : %.cxx
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<

ifeq (${NO_DEPS},)
-include ${DEPFILES}
endif

#
# Local Variables:
# mode: Makefile
# mode: font-lock
# tab-width: 8
# compile-command: "make"
# End:
#
