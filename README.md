# COBOL-Wasm

This project provides a docker image to compile COBOL programs to be used in a web browser.

Build the docker image:
```shell
docker build -t cobol-wasm .
```

Try the example:
```shell
./examples/call-cobol-from-js/build.sh
```

Serve the html file at `examples/call-cobol-from-js/AnswerToLife.html`.

For example: 

```shell
python -m http.server -d examples/call-cobol-from-js 8080
```
or

```shell
npx http-server examples/call-cobol-from-js
```

Open the example page at http://localhost:8080/AnswerToLife.html