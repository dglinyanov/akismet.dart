/// `dart:io` implementation of the package.
/// Import this library in console applications.
library akismet.io;

import 'core.dart' as core;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';

export 'core.dart' hide Client;

part 'src/io_client.dart';
part 'src/server.dart';
