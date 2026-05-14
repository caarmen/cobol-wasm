#!/usr/bin/env bash
set -e

./scripts/cobol-wasm.sh examples/call-cobol-from-js/AnswerToLife.cob _ANSWER__TO__LIFE,_ANSWER__TO__UNIVERSE

mv AnswerToLife.* examples/call-cobol-from-js/build/