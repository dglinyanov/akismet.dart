#!/usr/bin/env dart

/// Command line interface.
import 'dart:io';
import 'package:akismet/io.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Object used to parse command line argments.
final ArgParser _parser=new ArgParser()
  ..addOption('address', abbr: 'a', defaultsTo: '0.0.0.0', help: 'The address to which to listen.')
  ..addOption('port', abbr: 'p', defaultsTo: '8080', help: 'The port on which to listen.')
  ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false);

/// Prints the usage information.
void help() {
  var script=path.basename(Platform.script.toFilePath());
  var buffer=new StringBuffer()
    ..writeln('Akismet.dart Server.')
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
  // Parse the command line arguments.
  ArgResults results;
  try { results=_parser.parse(arguments); }

  on FormatException catch(e) {
    print(e.message);
    exit(1);
  }

  // Print the help whether required.
  if(results['help']) return help();

  // Start the server.
  var server=new Server(results['address'], int.parse(results['port']));
  server.start().then((_) {
    var now=new DateTime.now();
    print('[$now] Server started on http://${server.address}:${server.port}.');
  });
}
