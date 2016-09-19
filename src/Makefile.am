AM_CFLAGS = $(VARNISHAPI_CFLAGS) -Wall -Werror
AM_LDFLAGS = $(VARNISHAPI_LIBS) $(VMOD_LDFLAGS) $(CODE_COVERAGE_LDFLAGS)

vmod_LTLIBRARIES = libvmod_example.la

libvmod_example_la_SOURCES = \
	vmod_example.c

nodist_libvmod_example_la_SOURCES = \
	vcc_example_if.c \
	vcc_example_if.h

dist_man_MANS = vmod_example.3

@BUILD_VMOD_EXAMPLE@

AM_TESTS_ENVIRONMENT = \
	PATH="$(VMOD_TEST_PATH)" \
	LD_LIBRARY_PATH="$(VARNISH_LIBRARY_PATH)"
TEST_EXTENSIONS = .vtc
VTC_LOG_COMPILER = varnishtest -v
AM_VTC_LOG_FLAGS = -Dvmod_example="$(VMOD_EXAMPLE)"

TESTS = @VMOD_TESTS@

EXTRA_DIST = \
	vmod_example.vcc \
	$(VMOD_TESTS)
