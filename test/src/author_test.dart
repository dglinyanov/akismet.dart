part of akismet.tests.core;

/// Tests the features of [Author] class.
class AuthorTest {

  /// Runs the unit tests.
  void run() {
    group('Author', () {
      test('fromJson()', testFromJson);
      test('toJson()', testToJson);
    });
  }

  /// Tests the [Author.fromJson] constructor.
  void testFromJson() {
    var author=new Author.fromJson(JSON.decode('{}'));
    expect(author.email, isNull);
    expect(author.url, isNull);

    author=new Author.fromJson(JSON.decode('{ "comment_author_email": "cedric@belin.io", "comment_author_url": "http://belin.io" }'));
    expect(author.email, equals('cedric@belin.io'));
    expect(author.url, equals(Uri.parse('http://belin.io')));
  }

  /// Tests the [Author.toJson] method.
  void testToJson() {
    var author=new Author();
    expect(JSON.encode(author), equals('{}'));

    author=new Author('Cédric Belin', 'cedric@belin.io')
      ..ipAddress='88.174.21.31'
      ..url=Uri.parse('http://belin.io');

    expect(JSON.encode(author), equals('{"comment_author":"Cédric Belin","comment_author_email":"cedric@belin.io","comment_author_url":"http://belin.io","user_ip":"88.174.21.31"}'));
  }
}
