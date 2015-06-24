#!/bin/bash

###
# This script runs admsXml with files present in the Ngspice project.
###

#
# Request admsXml as argument
if [ -z "$1" ]
then
  echo "  Missing path to admsXml executable."
  echo "  Example: $ sh testNgspice.sh /usr/local/admsXml"
  exit 1
else
  ADMSXML=$1
  echo "  Running admsXml for Ngspice"
  echo "  Using: $ADMSXML"
fi

#
# Clone Ngspice sources.
#
if [ ! -d "ngspice" ]
then
 git clone --depth=1 --branch=master http://git.code.sf.net/p/ngspice/ngspice ngspice
fi


#
#
# List of XML scripts (order matters)
#
arrayXML=(ngspiceVersion.xml
          ngspiceMODULEitf.h.xml
          ngspiceMODULEinit.c.xml
          ngspiceMODULEinit.h.xml
          ngspiceMODULEext.h.xml
          ngspiceMODULEdefs.h.xml
          ngspiceMODULEask.c.xml
          ngspiceMODULEmask.c.xml
          ngspiceMODULEpar.c.xml
          ngspiceMODULEmpar.c.xml
          ngspiceMODULEload.c.xml
          ngspiceMODULEacld.c.xml
          ngspiceMODULEpzld.c.xml
          ngspiceMODULEtemp.c.xml
          ngspiceMODULEtrunc.c.xml
          ngspiceMODULEsetup.c.xml
          ngspiceMODULEdel.c.xml
          ngspiceMODULEmdel.c.xml
          ngspiceMODULEdest.c.xml
          ngspiceMODULEnoise.c.xml
          ngspiceMODULEguesstopology.c.xml
          ngspiceMODULE.hxx.xml
          ngspiceMODULE.c.xml)


#
# Turn list of scripts in a command: "-e script1 [-e script2]"
#
XML=""
for script in "${arrayXML[@]}"
do
  XML=$XML" -e ../../admst/$script"
done

#
# Process each Verilog-A file.
#

cd ngspice

topDir=`pwd`

arrayVA=($(find . -name '*.va'))
for VA in "${arrayVA[@]}"
do

  dir=`dirname $VA`
  file=`basename $VA`

  # jump in
  cd $dir

  cmd="$ADMSXML $XML $file"
  echo "---"
  echo "$cmd"

  # Run
  $cmd

  # Stop on error
  if [[ $? -ne 0 ]] ; then
    exit 1
  fi

  # jump out
  cd $topDir
done

