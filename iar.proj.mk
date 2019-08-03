##################################################
## file: //QInc/qmk/iar.proj.mk
##
## (C) Copyright Eric L. Hernes -- Monday, September 15, 2014
##
## Makefile to build something
##

ifeq (${APP},)
APP=$(notdir ${CURDIR})
endif

_QMK?=$(dir $(realpath $(lastword ${MAKEFILE_LIST})))
include ${_QMK}/arch.mk

IARBUILD?=c:/Program Files (x86)/IAR Systems/Embedded Workbench 7.5/common/bin/IarBuild.exe

ifeq ($(shell uname),Darwin)
MAKEFSDATA = cd htdocs_min; perl ${CURDIR}/../../../libs/lwip/apps/libHttpServer/makefsdata/makefsdata
JAVA=java
CP_R=cp -r
CP=cp
RM_RF=rm -rf
RM=rm
CAT=cat
APIGEN=${UKKO}/software/apigen/obj.Darwin/apigen
else
MAKEFSDATA = ${CURDIR}/../../../../software/contrib/makefsdata/obj.Mingw/makefsdata.exe htdocs_min -f:web_fsdata.h
JAVA="c:/Program Files/Java/jre7/bin/java.exe"
JAVA="C:/Program Files/Java/jre1.8.0_31/bin/java.exe"
JAVA=java.exe
CP_R=robocopy
CP=copy /b
FixPath = $(subst /,\,$1)
RM_RF=rmdir /s /q
RM=del
CAT=type
APIGEN=${UKKO}\software\apigen\obj.Mingw\apigen.exe
endif

WEBCOMPRESS?=${CURDIR}/../../../../software/contrib/webcompress
CLOSURE_COMP?=${JAVA} -jar ${WEBCOMPRESS}/compiler.jar
YUI_COMP?=${JAVA} -jar ${WEBCOMPRESS}/yuicompressor-2.4.8.jar
HTML_COMP?=${JAVA} -jar ${WEBCOMPRESS}/htmlcompressor-1.5.3.jar

ifeq (${CONFIG-${APP}},)
CONFIG-${APP}=F4-Devel
endif

ifneq (${CONFIG-${APP}},Library)
ifeq (${CONFIG-${APP}_boot},)
CONFIG-${APP}_boot=F4-Boot-FS
endif
endif

ifeq (${JS_SRC},)
JS_SRC=${APP}.js
endif

all: fsdata
	${IARBUILD} ${APP}.ewp -make ${CONFIG-${APP}}
ifneq (${CONFIG-${APP}_boot},)
	${IARBUILD} ${APP}_boot.ewp -make ${CONFIG-${APP}_boot}
endif

clean:
	${IARBUILD} ${APP}.ewp -clean ${CONFIG-${APP}}
ifneq (${CONFIG-${APP}_boot},)
	${IARBUILD} ${APP}_boot.ewp -clean ${CONFIG-${APP}_boot}
endif

.PHONY: fsdata api cgiapi jsapi

#
# $(call FileIterator, glob,cmd,type)
define FileIterator
$(foreach f, $(wildcard htdocs/${1}), ${2} $(patsubst htdocs%,htdocs_min%,${f}) ${f} &&) echo ${3} done
endef

# doesn't work when we add ${CURDIR}
#define FileIterator1
#$(foreach f, $(wildcard htdocs/${1}), ${2} $(patsubst htdocs%,${CURDIR}/htdocs_min%,${f}) ${CURDIR}/${f} &&) echo ${3} done
#endef
#	${CP_R} $(call FixPath, ${CURDIR}/htdocs/js/zepto.min.js) $(call FixPath,${CURDIR}/htdocs_min/js/)

API_LIB_PATH+=${CURDIR}/../../libs ${CURDIR}/../../../libs
API_FILES=$(foreach a, ${API_LIST}, $(wildcard $(patsubst %,%/lib${a}/${a}.api,${API_LIB_PATH})))

ifneq (${APP_API},)
API_FILES+=${CURDIR}/${APP_API}.api
endif

JS_API=$(patsubst %,%_api.js,${API_LIST} ${APP_API})

ifneq (${API_FILES},)

fsdata: jsapi
	-${RM_RF} htdocs_min
	mkdir htdocs_min
	mkdir htdocs_min\\css
	mkdir htdocs_min\\js
	mkdir htdocs_min\\images
	${CP_R} htdocs\\images htdocs_min\\images /S || echo WTF, ok
	$(call FileIterator,css/*.css,${YUI_COMP} --type css -o,css)
	$(call FileIterator,*.html,${HTML_COMP} --compress-css -t html -o,html)
	$(call FileIterator,js/*.js,${CLOSURE_COMP} --js_output_file,js)
	${MAKEFSDATA}

api:
	$(foreach i,${API_INTERFACE},${APIGEN} -i ${i} ${API_FILES} &&) echo ok

cgiapi:
	${APIGEN} -i fw-cgi-h ${API_FILES}

jsapi:
	${APIGEN} -i js ${API_FILES}
	${CAT} ${JS_API} >htdocs/js/api.js
	${RM} ${JS_API}
else
fsdata::
	echo no api files
endif

copy-to-server: GITV=$(shell git describe --always --dirty)

copy-to-server: 
ifneq (${DIST_DIR},)
	${CP} "obj.app/Exe/${APP}-${GITV}.mcu" "${DIST_DIR}\${DIST_SUBDIR}\"
	${CP} "obj.boot/Exe/${APP}_boot.hex" "${DIST_DIR}\${DIST_SUBDIR}\${APP}_boot-${GITV}.hex"
else
	@echo nothing to copy
endif
