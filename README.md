Dumps details in tree from variable. Optionally exits.

## Getting started

```dart
dart pub add dev:var_dump
```
## Usage

```dart
import 'package:var_dump/var_dump.dart';

void main(List<String> args) async {
  Map<String, dynamic> objects = {
    'string': 'Josh',
    'int': 10,
    'double': 1.0,
    'bool': true,
    'list': [1, 2, 3],
    'map': {'key': 'value'},
    'function': () {},
    'symbol': #symbol,
    'type': int,
    'uri': Uri.parse('https://example.com'),
    'null': null
  };

  dd(objects);
}
```

## LICENSE

[BSD 3-Clause License](./LICENSE)

## CONTRIBUTE
> Just do a PR
