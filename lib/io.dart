/// `dart:io` implementation of the package.
/// Import this library in console applications.
library akismet.io;

import 'core.dart' as core;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// TODO ? export 'core.dart' show Author, Comment;

part 'src/io_client.dart';