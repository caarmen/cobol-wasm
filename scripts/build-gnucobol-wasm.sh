#!/usr/bin/env bash

set -e

project_path="$(pwd)"
gnucobol_version="3.2"
deps_dir="$(realpath "${project_path}/deps")"
mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit
emsdk_dir="emsdk"

for dep in emsdk gmp libdb; do
    if [ ! -d "${dep}" ]; then
        echo "${dep} not present, exiting"
        exit 1
    fi
done

source "${emsdk_dir}/emsdk_env.sh"

if [ ! -d gnucobol-wasm ]; then
    curl "https://ftp.gnu.org/gnu/gnucobol/gnucobol-${gnucobol_version}.tar.gz" --output gnucobol.tar.gz
    tar xzf "gnucobol.tar.gz"
    rm "gnucobol.tar.gz"
    mv "gnucobol-${gnucobol_version}" gnucobol-wasm
fi

# Build libcob
pushd gnucobol-wasm || exit
glibtoolize --force --copy
autoreconf -vfi

emconfigure ./configure \
    --disable-shared \
    --prefix="$(pwd)/install" \
    LDFLAGS="-L${deps_dir}/gmp/.libs -lgmp" \
    LIBS="${deps_dir}/libdb/.libs/libdb-5.3.dylib" \
    CPPFLAGS="-I${deps_dir}/gmp/ -I${deps_dir}/libdb" \
    BDB_LIBS="${deps_dir}/libdb/.libs/libdb-5.3.dylib" \
    BDB_CFLAGS="-I${deps_dir}/libdb" 
     

emmake make SUBDIRS="libcob"

popd || exit
popd || exit