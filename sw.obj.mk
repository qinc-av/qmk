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

#
# API files
ifneq ($(filter API-%,${.VARIABLES}),)
$(info API:: $(filter API-%,${.VARIABLES}))
API_DIR?=.
include sw.api.mk

CLEANFILES+=${API_SRCS}
endif

#
# protobuf files
ifneq (${PROTO},)
PROTO_GENSRC=$(patsubst %,%.pb.c,${PROTO})
PROTO_GENHDR=$(patsubst %,%.pb.h,${PROTO})
CLEANFILES+=${PROTO_GENSRC} ${PROTO_GENHDR} $(patsubst %,%.pb,${PROTO})
endif

OBJS=$(patsubst %,%.pb.o,${PROTO})
OBJS+=$(patsubst %,%.o,$(basename $(notdir ${SRCS})))
ifneq (${API_SRCS},)
${OBJS}: ${API_SRCS}
OBJS+=$(patsubst %,%.o,$(basename $(notdir $(filter %.cpp,${API_SRCS}))))
endif
ifneq (${QMK_DEBUG},)
$(info SRCDIR is ${SRCDIR})
$(info SRCS are ${SRCS})
$(info OBJS are ${OBJS})
endif

_SRC_DIRS=$(sort $(foreach s,${SRCS},$(dir ${s})))
VPATH+=$(patsubst %,${SRCDIR}/%,${_SRC_DIRS})

ifneq (${QCORE_INCLUDES},)
INCLUDES+=${QCORE}/software/libs ${QCORE}/contrib ${UKKO_SW} ${UKKO_FW} ${UKKO_CONTRIB}
endif

INCLUDES+=${SRCDIR}/..

INCLUDES+=${INCLUDES-${BUILD_TARGET}}
DEFINES+=${DEFINES-${BUILD_TARGET}}

ifneq (${QMK_DEBUG},)
$(info includes ${INCLUDES})
$(info VPATH is ${VPATH})
endif

.SUFFIXES: .m .mm

ifeq (${NO_DEPS},)
DEPFLAGS?=-MT $@ -MMD -MP -MF $*.Td
DEPFILES=$(patsubst %,%.Td,$(basename $(notdir ${SRCS})))
CLEANFILES+=${DEPFILES}
endif

_CPP_FLAGS=$(patsubst %,-D%,${DEFINES}) $(patsubst %,-I%,${INCLUDES})
CFLAGS+=${OPTDBG} ${_CPP_FLAGS} ${DEPFLAGS}
CFLAGS+=${CFLAGS-${BUILD_TARGET}} ${_CPP_FLAGS} ${DEPFLAGS}
CXXFLAGS+=${CXX_STD} ${OPTDBG} ${_CPP_FLAGS} ${DEPFLAGS}
CXXFLAGS+=${CXXFLAGS-${BUILD_TARGET}}

%.pb : %.proto
	${PROTOC} ${PROTO_FLAGS} --proto_path ${SRCDIR} -o $@ $(notdir $<)

%.pb.h %.pb.c : %.pb
	${NANOPB_GENERATOR} ${NANOPB_FLAGS} $<

ifneq (${apple-multi-arch},)

define newline


endef

%.o : %.c
%.o : %.m
%.o : %.cpp
%.o : %.cc
%.o : %.mm

define cpp-rule
%.o : %.${1}
	echo build $$@ from $$^$(foreach a,${apple-multi-arch},${newline}	${CXX-${a}} ${ARCH-${a}} $${CXXFLAGS} -c -o $$<.${a}.o $$<)
	lipo -create -output $$@ $(foreach a,${apple-multi-arch},$$<.${a}.o)
	rm $(foreach a,${apple-multi-arch},$$<.${a}.o)
endef

define cc-rule
%.o : %.${1}
	echo build $$@ from $$^$(foreach a,${apple-multi-arch},${newline}	${CC-${a}} ${ARCH-${a}} $${CFLAGS} -c -o $$<.${a}.o $$<)
	lipo -create -output $$@ $(foreach a,${apple-multi-arch},$$<.${a}.o)
	rm $(foreach a,${apple-multi-arch},$$<.${a}.o)
endef

#$(info $(call cpp-rule,cpp))
#$(info $(call cpp-rule,cc))
#$(info $(call cpp-rule,mm))

$(eval $(call cpp-rule,cpp))
$(eval $(call cpp-rule,cc))
$(eval $(call cpp-rule,mm))

$(eval $(call cc-rule,c))
$(eval $(call cc-rule,m))

else
%.o : %.cxx
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<

%.o : %.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<

%.o : %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

%.o : %.m
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

%.o : %.mm
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<
endif

ifeq (${NO_DEPS},)
-include ${DEPFILES}
endif

#
# HTDOC handling
ifneq (${HTDOCS},)
HTDOCS_DIRS=$(sort $(foreach p,${HTDOCS},${CURDIR}/$(dir ${p})))
HTDOCS_FILES=$(sort $(foreach p,${HTDOCS},${CURDIR}/${p}))
HTDOCS_TOP=$(firstword ${HTDOCS_DIRS})
HTDOCS_JS_DIR?=${HTDOCS_TOP}js

BUILD_DEPENDS+=${HTDOCS_DIRS} ${HTDOCS_FILES} ${CIVET_H_API} fsdata.h
HTDOCS_FILES+=${JS_API}

endif

ifneq (${HTDOCS},)

${HTDOCS_DIRS}:
	${MKDIR} $@

define copy-rule
${2}/${1}: ${SRCDIR}/${1}
	${CP} ${SRCDIR}/${1} ${2}/${1}
endef

$(foreach p,${HTDOCS},$(eval $(call copy-rule,${p},${CURDIR})))

fsdata.h: ${HTDOCS_FILES} ${API_JS_FILES}
	${CIVETFS} ${HTDOCS_TOP:${CURDIR}/%/=%} >$@

CLEANFILES+=fsdata.h ${HTDOCS_DIRS}

endif

#
# Local Variables:
# mode: Makefile
# mode: font-lock
# tab-width: 8
# compile-command: "make"
# End:
#
