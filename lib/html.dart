/// `dart:html` implementation of the package.
/// Import this library in console applications.
library akismet.html;

import 'dart:async';
import 'dart:html' hide Comment;
import 'core.dart' as core;

export 'core.dart' hide Client;

part 'src/html/client.dart';
