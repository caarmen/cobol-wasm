#!/usr/bin/env bash

set -e

gmp_version="6.3.0"
deps_dir="deps"

mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit
emsdk_dir="emsdk"

if [ ! -d "${emsdk_dir}" ]; then
    echo "emsdk not present, exiting"
    exit 1
fi

source "${emsdk_dir}/emsdk_env.sh"

# Get gmp sources
if [ ! -d gmp ]; then
    curl "https://ftp.gnu.org/gnu/gmp/gmp-${gmp_version}.tar.gz" --output gmp.tar.gz
    tar xzf "gmp.tar.gz"
    rm "gmp.tar.gz"
    mv "gmp-${gmp_version}" gmp
fi

prefix="${PREFIX_ROOT:-/opt}"
mkdir -p "${prefix}"
prefix="$(realpath "${prefix}")"

pushd gmp || exit

${LIBTOOLIZE:-libtoolize} --force --copy
autoreconf -vfi
emconfigure ./configure \
  --prefix="${prefix}" \
  --host=wasm32-unknown-emscripten \
  --disable-shared \
  --disable-assembly \
  CC_FOR_BUILD=clang \
  HOST_CC=clang

emmake make
emmake make install
emmake make clean


popd || exit
popd || exit
