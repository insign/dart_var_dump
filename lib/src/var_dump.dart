import 'dart:io';

import 'package:all_exit_codes/all_exit_codes.dart';
import 'dart:mirrors';
import 'package:var_dump/var_dump.dart';

int level = 0;

/// Dump the variable to the console
///
/// Parameters:
/// - [obj]: The variable to dump
/// - [colorize]: Whether to colorize the output
void dump(dynamic obj, {bool colorize = true}) {
  // prints to stderr to avoid messing up stdout
  stderr.writeln(analyse(obj, colorize: colorize));
}

/// Dump the variable to the console
/// Alias for [dump]
/// Parameters:
/// - [obj]: The variable to dump
/// - [colorize]: Whether to colorize the output
// ignore: non_constant_identifier_names
void var_dump(dynamic obj, {bool colorize = true}) {
  dump(obj, colorize: colorize);
}

/// Dump the variable to the console and exit with success
///
/// Parameters:
/// - [obj]: The variable to dump
/// - [colorize]: Whether to colorize the output
Never dd(dynamic obj, {bool colorize = true}) {
  dump(obj, colorize: colorize);
  exit(success);
}

/// Analyse the variable and return it as a string
///
/// Parameters:
/// - [obj]: The variable to analyse
/// - [colorize]: Whether to colorize the output
String analyse(dynamic obj, {bool colorize = true}) {
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
    return '$nullColor$obj$noColor';
  }

  if (obj is String) {
    out = '"$strColor$obj$noColor"';
    return out;
  }

  if (obj is num) {
    out = '$numberColor$obj$noColor';
    return out;
  }

  if (obj is bool) {
    out = '$boolColor$obj$noColor';
    return out;
  }

  if (obj is Enum) {
    out = '$enumColor${obj.toString()}$noColor (enum)';
    return out;
  }

  if (obj is Map) {
    out += '$mapColor${obj.runtimeType}$noColor {\n';
    level++;
    obj.forEach((key, value) {
      out += '  ' * level;
      out += '$keyColor$key$noColor: ${analyse(value, colorize: colorize)}\n';
    });
    out += '  ' * (level - 1);
    out += '}$noColor';
    level--;
    return out;
  }

  if (obj is List) {
    out += '$listColor${obj.runtimeType}$noColor [\n';
    level++;
    for (var value in obj) {
      out += '  ' * level;
      out += '${analyse(value, colorize: colorize)}\n';
    }
    out += '  ' * (level - 1);
    out += ']$noColor';
    level--;
    return out;
  }

  if (obj is Set) {
    out += '$setColor${obj.runtimeType}$noColor {\n';
    level++;
    for (var value in obj) {
      out += '  ' * level;
      out += '${analyse(value, colorize: colorize)}\n';
    }
    out += '  ' * (level - 1);
    out += '}$noColor';
    level--;
    return out;
  }

  if (obj is Function) {
    out = '$funcColor${obj.runtimeType}$noColor';
    return out;
  }

  if (obj is Symbol) {
    out = '$objColor$obj$noColor ';
    return out;
  }

  if (obj is Uri) {
    out = '$linkColor$obj$noColor';
    return out;
  }

  if (obj is Object && obj is! Type) {
    ClassMirror classMirror = reflect(obj).type;
    Map<String, dynamic> fields = {};

    for (var declaration in classMirror.declarations.values) {
      if (declaration is VariableMirror) {
        try {
          fields[MirrorSystem.getName(declaration.simpleName)] =
              reflect(obj).getField(declaration.simpleName).reflectee;
        } on ArgumentError catch (_) {
          fields[MirrorSystem.getName(declaration.simpleName)] =
              '(unavailable)';
        }
      }
    }

    out += '$objColor${obj.runtimeType}$noColor {\n';
    level++;

    fields.forEach((name, value) {
      String key = '"$keyColor$name$noColor"';
      level++;
      out += '  ' * level;
      out += '$key: ${analyse(value, colorize: colorize)}\n';
      level--;
    });
    out += '  ' * (level - 1);
    out += '$noColor}';
    level--;
    return out;
  }

  if (obj is Type) {
    out = '($objColor$obj$noColor)';
    return out;
  }

  return "***$out***";
}
