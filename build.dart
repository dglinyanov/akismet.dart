#!/usr/bin/env dart

/// Dart build system.
library akismet.build;

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Value indicating whether to print JSON messages to the standard output.
bool _machineInterface=false;

/// Object used to parse command line argments.
final ArgParser _parser=new ArgParser()
  ..addOption('changed', allowMultiple: true, help: 'Specify a file that changed and should be rebuilt.')
  ..addOption('removed', allowMultiple: true, help: 'Specify a file that was removed and might affect the build.')
  ..addFlag('clean', help: 'Delete all generated files and reset any saved state.', negatable: false)
  ..addFlag('full', help: 'Perform a full build.', negatable: false)
  ..addFlag('machine', help: 'Print rich JSON messages to the standard output.', negatable: false)
  ..addFlag('deploy', help: 'Create the files needed to deploy the application to a server.', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false);

/// Absolute path of the package directory.
final String _root=path.dirname(Platform.script.toFilePath());

/// Performs a full build.
void buildPackage() {
  _echo('Building the package...');

  var entryPoints=[ path.join(_root, 'test', 'html_test.dart') ];
  for(final entryPoint in entryPoints) _writeScripts(entryPoint);
}

/// Deletes all generated files and reset any saved state.
void cleanPackage() {
  _echo('Cleaning the package...');

  var entryPoints=[ path.join(_root, 'test', 'html_test.dart') ];
  for(final entryPoint in entryPoints) {
    for(final path in [ '$entryPoint.js', '$entryPoint.js.deps', '$entryPoint.js.map', '$entryPoint.precompiled.js' ]) {
      var file=new File(path);
      file.exists().then((exists) {
        if(exists) {
          _echo('Delete file: $path');
          file.delete();
        }
      });
    }
  }
}

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  if(arguments.isEmpty) return printUsage();

  try {
    var results=_parser.parse(arguments);
    _machineInterface=results['machine'];

    if(results['clean']) return cleanPackage();
    if(results['full']) return buildPackage();
    if(results['help']) return printUsage();
  }

  on FormatException catch(e) {
    _echo(e.message, method: 'error');
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

  _echo(buffer);
}

/// Outputs a [message] to the console.
///
/// See [Dart Editor Build System](https://www.dartlang.org/tools/editor/build.html)
/// for more information about the available parameters.
void _echo(String message, { String method: 'info', String file: 'build.dart', int line: 0, int charStart: -1, int charEnd: -1 }) {
  if(!_machineInterface) return print(method=='info' ? message: '[$file:$line] $message');

  if(method!='info') {
    var params={ 'file': file, 'message': message };
    if(line>0) params['line']=line;
    if(charStart>=0) params['charStart']=charStart;
    if(charEnd>=0) params['charEnd']=charEnd;

    var json=JSON.encode({ 'method': method, 'params': params });
    print('[$json]');
  }
}

/// Generates the client scripts corresponding to the specified [entryPoint] path.
void _writeScripts(String entryPoint) {
  if(!Platform.environment.containsKey('DART_SDK')) {
    _echo('Unable to locate "dart2js" program: DART_SDK environment variable not set.', method: 'error');
    exit(2);
  }

  var args=[
    '--minify',
    '--package-root='+path.join(_root, 'packages'),
    '--out=$entryPoint.js',
    entryPoint
  ];

  _echo('Run: dart2js ${args.join(' ')}');
  Process.start(path.join(Platform.environment['DART_SDK'], 'bin', 'dart2js'), args)
    .then((process) {
      process.stderr.pipe(stderr);
      process.stdout.pipe(stdout);
      process.exitCode.then((exitCode) => exit(exitCode));
    })
    .catchError((error) {
      _echo(error.toString(), method: 'error');
      exit(3);
    });
}
