/// `dart:html` implementation of the unit tests.
library akismet.tests.html;

import 'core_test.dart' as core;
import 'dart:html';
import 'package:akismet/html.dart';
import 'package:unittest/html_enhanced_config.dart';

/// Runs the unit tests.
void main() {
  useHtmlEnhancedConfiguration();

  print(window.location.host);

  var button=(querySelector('#submit') as ButtonElement);
  button.onClick.listen((event) {
    var apiKey=(querySelector('#key') as InputElement).value.trim();
    if(apiKey.length==0) return window.alert('You must provide a valid Akismet API key in order to test the package.');

    core.main();
    var client=new Client(apiKey, Uri.parse('https://github.com/cedx/akismet.dart'));
    new core.ClientTest(client).run();
  });
}
