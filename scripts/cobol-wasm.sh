#!/usr/bin/env bash
set -e

docker_image="ghcr.io/caarmen/cobol-wasm:latest"

# Check if a COBOL file path is provided as an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <path_to_cobol_file> [function1,function2,function3]"
  exit 1
fi

cobol_file="$1"; shift
base_name=$(basename "$cobol_file" .cob)

# Extract the directory of the COBOL file
input_dir="$(realpath "$(dirname "$cobol_file")")"

tmp_dir="$(mktemp -d)"

docker run --rm -it \
  -v "${tmp_dir}:/workspace/output" \
  -v "${input_dir}:/workspace/input" \
  "${docker_image}" \
  bash -c "cd /workspace/output && /opt/gnucobol/bin/cobc -C /workspace/input/${base_name}.cob"

docker run --rm -it \
  -v "${tmp_dir}:/workspace/output" \
  -v "${input_dir}:/workspace/input" \
  "${docker_image}" \
  bash -c "cd /workspace/output && source /workspace/deps/emsdk/emsdk_env.sh && emcc -o ${base_name}.js -O3 -s WASM=1 -sEXPORTED_FUNCTIONS='[${*}, \"_cob_init\", \"_malloc\", \"_free\"]' -sEXPORTED_RUNTIME_METHODS='[\"cwrap\", \"HEAPU8\", \"UTF8ToString\"]' -I/opt/gnucobol-wasm/include -L/opt/gnucobol-wasm/lib -lcob -L/workspace/deps/gmp/.libs -lgmp /workspace/deps/libdb/build_unix/.libs/libdb-5.3.so ${base_name}.c"

cp "${tmp_dir}"/*.{js,wasm} .