##################################################
## file: /QInc/qmk/cfg/Darwin-Linux-dart.mk
##
## born_on Wednesday, January 10, 2018
## (C) Copyright Eric L. Hernes 2018
## (C) Copyright Q, Inc. 2018
##

########################################
## Linux-ARM for imx6ul/dart cross on Darwin
##
ARCH-Linux-dart=
CROSS=arm-imx6_dart-linux-gnueabihf-
EXE=
QMAKE=${CROSS}qmake-qt5
QMAKE_SPEC=
#SYSROOT=${HOME}/work/QInc/Elac/DDP2/sysroots/imx6ul-var-dart
#ARCH_FLAGS=-nostdinc --sysroot ${SYSROOT} -isystem ${SYSROOT}/usr/include

# 
# Local Variables:
# mode: Makefile
# mode: font-lock
# c-basic-offset: 2
# tab-width: 8
# compile-command: "make.qmk"
# End:
#

## end of /QInc/qmk/cfg/Darwin-Linux-dart.mk
