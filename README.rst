============
vmod-example
============

notice
------

For new developments, we recommend to consider using
https://github.com/Dridi/vcdk

SYNOPSIS
========

import example;

DESCRIPTION
===========

Example Varnish vmod demonstrating how to write an out-of-tree Varnish vmod.

Implements the traditional Hello World as a vmod.

FUNCTIONS
=========

hello
-----

Prototype
        ::

                hello(STRING S)
Return value
	STRING
Description
	Returns "Hello, " prepended to S
Example
        ::

                set resp.http.hello = example.hello("World");

INSTALLATION
============

Installation will require:

- `cmake`
- `make`, `ninja` or another build system
- `clang`, `gcc` or another C compiler

The source tree is based on `cmake` to configure the building, and
does also have the necessary bits in place to do functional unit tests
using the ``varnishtest`` tool.

Building requires the Varnish header files and uses pkg-config to find
the necessary paths.

Usage::

 mkdir build
 cmake -S . -B build 

If you have installed Varnish to a non-standard directory, export
``PKG_CONFIG_PATH`` pointing to the appropriate path before calling `cmake`.
For instance, when varnishd configure was called with ``--prefix=$PREFIX``, use

::

 export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig

Make targets:

* `make -C build` - builds the vmod.
* `make -C build install` - installs your vmod.
* `make -C build test` - runs the unit tests in ``tests/*.vtc``.

You can install your vmod under a specific prefix by adding `DESTDIR` to
the `make` command line.

USAGE
=====

In your VCL you could then use this vmod along the following lines::

        import example;

        sub vcl_deliver {
                # This sets resp.http.hello to "Hello, World"
                set resp.http.hello = example.hello("World");
        }

COMMON PROBLEMS
===============

* configure: error: Need varnish.m4 -- see README.rst

  Check whether ``PKG_CONFIG_PATH`` and ``ACLOCAL_PATH`` were set correctly
  before calling ``autogen.sh`` and ``configure``

* Incompatibilities with different Varnish Cache versions

  Make sure you build this vmod against its correspondent Varnish Cache version.
  For instance, to build against Varnish Cache 4.1, this vmod must be built from
  branch 4.1.

START YOUR OWN VMOD
===================

The basic steps to start a new vmod from this example are::

  name=myvmod
  git clone libvmod-example libvmod-$name
  cd libvmod-$name
  ./rename-vmod-script $name

and follow the instructions output by rename-vmod-script

.. image:: https://circleci.com/gh/varnishcache/libvmod-example/tree/master.svg?style=svg
    :target: https://app.circleci.com/pipelines/github/varnishcache/libvmod-example?branch=master
