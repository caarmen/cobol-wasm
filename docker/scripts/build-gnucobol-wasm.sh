#!/usr/bin/env bash

set -e

project_path="$(pwd)"
gnucobol_version="3.2"
deps_dir="$(realpath "${project_path}/deps")"
mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit
emsdk_dir="emsdk"

source "${emsdk_dir}/emsdk_env.sh"

if [ ! -d gnucobol-wasm ]; then
    curl "https://ftp.gnu.org/gnu/gnucobol/gnucobol-${gnucobol_version}.tar.gz" --output gnucobol.tar.gz
    tar xzf "gnucobol.tar.gz"
    rm "gnucobol.tar.gz"
    mv "gnucobol-${gnucobol_version}" gnucobol-wasm
fi

# Build libcob
prefix_root="${PREFIX_ROOT:-/opt}"
mkdir -p "${prefix_root}"
prefix_root="$(realpath "${prefix_root}")"

pushd gnucobol-wasm || exit
aclocal
automake

BDB_LIBS_DIR="${prefix_root}/lib/"
if [[ -f "${BDB_LIBS_DIR}/libdb-5.3.dylib" ]]; then
  BDB_LIB="${BDB_LIBS_DIR}/libdb-5.3.dylib"
else
  BDB_LIB="${BDB_LIBS_DIR}/libdb-5.3.so"
fi

emconfigure ./configure \
    --disable-shared \
    --prefix="${prefix_root}/gnucobol-wasm" \
    LDFLAGS="-L${prefix_root}/lib -lgmp" \
    LIBS="${BDB_LIB}" \
    CPPFLAGS="-I${prefix_root}/include/" \
    BDB_LIBS="${BDB_LIB}" \
    BDB_CFLAGS="-I${prefix_root}/include"
     

emmake make SUBDIRS="libcob"
emmake make install SUBDIRS="libcob"
emmake make clean SUBDIRS="libcob"

popd || exit
rm -rf gnucobol-wasm
popd || exit