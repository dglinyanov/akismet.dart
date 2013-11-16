/// `dart:io` implementation of the unit tests.
library akismet.tests.io;

import 'core.dart' as core;
import 'dart:io';
import 'package:akismet/io.dart';
import 'package:unittest/vm_config.dart';

/// Runs the unit tests using the specified command line [arguments].
void main(List<String> arguments) {
  useVMConfiguration();

  if(arguments.isEmpty) {
    print('You must provide a valid Akismet API key in order to test the package.');
    exit(1);
  }

  core.main();
  new core.ClientTest(new Client(arguments.first, 'https://github.com/cedx/akismet.dart')).run();
}
