#!/usr/bin/env bash

set -e

deps_dir="deps"

mkdir -p "${deps_dir}"
pushd "${deps_dir}" || exit

if [ ! -d emsdk ]; then
    git clone https://github.com/emscripten-core/emsdk.git
fi

pushd emsdk || exit

git pull
./emsdk install latest
./emsdk activate latest

popd || exit
popd || exit