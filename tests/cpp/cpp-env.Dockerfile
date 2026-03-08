ARG CLANG_VERSION=""
ARG PROTO_VERSION=""

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    clang${CLANG_VERSION} \
    libprotobuf-dev${PROTO_VERSION} \
    && rm -rf /var/lib/apt/lists/*

# Container folder structure
RUN mkdir -p /src /build

# Container stays alive for interactive usage

ENTRYPOINT ["sleep", "infinity"]
