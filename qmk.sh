#!/bin/sh
QMK=${QMK:-$(dirname $(realpath ${0}))}
make -f ${QMK}/srcdir.mk $@

