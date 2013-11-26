#!/usr/bin/env dart

/// Generate the API reference.
import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Absolute path of the package directory.
final String _root=path.normalize(path.join(path.dirname(Platform.script.toFilePath()), '..'));

/// Object used to parse command line argments.
final ArgParser _parser=new ArgParser()
  ..addOption('out', abbr: 'o', defaultsTo: path.join(_root, 'doc', 'api'), help: 'Generate files into the specified directory.')
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false);

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  try {
    var results=_parser.parse(arguments);
    return results['help'] ? printUsage() : writeDocs(results['out']);
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
    ..writeln('Generate the API reference.')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('    $script [options]')
    ..writeln()
    ..writeln('Options:')
    ..write(_parser.getUsage());

  print(buffer);
}

/// Generates the API reference into the specified [outputDirectory].
void writeDocs(String outputDirectory) {
  print('Generating the API reference...');

  if(!Platform.environment.containsKey('DART_SDK')) {
    print('Unable to locate "dartdoc" program: DART_SDK environment variable not set.');
    exit(2);
  }

  var args=[
    '--include-lib',
    'akismet.core,akismet.html,akismet.io,http_server,route.url_pattern',
    '--link-api',
    '--package-root',
    path.join(_root, 'packages'),
    '--out',
    outputDirectory,
    path.join(_root, 'lib', 'html.dart'),
    path.join(_root, 'lib', 'io.dart')
  ];

  print('Run: dartdoc ${args.join(' ')}');
  Process.start(path.join(Platform.environment['DART_SDK'], 'bin', 'dartdoc'), args)
    .then((process) {
      process.stderr.pipe(stderr);
      process.stdout.pipe(stdout);
      process.exitCode.then((exitCode) => exit(exitCode));
    })
    .catchError((error) {
      print(error);
      exit(3);
    });
}
