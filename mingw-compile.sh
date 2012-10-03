#! /bin/sh
#
# mingw-compile.sh
#
# Run this script from MSYS window to compile MINGW adsmXml.exe using CYGWIN generated files.

gcc -O2 -Wall -Dstaticlink -DYY_NO_UNISTD_H -DHAVE_CONFIG_H -DinsideElement -DinsidePreprocessor -DinsideVeriloga -I. -IadmsXml admsXml/adms.c admsXml/preprocessorLex.c admsXml/preprocessorMain.c admsXml/preprocessorYacc.c admsXml/verilogaLex.c admsXml/verilogaYacc.c admsXml/admsXml.c admsXml/admstpathYacc.c -o admsXmlWin.exe

cp -f admsXmlWin.exe /bin/admsXml.exe
