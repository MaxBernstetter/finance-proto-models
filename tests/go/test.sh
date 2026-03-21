#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
mkdir -p tmp

# Extract the go-models tarball (includes go.mod, go.sum, financepb/, version.txt)
cp -r "$RELEASE_DIR/go/." ./tmp/
tar -xzf ./tmp/finance-proto-models-go.tar.gz -C ./tmp

# Small verifier under cmd/ so main does not live in the module root
mkdir -p tmp/cmd/verify
cat > tmp/cmd/verify/main.go <<'EOF'
package main

import (
	"fmt"

	financepb "github.com/MaxBernstetter/finance-proto-models/financepb"
)

func main() {
	fmt.Println(financepb.Provider_COINBASE)
}
EOF

(
	cd tmp
	go mod tidy
	go build -o "$SCRIPT_DIR/tmp/test-go" ./cmd/verify
)

# Run the test program & assert the output "0" (COINBASE)
./tmp/test-go | grep -q "COINBASE"

echo "Test completed successfully!"
echo "All steps succeeded - package is working properly"
