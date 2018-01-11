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
CROSS=i686-w64-mingw32.static-
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
