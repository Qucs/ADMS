# !/bin/sh

here=`pwd`
cd `dirname $0`

echo "Bootstrapping the ADMS sources..."

echo "Libtoolizing... "
case `uname` in
  *Darwin*) LIBTOOLIZE=glibtoolize ;;
  *)        LIBTOOLIZE=libtoolize ;;
esac
$LIBTOOLIZE --copy --force

echo "Creating aclocal.m4... "
aclocal -I m4

echo "Creating headers... "
autoheader

echo "Creating Makefiles... "
automake -Wall --copy --add-missing --foreign

echo "Creating configure... "
autoconf

echo "Done!"
exit 0
