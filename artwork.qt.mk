##################################################
## file: //QInc/Projects/qmk/artwork.qt.mk
##
## (C) Copyright Eric L. Hernes -- Monday, March 7, 2016
##
## Makefile to build something
##

IMAGES= $(foreach sz,${icon_sz},icon_${sz}x${sz}.png icon_${sz}x${sz}@2x.png)

ICON?=${APP}-icon

ICON_FILES=$(patsubst %,${ICONSET}/%,${IMAGES})

ICON_PNG=${ICON}.png
ICONSET=${ICON}.iconset
ICNS=${ICON}.icns
ICO=${ICON}.ico

icon_sz=16 32 128 256 512

all: ${ICNS} ${ICO} ${ARTWORK_PNG}

define IconRule
${ICONSET}/icon_${1}x${1}.png: ${ICON_PNG}
	convert ${ICON_PNG} -scale ${1}x${1} ${ICONSET}/icon_${1}x${1}.png

${ICONSET}/icon_${1}x${1}@2x.png: ${ICON_PNG}
	convert ${ICON_PNG} -scale $$$$((${1}*2))x$$$$((${1}*2)) ${ICONSET}/icon_${1}x${1}@2x.png
endef

$(foreach sz,${icon_sz},$(eval $(call IconRule,${sz})))

${ICONSET}: ${ICON_PNG}
	rm -rf ${ICONSET}
	mkdir ${ICONSET}

${ICNS}: ${ICONSET} ${ICON_FILES}
	iconutil -c icns ${ICONSET}

.SUFFIXES: .png .ico .xcf

.png.ico:
	convert $< -alpha off -resize 256x256 -define icon:auto-resize="256,128,96,64,48,32,16" $@

.xcf.png:
	convert $< -background transparent -layers flatten $@

clean:
	rm -rf ${ICONSET} ${ICO} ${ICNS} ${ICON_PNG} ${ARTWORK_PNG}

