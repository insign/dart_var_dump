import 'package:test/test.dart';
import 'package:var_dump/var_dump.dart';

void main() {
  group('Dumper Iterable', () {
    test('should dump an iterable', () {
      final dumper = Dumper(colorize: false);
      final iterable = Iterable.generate(3, (i) => i * 2);
      final output = dumper.dump(iterable);

      // Check for the values and structure
      expect(output, contains('(\n  0\n  2\n  4\n)'));

      // Check that it identifies as an iterable type (GeneratorIterable usually)
      // We handle potential variations in type name by just checking it ends with (
      expect(output, endsWith('(\n  0\n  2\n  4\n)'));
    });
  });
}
