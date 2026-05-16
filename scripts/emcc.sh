#!/usr/bin/env bash
set -e

docker_image="ghcr.io/caarmen/cobol-wasm:latest"

docker run --rm -it \
  -v "$(pwd):/workspace/input" \
  --workdir /workspace/input \
  "${docker_image}" \
  bash -c "source /opt/emsdk/emsdk_env.sh && emcc \
    -I/opt/gnucobol/include \
    -I/opt/include \
    -L/opt/gnucobol-wasm/lib -lcob \
    -L/opt/lib -lgmp -ldb-5.3 \
    $*"
