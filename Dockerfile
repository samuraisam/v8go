FROM ubuntu:20.04@sha256:b795f8e0caaaacad9859a9a38fe1c78154f8301fdaf0872eaf1520d66d9c0b98

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y build-essential python pkg-config
RUN apt-get install -y git ca-certificates
RUN apt-get install -y curl wget python3 libglib2.0-dev

# supported: x86_64 or arm64
ARG ARCH
ENV ARCH=${ARCH:-x86_64}  

RUN if [ "$ARCH" == "arm64" ]; then \
        apt-get install -y g++-aarch64-linux-gnu; \
    fi;

WORKDIR /code
COPY . /code

RUN cd deps/depot_tools && git config --unset-all remote.origin.fetch; git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*

RUN cd deps && ./build.py --no-clang --arch ${ARCH}
