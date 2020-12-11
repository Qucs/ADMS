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

# todo
srcdir=.
#
# run admsXml and check output against reference
#
for test in "${arrayTest[@]}"
do
  $ADMSXML ${srcdir}/$test.va -e ${srcdir}/$test.xml
  cmp ${srcdir}/out/.$test.va.adms .$test.va.adms
done
