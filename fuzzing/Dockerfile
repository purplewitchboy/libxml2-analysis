FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    git \
    make \
    autoconf \
    automake \
    libtool \
    clang \
    llvm \
    afl++ \
    python3.12 \
    python3.12-dev \
    pkg-config \
    m4
    

WORKDIR /work

RUN git clone https://git.altlinux.org/gears/l/libxml2.git
WORKDIR /work/libxml2

RUN git checkout v2.12.10

ENV CC=afl-clang-fast
ENV CXX=afl-clang-fast++
