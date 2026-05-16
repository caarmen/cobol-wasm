#!/usr/bin/env bash

install_root="${PREFIX_ROOT:-$HOME/.local/cobol-wasm}"
example_dir=examples/file-input-and-stdout
build_dir="${example_dir}/build"
mkdir -p "${build_dir}"

"${install_root}/gnucobol/bin/cobc" -x -C "${example_dir}"/*.cob
source "${install_root}/emsdk/emsdk_env.sh"

emcc -o "${build_dir}/output.js" \
  -O3 -s WASM=1 \
  -sINVOKE_RUN=0 \
  -sEXPORT_ES6 \
  -sEXPORTED_FUNCTIONS=_main \
  -sEXPORTED_RUNTIME_METHODS=callMain,FS \
  -I"${install_root}/gnucobol/include" \
  -I"${install_root}/include" \
  -L"${install_root}/gnucobol-wasm/lib" -lcob \
  -L"${install_root}/lib" -lgmp -ldb-5.3 \
  ./*.c