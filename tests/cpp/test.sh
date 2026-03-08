#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Rebuild & run the container
docker build -f cpp-env.Dockerfile \
  --build-arg CLANG_VERSION="${CLANG_VERSION}" \
  --build-arg PROTO_VERSION="${PROTO_VERSION}" \
  -t cpp-test-image .

docker rm -f cpp-tests-runner > /dev/null 2>&1 || true
docker run -d --name cpp-tests-runner --network none cpp-test-image

# Clean
docker exec cpp-tests-runner rm -rf /build/* src/*

# Add some basic testing code (import & enum access)
docker exec cpp-tests-runner bash -c 'printf "%s\n" "#include \"finance-proto-models/provider/enum_provider.pb.h\"" "" "int main() { return FinanceProtobufModels::Provider::COINBASE; }" > /src/main.cpp'

# Copy and prepare compiled protobuf files
docker cp $RELEASE_DIR/cpp/. cpp-tests-runner:/src/
docker exec cpp-tests-runner tar -xzf /src/finance-proto-models-cpp.tar.gz -C /src

# Compile - using compiler flags from the environment
# Include main.cpp
# Include all protobuf files
# Link against protobuf library
docker exec cpp-tests-runner bash -c 'clang++ -std=c++20 -lprotobuf -pthread -I/src/finance-proto-models -o /build/test-program /src/main.cpp $(find /src/finance-proto-models -name "*.cc") -lprotobuf'

# Run the test program
docker exec cpp-tests-runner /build/test-program