import 'package:var_dump/src/colors.dart';

class Dumper {
  Dumper({this.colorize = true});

  final bool colorize;
  int _level = 0;
  final _visited = Set<dynamic>.identity();
  final _buffer = StringBuffer();

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
    _buffer.clear();
    _visited.clear();
    _level = 0;
    _dump(obj);
    return _buffer.toString();
  }

  void _dump(dynamic obj) {
    if (obj != null && _visited.contains(obj)) {
      _buffer.write('*RECURSION*');
      return;
    }
    if (obj != null) {
      _visited.add(obj);
    }

    if (obj == null) {
      _buffer.write(
        '$_nullColor'
        'null'
        '$_noColor',
      );
      return;
    }

    try {
      if (obj is String) {
        _buffer.write('"$_strColor$obj$_noColor"');
        return;
      }

      if (obj is num) {
        _buffer.write('$_numberColor$obj$_noColor');
        return;
      }

      if (obj is bool) {
        _buffer.write('$_boolColor$obj$_noColor');
        return;
      }

      if (obj is Enum) {
        _buffer.write('$_enumColor${obj.toString()}$_noColor (enum)');
        return;
      }

      if (obj is Function) {
        _buffer.write('$_funcColor${obj.runtimeType}$_noColor');
        return;
      }

      if (obj is Symbol) {
        _buffer.write('$_objColor$obj$_noColor ');
        return;
      }

      if (obj is Uri) {
        _buffer.write('$_linkColor$obj$_noColor');
        return;
      }

      if (obj is Type) {
        _buffer.write('($_objColor$obj$_noColor)');
        return;
      }

      if (obj is Map) {
        if (obj.isEmpty) {
          _buffer.write(
            '$_mapColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {}',
          );
          return;
        }
        _buffer.write(
          '$_mapColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n',
        );
        _level++;
        obj.forEach((key, value) {
          _buffer.write('  ' * _level);
          _buffer.write('$_keyColor$key$_noColor: ');
          _dump(value);
          _buffer.write('\n');
        });
        _buffer.write('  ' * (_level - 1));
        _buffer.write('}');
        _level--;
        return;
      }

      if (obj is List) {
        if (obj.isEmpty) {
          _buffer.write(
            '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor []',
          );
          return;
        }
        _buffer.write(
          '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor [\n',
        );
        _level++;
        for (var i = 0; i < obj.length; i++) {
          _buffer.write('  ' * _level);
          _buffer.write('$_numberColor$i$_noColor: ');
          _dump(obj[i]);
          _buffer.write('\n');
        }
        _buffer.write('  ' * (_level - 1));
        _buffer.write(']');
        _level--;
        return;
      }

      if (obj is Set) {
        if (obj.isEmpty) {
          _buffer.write(
            '$_setColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {}',
          );
          return;
        }
        _buffer.write(
          '$_setColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n',
        );
        _level++;
        for (var value in obj) {
          _buffer.write('  ' * _level);
          _dump(value);
          _buffer.write('\n');
        }
        _buffer.write('  ' * (_level - 1));
        _buffer.write('}');
        _level--;
        return;
      }

      if (obj is Iterable) {
        if (obj.isEmpty) {
          _buffer.write(
            '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor ()',
          );
          return;
        }
        _buffer.write(
          '$_listColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor (\n',
        );
        _level++;
        for (var value in obj) {
          _buffer.write('  ' * _level);
          _dump(value);
          _buffer.write('\n');
        }
        _buffer.write('  ' * (_level - 1));
        _buffer.write(')');
        _level--;
        return;
      }

      if (obj is Object) {
        dynamic json;
        dynamic toJsonMethod;
        try {
          toJsonMethod = (obj as dynamic).toJson;
        } on NoSuchMethodError {
          // ignore
        }

        if (toJsonMethod is Function) {
          json = toJsonMethod();
          if (json is Map) {
            if (json.isEmpty) {
              _buffer.write(
                '$_objColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {}',
              );
              return;
            }
            _buffer.write(
              '$_objColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor {\n',
            );
            _level++;
            json.forEach((key, value) {
              _buffer.write('  ' * _level);
              _buffer.write('$_keyColor"$key"$_noColor: ');
              _dump(value);
              _buffer.write('\n');
            });
            _buffer.write('  ' * (_level - 1));
            _buffer.write('}');
            _level--;
            return;
          } else {
            _buffer.write('$_objColor${obj.runtimeType.toString().replaceAll('_', '')}$_noColor ');
            _dump(json);
            return;
          }
        }

        _buffer.write('$_objColor${obj.toString()}$_noColor');
        return;
      }

      _buffer.write('***${obj.toString()}***');
    } finally {
      if (obj != null) {
        _visited.remove(obj);
      }
    }
  }
}
