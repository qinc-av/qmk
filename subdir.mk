##################################################
## file: //QInc/Projects/qmk/subdir.mk
##
## (C) Copyright Eric L. Hernes -- Wednesday, January 1, 2014
##
## Makefile to build something
##

_QMK=$(abspath ${QMK})

include ${_QMK}/arch.mk

.PHONY: subdirs ${SUBDIRS}

_SUBDIRS=${SUBDIRS} ${SUBDIRS-${BUILD_HOST}} ${SUBDIRS-${BUILD_TARGET}}

#$(info SUBDIRS is ${_SUBDIRS})
#$(info BUILD_TARGET is ${BUILD_TARGET})
#$(info BUILD_HOST is ${BUILD_HOST})

all clean install:
	$(foreach d, ${_SUBDIRS}, echo Building ${d} && $(MAKE) -C ${d} -I ${QMK}/mk QMK=${_QMK} $@ &&) echo ok

export:
	$(foreach d, ${EXPORTS-${OEM}}, echo Exporting ${d} for ${OEM} && $(MAKE) -C ${d} -I ${QMK}/mk QMK=${_QMK} DESTDIR=${DESTDIR-${OEM}} install &&) echo ok
