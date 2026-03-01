#!/bin/bash
set -e  # Exit on error
mkdir -p $(dirname "$0")/tmp

# Script to test Python package installation from a release directory
# Usage: ./test-python.sh <path-to-release-directory>


# Validate argument
if [ $# -eq 0 ]; then
    echo "Release directory path is required as argument" && exit 1
fi

RELEASE_DIR="$1"

# Validate release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "Release directory does not exist: $RELEASE_DIR" && exit 1
fi

# Find wheel file
WHEEL_FILE=$(find "$RELEASE_DIR" -name "*.whl" | head -1)

if [ -z "$WHEEL_FILE" ]; then
    echo "No .whl file found in release directory: $RELEASE_DIR" && exit 1
fi

echo "Found wheel file: $WHEEL_FILE"

# Create temporary virtual environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/tmp/test-venv-$$"

# Clean up any existing venv directory (shouldn't happen, but be safe)
if [ -d "$VENV_DIR" ]; then
    rm -rf "$VENV_DIR"
fi
echo "Creating virtual environment under: $VENV_DIR"
python3 -m venv "$VENV_DIR"
. "$VENV_DIR/bin/activate"

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install the wheel
echo "Installing wheel: $WHEEL_FILE"
pip install "$WHEEL_FILE"

echo "Package installed successfully"

# Verify installation by checking if package is importable
echo "Testing package import..."

# Get the test script path
TEST_SCRIPT="$SCRIPT_DIR/test-script.py"

if [ ! -f "$TEST_SCRIPT" ]; then
    echo "Test script not found: $TEST_SCRIPT" && exit 1
fi

# Run the test script
echo "Running test script: $TEST_SCRIPT"
python3 "$TEST_SCRIPT"

echo "Package test completed successfully!"
echo "All steps succeeded - package is working properly"
