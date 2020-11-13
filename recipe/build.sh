#!/bin/bash

set -ex

# necessary to ensure the gobject-introspection-1.0 pkg-config file gets found
# meson needs this to determine where the g-ir-scanner script is located
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig
export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  MESON_ARGS="${MESON_ARGS} -Dintrospection=disabled"
else
  MESON_ARGS="${MESON_ARGS} -Dintrospection=enabled"
fi

meson setup builddir \
        ${MESON_ARGS} \
	--buildtype=release \
	--default-library=both \
	--prefix=$PREFIX \
	-Dlibdir=lib \
	-Dglib=enabled \
	-Dgobject=enabled \
	-Dcairo=enabled \
	-Dfontconfig=enabled \
	-Dicu=enabled \
	-Dgraphite=enabled \
	-Dfreetype=enabled \
	-Dgdi=auto \
	-Dcoretext=auto \
	-Dtests=disabled \
	-Ddocs=disabled \
	-Dbenchmark=disabled
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}


pushd $PREFIX
rm -rf share/gtk-doc
popd
