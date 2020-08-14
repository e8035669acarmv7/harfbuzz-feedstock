#!/bin/bash

set -ex

# necessary to ensure the gobject-introspection-1.0 pkg-config file gets found
# meson needs this to determine where the g-ir-scanner script is located
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig

meson setup builddir \
	--buildtype=release \
	--default-library=both \
	--prefix=$PREFIX \
	--libdir=lib \
	-Dglib=enabled \
	-Dgobject=enabled \
	-Dcairo=enabled \
	-Dfontconfig=enabled \
	-Dicu=enabled \
	-Dgraphite=enabled \
	-Dfreetype=enabled \
	-Dgdi=auto \
	-Dcoretext=auto \
	-Dintrospection=enabled \
	-Dtests=disabled \
	-Ddocs=disabled \
	-Dbenchmark=disabled
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}


pushd $PREFIX
rm -rf share/gtk-doc
popd
