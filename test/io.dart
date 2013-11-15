/// `dart:io` implementation of the unit tests.
library akismet.tests.io;

import 'core.dart' as core;
import 'dart:io';
import 'package:akismet/io.dart';
import 'package:unittest/unittest.dart';

part 'src/io_client_test.dart';

/// Runs the unit tests using the specified command line [arguments].
void main(List<String> arguments) {
  core.main();

  if(arguments.isEmpty) {
    print('You must provide a valid Akismet API key in order to test the Client class.');
    exit(1);
  }

  new ClientTest().run(arguments.first);
}
