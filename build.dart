#!/usr/bin/env dart

/// Dart build system.
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Absolute path of the package directory.
final String _root=path.dirname(Platform.script.toFilePath());

/// Object used to parse command line argments.
final ArgParser _parser=new ArgParser()
  ..addOption('changed', allowMultiple: true, help: 'Specify a file that changed and should be rebuilt.')
  ..addOption('removed', allowMultiple: true, help: 'Specify a file that was removed and might affect the build.')
  ..addFlag('clean', help: 'Delete all generated files and reset any saved state.', negatable: false)
  ..addFlag('machine', help: 'Print rich JSON messages to the standard output.', negatable: false)
  ..addFlag('full', help: 'Perform a full build.', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false);

/// Deletes all generated files and reset any saved state.
void cleanPackage() {
  print('Cleaning the package...');

  var files=[
    '$_root/pubspec.lock',
    '$_root/test/html.dart.js',
    '$_root/test/html.dart.js.deps',
    '$_root/test/html.dart.js.map',
    '$_root/test/html.dart.precompiled.js'
  ];

  for(final path in files) {
    var file=new File(path);
    file.exists().then((result) {
      if(result) {
        print('Delete file: $path');
        file.delete();
      }
    });
  }
}

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  if(arguments.isEmpty) return printUsage();

  try {
    var results=_parser.parse(arguments);
    if(results['clean']) return cleanPackage();
    if(results['help']) return printUsage();
  }

  on FormatException catch(e) {
    print(e.message);
    exit(1);
  }
}

/// Prints the usage information.
void printUsage() {
  var script=path.basename(Platform.script.toFilePath());
  var buffer=new StringBuffer()
    ..writeln('Dart build system.')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('    $script [options]')
    ..writeln()
    ..writeln('Options:')
    ..write(_parser.getUsage());

  print(buffer);
}
