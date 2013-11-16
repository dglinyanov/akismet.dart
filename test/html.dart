/// `dart:html` implementation of the unit tests.
library akismet.tests.html;

import 'core.dart' as core;
import 'dart:html';
import 'dart:js';
import 'package:akismet/html.dart';

/// Runs the unit tests.
void main() {
  var apiKey=context.callMethod('prompt', [ 'Please provide your Akismet API key:' ]);
  if(apiKey==null || apiKey.length==0) return window.alert('You must provide a valid Akismet API key in order to test the package.');

  core.main();
  new core.ClientTest(new Client(apiKey, 'https://github.com/cedx/akismet.dart')).run();
}
