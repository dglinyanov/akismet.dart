part of akismet.tests;

/// Tests the features of [Comment] class.
class CommentTest {

  /// Runs the unit tests.
  void run() {
    group('Comment', () {
      test('fromJson()', testFromJson);
      test('toJson()', testToJson);
    });
  }

  /// Tests the [Comment.fromJson] constructor.
  void testFromJson() {
    var comment=new Comment.fromJson(JSON.decode('{}'));
    expect(comment.author, isNull);
    expect(comment.content, isNull);
    expect(comment.referrer, isNull);

    comment=new Comment.fromJson(JSON.decode('{ "author": { "name": "Cédric Belin" }, "content": "A user comment.", "referrer": "http://belin.io" }'));
    expect(comment.author, new isInstanceOf<Author>());
    expect(comment.author.name, equals('Cédric Belin'));
    expect(comment.content, equals('A user comment.'));
    expect(comment.referrer, equals(Uri.parse('http://belin.io')));
  }

  /// Tests the [Comment.toJson] method.
  void testToJson() {
    var comment=new Comment();
    expect(JSON.encode(comment), equals('{}'));

    comment=new Comment('A user comment.', new Author('Cédric Belin'))
      ..referrer=Uri.parse('http://belin.io');

    expect(JSON.encode(comment), equals('{"author":{"name":"Cédric Belin"},"content":"A user comment.","referrer":"http://belin.io"}'));
  }
}
