/// Unit tests of the package.
library akismet.tests.core;

import 'dart:convert';
import 'dart:mirrors' hide Comment;
import 'package:akismet/core.dart';
import 'package:unittest/unittest.dart';

part 'src/author_test.dart';
part 'src/client_test.dart';
part 'src/comment_test.dart';

/// Runs the unit tests.
void main() {
  groupSep='.';
  new AuthorTest().run();
  new CommentTest().run();
}
