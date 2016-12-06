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
make check
make install
