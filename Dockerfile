FROM debian:12.13-slim@sha256:b9622a9886f8950fc2d039ad4e1e031b0f96c818642797538edda77c8315a562

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    bison \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    file \
    flex \
    git \
    libgmp-dev \
    libtool \
    m4 \
    make \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    texinfo \
    wget \
    xz-utils \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY docker/scripts/*.sh .

RUN ./build-emsdk.sh
RUN ./build-gmp.sh
RUN ./build-libdb.sh
RUN ./build-gnucobol.sh
RUN ./build-gnucobol-wasm.sh