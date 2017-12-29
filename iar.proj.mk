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

IARBUILD?=c:/Program Files (x86)/IAR Systems/Embedded Workbench 7.0/common/bin/IarBuild.exe

ifeq ($(shell uname),Darwin)
MAKEFSDATA = cd htdocs_min; perl ${CURDIR}/../../../libs/lwip/apps/libHttpServer/makefsdata/makefsdata
JAVA=java
CP=cp
RM_RF=rm -rf
RM=rm
CAT=cat
APIGEN=${CURDIR}/../../../../software/apigen/obj.Darwin/apigen
else
MAKEFSDATA = ${CURDIR}/../../../../software/contrib/makefsdata/obj.Mingw/makefsdata.exe htdocs_min -f:web_fsdata.h
JAVA="c:/Program Files/Java/jre7/bin/java.exe"
JAVA="C:/Program Files/Java/jre1.8.0_31/bin/java.exe"
JAVA=java.exe
CP=robocopy
FixPath = $(subst /,\,$1)
RM_RF=rmdir /s /q
RM=del
CAT=type
APIGEN=${CURDIR}\..\..\..\..\software\apigen\obj.Mingw\apigen.exe
endif

WEBCOMPRESS?=${CURDIR}/../../../../software/contrib/webcompress
CLOSURE_COMP?=${JAVA} -jar ${WEBCOMPRESS}/compiler.jar
YUI_COMP?=${JAVA} -jar ${WEBCOMPRESS}/yuicompressor-2.4.8.jar
HTML_COMP?=${JAVA} -jar ${WEBCOMPRESS}/htmlcompressor-1.5.3.jar

ifeq (${CONFIG-${APP}},)
CONFIG-${APP}=F4-Debug
endif

ifeq (${CONFIG-${APP}_boot},)
CONFIG-${APP}_boot=DFU-Boot-F4-FS
endif

ifeq (${JS_SRC},)
JS_SRC=${APP}.js
endif

all: fsdata
	${IARBUILD} ${APP}.ewp -make ${CONFIG-${APP}}
	${IARBUILD} ${APP}_boot.ewp -make ${CONFIG-${APP}_boot}

clean:
	${IARBUILD} ${APP}.ewp -clean ${CONFIG-${APP}}
	${IARBUILD} ${APP}_boot.ewp -clean ${CONFIG-${APP}_boot}

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
#	${CP} $(call FixPath, ${CURDIR}/htdocs/js/zepto.min.js) $(call FixPath,${CURDIR}/htdocs_min/js/)

fsdata: jsapi
	-${RM_RF} htdocs_min
	mkdir htdocs_min
	mkdir htdocs_min\\css
	mkdir htdocs_min\\js
	mkdir htdocs_min\\images
	${CP} htdocs\\images htdocs_min\\images /S || echo WTF, ok
	$(call FileIterator,css/*.css,${YUI_COMP} --type css -o,css)
	$(call FileIterator,*.html,${HTML_COMP} --compress-css -t html -o,html)
	$(call FileIterator,js/*.js,${CLOSURE_COMP} --js_output_file,js)
	${MAKEFSDATA}

API_FILES=$(foreach a, ${API_LIST}, ${CURDIR}/../../../libs/lib${a}/${a}.api)
ifneq (${APP_API},)
API_FILES+=${CURDIR}/${APP_API}.api
endif

JS_API=$(patsubst %,%_api.js,${API_LIST} ${APP_API})

ifneq (${API_FILES},)
api:
	$(foreach i,${API_INTERFACE},${APIGEN} -i ${i} ${API_FILES} &&) echo ok

cgiapi:
	${APIGEN} -i fw-cgi-h ${API_FILES}

jsapi:
	${APIGEN} -i js ${API_FILES}
	${CAT} ${JS_API} >htdocs/js/api.js
	${RM} ${JS_API}
endif
