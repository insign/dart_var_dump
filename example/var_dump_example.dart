import 'package:var_dump/var_dump.dart';

void main(List<String> args) async {
  Map<String, dynamic> allObjects = {
    'string': 'string',
    'int': 1,
    'double': 1.0,
    'bool': true,
    'list': [1, 2, 3],
    'map': {'key': 'value'},
    'function': () {},
    'symbol': #symbol,
    'type': int,
    'uri': Uri.parse('https://example.com'),
    'null': null,
  };

  dd(allObjects);
}
