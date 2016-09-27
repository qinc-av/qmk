win32 {
  CONFIG -= debug_and_release
  CONFIG -= debug
  CONFIG += release
  BUILD_TARGET=Mingw
  PKG_CONFIG=i686-w64-mingw32.static-pkg-config
}

macx {
  QMAKE_MACOSX_DEPLOYMENT_TARGET=10.7
  BUILD_TARGET=Darwin
  PKG_CONFIG=pkg-config
}

INCLUDEPATH += $${QINC}/Libs
LIB_P=$${QINC}/Libs $${QINC}/contrib $${UKKO}/software $${UKKO}/software/contrib $${AVPGH}

PRISMA_SDK=$${QINC}/Libs/prisma-sdk
libPRISMA_SDK=$${PRISMA_SDK}/obj.$${BUILD_TARGET}/libprisma.a

libSixGIo=$(HOME)/work/QInc/Murideo/libSixGIo/obj.$${BUILD_TARGET}/libSixGIo.a

QWT3D=$${QINC}/contrib/qwtplot3d
QWT3D_INC=$${QWT3D}
libQWT3D=$${QWT3D}/obj.$${BUILD_TARGET}/lib/libqwtplot3d.a
contains(QI_LIBS, QWT3D) {
  INCLUDEPATH+=$${QWT3D_INC}
}

QWT=$${QINC}/contrib/qwt
QWT_INC=$${QWT}/src
libQWT=$${QWT}/obj.$${BUILD_TARGET}/lib/libqwt.a
contains(QI_LIBS, QWT) {
  INCLUDEPATH+=$${QWT_INC}
}

for(sd, LIB_P) {
  sp=$$files($${sd}/lib*)
  for(l, sp) {
    d=$$dirname(l)
    b=$$basename(l)
    p=$$sprintf("$${d}/%01/obj.$${BUILD_TARGET}/%01.a", $${b})
    eval($${b}=$${p})
    ALL_LIBS+=$${b}
  }
}

macx {
  libColorAnalyzer_extra+=-F$${QINC}/Libs/libColorAnalyzer/Frameworks -framework SipFrame -framework i1d3SDK
}
win32 {
  libColorAnalyzer_extra+=$${QINC}/Libs/libColorAnalyzer/XRite/Win32/i386/SipCal.lib
  libColorAnalyzer_extra+=$${QINC}/Libs/libColorAnalyzer/XRite/Win32/i386/i1d3SDK.lib
}

for(l, QI_LIBS) {
  p=$$eval(lib$${l})
  px=$$eval(lib$${l}_extra)
  LIBS+=$${p} $${px}
  PRE_TARGETDEPS+=$${p}
}
