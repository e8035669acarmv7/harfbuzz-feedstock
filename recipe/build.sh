#!/bin/bash

set -e

if [ $(uname) == Darwin ]; then
  export CC=clang
  export CXX=clang++
  export MACOSX_DEPLOYMENT_TARGET="10.9"
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
fi

# CircleCI seems to have some weird issue with harfbuzz tarballs. The files
# come out with modification times such that the build scripts want to rerun
# automake, etc.; we need to run it ourselves since we don't have the precise
# version that the build scripts embed. And the 'configure' script comes out
# without its execute bit set. In a Docker container running locally, these
# problems don't occur.

autoreconf --force --install
chmod +x configure

./configure --prefix=$PREFIX \
            --disable-gtk-doc \
            --enable-static \
            --with-graphite2=yes \
            --with-gobject=yes

make
make check
make install

pushd $PREFIX
rm -rf share/gtk-doc
popd
