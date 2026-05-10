#!/usr/bin/env bash
set -e
script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
build_dir="${script_dir}/build"
deps_dir="$(realpath deps)"
source "${deps_dir}/emsdk/emsdk_env.sh"
mkdir -p "${build_dir}"
pushd "${build_dir}" || exit
"${deps_dir}/gnucobol/cobc/cobc" -C "${script_dir}/AnswerToLife.cob"
emcc -o "AnswerToLife.js" \
  -O3 \
  -s WASM=1 \
  -sEXPORTED_FUNCTIONS='["_ANSWER__TO__LIFE", "_cob_init", "_malloc", "_free"]' \
  -sEXPORTED_RUNTIME_METHODS='["cwrap", "HEAPU8", "UTF8ToString"]' \
  -I"${deps_dir}/gnucobol-wasm" \
  -L"${deps_dir}/gnucobol-wasm/libcob/.libs" -lcob \
  -L"${deps_dir}/gmp/.libs" -lgmp \
  "${deps_dir}/libdb/.libs/libdb-5.3.dylib" \
  "AnswerToLife.c"

popd || exit

