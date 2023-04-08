import 'package:test/test.dart';
import 'package:var_dump/var_dump.dart';

void main() {
  group('dump()', () {
    test('should return a string representation of the variable', () {
      final String obj = 'Hello, world!';
      final String expected = '"${darkYellow}Hello, world!\u001b[0m"';
      final String result = analyse(obj, colorize: true);
      expect(result, equals(expected));
    });
  });

  group('analyse()', () {
    test('should return a string representation of the variable', () {
      final dynamic obj = {'name': 'John', 'age': 30};
      final String expected = '\x1B[38;5;28m_Map<String, Object>\x1B[0m {\n'
          '  \x1B[38;5;197mname\x1B[0m: "\x1B[38;5;136mJohn\x1B[0m"\n'
          '  \x1B[38;5;197mage\x1B[0m: \x1B[38;5;124m\x1B[1m30\x1B[0m\n'
          '}\x1B[0m';
      final String result = analyse(obj, colorize: true);
      expect(result, equals(expected));
    });

    test('should return a string representation of null', () {
      final dynamic obj = null;
      final String expected = 'null';
      final String result = analyse(obj, colorize: false);
      expect(result, equals(expected));
    });
  });
}
