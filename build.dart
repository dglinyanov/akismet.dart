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
  ..addFlag('machine', help: 'Print rich JSON messages to the standard output.', negatable: false)
  ..addFlag('clean', abbr: 'c', help: 'Delete all generated files and reset any saved state.', negatable: false)
  ..addFlag('full', abbr: 'f', help: 'Perform a full build.', negatable: false)
  ..addFlag('deploy', abbr: 'd', help: 'Create the files needed to deploy the application to a server.', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false);

/// Absolute path of the package directory.
final String _root=path.dirname(Platform.script.toFilePath());

/// Performs a full build.
void buildPackage() {
  _echo('Building the package...');

  var entryPoint=path.join(_root, 'test', 'html_test.dart');
  _writeScripts(entryPoint, path.dirname(entryPoint), format: 'js');
}

/// Deletes all generated files and reset any saved state.
void cleanPackage() {
  _echo('Cleaning the package...');

  // Remove build directory.
  var directory=new Directory(path.join(_root, 'build'));
  if(directory.existsSync()) {
    _echo('Delete directory: ${directory.path}');
    directory.deleteSync(recursive: true);
  }

  // Remove minified JavaScript.
  var entryPoint=path.join(_root, 'test', 'html_test.dart');
  for(final asset in [ '$entryPoint.js', '$entryPoint.js.deps', '$entryPoint.js.map', '$entryPoint.precompiled.js' ]) {
    var file=new File(asset);
    if(file.existsSync()) {
      _echo('Delete file: ${file.path}');
      file.deleteSync();
    }
  }
}

/// Creates the files needed to deploy the application to a server.
void deployPackage() {
  _echo('Deploying the package...');

  var output=new Directory(path.join(_root, 'build'));
  if(!output.existsSync()) {
    _echo('Create directory: ${output.path}');
    output.createSync(recursive: true);
  }

  // Copy assets.
  var srcFile=new File(path.join(_root, 'test', 'index.html'));
  var dstFile=new File(path.join(output.path, path.basename(srcFile.path)));

  _echo('Copy file: ${srcFile.path} => ${dstFile.path}');
  dstFile.writeAsStringSync(srcFile.readAsStringSync());

  // Generate minified JavaScript.
  buildPackage();

  var entryPoint=path.join(_root, 'test', 'html_test.dart');
  srcFile=new File('$entryPoint.precompiled.js');
  dstFile=new File(path.join(output.path, path.basename(entryPoint)+'.js'));

  _echo('Copy file: ${srcFile.path} => ${dstFile.path}');
  dstFile.writeAsStringSync(srcFile.readAsStringSync());

  // Generate minified Dart.
  _writeScripts(entryPoint, output.path, format: 'dart');
}

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  if(arguments.isEmpty) return printUsage();

  try {
    var results=_parser.parse(arguments);
    _machineInterface=results['machine'];

    if(results['clean']) return cleanPackage();
    if(results['deploy']) return deployPackage();
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
  if(!_machineInterface) return print(method=='info' ? message : '[$file:$line] $message');

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
void _writeScripts(String entryPoint, String outputDirectory, { format: 'js' }) {
  if(!Platform.environment.containsKey('DART_SDK')) {
    _echo('Unable to locate "dart2js" program: DART_SDK environment variable not set.', method: 'error');
    exit(2);
  }

  var script=path.basename(entryPoint);
  if(format!='dart') script+='.$format';

  var args=[
    '--minify',
    '--package-root='+path.join(_root, 'packages'),
    '--out=$outputDirectory/$script',
    entryPoint
  ];

  if(format=='dart') args.add('--output-type=dart');
  _echo('Run: dart2js ${args.join(' ')}');

  var result=Process.runSync(path.join(Platform.environment['DART_SDK'], 'bin', 'dart2js'), args);
  if(result.exitCode!=0) {
    _echo(result.stderr.length>0 ? result.stderr : result.stdout, method: 'error');
    exit(3);
  }

  _echo(result.stdout);

  /* TODO
  Process.start(path.join(Platform.environment['DART_SDK'], 'bin', 'dart2js'), args)
    .then((process) {
      process.stderr.pipe(stderr);
      process.stdout.pipe(stdout);
      process.exitCode.then((exitCode) => exit(exitCode));
    })
    .catchError((error) {
      _echo(error.toString(), method: 'error');
      exit(3);
    });*/
}
