#!/usr/bin/env bash
set -e

script_dir="$(realpath "$(dirname "${BASH_SOURCE[@]}")")"
mkdir -p "${script_dir}/build"
build_dir="/workspace/output/build"
docker_image="ghcr.io/caarmen/cobol-wasm:latest"

docker run --rm -it \
  -v "$(pwd)/examples/call-cobol-from-js:/workspace/output" \
  "${docker_image}" \
  bash -c "cd ${build_dir} && /opt/gnucobol/bin/cobc -C ../AnswerToLife.cob"

docker run --rm -it \
  -v "$(pwd)/examples/call-cobol-from-js:/workspace/output" \
  "${docker_image}" \
  bash -c "cd ${build_dir} && source /workspace/deps/emsdk/emsdk_env.sh && emcc -o AnswerToLife.js -O3 -s WASM=1 -sEXPORTED_FUNCTIONS='[\"_ANSWER__TO__LIFE\", \"_cob_init\", \"_malloc\", \"_free\"]' -sEXPORTED_RUNTIME_METHODS='[\"cwrap\", \"HEAPU8\", \"UTF8ToString\"]' -I/opt/gnucobol-wasm/include -L/opt/gnucobol-wasm/lib -lcob -L/workspace/deps/gmp/.libs -lgmp /workspace/deps/libdb/build_unix/.libs/libdb-5.3.so AnswerToLife.c"


