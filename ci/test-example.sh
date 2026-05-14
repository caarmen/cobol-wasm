#!/usr/bin/env bash
npx http-server examples/call-cobol-from-js &
server_pid=$!

npm i -D @playwright/test@1.60.0

npx playwright install
npx playwright test

kill "${server_pid}"