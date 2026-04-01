import 'package:test/test.dart';
import 'package:var_dump/var_dump.dart';

void main() {
  group('Dumper', () {
    test('should dump a string', () {
      final dumper = Dumper(colorize: false);
      expect(dumper.dump('hello'), equals('"hello"'));
    });

    test('should dump an integer', () {
      final dumper = Dumper(colorize: false);
      expect(dumper.dump(123), equals('123'));
    });

    test('should dump a double', () {
      final dumper = Dumper(colorize: false);
      expect(dumper.dump(123.45), equals('123.45'));
    });

    test('should dump a boolean', () {
      final dumper = Dumper(colorize: false);
      expect(dumper.dump(true), equals('true'));
    });

    test('should dump null', () {
      final dumper = Dumper(colorize: false);
      expect(dumper.dump(null), equals('null'));
    });

    test('should dump a list', () {
      final dumper = Dumper(colorize: false);
      final list = [1, 'two', true];
      final expected = 'List<Object> [\n  0: 1\n  1: "two"\n  2: true\n]';
      expect(dumper.dump(list), equals(expected));
    });

    test('should dump a map', () {
      final dumper = Dumper(colorize: false);
      final map = {'a': 1, 'b': 'two', 'c': true};
      final expected = 'Map<String, Object> {\n  a: 1\n  b: "two"\n  c: true\n}';
      expect(dumper.dump(map), equals(expected));
    });

    test('should dump a generic iterable', () {
      final dumper = Dumper(colorize: false);
      final iterable = [1, 2, 3].map((e) => e * 2);
      final expected = 'MappedListIterable<int, int> (\n  2\n  4\n  6\n)';
      expect(dumper.dump(iterable), equals(expected));
    });

    test('should dump an empty list concisely', () {
      final dumper = Dumper(colorize: false);
      final list = <int>[];
      final expected = 'List<int> []';
      expect(dumper.dump(list), equals(expected));
    });

    test('should dump an empty map concisely', () {
      final dumper = Dumper(colorize: false);
      final map = <String, int>{};
      final expected = 'Map<String, int> {}';
      expect(dumper.dump(map), equals(expected));
    });

    test('should dump an empty set concisely', () {
      final dumper = Dumper(colorize: false);
      final set = <int>{};
      final expected = 'Set<int> {}';
      expect(dumper.dump(set), equals(expected));
    });

    test('should dump an empty iterable concisely', () {
      final dumper = Dumper(colorize: false);
      final iterable = <int>[].where((e) => e > 0);
      final expected = 'WhereIterable<int> ()';
      expect(dumper.dump(iterable), equals(expected));
    });
  });
}
