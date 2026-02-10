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
    final buffer = StringBuffer();
    _dump(obj, buffer);
    return buffer.toString();
  }

  void _dump(dynamic obj, StringBuffer buffer) {
    if (obj != null && _visited.contains(obj)) {
      buffer.write('*RECURSION*');
      return;
    }
    if (obj != null) {
      _visited.add(obj);
    }

    if (obj == null) {
      buffer.write('$_nullColor'
          'null'
          '$_noColor');
      return;
    }

    try {
      if (obj is String) {
        buffer.write('"$_strColor$obj$_noColor"');
        return;
      }

      if (obj is num) {
        buffer.write('$_numberColor$obj$_noColor');
        return;
      }

      if (obj is bool) {
        buffer.write('$_boolColor$obj$_noColor');
        return;
      }

      if (obj is Enum) {
        buffer.write('$_enumColor${obj.toString()}$_noColor (enum)');
        return;
      }

      if (obj is Map) {
        buffer.write(
            '$_mapColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n');
        _level++;
        obj.forEach((key, value) {
          buffer.write('  ' * _level);
          buffer.write('$_keyColor$key$_noColor: ');
          _dump(value, buffer);
          buffer.write('\n');
        });
        buffer.write('  ' * (_level - 1));
        buffer.write('}');
        _level--;
        return;
      }

      if (obj is List) {
        buffer.write(
            '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor [\n');
        _level++;
        for (var i = 0; i < obj.length; i++) {
          buffer.write('  ' * _level);
          buffer.write('$_numberColor$i$_noColor: ');
          _dump(obj[i], buffer);
          buffer.write('\n');
        }
        buffer.write('  ' * (_level - 1));
        buffer.write(']');
        _level--;
        return;
      }

      if (obj is Set) {
        buffer.write(
            '$_setColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n');
        _level++;
        for (var value in obj) {
          buffer.write('  ' * _level);
          _dump(value, buffer);
          buffer.write('\n');
        }
        buffer.write('  ' * (_level - 1));
        buffer.write('}');
        _level--;
        return;
      }

      if (obj is Function) {
        buffer.write('$_funcColor${obj.runtimeType}$_noColor');
        return;
      }

      if (obj is Symbol) {
        buffer.write('$_objColor$obj$_noColor ');
        return;
      }

      if (obj is Uri) {
        buffer.write('$_linkColor$obj$_noColor');
        return;
      }

      if (obj is Object && obj is! Type) {
        Map<String, dynamic>? json;
        try {
          json = (obj as dynamic).toJson();
        } catch (e) {
          // ignore
        }

        if (json != null) {
          buffer.write(
              '$_objColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n');
          _level++;
          json.forEach((key, value) {
            buffer.write('  ' * _level);
            buffer.write('$_keyColor"$key"$_noColor: ');
            _dump(value, buffer);
            buffer.write('\n');
          });
          buffer.write('  ' * (_level - 1));
          buffer.write('}');
          _level--;
        } else {
          buffer.write('$_objColor${obj.toString()}$_noColor');
        }
        return;
      }

      if (obj is Type) {
        buffer.write('($_objColor$obj$_noColor)');
        return;
      }

      return;
    } finally {
      if (obj != null) {
        _visited.remove(obj);
      }
    }
  }
}
