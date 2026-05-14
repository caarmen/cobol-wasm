#!/usr/bin/env bash
set -e

./scripts/cobol-wasm.sh _ANSWER__TO__UNIVERSE,_ANSWER__TO__LIFE examples/call-cobol-from-js/AnswerToLife.cob examples/call-cobol-from-js/AnswerToUniverse.cob

mv output.{js,wasm} examples/call-cobol-from-js/build/