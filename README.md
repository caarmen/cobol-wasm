# COBOL-Wasm

This project provides a docker image to compile COBOL programs to be used in a web browser.

## Usage

```shell
./scripts/cobol-wasm.sh <path_to_cobol_file> <program1,program2,program3>
```

Example:
To compile a `hello.cob` file which defines a program `MY-PROGRAM` that you wish to call from javascript:

```shell
./scripts/cobol-wasm.sh /path/to/hello.cob _MY__PROGRAM
```
This will produce `hello.js` and `hello.wasm` in the current working directory.

## Example
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


## License
The files in this repository (shell scripts, Dockerfile, examples, etc.)
are licensed under the MIT License.

This project builds and redistributes GnuCOBOL artifacts inside the Docker
image. Those artifacts remain covered by their original licenses.

GnuCOBOL licensing information:
* GnuCOBOL compiler (`cobc`): GPLv3
* GnuCOBOL runtime library (`libcob`): LGPLv3

See the upstream GnuCOBOL project for details:
https://sourceforge.net/p/gnucobol/code/HEAD/tree/branches/gnucobol-3.x/