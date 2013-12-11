/// Prevent comment spam using [Akismet](https://akismet.com) service.
library akismet.core;

import 'dart:async';
import 'package:route/url_pattern.dart';

part 'src/core/author.dart';
part 'src/core/client.dart';
part 'src/core/comment.dart';
part 'src/core/end_points.dart';
part 'src/core/http_headers.dart';

/// The version number of the package.
const String VERSION='0.2.1';
