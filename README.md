# Finance Proto Models

Generated protobuf models for financial data, supporting C++, Go, and Python.

## Overview

This repository contains Protocol Buffer definitions and generated code for finance-related models. Pre-built model files are available for multiple programming languages and can be extracted from tarballs/packages included in this repository.

## Working with Releases

Release packages are provided for C++, Go, and Python and include generated model files, dependencies, and documentation.

### C++

The C++ release is provided as `release/cpp/finance-proto-models-cpp.tar.gz`.

**To extract:**
```bash
cd release/cpp
tar -xzf finance-proto-models-cpp.tar.gz
```

For detailed integration instructions, see the README.md included in the release.

### Go

The Go release is provided as `release/go/finance-proto-models-go.tar.gz`.

**To extract:**
```bash
cd release/go
tar -xzf finance-proto-models-go.tar.gz
```

For detailed integration instructions, see the README.md included in the release.

### Python

The Python release is available as:
- Source distribution (tarball): `build/python/dist/finance_proto_models_py-0.0.0.tar.gz`
- Wheel package: `build/python/dist/finance_proto_models_py-0.0.0-py3-none-any.whl`

For installation and usage instructions, see the README.md included in the release.

## Release Contents

Each release includes:

- **Generated Code**: Language-specific protobuf bindings
- **Modules**: Original module definitions defining the protobuf structures
- **version.txt**: Contains the release version, git commit hash, and timestamp

## Proto Schema

The project defines the following protobuf messages:

- `Envelope`: Root message container
- `Price`: Financial price data
- `MetricAggregationWindow`: Enum for aggregation windows
- `MetricTypes`: Enum for metric types
- `Provider`: Enum for data providers

## License

See [LICENSE](LICENSE) for details.
