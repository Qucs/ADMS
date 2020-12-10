#
# Request admsXml as argument
#
if [ -z "$1" ]
then
  echo "  Missing path to admsXml executable."
  echo "  Example: $ sh testADMS.sh /usr/local/admsXml"
  exit 1
else
  ADMSXML=$1
  echo "  Testing admsXml"
  echo "  Using: $ADMSXML"
fi

#
# list of all the tests to be run
#
arrayTest=(
           0000_scale_factor
           0001_operator
           0002_transition
           0003_subdev)

#
# run admsXml and check output against reference
#
for test in "${arrayTest[@]}"
do
  $ADMSXML $test.va -e $test.xml > /dev/null
  cmp $test.ref .$test.va.adms
done

rm discipline.h .*.va.adms .adms.implicit.xml .interface.xml
