#!/usr/bin/env bash

set -e

project_path="$(pwd)"
gnucobol_version="3.2"
deps_dir="$(realpath "${project_path}/deps")"
mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit
emsdk_dir="emsdk"

source "${emsdk_dir}/emsdk_env.sh"

if [ ! -d gnucobol ]; then
    curl "https://ftp.gnu.org/gnu/gnucobol/gnucobol-${gnucobol_version}.tar.gz" --output gnucobol.tar.gz
    tar xzf "gnucobol.tar.gz"
    rm "gnucobol.tar.gz"
    mv "gnucobol-${gnucobol_version}" gnucobol
fi

# Build cobc
prefix_root="${PREFIX_ROOT:-$HOME/.local/cobol-wasm}"
mkdir -p "${prefix_root}"
prefix_root="$(realpath "${prefix_root}")"
pushd gnucobol || exit
aclocal
automake
./configure \
    --disable-shared \
    --prefix="${prefix_root}/gnucobol" \
    --without-db

make SUBDIRS="lib libcob cobc config"
make install SUBDIRS="lib libcob cobc config"
make clean SUBDIRS="lib libcob cobc config"


popd || exit
rm -rf gnucobol
popd || exit