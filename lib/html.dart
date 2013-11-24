/// `dart:html` implementation of the package.
/// Import this library in console applications.
library akismet.html;

import 'core.dart' as core;
import 'dart:async';
import 'dart:html' hide Comment;

export 'core.dart' hide Client;

part 'src/html_client.dart';
