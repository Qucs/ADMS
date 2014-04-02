PROJECT(ADMS)
cmake_minimum_required(VERSION 2.8)

find_package(BISON)

# handle api.prefix, unused for the moment
MESSAGE("BISON_VERSION ${BISON_VERSION}")
IF (${BISON_VERSION} VERSION_LESS "2.6")
  SET (BISON_APIPREFIX "-p")
ELSE (${BISON_VERSION} VERSION_LESS "2.6")
  SET (BISON_APIPREFIX "-Dapi.prefix=")
ENDIF (${BISON_VERSION} VERSION_LESS "2.6")

find_package(FLEX)
ADD_SUBDIRECTORY(admsXml)

