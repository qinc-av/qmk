##################################################
## file: /QInc/qmk/cfg/Darwin-Darwin.mk
##
## born_on Wednesday, January 10, 2018
## (C) Copyright Eric L. Hernes 2018
## (C) Copyright Q, Inc. 2018
##
## Makefile to build something
##
# https://gist.github.com/wmanth/908ae784d32ab572033b50b2289c6e20

apple-multi-arch=appletvos appletvsimulator

ARCH-appletvos=-arch arm64 -mtvos-version-min=13 -fembed-bitcode
CC-appletvos=xcrun --sdk appletvos clang ${ARCH-appletvos}
CXX-appletvos=xcrun --sdk appletvos clang++ ${ARCH-appletvos}
ARCH-appletvsimulator=-arch x86_64
CC-appletvsimulator=xcrun --sdk  appletvsimulator clang ${ARCH-appletvsimulator}
CXX-appletvsimulator=xcrun --sdk appletvsimulator clang++ ${ARCH-appletvsimulator}

CROSS=
EXE=

QMAKE?=${HOME}/Qt/5.12.5/ios/bin/qmake

CC=xcrun --sdk appletvos clang ${ARCH-tvOS}
CXX=xcrun --sdk appletvos clang++ ${ARCH-tvOS}
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
