/// `dart:html` implementation of the unit tests.
library akismet.tests.html;

import 'core_test.dart' as core;
import 'dart:html';
import 'package:akismet/html.dart';
import 'package:unittest/html_enhanced_config.dart';

/// Runs the unit tests.
void main() {
  useHtmlEnhancedConfiguration();

  var apiKey=(querySelector('#apiKey') as InputElement);
  apiKey.focus();

  var button=(querySelector('#runTests') as ButtonElement);
  button.onClick.listen((event) {
    event.preventDefault();

    var blog=(querySelector('#blog') as InputElement);
    blog.value=blog.value.trim();
    if(blog.value.length==0) blog.value='http://akismet.belin.io';

    var serviceUrl=(querySelector('#serviceUrl') as InputElement);
    serviceUrl.value=serviceUrl.value.trim();
    if(serviceUrl.value.length==0) serviceUrl.value='http://belin.io:3019';

    apiKey.value=apiKey.value.trim();
    if(apiKey.value.length==0) return window.alert('You must provide a valid Akismet API key in order to run the unit tests.');

    core.main();
    var client=new Client(apiKey.value, Uri.parse(blog.value))..serviceUrl=Uri.parse(serviceUrl.value);
    new core.ClientTest(client).run();
  });

  button=(querySelector('#visitHomepage') as ButtonElement);
  button.onClick.listen((event) {
    event.preventDefault();
    window.location.href='https://pub.dartlang.org/packages/akismet';
  });
}
