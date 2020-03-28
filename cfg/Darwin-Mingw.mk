##################################################
## file: /QInc/qmk/cfg/Darwin-Mingw.mk
##
## born_on Wednesday, January 10, 2018
## (C) Copyright Eric L. Hernes 2018
## (C) Copyright Q, Inc. 2018
##
## Makefile to build something
##

ifdef WIN_XP
ARCH-Mingw=-m32 -DWIN_XP
endif

MXE_BIN?=/Volumes/CSData/Development/github/mxe/usr/bin

ifneq (${MXE_BIN},$(findstring ${MXE_BIN},${PATH}))
$(info no mxe bin)
export PATH:=${PATH}:${MXE_BIN}
endif

#i686-w64-mingw32.static
#i686-w64-mingw32.shared
#x86_64-w64-mingw32.shared
#x86_64-w64-mingw32.static
#i686-w64-mingw32.static.posix
#i686-w64-mingw32.shared.posix
#x86_64-w64-mingw32.shared.posix
#x86_64-w64-mingw32.static.posix

CROSS:=$(if ${MXE_CROSS},${MXE_CROSS},i686-w64-mingw32.shared.posix)-

EXE=.exe
QMAKE=${CROSS}qmake-qt5
QMAKE_SPEC=

# 
# Local Variables:
# mode: Makefile
# mode: font-lock
# c-basic-offset: 2
# tab-width: 8
# compile-command: "make.qmk"
# End:
#

## end of /QInc/qmk/cfg/Darwin-Mingw.mk
