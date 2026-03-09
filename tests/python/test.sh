#!/bin/bash
set -e  # Exit on error

# Find wheel file
WHEEL_FILE=$(find "$RELEASE_DIR/python" -name "*.whl" | head -1)

if [ -z "$WHEEL_FILE" ]; then
    echo "No .whl file found in release directory: $RELEASE_DIR" && exit 1
fi

echo "Found wheel file: $WHEEL_FILE"

# Create temporary virtual environment
TMP_DIR="$(dirname "$0")/tmp"
VENV_DIR="$TMP_DIR/test-venv-$$"

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

# Execute the test script
TEST_SCRIPT="$(dirname "$0")/test-script.py"

if [ ! -f "$TEST_SCRIPT" ]; then
    echo "Test script not found: $TEST_SCRIPT" && exit 1
fi

# Run the test script
echo "Running test script: $TEST_SCRIPT"
python3 "$TEST_SCRIPT"

echo "Package test completed successfully!"
echo "All steps succeeded - package is working properly"