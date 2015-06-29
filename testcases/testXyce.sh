#!/bin/bash

###
# This script runs admsXml with files present in the Xyce project.
#
#  - Run this script from the directory ~/git/ADMS/testcases/
###

#
# Request admsXml as argument
#
if [ -z "$1" ]
then
  echo "  Missing path to admsXml executable."
  echo "  Example: $ sh testXyce.sh /usr/local/admsXml"
  exit 1
else
  ADMSXML=$1
  echo "  Running admsXml for Xyce"
  echo "  Using: $ADMSXML"
fi

#
# Get Xyce sources.
#
if [ ! -d "Xyce-6.2" ]
then
 echo ""
 echo "Please download and extract the Xyce sources"
 echo "from https://xyce.sandia.gov/index.html"
 exit
fi

testDir=`pwd`

#
# Boostrap Verilog-A files customized to Xyce.
#
cd Xyce-6.2/
sh utils/generate_ADMS.sh

#
# List of XML scripts (order matters)
#
arrayXML=(xyceBasicTemplates.xml
          xyceVersion.xml
          xyceHeaderFile.xml
          xyceImplementationFile.xml)

#
# Turn list of scripts in a command: "-e script1 [-e script2]"
#
XML=""
for script in "${arrayXML[@]}"
do
  XML=$XML" -e $testDir/Xyce-6.2/utils/ADMS/$script"
done

#
# Process each Verilog-A file.
#
cd $testDir

cd Xyce-6.2
topDir=`pwd`

arrayVA=($(find . -name *.va))
for VA in "${arrayVA[@]}"
do
  echo "---"

  dir=`dirname $VA`
  file=`basename $VA`

  # skip
  # - bsimcmg* :included in another file. Complain of missint `attr
  # - fbhhbt   :fails with missing absdelay
  if [ "$file" == "bsimcmg_main.va" ] ||
     [ "$file" == "bsimcmg_nqsmod3.va" ] ||
     [ "$file" == "fbhhbt-2.1.va" ]
  then
    echo "Skip $file"
    continue
  fi

  # jump in
  cd $dir
  echo `pwd`

  cmd="$ADMSXML $XML $file"
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

