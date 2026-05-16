#!/usr/bin/env bash
set -e

docker_image="${COBOL_WASM_IMAGE:-ghcr.io/caarmen/cobol-wasm:latest}"

docker run --rm -it \
  -v "$(pwd):/workspace/input" \
  --workdir /workspace/input \
  "${docker_image}" \
  /opt/gnucobol/bin/cobc "$@"
