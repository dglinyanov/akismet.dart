/// `dart:io` implementation of the package.
/// Import this library in console applications.
library akismet.io;

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';
import 'core.dart' as core;

export 'core.dart' hide Client;

part 'src/io/client.dart';
part 'src/io/server.dart';
