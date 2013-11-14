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
    expect(comment.type, isNull);

    comment=new Comment.fromJson(JSON.decode('{ "comment_author": "Cédric Belin", "comment_content": "A user comment.", "comment_type": "trackback", "referrer": "http://belin.io" }'));
    expect(comment.author, new isInstanceOf<Author>());
    expect(comment.author.name, equals('Cédric Belin'));
    expect(comment.content, equals('A user comment.'));
    expect(comment.referrer, equals(Uri.parse('http://belin.io')));
    expect(comment.type, equals(CommentType.TRACKBACK));
  }

  /// Tests the [Comment.toJson] method.
  void testToJson() {
    var comment=new Comment();
    expect(JSON.encode(comment), equals('{}'));

    comment=new Comment('A user comment.', new Author('Cédric Belin'))
      ..referrer=Uri.parse('http://belin.io')
      ..type=CommentType.PINGBACK;

    expect(JSON.encode(comment), equals('{"comment_author":"Cédric Belin","comment_content":"A user comment.","comment_type":"pingback","referrer":"http://belin.io"}'));
  }
}
