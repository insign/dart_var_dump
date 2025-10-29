import 'package:var_dump/src/colors.dart';

class Dumper {
  Dumper({this.colorize = true});

  final bool colorize;
  int _level = 0;
  final _visited = <dynamic>{};

  String dump(dynamic obj) {
    if (obj != null && _visited.contains(obj)) {
      return '*RECURSION*';
    }
    if (obj != null) {
      _visited.add(obj);
    }

    String out = '';

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

    if (obj is String) {
      out = '"$strColor$obj$noColor"';
      _visited.remove(obj);
      return out;
    }

    if (obj is num) {
      out = '$numberColor$obj$noColor';
      _visited.remove(obj);
      return out;
    }

    if (obj is bool) {
      out = '$boolColor$obj$noColor';
      _visited.remove(obj);
      return out;
    }

    if (obj is Enum) {
      out = '$enumColor${obj.toString()}$noColor (enum)';
      _visited.remove(obj);
      return out;
    }

    if (obj is Map) {
      out += '$mapColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor {\n';
      _level++;
      obj.forEach((key, value) {
        out += '  ' * _level;
        out += '$keyColor$key$noColor: ${dump(value)}\n';
      });
      out += '  ' * (_level - 1);
      out += '}';
      _level--;
      _visited.remove(obj);
      return out;
    }

    if (obj is List) {
      out += '$listColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor [\n';
      _level++;
      for (var value in obj) {
        out += '  ' * _level;
        out += '${dump(value)}\n';
      }
      out += '  ' * (_level - 1);
      out += ']';
      _level--;
      _visited.remove(obj);
      return out;
    }

    if (obj is Set) {
      out += '$setColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor {\n';
      _level++;
      for (var value in obj) {
        out += '  ' * _level;
        out += '${dump(value)}\n';
      }
      out += '  ' * (_level - 1);
      out += '}';
      _level--;
      _visited.remove(obj);
      return out;
    }

    if (obj is Function) {
      out = '$funcColor${obj.runtimeType}$noColor';
      _visited.remove(obj);
      return out;
    }

    if (obj is Symbol) {
      out = '$objColor$obj$noColor ';
      _visited.remove(obj);
      return out;
    }

    if (obj is Uri) {
      out = '$linkColor$obj$noColor';
      _visited.remove(obj);
      return out;
    }

    if (obj is Object && obj is! Type) {
      out += '$objColor${obj.runtimeType.toString().replaceAll('_', '')}$noColor {\n';
      _level++;
      try {
        final Map<String, dynamic> json = (obj as dynamic).toJson();
        json.forEach((key, value) {
          out += '  ' * _level;
          out += '$keyColor"$key"$noColor: ${dump(value)}\n';
        });
      } catch (e) {
        out += '  ' * _level + '${obj.toString()}\n';
      }
      out += '  ' * (_level - 1);
      out += '}';
      _level--;
      _visited.remove(obj);
      return out;
    }

    if (obj is Type) {
      out = '($objColor$obj$noColor)';
      _visited.remove(obj);
      return out;
    }

    _visited.remove(obj);
    return "***$out***";
  }
}
