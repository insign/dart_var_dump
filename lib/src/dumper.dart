import 'package:var_dump/src/colors.dart';

class Dumper {
  Dumper({this.colorize = true});

  final bool colorize;
  int _level = 0;
  final _visited = Set<dynamic>.identity();

  String dump(dynamic obj) {
    if (obj != null && _visited.contains(obj)) {
      return '*RECURSION*';
    }
    if (obj != null) {
      _visited.add(obj);
    }

    final String noColor = colorize ? reset : '';
    final String keyColor = colorize ? pink : '';
    final String strColor = colorize ? darkYellow : '';
    final String boolColor = colorize ? yellow + italic + bold : '';
    final String numberColor = colorize ? darkRed + bold : '';
    final String nullColor = colorize ? orange + bold + italic : '';
    final String objColor = colorize ? darkGreen : '';
    final String linkColor = colorize ? lightBlue + underline : '';
    final String funcColor = colorize ? blue : '';
    final String listColor = colorize ? lightGreen : '';
    final String setColor = colorize ? lightMagenta : '';
    final String mapColor = colorize ? lightCyan : '';
    final String enumColor = colorize ? lightYellow : '';

    if (obj == null) {
      return '$nullColor'
          'null'
          '$noColor';
    }

    try {
      if (obj is String) {
        return '"$strColor$obj$noColor"';
      }

      if (obj is num) {
        return '$numberColor$obj$noColor';
      }

      if (obj is bool) {
        return '$boolColor$obj$noColor';
      }

      if (obj is Enum) {
        return '$enumColor${obj.toString()}$noColor (enum)';
      }

      if (obj is Function) {
        return '$funcColor${obj.runtimeType}$noColor';
      }

      if (obj is Symbol) {
        return '$objColor$obj$noColor ';
      }

      if (obj is Uri) {
        return '$linkColor$obj$noColor';
      }

      if (obj is Type) {
        return '($objColor$obj$noColor)';
      }

      final StringBuffer out = StringBuffer();

      if (obj is Map) {
        out.write(
            '$mapColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor {\n');
        _level++;
        obj.forEach((key, value) {
          out.write('  ' * _level);
          out.write('$keyColor$key$noColor: ${dump(value)}\n');
        });
        out.write('  ' * (_level - 1));
        out.write('}');
        _level--;
        return out.toString();
      }

      if (obj is List) {
        out.write(
            '$listColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor [\n');
        _level++;
        for (var i = 0; i < obj.length; i++) {
          out.write('  ' * _level);
          out.write('$numberColor$i$noColor: ${dump(obj[i])}\n');
        }
        out.write('  ' * (_level - 1));
        out.write(']');
        _level--;
        return out.toString();
      }

      if (obj is Set) {
        out.write(
            '$setColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor {\n');
        _level++;
        for (var value in obj) {
          out.write('  ' * _level);
          out.write('${dump(value)}\n');
        }
        out.write('  ' * (_level - 1));
        out.write('}');
        _level--;
        return out.toString();
      }

      if (obj is Object) {
        Map<String, dynamic>? json;
        try {
          json = (obj as dynamic).toJson();
        } catch (e) {
          // ignore
        }

        if (json != null) {
          out.write(
              '$objColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor {\n');
          _level++;
          json.forEach((key, value) {
            out.write('  ' * _level);
            out.write('$keyColor"$key"$noColor: ${dump(value)}\n');
          });
          out.write('  ' * (_level - 1));
          out.write('}');
          _level--;
          return out.toString();
        } else {
          return '$objColor${obj.toString()}$noColor';
        }
      }

      return "***${out.toString()}***";
    } finally {
      if (obj != null) {
        _visited.remove(obj);
      }
    }
  }
}
