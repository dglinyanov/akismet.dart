#!/usr/bin/env dart

/// Dart build system.
library akismet.build;

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:unittest/vm_config.dart';
import 'test/io.dart' as unitTests;

/// Object used to parse command line argments.
final ArgParser _parser=new ArgParser()
  ..addOption('changed', allowMultiple: true, help: 'Specify a file that changed and should be rebuilt.')
  ..addOption('removed', allowMultiple: true, help: 'Specify a file that was removed and might affect the build.')
  ..addFlag('clean', help: 'Delete all generated files and reset any saved state.', negatable: false)
  ..addFlag('machine', help: 'Print rich JSON messages to the standard output.', negatable: false)
  ..addFlag('full', help: 'Perform a full build.', negatable: false)
  ..addFlag('docs', abbr: 'd', help: 'Generate the API reference.', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false)
  ..addFlag('scripts', abbr: 's', help: 'Generate the client scripts.', negatable: false)
  ..addOption('tests', abbr: 't', help: 'Run the unit tests using the specified Akismet API key.');

/// Absolute path of the package directory.
final String _root=path.normalize(path.absolute(path.dirname(Platform.script.toFilePath())));

/// Deletes all generated files and reset any saved state.
void clean() {
  print('Cleaning the package...');

  List directories=[
    '$_root/doc/api'
  ];

  for(final path in directories) {
    Directory directory=new Directory(path);
    directory.exists().then((result) {
      if(result) {
        print('Delete directory: $path');
        directory.delete(recursive: true);
      }
    });
  }

  List files=[
    '$_root/pubspec.lock',
    '$_root/test/html.dart.js',
    '$_root/test/html.dart.js.deps',
    '$_root/test/html.dart.js.map',
    '$_root/test/html.dart.precompiled.js'
  ];

  for(final path in files) {
    File file=new File(path);
    file.exists().then((result) {
      if(result) {
        print('Delete file: $path');
        file.delete();
      }
    });
  }
}

/// Generates the API reference.
void docs() {
  print('Generating the API reference...');

  List args=[
    '--include-lib=akismet.core,akismet.io',
    '--link-api',
    '--package-root=$_root/packages',
    '--no-code',
    '--out=$_root/doc/api'
  ];

  List entryPoints=[
    '$_root/lib/io.dart'
  ];

  args.addAll(entryPoints);
  _run('dartdoc', args);
}

/// Prints the usage information.
void help() {
  String script=path.basename(Platform.script.toFilePath());
  StringBuffer buffer=new StringBuffer()
    ..writeln('Dart build system.')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('    $script [options]')
    ..writeln()
    ..writeln('Options:')
    ..write(_parser.getUsage());

  print(buffer);
}

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  if(arguments.isEmpty) return help();

  // Parse command line arguments.
  ArgResults results;
  try { results=_parser.parse(arguments); }

  on FormatException catch(e) {
    print(e.message);
    exit(1);
  }

  // Handle flags.
  if(results['clean']) return clean();
  if(results['docs']) return docs();
  if(results['help']) return help();
  if(results['scripts']) return scripts();
  if(results['tests']!=null) return tests(results['tests']);
}

/// Generates the client scripts.
void scripts() {
  print('Generating the client scripts...');

  String entryPoint='$_root/test/html.dart';
  String script=path.basename(entryPoint);
  _run('dart2js', [
      '--out=$_root/test/$script.js',
      '--package-root=$_root/packages',
      entryPoint
  ]);
}

/// Runs the unit tests using the specified Akismet API key.
void tests(String apiKey) {
  print('Running the unit tests...');
  useVMConfiguration();
  unitTests.main([ apiKey ]);
}

/// Runs a [command] with the specified [options].
/// Returns a [Future] that completes when the command completes.
Future _run(String command, [ List<String> options ]) {
  Completer completer=new Completer();
  List arguments=[ command ];
  if(options!=null) arguments.addAll(options);

  print('Run: ${arguments.join(' ')}');
  Process
    .start('/usr/bin/env', arguments)
    .then((Process process) {
      process.stdout.pipe(stdout);
      process.stderr.pipe(stderr);
      process.exitCode.then((_) {
        completer.complete();
      });
    });

  return completer.future;
}
