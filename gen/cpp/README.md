# finance-proto-models-cpp

This package contains the generated C++ code from the finance-proto-models protobuf definitions.

## Usage

### Including Headers

Include the generated headers in your C++ code:

```cpp
#include "envelope.pb.h"
#include "metrics/price.pb.h"
#include "metrics/enum_metric_types.pb.h"
#include "metrics/enum_aggregation_window.pb.h"
#include "provider/enum_provider.pb.h"
```

### Linking Against Protobuf

1. Compile the `.cc` files with your project
2. Link against `libprotobuf` (or `libprotobuf-lite` for reduced size)
3. Ensure protobuf development libraries are installed:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install libprotobuf-dev
   
   # macOS
   brew install protobuf
   ```

### CMake Integration

Example CMake configuration:

```cmake
find_package(Protobuf REQUIRED)

add_library(finance_proto_models
  envelope.pb.cc
  metrics/price.pb.cc
  metrics/enum_metric_types.pb.cc
  metrics/enum_aggregation_window.pb.cc
  provider/enum_provider.pb.cc
)

target_link_libraries(finance_proto_models PUBLIC protobuf::libprotobuf)
```

## Files

- Generated C++ headers (`.h`) and source files (`.cc`)
- `version.txt`: Release version, git commit hash, and timestamp