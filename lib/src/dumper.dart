import 'package:var_dump/src/colors.dart';

class Dumper {
  Dumper({this.colorize = true});

  final bool colorize;
  int _level = 0;
  final _visited = Set<dynamic>.identity();

  late final String _noColor = colorize ? reset : '';
  late final String _keyColor = colorize ? pink : '';
  late final String _strColor = colorize ? darkYellow : '';
  late final String _boolColor = colorize ? yellow + italic + bold : '';
  late final String _numberColor = colorize ? darkRed + bold : '';
  late final String _nullColor = colorize ? orange + bold + italic : '';
  late final String _objColor = colorize ? darkGreen : '';
  late final String _linkColor = colorize ? lightBlue + underline : '';
  late final String _funcColor = colorize ? blue : '';
  late final String _listColor = colorize ? lightGreen : '';
  late final String _setColor = colorize ? lightMagenta : '';
  late final String _mapColor = colorize ? lightCyan : '';
  late final String _enumColor = colorize ? lightYellow : '';

  String dump(dynamic obj) {
    if (obj != null && _visited.contains(obj)) {
      return '*RECURSION*';
    }
    if (obj != null) {
      _visited.add(obj);
    }

    if (obj == null) {
      return '$_nullColor'
          'null'
          '$_noColor';
    }

    try {
      if (obj is String) {
        return '"$_strColor$obj$_noColor"';
      }

      if (obj is num) {
        return '$_numberColor$obj$_noColor';
      }

      if (obj is bool) {
        return '$_boolColor$obj$_noColor';
      }

      if (obj is Enum) {
        return '$_enumColor${obj.toString()}$_noColor (enum)';
      }

      if (obj is Function) {
        return '$_funcColor${obj.runtimeType}$_noColor';
      }

      if (obj is Symbol) {
        return '$_objColor$obj$_noColor ';
      }

      if (obj is Uri) {
        return '$_linkColor$obj$_noColor';
      }

      if (obj is Type) {
        return '($_objColor$obj$_noColor)';
      }

      final StringBuffer out = StringBuffer();

      if (obj is Map) {
        out.write(
            '$_mapColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n');
        _level++;
        obj.forEach((key, value) {
          out.write('  ' * _level);
          out.write('$_keyColor$key$_noColor: ${dump(value)}\n');
        });
        out.write('  ' * (_level - 1));
        out.write('}');
        _level--;
        return out.toString();
      }

      if (obj is List) {
        out.write(
            '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor [\n');
        _level++;
        for (var i = 0; i < obj.length; i++) {
          out.write('  ' * _level);
          out.write('$_numberColor$i$_noColor: ${dump(obj[i])}\n');
        }
        out.write('  ' * (_level - 1));
        out.write(']');
        _level--;
        return out.toString();
      }

      if (obj is Set) {
        out.write(
            '$_setColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n');
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

      if (obj is Iterable) {
        out.write(
            '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor (\n');
        _level++;
        for (var value in obj) {
          out.write('  ' * _level);
          out.write('${dump(value)}\n');
        }
        out.write('  ' * (_level - 1));
        out.write(')');
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
              '$_objColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n');
          _level++;
          json.forEach((key, value) {
            out.write('  ' * _level);
            out.write('$_keyColor"$key"$_noColor: ${dump(value)}\n');
          });
          out.write('  ' * (_level - 1));
          out.write('}');
          _level--;
          return out.toString();
        } else {
          return '$_objColor${obj.toString()}$_noColor';
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
