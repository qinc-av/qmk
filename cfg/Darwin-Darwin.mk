##################################################
## file: /QInc/qmk/cfg/Darwin-Darwin.mk
##
## born_on Wednesday, January 10, 2018
## (C) Copyright Eric L. Hernes 2018
## (C) Copyright Q, Inc. 2018
##
## Makefile to build something
##

CROSS=
EXE=
ARCH-Darwin?=-arch x86_64 -arch arm64
ARCH_FLAGS?=-mmacosx-version-min=10.12
QMAKE?=${HOME}/Qt/5.14.1/clang_64/bin/qmake

CC=/usr/bin/gcc ${ARCH_FLAGS}
CXX=/usr/bin/c++ ${ARCH_FLAGS}
LD=/usr/bin/ld
AR=/usr/bin/ar
RANLIB=/usr/bin/ranlib
AS=/usr/bin/as
PKG_CONFIG=pkg-config
STRIP=/usr/bin/strip

TOOLCHAIN_OK=y
# 
# Local Variables:
# mode: Makefile
# mode: font-lock
# c-basic-offset: 2
# tab-width: 8
# compile-command: "make.qmk"
# End:
#

## end of /QInc/qmk/cfg/Darwin-Darwin.mk
