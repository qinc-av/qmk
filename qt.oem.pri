################################################################################
## Should be template material below here
##

win32 {
  BUILD_TARGET=Mingw
  CONFIG -= debug_and_release
  CONFIG -= debug
  CONFIG += release
  PKG_CONFIG=i686-w64-mingw32.static-pkg-config

  libColorAnalyzer_extra+=$${QCORE}/software/Libs/libColorAnalyzer/XRite/Win32/i386/SipCal.lib
  libColorAnalyzer_extra+=$${QCORE}/software/Libs/libColorAnalyzer/XRite/Win32/i386/i1d3SDK.lib
}

macx {
  BUILD_TARGET=Darwin
#  QMAKE_MACOSX_DEPLOYMENT_TARGET=10.10
  PKG_CONFIG=pkg-config

  libColorAnalyzer_extra+=-F$${QCORE}/software/Libs/libColorAnalyzer/Frameworks -framework SipFrame -framework i1d3SDK
}

INCLUDEPATH+=$${OEM}/QInc/include $${LIB_P}

defined (VERSION) {
  QMAKE_CFLAGS += -DSW_VERSION=\\\"r$$VERSION\\\"
  QMAKE_CXXFLAGS += -DSW_VERSION=\\\"r$$VERSION\\\"
}
!defined (XLIB_P) {
  XLIB_P=$${OEM}/QInc/include
}

for(sd, LIB_P) {
  sp=$$files($${sd}/lib*)
  for(l, sp) {
    d=$$dirname(l)
    b=$$basename(l)
    p=$$sprintf("$${d}/%01/obj.$${BUILD_TARGET}/%01.a", $${b})
    eval($${b}=$${p})
  }
}

for(sd, XLIB_P) {
  sp=$$files($${sd}/lib*)
  for(l, sp) {
    d1=$$dirname(l)
    d=$$dirname(d1)
    b=$$basename(l)
    p=$$sprintf("$${d}/lib/obj.$${BUILD_TARGET}/%01.a", $${b})
    eval($${b}=$${p})
  }
}

for(l, X_LIBS) {
  p=$$eval(lib$${l})
  px=$$eval(lib$${l}_extra)
  LIBS+=$${p} $${px}
  PRE_TARGETDEPS+=$${p}
}
