AC_PREREQ([2.68])
AC_INIT([libvmod-example], [0.1], [], [vmod-example])
AC_COPYRIGHT([Copyright (c) 2011-2016 Varnish Software AS])
AC_CONFIG_MACRO_DIR([m4])
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

m4_ifndef([VARNISH_PREREQ], AC_MSG_ERROR([Need varnish.m4 -- see README.rst]))

VARNISH_PREREQ([4.1.3])
VARNISH_VMODS([example])

VMOD_TESTS="$(cd $srcdir/src && echo tests/*.vtc)"
AC_SUBST(VMOD_TESTS)

PKG_CHECK_VAR([LIBVARNISHAPI_LIBDIR], [varnishapi], [libdir])
AC_SUBST([VARNISH_LIBRARY_PATH],
	[$LIBVARNISHAPI_LIBDIR:$LIBVARNISHAPI_LIBDIR/varnish])

AC_CONFIG_FILES([
	Makefile
	src/Makefile
])
AC_OUTPUT
