#!/usr/bin/env bash
script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
"${script_dir}/build-emsdk.sh"
"${script_dir}/build-gmp.sh"
"${script_dir}/build-libdb.sh"
"${script_dir}/build-gnucobol.sh"
"${script_dir}/build-gnucobol-wasm.sh"