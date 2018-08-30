##################################################
## file: sw.api..mk
##
## generated with apigen - 1.08, 
## (C) Copyright Eric L. Hernes 2018
## (C) Copyright Q, Inc. 2018
##
## Makefile template for api generator
##

# API-cgi-fw += 
# API-cgi-fw-h += 
# API-js += 
# API-jsio-server += 
# API-json-schema += 
# API-rest-host-cpp += 
# API-rest-host-h += 
# API-rest-host-ih += 
# API-serial-fw += 
# API-serial-host += 
# API-usb-fw += 
# API-usb-host += 
# API-uxcgi-server += 
# API-uxcgi-server-h += 

API_GENERATORS := cgi-fw cgi-fw-h js jsio-server json-schema rest-host-cpp rest-host-h rest-host-ih serial-fw serial-host usb-fw usb-host uxcgi-server uxcgi-server-h

API_SUFFIX-cgi-fw := _fcgi.cpp
API_SUFFIX-cgi-fw-h := _fcgi.h
API_SUFFIX-js := _api.js
API_SUFFIX-jsio-server := _jsio-server.cpp
API_SUFFIX-json-schema := .schema.json
API_SUFFIX-rest-host-cpp := _rest.cpp
API_SUFFIX-rest-host-h := _rest.h
API_SUFFIX-rest-host-ih := _rest.h
API_SUFFIX-serial-fw := _serial-fw.cpp
API_SUFFIX-serial-host := _serial-host.cpp
API_SUFFIX-usb-fw := _usb-fw.cpp
API_SUFFIX-usb-host := _usb-host.cpp
API_SUFFIX-uxcgi-server := _uxcgi.cpp
API_SUFFIX-uxcgi-server-h := _uxcgi.h

$(foreach g,${API_GENERATORS},\
	$(if ${API-${g}},\
		$(foreach a,${API-${g}},\
			$(eval API_SRCS+=${API_DIR}/${a}${API_SUFFIX-${g}}))))

$(info API_SRCS:: ${API_SRCS})

${API_DIR}/%_fcgi.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i cgi-fw $<

${API_DIR}/%_fcgi.h : %.api
	 ${APIGEN} -d ${API_DIR} -i cgi-fw-h $<

${API_DIR}/%_api.js : %.api
	 ${APIGEN} -d ${API_DIR} -i js $<

${API_DIR}/%_jsio-server.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i jsio-server $<

${API_DIR}/%.schema.json : %.api
	 ${APIGEN} -d ${API_DIR} -i json-schema $<

${API_DIR}/%_rest.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i rest-host-cpp $<

${API_DIR}/%_rest.h : %.api
	 ${APIGEN} -d ${API_DIR} -i rest-host-h $<

${API_DIR}/%_rest.h : %.api
	 ${APIGEN} -d ${API_DIR} -i rest-host-ih $<

${API_DIR}/%_serial-fw.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i serial-fw $<

${API_DIR}/%_serial-host.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i serial-host $<

${API_DIR}/%_usb-fw.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i usb-fw $<

${API_DIR}/%_usb-host.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i usb-host $<

${API_DIR}/%_uxcgi.cpp : %.api
	 ${APIGEN} -d ${API_DIR} -i uxcgi-server $<

${API_DIR}/%_uxcgi.h : %.api
	 ${APIGEN} -d ${API_DIR} -i uxcgi-server-h $<

