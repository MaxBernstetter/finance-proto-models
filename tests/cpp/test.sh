#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Dedicated Conan state for this script run
export CONAN_HOME="$SCRIPT_DIR/tmp/conan-home"
#rm -rf "$CONAN_HOME"
mkdir -p "$CONAN_HOME/profiles"

# Ensure remote exists in THIS Conan home
conan remote add conancenter https://center2.conan.io --force
conan remote enable conancenter

PROFILE_NAME="clang18-local"
cat > "$CONAN_HOME/profiles/$PROFILE_NAME" <<'EOF'
[settings]
os=Linux
arch=x86_64
build_type=Release
compiler=clang
compiler.version=18
compiler.libcxx=libstdc++11
compiler.cppstd=20

[conf]
tools.build:compiler_executables={"c":"clang","cpp":"clang++"}
EOF

conan install \
  --requires="protobuf/${CONAN_PROTOBUF_VERSION}" \
  --output-folder=tmp/conan \
  --build=missing \
  -g VirtualBuildEnv \
  -g AutotoolsDeps \
  -pr:h="$PROFILE_NAME" \
  -pr:b="$PROFILE_NAME"

# Export env vars so pkg-config sees Conan metadata/libs
source tmp/conan/conanbuild.sh
source tmp/conan/conanautotoolsdeps.sh

# Add some basic testing code (import & enum access)
printf "%s\n" "#include \"finance-proto-models/provider/enum_provider.pb.h\"" "" "int main() { return FinanceProtobufModels::Provider::COINBASE; }" > ./tmp/main.cpp

# Copy and prepare compiled protobuf files
cp -r $RELEASE_DIR/cpp/. ./tmp/
tar -xzf ./tmp/finance-proto-models-cpp.tar.gz -C ./tmp

# Compile - using compiler flags from the environment
# Include main.cpp
# Include all protobuf files
clang++ \
  -std=c++20 \
  -pthread \
  -I./tmp/finance-proto-models \
  $CPPFLAGS $CXXFLAGS \
  -o ./tmp/test-program \
  ./tmp/main.cpp \
  $(find ./tmp/finance-proto-models -name "*.cc") \
  $LDFLAGS $LIBS

# Run the test program
./tmp/test-program