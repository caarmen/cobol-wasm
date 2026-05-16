#!/usr/bin/env bash

set -e

deps_dir="deps"
mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit
prefix="${PREFIX_ROOT:-$HOME/.local/cobol-wasm}"
mkdir -p "${prefix}"
prefix="$(realpath "${prefix}")"
emsdk_dir="${prefix}/emsdk"

source "${emsdk_dir}/emsdk_env.sh"

if [ ! -d libdb ]; then
    git clone https://github.com/berkeleydb/libdb.git
fi


pushd libdb/build_unix || exit

emconfigure ../dist/configure \
  --prefix="${prefix}" \
  --disable-tcl \
  --disable-test \
  --enable-sequences \
  --disable-dbm \
  --disable-java \
  --disable-sql \
  --disable-static \
  --disable-cxx \
  --with-mutex=POSIX/pthreads

emmake make
emmake make install
emmake make clean

popd || exit
rm -rf libdb
popd || exit