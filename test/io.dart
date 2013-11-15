/// `dart:io` implementation of the unit tests.
library akismet.tests.io;

import 'core.dart' as core;
import 'package:akismet/io.dart';
import 'package:unittest/unittest.dart';

part 'src/io_client_test.dart';

/// Runs the unit tests.
void main() {
  core.main();
  new ClientTest().run();
}
