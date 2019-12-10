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

all clean install objdirs:
	@$(foreach d, ${_SUBDIRS}, echo Building $@ in ${d} && $(MAKE) -C ${d} -I ${QMK} -f ${QMK}/make.qmk QMK=${QMK} $@ &&) echo ok

export:
	$(foreach d, ${EXPORTS-${OEM}}, echo Exporting ${d} for ${OEM} && $(MAKE) -C ${d} -I ${QMK} QMK=${QMK} PREFIX=${PREFIX-${OEM}} install &&) echo ok
