AC_PREREQ([2.68])
AC_INIT([libvmod-example], [0.1], [], [vmod-example])
AC_COPYRIGHT([Copyright (c) 2011-2016 Varnish Software AS])
AC_CONFIG_MACRO_DIR([m4])
m4_ifndef([VARNISH_VMOD_INCLUDES], AC_MSG_ERROR([Need varnish.m4 -- see README.rst]))
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_SRCDIR(src/vmod_example.vcc)
AC_CONFIG_HEADER([config.h])

AM_INIT_AUTOMAKE([1.12 -Wall -Werror foreign parallel-tests])
AM_SILENT_RULES([yes])
AM_PROG_AR

LT_PREREQ([2.2.6])
LT_INIT([dlopen disable-static])

AX_PTHREAD(,[AC_MSG_ERROR([Could not configure pthreads support])])

LIBS="$PTHREAD_LIBS $LIBS"
CFLAGS="$CFLAGS $PTHREAD_CFLAGS"
CC="$PTHREAD_CC"


# Check for rst utilities
AC_CHECK_PROGS(RST2MAN, [rst2man rst2man.py], "no")
if test "x$RST2MAN" = "xno"; then
	AC_MSG_ERROR([rst2man not found - cannot build man pages])
fi

# Checks for header files.
AC_CHECK_HEADERS([sys/stdlib.h])

VMOD_TESTS="$(cd $srcdir/src && echo tests/*.vtc)"
AC_SUBST(VMOD_TESTS)

PKG_CHECK_MODULES([libvarnishapi], [varnishapi])
PKG_CHECK_VAR([LIBVARNISHAPI_PREFIX], [varnishapi], [prefix])
PKG_CHECK_VAR([LIBVARNISHAPI_DATAROOTDIR], [varnishapi], [datarootdir])
PKG_CHECK_VAR([LIBVARNISHAPI_BINDIR], [varnishapi], [bindir])
PKG_CHECK_VAR([LIBVARNISHAPI_SBINDIR], [varnishapi], [sbindir])
AC_SUBST([LIBVARNISHAPI_DATAROOTDIR])

# Varnish include files tree
VARNISH_VMOD_INCLUDES
VARNISH_VMOD_DIR
VARNISH_VMODTOOL
# inherit the prefix from Varnish.
# acessing ac_ variable because AC_PREFIX_DEFAULT acts too early
ac_default_prefix=$LIBVARNISHAPI_PREFIX

AC_PATH_PROG([VARNISHTEST], [varnishtest], [], [$LIBVARNISHAPI_BINDIR:$PATH])
AC_PATH_PROG([VARNISHD], [varnishd], [], [$LIBVARNISHAPI_SBINDIR:$PATH])

AC_CONFIG_FILES([
	Makefile
	src/Makefile
])
AC_OUTPUT
