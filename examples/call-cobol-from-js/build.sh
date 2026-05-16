#!/usr/bin/env bash

install_root="${PREFIX_ROOT:-$HOME/.local/cobol-wasm}"
example_dir=examples/call-cobol-from-js
build_dir="${example_dir}/build"
mkdir -p "${build_dir}"

"${install_root}/gnucobol/bin/cobc" -C "${example_dir}"/*.cob
source deps/emsdk/emsdk_env.sh

BDB_LIBS_DIR="${install_root}/lib"
if [[ -f "${BDB_LIBS_DIR}/libdb-5.3.dylib" ]]; then
  BDB_LIB="${BDB_LIBS_DIR}/libdb-5.3.dylib"
else
  BDB_LIB="${BDB_LIBS_DIR}/libdb-5.3.so"
fi

emcc -o "${build_dir}/output.js" \
  -O3 -s WASM=1 \
  -sEXPORTED_FUNCTIONS='[_ANSWER__TO__LIFE, _ANSWER__TO__UNIVERSE, _cob_init, _malloc, _free]' \
  -sEXPORTED_RUNTIME_METHODS='[cwrap, HEAPU8, UTF8ToString]' \
  -I"${install_root}/gnucobol/include" \
  -L"${install_root}/gnucobol-wasm/lib" -lcob \
  -L"${install_root}/lib" -lgmp \
  "${BDB_LIB}" \
  ./*.c