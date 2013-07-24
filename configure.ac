#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT([adms],[2.3.0],[r29173@users.sourceforge.net])
AC_CONFIG_HEADER([config.h])

# specific configuration.
AC_CONFIG_AUX_DIR([auxconf])
AC_CONFIG_MACRO_DIR([m4])

# Checks for programs.
AC_PROG_CXX
AC_PROG_AWK
AC_PROG_YACC
AC_PROG_CC
AC_PROG_CPP
AC_PROG_LEX
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
LT_INIT

# Automake Initialisation.
AM_INIT_AUTOMAKE

AX_PROG_FLEX([],[AC_MSG_WARN(Program flex not found (found $LEX))
                 AC_MSG_ERROR(Please install gnu flex from http://www.gnu.org/software/flex/)])
AX_PROG_BISON([],[AC_MSG_WARN(Program bison not found (found $YACC))
                  AC_MSG_ERROR(Please install gnu bison from http://www.gnu.org/software/bison/)])


#advice use of gcc
AX_COMPILER_VENDOR
if test "x$ax_cv_c_compiler_vendor" != "xgnu"; then
  AC_MSG_WARN(Seems that the selected C-compiler is not gnu gcc C-compiler)
  AC_MSG_WARN(We advice you to use gcc as C-compiler)
  AC_MSG_WARN(You can install it from http://www.gnu.org/software/gcc/)
fi

AX_CFLAGS_WARN_ALL

# Checks for libraries.
# FIXME: Replace `main' with a function in `-lm':
AC_CHECK_LIB([m], [pow])

# Checks for header files.
AC_FUNC_ALLOCA
AC_HEADER_STDC
AC_CHECK_HEADERS([float.h inttypes.h libintl.h locale.h malloc.h stddef.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT8_T
AC_TYPE_SIZE_T
AC_STRUCT_TM
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_FUNC_STAT
AC_FUNC_STRFTIME
AC_FUNC_STRTOD
AC_CHECK_FUNCS([floor memset putenv setenv strdup strstr strtol])

# Libtool initialisation.
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL
AC_SUBST([LIBTOOL_DEPS])

dnl perl and libXML
AC_PATH_PROG(PERL, perl, :)
if test "$PERL" = ":"; then
    AC_MSG_ERROR([The $PACKAGE package requires an installed perl.])
fi;

AX_PERL_MODULE_VERSION([XML::LibXML 0],[],[
    AC_MSG_RESULT(failed)
    AC_MSG_ERROR([Perl package XML::LibXML may be downloaded from http://search.cpan.org/dist/libXML])])
AX_PERL_MODULE_VERSION([GD 0],[],[
    AC_MSG_ERROR([Perl package GD:: may be downloaded from http://search.cpan.org/dist/GD])])

AC_CONFIG_FILES([Makefile
                 admsXml/Makefile
                 images/Makefile
                 scripts/Makefile])
AC_OUTPUT
