# finance-proto-models-py

Version: ${PACKAGE_VERSION}

Python bindings for finance-proto-models protobuf definitions.

## Installation
Can either be installed from raw files or from .wheel

```bash
python -m venv venv
source venv/bin/activate
pip install finance_proto_models_py-0.0.0.tar.gz
pip install finance_proto_models_py-0.0.0-py3-none-any.whl
```

## Usage

### Importing Models

```python
from finance_proto_models import envelope_pb2
from finance_proto_models.metrics import price_pb2, enum_metric_types_pb2, enum_aggregation_window_pb2
from finance_proto_models.provider import enum_provider_pb2
```

### Creating and Using Messages

```python
envelope = envelope_pb2.Envelope()
price = price_pb2.Price()
```
## Files

Generated Python protobuf files in the `finance_proto_models` package.