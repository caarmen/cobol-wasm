#!/usr/bin/env bash
set -e

docker_image="ghcr.io/caarmen/cobol-wasm:latest"

if [ $# -lt 2 ]; then
  echo "Usage: $0 <program1,program2,program3> </path/to/file1.cob> </path/to/file2.cob> ..."
  exit 1
fi

program_names="$1"; shift
input_files=$*

docker run --rm -it \
  -v "$(pwd):/workspace/input" \
  "${docker_image}" \
  bash -c "cd /workspace/input && /opt/gnucobol/bin/cobc -C ${input_files[*]}"

docker run --rm -it \
  -v "$(pwd):/workspace/input" \
  "${docker_image}" \
  bash -c "cd /workspace/input && source /workspace/deps/emsdk/emsdk_env.sh && emcc -o output.js -O3 -s WASM=1 -sEXPORTED_FUNCTIONS='[${program_names}, \"_cob_init\", \"_malloc\", \"_free\"]' -sEXPORTED_RUNTIME_METHODS='[\"cwrap\", \"HEAPU8\", \"UTF8ToString\"]' -I/opt/gnucobol-wasm/include -L/opt/gnucobol-wasm/lib -lcob -L/workspace/deps/gmp/.libs -lgmp /workspace/deps/libdb/build_unix/.libs/libdb-5.3.so *.c"
