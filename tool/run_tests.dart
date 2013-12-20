#!/usr/bin/env dart

/// Run the unit tests.
library akismet.tools.run_tests;

import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../test/io_test.dart' as unitTests;

/// Object used to parse command line argments.
final ArgParser _parser=new ArgParser()
  ..addOption('key', abbr: 'k', help: 'The Akismet API key.')
  ..addOption('blog', abbr: 'b', defaultsTo: 'https://github.com/cedx/akismet.dart', help: 'The front page or home URL.')
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false);

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  if(arguments.isEmpty) return printUsage();

  try {
    var results=_parser.parse(arguments);
    if(results['help']) return printUsage();
    if(results['key']!=null) return runTests(results['key'], Uri.parse(results['blog']));

    print('You must provide a valid Akismet API key in order to run the unit tests.');
    exit(2);
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
    ..writeln('Run the unit tests.')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('    $script [options]')
    ..writeln()
    ..writeln('Options:')
    ..write(_parser.getUsage());

  print(buffer);
}

/// Runs the unit tests using the specified Akismet [apiKey] and [blog] URL.
void runTests(String apiKey, Uri blog) {
  print('Running the unit tests...');
  unitTests.main([ apiKey, blog.toString() ]);
}
