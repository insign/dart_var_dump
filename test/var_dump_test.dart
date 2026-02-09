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
        true,
      ];
      final expected =
          'List<Object> [\n  0: 1\n  1: List<String> [\n    0: "a"\n    1: "b"\n    2: "c"\n  ]\n  2: true\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should dump a nested map', () {
      final dumper = Dumper(colorize: false);
      final map = {
        'a': 1,
        'b': {'x': 10, 'y': 20},
        'c': true,
      };
      final expected =
          'Map<String, Object> {\n  a: 1\n  b: Map<String, int> {\n    x: 10\n    y: 20\n  }\n  c: true\n}';
      expect(dumper.dump(map), equals(expected));
    });

    test('should dump a list of maps', () {
      final dumper = Dumper(colorize: false);
      final list = [
        {'a': 1},
        {'b': 2},
      ];
      final expected =
          'List<Map<String, int>> [\n  0: Map<String, int> {\n    a: 1\n  }\n  1: Map<String, int> {\n    b: 2\n  }\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should dump a map of lists', () {
      final dumper = Dumper(colorize: false);
      final map = {
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      };
      final expected =
          'Map<String, List<int>> {\n  a: List<int> [\n    0: 1\n    1: 2\n    2: 3\n  ]\n  b: List<int> [\n    0: 4\n    1: 5\n    2: 6\n  ]\n}';
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
      final expected = 'Instance of \'_TestClassWithoutToJson\'';
      expect(dumper.dump(obj), equals(expected));
    });
  });

  group('circular references', () {
    test('should handle circular references in lists', () {
      final dumper = Dumper(colorize: false);
      final list = <dynamic>[1, 2, 3];
      list.add(list);
      final expected =
          'List<dynamic> [\n  0: 1\n  1: 2\n  2: 3\n  3: *RECURSION*\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should handle circular references in maps', () {
      final dumper = Dumper(colorize: false);
      final map = <String, dynamic>{'a': 1, 'b': 2};
      map['c'] = map;
      final expected = 'Map<String, dynamic> {\n  a: 1\n  b: 2\n  c: *RECURSION*\n}';
      expect(dumper.dump(map), equals(expected));
    });

    test('should NOT handle distinct objects as circular references', () {
      final dumper = Dumper(colorize: false);
      final child = _TestNode(1);
      final parent = _TestNode(1, child);
      final expected = 'TestNode {\n  "id": 1\n  "child": TestNode {\n    "id": 1\n    "child": null\n  }\n}';
      expect(dumper.dump(parent), equals(expected));
    });
  });
}

class _TestNode {
  final int id;
  final _TestNode? child;
  _TestNode(this.id, [this.child]);

  @override
  bool operator ==(Object other) => other is _TestNode && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
        'id': id,
        'child': child,
      };
}

class _TestClassWithToJson {
  _TestClassWithToJson(this.a, this.b);

  final int a;
  final String b;

  Map<String, dynamic> toJson() => {'a': a, 'b': b};
}

class _TestClassWithoutToJson {
  _TestClassWithoutToJson(this.a, this.b);

  final int a;
  final String b;
}
