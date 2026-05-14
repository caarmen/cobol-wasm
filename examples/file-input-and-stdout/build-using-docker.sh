#!/usr/bin/env bash

example_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
build_dir="${example_dir}/build"
mkdir -p "${build_dir}"

docker_image="ghcr.io/caarmen/cobol-wasm:latest"

docker run --rm -it \
  -v "$(pwd):/workspace/input" \
  --workdir /workspace/input \
  "${docker_image}" \
  /opt/gnucobol/bin/cobc -x -C examples/file-input-and-stdout/day01.cob

docker run --rm -it \
  -v "$(pwd):/workspace/input" \
  --workdir /workspace/input \
  "${docker_image}" \
  bash -c "source /workspace/deps/emsdk/emsdk_env.sh && \
  emcc -o examples/file-input-and-stdout/build/output.js \
  -O3 -s WASM=1 \
  -sINVOKE_RUN=0 \
  -sEXPORT_ES6 \
  -sEXPORTED_FUNCTIONS=_main \
  -sEXPORTED_RUNTIME_METHODS=callMain,FS \
  -I/opt/gnucobol/include \
  -I/opt/include \
  -L/opt/gnucobol-wasm/lib -lcob \
  -L/opt/lib -lgmp \
  /opt/lib/libdb-5.3.so \
  ./day01.c
  "
