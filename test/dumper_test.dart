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

    test('should dump a set', () {
      final dumper = Dumper(colorize: false);
      final set = {1, 2, 3};
      final expected = 'Set<int> {\n  1\n  2\n  3\n}';
      expect(dumper.dump(set), equals(expected));
    });

    test('should dump a custom iterable', () {
      final dumper = Dumper(colorize: false);
      final iterable = MyIterable();
      final expected = 'MyIterable (\n  1\n  2\n  3\n)';
      expect(dumper.dump(iterable), equals(expected));
    });

    test('should dump map keys', () {
      final dumper = Dumper(colorize: false);
      final map = {'a': 1, 'b': 2};
      final keys = map.keys;
      final dump = dumper.dump(keys);
      expect(dump, contains('Iterable'));
      expect(dump, contains('('));
      expect(dump, contains('  "a"'));
      expect(dump, contains('  "b"'));
      expect(dump, endsWith(')'));
    });
  });
}

class MyIterable extends Iterable<int> {
  @override
  Iterator<int> get iterator => [1, 2, 3].iterator;
}
