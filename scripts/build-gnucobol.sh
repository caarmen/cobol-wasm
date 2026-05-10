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

if [ ! -d gnucobol ]; then
    curl "https://ftp.gnu.org/gnu/gnucobol/gnucobol-${gnucobol_version}.tar.gz" --output gnucobol.tar.gz
    tar xzf "gnucobol.tar.gz"
    rm "gnucobol.tar.gz"
    mv "gnucobol-${gnucobol_version}" gnucobol
fi

# Build cobc
pushd gnucobol || exit
glibtoolize --force --copy
autoreconf -vfi
./configure \
    --disable-shared \
    --prefix="$(pwd)/install" \
    --without-db

make  SUBDIRS="lib libcob cobc config"
make install SUBDIRS="lib libcob cobc config"


popd || exit
popd || exit