#!/usr/bin/env bash

set -e

prefix="${PREFIX_ROOT:-$HOME/.local/cobol-wasm}"
mkdir -p "${prefix}"
pushd "${prefix}" || exit

if [ ! -d emsdk ]; then
    git clone https://github.com/emscripten-core/emsdk.git
fi

pushd emsdk || exit

git pull
./emsdk install latest
./emsdk activate latest

popd || exit
popd || exit