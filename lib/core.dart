/// Prevent comment spam using [Akismet](https://akismet.com) service.
library akismet.core;

import 'dart:async';
import 'package:route/url_pattern.dart';

part 'src/author.dart';
part 'src/client.dart';
part 'src/comment.dart';

/// The name of the current package.
const String PACKAGE_NAME='Akismet.dart';

/// The version of the current package.
const String PACKAGE_VERSION='0.2.1';
