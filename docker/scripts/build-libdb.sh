#!/usr/bin/env bash

set -e

deps_dir="deps"
mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit
emsdk_dir="emsdk"

if [ ! -d "${emsdk_dir}" ]; then
    echo "emsdk not present, exiting"
    exit 1
fi

source "${emsdk_dir}/emsdk_env.sh"

if [ ! -d libdb ]; then
    git clone https://github.com/berkeleydb/libdb.git
fi

pushd libdb/build_unix || exit

emconfigure ../dist/configure \
  --prefix=$(pwd)/install \
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

popd || exit
popd || exit