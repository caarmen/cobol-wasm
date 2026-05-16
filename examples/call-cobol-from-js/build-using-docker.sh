#!/usr/bin/env bash
set -e

source_dir="$(dirname "${BASH_SOURCE[0]}")"
build_dir="${source_dir}/build"
mkdir -p "${build_dir}"

# Compile COBOL to C
./scripts/cobc.sh \
  -C \
  "${source_dir}"/*.cob

# Produce js and wasm
./scripts/emcc.sh \
  -O3 \
  -sWASM=1 \
  -sEXPORTED_FUNCTIONS=_ANSWER__TO__LIFE,_ANSWER__TO__UNIVERSE,_cob_init,_malloc,_free \
  -sEXPORTED_RUNTIME_METHODS=cwrap,HEAPU8,UTF8ToString \
  -o "${build_dir}/output.js" \
  ./*.c

# Remove temporary files
rm AnswerToLife.{c,c.h,c.l.h}
rm AnswerToUniverse.{c,c.h,c.l.h}