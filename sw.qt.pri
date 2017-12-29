win32 {
    CONFIG -= debug_and_release
    CONFIG -= debug
    CONFIG += release
    BUILD_TARGET=Mingw
    PKG_CONFIG=i686-w64-mingw32.static-pkg-config
}

macx {
    QMAKE_MACOSX_DEPLOYMENT_TARGET=10.13
    BUILD_TARGET=Darwin
    PKG_CONFIG=pkg-config
}

defined (VERSION) {
    QMAKE_CFLAGS += -DSW_VERSION=\\\"r$$VERSION\\\"
    QMAKE_CXXFLAGS += -DSW_VERSION=\\\"r$$VERSION\\\"
}

isEmpty(UKKO) UKKO=$$(HOME)/work/QInc/Ukko
isEmpty(AVPGH) AVPGH=$$(HOME)/work/QInc/AVProGH
INCLUDEPATH += $${QINC}/software/libs
LIB_P+=$${QINC}/software/libs $${QINC}/contrib $${UKKO}/software $${UKKO}/software/contrib $${AVPGH}/software

PRISMA_SDK=$${QINC}/software/libs/prisma-sdk
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
    !isEmpty(QMK_DEBUG) {
	message(scanning $${sd} for libs)
    }
    sp=$$files($${sd}/lib*)
    for(l, sp) {
	d=$$dirname(l)
	b=$$basename(l)
	p=$$sprintf("$${d}/%01/obj.$${BUILD_TARGET}/%01.a", $${b})
	!isEmpty(QMK_DEBUG) {
	    message(  found $${b} => $${p})
	}
	eval($${b}=$${p})
	ALL_LIBS+=$${b}
    }
}

macx {
    libColorAnalyzer_extra+=-F$${QINC}/software/libs/libColorAnalyzer/Frameworks -framework SipFrame -framework i1d3SDK
}
win32 {
    libColorAnalyzer_extra+=$${QINC}/software/libs/libColorAnalyzer/XRite/Win32/i386/SipCal.lib
    libColorAnalyzer_extra+=$${QINC}/software/libs/libColorAnalyzer/XRite/Win32/i386/i1d3SDK.lib
}

for(l, QI_LIBS) {
    p=$$eval(lib$${l})
    isEmpty(p) {
	error(could not find library for $${l} ($${p}) )
    }
    px=$$eval(lib$${l}_extra)
    LIBS+=$${p} $${px}
    PRE_TARGETDEPS+=$${p}
}

#  Local Variables:
#  mode: qmake
#  mode: font-lock
#  c-basic-offset: 2
#  tab-width: 8
#  End:
