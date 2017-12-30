##################################################
## file: //QInc/qmk/subdir.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to recurse build subdirectories
##

QMK?=$(dir $(realpath $(lastword ${MAKEFILE_LIST})))

include ${QMK}/arch.mk

.PHONY: subdirs ${SUBDIRS}

_SUBDIRS=${SUBDIRS} ${SUBDIRS-${BUILD_HOST}} ${SUBDIRS-${BUILD_TARGET}}

#$(info SUBDIRS is ${_SUBDIRS})
#$(info BUILD_TARGET is ${BUILD_TARGET})
#$(info BUILD_HOST is ${BUILD_HOST})

all clean install objdirs:
	$(foreach d, ${_SUBDIRS}, echo Building ${d} && $(MAKE) -C ${d} -I ${QMK}/mk -f ${QMK}/make.qmk $@ &&) echo ok

export:
	$(foreach d, ${EXPORTS-${OEM}}, echo Exporting ${d} for ${OEM} && $(MAKE) -C ${d} -I ${QMK}/mk QMK=${_QMK} PREFIX=${PREFIX-${OEM}} install &&) echo ok
