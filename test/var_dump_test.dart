import 'package:test/test.dart';
import 'package:var_dump/var_dump.dart';

void main() {
  group('dump()', () {
    test('should return a string representation of the variable', () {
      final dumper = Dumper(colorize: false);
      final String obj = 'Hello, world!';
      final String expected = '"Hello, world!"';
      final String result = dumper.dump(obj);
      expect(result, equals(expected));
    });
  });

  group('complex data types', () {
    test('should dump a nested list', () {
      final dumper = Dumper(colorize: false);
      final list = [
        1,
        ['a', 'b', 'c'],
        true
      ];
      final expected = 'List<Object> [\n  1\n  List<String> [\n    "a"\n    "b"\n    "c"\n  ]\n  true\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should dump a nested map', () {
      final dumper = Dumper(colorize: false);
      final map = {
        'a': 1,
        'b': {'x': 10, 'y': 20},
        'c': true
      };
      final expected = 'Map<String, Object> {\n  a: 1\n  b: Map<String, int> {\n    x: 10\n    y: 20\n  }\n  c: true\n}';
      expect(dumper.dump(map), equals(expected));
    });

    test('should dump a list of maps', () {
      final dumper = Dumper(colorize: false);
      final list = [
        {'a': 1},
        {'b': 2}
      ];
      final expected = 'List<Map<String, int>> [\n  Map<String, int> {\n    a: 1\n  }\n  Map<String, int> {\n    b: 2\n  }\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should dump a map of lists', () {
      final dumper = Dumper(colorize: false);
      final map = {
        'a': [1, 2, 3],
        'b': [4, 5, 6]
      };
      final expected = 'Map<String, List<int>> {\n  a: List<int> [\n    1\n    2\n    3\n  ]\n  b: List<int> [\n    4\n    5\n    6\n  ]\n}';
      expect(dumper.dump(map), equals(expected));
    });
  });

  group('custom objects', () {
    test('should dump an object with a toJson method', () {
      final dumper = Dumper(colorize: false);
      final obj = _TestClassWithToJson(1, 'two');
      final expected = 'TestClassWithToJson {\n  "a": 1\n  "b": "two"\n}';
      expect(dumper.dump(obj), equals(expected));
    });

    test('should dump an object without a toJson method', () {
      final dumper = Dumper(colorize: false);
      final obj = _TestClassWithoutToJson(1, 'two');
      final expected = 'TestClassWithoutToJson {\n  Instance of \'_TestClassWithoutToJson\'\n}';
      expect(dumper.dump(obj), equals(expected));
    });
  });

  group('circular references', () {
    test('should handle circular references in lists', () {
      final dumper = Dumper(colorize: false);
      final list = <dynamic>[1, 2, 3];
      list.add(list);
      final expected = 'List<dynamic> [\n  1\n  2\n  3\n  *RECURSION*\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should handle circular references in maps', () {
      final dumper = Dumper(colorize: false);
      final map = <String, dynamic>{'a': 1, 'b': 2};
      map['c'] = map;
      final expected = 'Map<String, dynamic> {\n  a: 1\n  b: 2\n  c: *RECURSION*\n}';
      expect(dumper.dump(map), equals(expected));
    });
  });
}

class _TestClassWithToJson {
  _TestClassWithToJson(this.a, this.b);

  final int a;
  final String b;

  Map<String, dynamic> toJson() => {
        'a': a,
        'b': b,
      };
}

class _TestClassWithoutToJson {
  _TestClassWithoutToJson(this.a, this.b);

  final int a;
  final String b;
}