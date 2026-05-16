#!/usr/bin/env bash
set -e

source_dir="$(dirname "${BASH_SOURCE[0]}")"
build_dir="${source_dir}/build"
mkdir -p "${build_dir}"

# Compile COBOL to C
./scripts/cobc.sh \
  -x \
  -C \
  "${source_dir}/day01.cob"

# Produce js and wasm
./scripts/emcc.sh \
  -O3 \
  -sWASM=1 \
  -sINVOKE_RUN=0 \
  -sEXPORT_ES6 \
  -sEXPORTED_FUNCTIONS=_main \
  -sEXPORTED_RUNTIME_METHODS=callMain,FS \
  -o "${build_dir}/output.js" \
  ./*.c

# Remove temporary files
rm day01.{c,c.h,c.l.h}