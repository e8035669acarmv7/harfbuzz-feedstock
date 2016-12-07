#!/bin/bash

if [ $(uname) == Darwin ]; then
  export CC=clang
  export CXX=clang++
  export MACOSX_DEPLOYMENT_TARGET="10.9"
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
  export CXXFLAGS="$CXXFLAGS -stdlib=libc++"
  export OPTS=""
elif [[ $(uname) == Linux ]]; then
  export OPTS="--with-gobject"
fi

# We do not need this when building locally. Weird.
autoreconf --force --install

# FIXME: Locally it does have the executable bits,
# but for some reason it does not work on CircleCi :-/
bash configure --prefix=$PREFIX \
               --disable-gtk-doc \
               --enable-static \
               $OPTS

make
# FIXME
# OS X:
# FAIL: test-ot-tag
# Linux (all the tests pass when using the docker image :-/)
# FAIL: check-c-linkage-decls.sh
# FAIL: check-defs.sh
# FAIL: check-header-guards.sh
# FAIL: check-includes.sh
# FAIL: check-libstdc++.sh
# FAIL: check-static-inits.sh
# FAIL: check-symbols.sh
# PASS: test-ot-tag
# make check
make install
