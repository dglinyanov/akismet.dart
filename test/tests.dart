/// Unit tests of the [Akismet.dart](https://github.com/cedx/akismet.dart) package.
library akismet.tests;

import 'dart:convert';
import 'package:akismet/core.dart';
import 'package:unittest/unittest.dart';

part 'src/author_test.dart';
part 'src/comment_test.dart';

/// Runs the unit tests.
void main() {
  groupSep='.';

  print('# AuthorTest');
  new AuthorTest().run();

  print('# CommentTest');
  new CommentTest().run();
}
