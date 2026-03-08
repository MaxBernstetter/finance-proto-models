#!/bin/bash

# Build script to generate Python or C++ code from protobuf files
# Usage: ./build_py.sh [python|cpp|all]

set -e
eval "$(devbox shellenv)"
poetry install
source $VENV_DIR/bin/activate

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PROTO_SRC_DIR="$SCRIPT_DIR/src"
PYTHON_OUTPUT_DIR="$SCRIPT_DIR/build/python"
PYTHON_PACKAGE_NAME="finance_proto_models"
CPP_OUTPUT_DIR="$SCRIPT_DIR/build/cpp/finance-proto-models"

# Find all proto files
find_proto_files() {
    local proto_files=$(find "$PROTO_SRC_DIR" -name "*.proto")
    if [ -z "$proto_files" ]; then
        echo "❌ No .proto files found in $PROTO_SRC_DIR"
        exit 1
    fi
    echo "$proto_files"
}

# List proto files
list_proto_files() {
    local proto_files="$1"
    echo "Found proto files:"
    for proto_file in $proto_files; do
        echo "  - $proto_file"
    done
}

# Generic build function
build_target() {
    local target_name="$1"
    local output_dir="$2"
    local protoc_flag="$3"
    
    echo "📦 Generating $target_name code from all .proto files..."
    
    mkdir -p "$output_dir"
    echo "Proto source directory: $PROTO_SRC_DIR"
    echo "$target_name output directory: $output_dir"
    echo ""
    
    local proto_files=$(find_proto_files)
    list_proto_files "$proto_files"
    echo ""
    
    for proto_file in $proto_files; do
        echo "🔧 Processing $(basename "$proto_file")..."
        protoc -I "$PROTO_SRC_DIR" "$protoc_flag=$output_dir" "$proto_file"
        if [ $? -ne 0 ]; then
            echo "❌ Failed to generate $target_name code for $(basename "$proto_file")"
            exit 1
        fi
    done
}

# Build both targets
build_all() {
    echo "🚀 Building both Python and C++ targets..."
    echo ""
    build_target "Python" "$PYTHON_OUTPUT_DIR" "--python_betterproto_out"
    echo ""
    echo "---"
    echo ""
    build_target "C++" "$CPP_OUTPUT_DIR" "--cpp_out"
    echo ""
    echo "🎉 All builds complete!"
}

# Main script logic
TARGET="${1:-python}"

case "$TARGET" in
    python)
        build_target "Python" "$PYTHON_OUTPUT_DIR" "--python_betterproto_out"
        echo ""
        echo "Python build complete! You can now import the generated classes"
        echo "   Example: from commons.proto.envelope_pb2 import PriceMessageEnvelope"
        ;;
    cpp)
        shopt -s extglob
        build_target "C++" "$CPP_OUTPUT_DIR" "--cpp_out"
        echo ""
        echo "C++ build complete! Generated files are in $CPP_OUTPUT_DIR"
        ;;
    all)
        build_all
        ;;
    *)
        echo "Invalid target: $TARGET"
        echo "Usage: $0 [python|cpp|all]"
        echo "  python - Build Python code (default)"
        echo "  cpp    - Build C++ code"
        echo "  all    - Build both Python and C++ code"
        exit 1
        ;;
esac
