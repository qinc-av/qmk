##################################################
## file: /QInc/qmk/cfg/Darwin-iOS.mk
##
## born_on Wednesday, January 10, 2018
## (C) Copyright Eric L. Hernes 2018
## (C) Copyright Q, Inc. 2018
##
## Makefile to build something
##

apple-multi-arch=iphoneos iphonesimulator
ARCH-iphoneos=-arch arm64 -miphoneos-version-min=13 -fembed-bitcode
CC-iphoneos=xcrun --sdk iphoneos clang ${ARCH-iphoneos}
CXX-iphoneos=xcrun --sdk iphoneos clang++ ${ARCH-iphoneos}
ARCH-iphonesimulator=-arch x86_64
CC-iphonesimulator=xcrun --sdk  iphonesimulator clang ${ARCH-iphonesimulator}
CXX-iphonesimulator=xcrun --sdk iphonesimulator clang++ ${ARCH-iphonesimulator}
CROSS=
EXE=

QMAKE?=${HOME}/Qt/5.12.5/ios/bin/qmake

#ARCH=-arch arm64
#CC=xcrun --sdk iphoneos clang ${ARCH-iphoneos}
#CXX=xcrun --sdk iphoneos clang++ ${ARCH-iphoneos}

LD=/usr/bin/ld
AR=/usr/bin/ar
RANLIB=/usr/bin/ranlib
PKG_CONFIG=pkg-config
STRIP=/usr/bin/strip

TOOLCHAIN_OK=y

## end of /QInc/qmk/cfg/Darwin-iOS.mk
