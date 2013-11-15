/// `dart:io` implementation of the package.
/// Import this library in console applications.
library akismet.io;

import 'core.dart' as core;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

export 'core.dart' hide Client;
part 'src/io_client.dart';