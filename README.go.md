# finance-proto-models-go

Go bindings for finance-proto-models protobuf definitions.

## Installation

### Extracting the Release

```bash
tar -xzf finance-proto-models-go.tar.gz
```

This extracts the complete Go module with all generated protobuf files.

### Adding to Your Project

#### Option 1: Local Path Dependency

Copy the extracted files to your project and reference them in `go.mod`:

```bash
require github.com/MaxBernstetter/finance-proto-models v0.0.0
replace github.com/MaxBernstetter/finance-proto-models => ./path/to/extracted/module
```

Then run:
```bash
go mod tidy
```

#### Option 2: Vendored Module

If already vendored in your project:

```bash
go mod tidy
```

## Usage

### Importing Models

```go
import "github.com/MaxBernstetter/finance-proto-models/financepb"
```

### Creating and Using Messages

```go
func main() {
    envelope := &financepb.Envelope{}
    price := &financepb.Price{}
    
    // Populate and use your models...
}
```

## Dependencies

- `google.golang.org/protobuf v1.36+`

The module's `go.mod` file declares all required dependencies.

## Files

- Generated Go protobuf files (`.pb.go`) in the `financepb` package
- `go.mod` and `go.sum`: Go module files
- `version.txt`: Release version, git commit hash, and timestamp
