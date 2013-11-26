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

/// Starts the application using the specified command line [arguments].
void main(List<String> arguments) {
  try {
    var results=_parser.parse(arguments);
    return results['help'] ? printUsage() : startServer(results['address'], int.parse(results['port']));
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
    ..writeln('Akismet.dart Server.')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('    $script [options]')
    ..writeln()
    ..writeln('Options:')
    ..write(_parser.getUsage());

  print(buffer);
}

/// Starts a [Server] listening for HTTP requests on the specified [address] and [port].
/// The [address] can either be a [String] or an [InternetAddress].
void startServer(address, int port) {
  var server=new Server();
  server.start(address, port).then((_) {
    var now=new DateTime.now();
    print('[$now] Server started on http://${server.address.address}:${server.port}.');
  });
}
