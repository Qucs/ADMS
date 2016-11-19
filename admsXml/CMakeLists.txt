# This file is part of adms - http://sourceforge.net/projects/mot-adms.
#
# adms is a code generator for the Verilog-AMS language.
#
# Copyright (C) 2014-2015 Guilherme Brondani Torri <guitorri@gmail.com>
#               2014 Luther T. Cat <lutherthecat@github>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

INCLUDE_DIRECTORIES( ${CMAKE_BINARY_DIR} ) # for config.h
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR} ) # for admsPreprocessor.h, amdsVeriloga.h
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_BINARY_DIR} ) # for generated source code

# Maintainer mode runs the Perl scrips that generate source code
if ( USE_MAINTAINER_MODE )

  # Run mkelements.pl
  #   Read in `adms.xml` and generete portions of adms and admst
  # Generate outputs:
  #    adms.h
  #    adms.c
  #    admstpathYacc.y
  #    admstpathYacc.h
  #    admstpath.dtd
  MESSAGE(STATUS "Running mkelements.pl code generator")

  EXECUTE_PROCESS(
    COMMAND perl ${CMAKE_SOURCE_DIR}/admsXml/mkelements.pl ${CMAKE_SOURCE_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
          RESULT_VARIABLE element_result )

  IF(element_result EQUAL 0)
    MESSAGE(STATUS "mkelement.pl completed successfully")
  ELSE(element_result EQUAL 0)
    MESSAGE(FATAL_ERROR "mkelement.pl failed. Exit code: ${element_result}")
  ENDIF(element_result EQUAL 0)


  # Run mkctext.pl
  #   Wrap source files as C code
  # Generate outputs:
  #    constants.vams.c
  #    disciplines.vams.c
  #    adms.implicit.xml.c
  #    dummy.va.c
  #    dummy.xml.c
  SET(CTEXT
    constants.vams
    disciplines.vams
    adms.implicit.xml
    dummy.va
    dummy.xml )

  FOREACH( inc ${CTEXT} )
    MESSAGE(STATUS "Running mkctext.pl code generator on ${inc}")

    EXECUTE_PROCESS(
      COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/mkctext.pl ${CMAKE_CURRENT_SOURCE_DIR}/${inc}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      RESULT_VARIABLE text_result )

    IF(text_result EQUAL 0)
      MESSAGE(STATUS "mkctext.pl completed successfully")
    ELSE(text_result EQUAL 0)
      MESSAGE(FATAL_ERROR "mkctext.pl failed. Exit code: ${text_result}")
    ENDIF(text_result EQUAL 0)
  ENDFOREACH()


  # Run mkgrammar.pl
  #   Process verilogaYacc.y.in and generate the parser
  # Generate output:
  #    verilogaYacc.y
  #
  MESSAGE(STATUS "Running mkgrammar.pl code generator")

  EXECUTE_PROCESS(
    COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/mkgrammar.pl ${CMAKE_CURRENT_SOURCE_DIR}/verilogaYacc.y.in
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
          RESULT_VARIABLE grammar_result )

  IF(grammar_result EQUAL 0)
    MESSAGE(STATUS "mkgrammar.pl completed successfully")
  ELSE(grammar_result EQUAL 0)
    MESSAGE(FATAL_ERROR "mkgrammar.pl failed. Exit code: ${grammar_result}")
  ENDIF(grammar_result EQUAL 0)

ENDIF ( USE_MAINTAINER_MODE )

# Issue with flex:
#   BISON_TARGET, FLEX_TARGET and ADD_FLEX_BISON_DEPENDENCY
#   Does not seem to overide the '%option outfile' or the location with -o option.
# Solution: use custom command and set the working directory.

#
# -= admsElement =-
#
ADD_LIBRARY(admsElement ${CMAKE_CURRENT_BINARY_DIR}/adms.c)
SET_TARGET_PROPERTIES(admsElement PROPERTIES COMPILE_DEFINITIONS insideElement)

#
# -= admsPreprocessor =-
#
SET(BisonOutput
  ${CMAKE_CURRENT_BINARY_DIR}/preprocessorYacc.h
  ${CMAKE_CURRENT_BINARY_DIR}/preprocessorYacc.c )
ADD_CUSTOM_COMMAND(
  OUTPUT ${BisonOutput}
  COMMAND ${BISON_EXECUTABLE}
  ARGS -by -opreprocessorYacc.c ${CMAKE_CURRENT_SOURCE_DIR}/preprocessorYacc.y
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )

SET(FlexOutput
  ${CMAKE_CURRENT_BINARY_DIR}/preprocessorLex.h
  ${CMAKE_CURRENT_BINARY_DIR}/preprocessorLex.c )
ADD_CUSTOM_COMMAND(
  OUTPUT ${FlexOutput}
  COMMAND ${FLEX_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/preprocessorLex.l
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )


ADD_LIBRARY(admsPreprocessor
  preprocessorMain.c
  ${BisonOutput}
  ${FlexOutput} )

SET_TARGET_PROPERTIES(admsPreprocessor PROPERTIES COMPILE_DEFINITIONS insidePreprocessor)

#
# -= admsVeriloga =-
#
SET(BisonOutput
  ${CMAKE_CURRENT_BINARY_DIR}/verilogaYacc.h
  ${CMAKE_CURRENT_BINARY_DIR}/verilogaYacc.c )
ADD_CUSTOM_COMMAND(
  OUTPUT ${BisonOutput}
  COMMAND ${BISON_EXECUTABLE}
  ARGS -by -overilogaYacc.c ${CMAKE_CURRENT_BINARY_DIR}/verilogaYacc.y
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )

SET(FlexOutput
  ${CMAKE_CURRENT_BINARY_DIR}/verilogaLex.h
  ${CMAKE_CURRENT_BINARY_DIR}/verilogaLex.c )
ADD_CUSTOM_COMMAND(
  OUTPUT ${FlexOutput}
  COMMAND ${FLEX_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/verilogaLex.l
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )

ADD_LIBRARY(admsVeriloga ${BisonOutput} ${FlexOutput} )

SET_TARGET_PROPERTIES(admsVeriloga PROPERTIES COMPILE_DEFINITIONS insideVeriloga)

#
# -= admsAdmstpath =-
#
SET(BisonOutput
	${CMAKE_CURRENT_BINARY_DIR}/admstpathYacc.c )
ADD_CUSTOM_COMMAND(
  OUTPUT ${BisonOutput}
  COMMAND ${BISON_EXECUTABLE}
  ARGS -by -oadmstpathYacc.c ${CMAKE_CURRENT_BINARY_DIR}/admstpathYacc.y
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )

# admstpathYacc.h is generated by mkelement.pl
ADD_LIBRARY(admsAdmstpath ${BisonOutput} ${CMAKE_CURRENT_BINARY_DIR}/admstpathYacc.h )
SET_TARGET_PROPERTIES(admsAdmstpath PROPERTIES COMPILE_DEFINITIONS insideadmstpathYacc)

#
# -= admsXml =-
#
ADD_EXECUTABLE(admsXml admsXml.c)
TARGET_LINK_LIBRARIES(admsXml admsElement admsVeriloga admsAdmstpath admsPreprocessor -lm)

#
# -= admsCheck =-
#
ADD_EXECUTABLE(admsCheck admsCheck.c)
TARGET_LINK_LIBRARIES(admsCheck admsElement)

#
# Handle installation
#
INSTALL(TARGETS admsXml DESTINATION bin)
INSTALL(FILES admsXml.1 DESTINATION share/man/man1)

INSTALL(TARGETS admsCheck DESTINATION bin)
INSTALL(FILES admsCheck.1 DESTINATION share/man/man1)

INSTALL(FILES constants.vams disciplines.vams DESTINATION include/adms)

