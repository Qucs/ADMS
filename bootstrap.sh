# !/bin/sh

echo "bootstrapping the ADMS sources..."
echo "Creating aclocal.m4... "
aclocal -I m4
echo "Creating headers... "
autoheader
echo "Creating configure... "
autoconf
echo "Creating Makefiles... "
automake --copy --add-missing --foreign
echo "done."

