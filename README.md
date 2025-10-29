# var_dump for Dart

A simple, yet powerful, variable dumper for Dart that provides detailed, colorized output, similar to Symfony's `var_dumper`.

## Features

*   **Detailed output:** Dumps detailed information about variables, including their type and value.
*   **Colorized output:** Uses ANSI escape codes to colorize the output for better readability.
*   **Handles complex data types:** Can dump nested lists, maps, and sets.
*   **Handles custom objects:** Can dump custom objects, and will use the `toJson()` method if it is available.
*   **Handles circular references:** Detects and handles circular references to prevent infinite loops.
*   **Multiple dump functions:** Provides `dump()`, `var_dump()`, and `dd()` functions for different use cases.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dev_dependencies:
  var_dump: ^0.5.0 # Replace with the latest version
```

Then, run `dart pub get`.

## Usage

Import the library:

```dart
import 'package:var_dump/var_dump.dart';
```

### Basic Usage

The `dump()` function prints a detailed, colorized representation of a variable to the console.

```dart
void main() {
  final myVariable = {'name': 'John Doe', 'age': 30};
  dump(myVariable);
}
```

### `var_dump()`

The `var_dump()` function is an alias for `dump()`.

```dart
void main() {
  final myVariable = {'name': 'John Doe', 'age': 30};
  var_dump(myVariable);
}
```

### `dd()` (Dump and Die)

The `dd()` function dumps a variable and then immediately terminates the script.

```dart
void main() {
  final myVariable = {'name': 'John Doe', 'age': 30};
  dd(myVariable);
  // This code will not be executed.
  print('Hello, world!');
}
```

### Examples

#### Dumping a List

```dart
void main() {
  final myList = [1, 'two', true, [1, 2, 3]];
  dump(myList);
}
```

#### Dumping a Map

```dart
void main() {
  final myMap = {
    'name': 'John Doe',
    'age': 30,
    'address': {
      'street': '123 Main St',
      'city': 'Anytown',
    },
  };
  dump(myMap);
}
```

#### Dumping a Custom Object

If a custom object has a `toJson()` method, the dumper will use it to get a map of the object's properties. Otherwise, it will use the `toString()` method.

```dart
class MyClassWithToJson {
  MyClassWithToJson(this.a, this.b);

  final int a;
  final String b;

  Map<String, dynamic> toJson() => {
        'a': a,
        'b': b,
      };
}

class MyClassWithoutToJson {
  MyClassWithoutToJson(this.a, this.b);

  final int a;
  final String b;
}

void main() {
  final withToJson = MyClassWithToJson(1, 'two');
  final withoutToJson = MyClassWithoutToJson(1, 'two');

  dump(withToJson);
  dump(withoutToJson);
}
```

#### Disabling Colorization

To disable colorization, pass `colorize: false` to the dump function.

```dart
void main() {
  final myVariable = {'name': 'John Doe', 'age': 30};
  dump(myVariable, colorize: false);
}
```

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you would like to contribute code, please open a pull request.

## License

This project is licensed under the BSD 3-Clause License. See the [LICENSE](./LICENSE) file for details.