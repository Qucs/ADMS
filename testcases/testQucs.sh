#!/bin/bash

###
# This script runs admsXml with files present in the Qucs project.
###

#
# Request admsXml as argument
#
if [ -z "$1" ]
then
  echo "  Missing path to admsXml executable."
  echo "  Example: $ sh testQucs.sh /usr/local/admsXml"
  exit 1
else
  ADMSXML=$1
  echo "  Running admsXml for Qucs"
  echo "  Using: $ADMSXML"
fi

#
# Clone Qucs sources.
#
if [ ! -d "qucs" ]
then
 git clone --depth=1 --branch=master https://github.com/Qucs/qucs.git qucs
fi

cd qucs/qucs-core/src/components/verilog

#
# List of XML scripts (order matters)
#
arrayXML=(analogfunction.xml
          qucsVersion.xml
          qucsMODULEdefs.xml
          qucsMODULEguiJSONsymbol.xml
          qucsMODULEcore.xml
          qucsMODULEgui.xml)

#
# Turn list of scripts in a command: "-e script1 [-e script2]"
#
XML=""
for script in "${arrayXML[@]}"
do
  XML=$XML" -e $script"
done

#
# Process each Verilog-A file.
#
arrayVA=($(ls *.va))
for VA in "${arrayVA[@]}"
do
  cmd="$ADMSXML $XML $VA"
  echo "---"
  echo "$cmd"

  # Run
  $cmd

  # Stop on error
  if [[ $? -ne 0 ]] ; then
    exit 1
  fi
done

