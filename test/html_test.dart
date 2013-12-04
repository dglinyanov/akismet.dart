/// `dart:html` implementation of the unit tests.
library akismet.tests.html;

import 'core_test.dart' as core;
import 'dart:html';
import 'dart:js';
import 'package:akismet/html.dart';
import 'package:unittest/html_enhanced_config.dart';

/// Runs the unit tests.
void main() {
  useHtmlEnhancedConfiguration();

  var $=context['jQuery'].apply;
  $([ '[data-toggle="tooltip"]' ]).callMethod('tooltip');

  var button=(querySelector('#btn-submit') as ButtonElement);
  button.onClick.listen((event) {
    event.preventDefault();
    for(var element in querySelectorAll('#form-unit-tests > .form-group')) element.classes.remove('has-error');

    var blog=(querySelector('#blog-url') as InputElement);
    blog.value=blog.value.trim();
    if(blog.value.length==0) blog.value='http://akismet.belin.io';

    var serviceUrl=(querySelector('#service-url') as InputElement);
    serviceUrl.value=serviceUrl.value.trim();
    if(serviceUrl.value.length==0) serviceUrl.value='http://api.belin.io:3019';

    var apiKey=(querySelector('#api-key') as InputElement);
    apiKey.value=apiKey.value.trim();
    if(apiKey.value.length==0) {
      apiKey.parent.parent.classes.add('has-error');
      apiKey.focus();
      return window.alert('You must provide a valid Akismet API key in order to run the unit tests.');
    }

    core.main();
    var client=new Client(apiKey.value, Uri.parse(blog.value))..serviceUrl=Uri.parse(serviceUrl.value);
    new core.ClientTest(client).run();
  });
}
