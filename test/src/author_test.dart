part of akismet.tests;

/// Tests the features of [Author] class.
class AuthorTest {

  /// Runs the unit tests.
  void run() {
    group('Author', () {
      group('fromJson()', testFromJson);
      group('toJson()', testToJson);
    });
  }

  /// Tests the [Author.fromJson] constructor.
  void testFromJson() {
    test('Empty instance', () {
      var author=new Author.fromJson(JSON.decode('{}'));
      expect(author.email, isNull);
      expect(author.url, isNull);
    });

    test('Non-empty instance', () {
      var author=new Author.fromJson(JSON.decode('{"email":"cedric@belin.io","url":"http://belin.io"}'));
      expect(author.email, 'cedric@belin.io');
      expect(author.url, Uri.parse('http://belin.io'));
    });
  }

  /// Tests the [Author.toJson] method.
  void testToJson() {
    test('Empty instance', () {
      expect(JSON.encode(new Author()), '{}');
    });

    test('Non-empty instance', () {
      var author=new Author('Cédric Belin', 'cedric@belin.io')
        ..ipAddress='88.174.21.31'
        ..url=Uri.parse('http://belin.io');

      expect(JSON.encode(author), '{"email":"cedric@belin.io","ipAddress":"88.174.21.31","name":"Cédric Belin","url":"http://belin.io"}');
    });
  }
}
