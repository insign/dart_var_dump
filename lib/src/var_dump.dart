import 'dart:io';

import 'package:all_exit_codes/all_exit_codes.dart';
import 'package:var_dump/src/dumper.dart';

/// Dump the variable to the console
///
/// Parameters:
/// - [obj]: The variable to dump
/// - [colorize]: Whether to colorize the output
void dump(dynamic obj, {bool colorize = true}) {
  final dumper = Dumper(colorize: colorize);
  // prints to stderr to avoid messing up stdout
  stderr.writeln(dumper.dump(obj));
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