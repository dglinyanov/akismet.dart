part of akismet.tests.io;

/// Tests the features of [Client] class.
class ClientTest {

  /// The client used to query the service database.
  Client _client;

  /// Runs the unit tests.
  void run() {
    setUp(() {
      _client=new Client('8b8d8d8c375d', 'http://your.url.here.com');
    });

    group('Client', () {
      skip_test('checkComment()', testCheckComment); // TODO: uncomment this test when it will be reliable
      test('submitHam()', testSubmitHam);
      test('submitSpam()', testSubmitSpam);
      test('verifyKey()', testVerifyKey);
    });
  }

  /// Tests the [Client.checkComment] method.
  void testCheckComment() {
    var author=new Author('Cédric Belin')
      ..ipAddress='127.0.0.1'
      ..userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71';

    var comment=new Comment('Hey, I\'m testing out the Service API!', author)
      ..type=CommentType.COMMENT;

    expect(_client.checkComment(comment), completion(isFalse));

    author=new Author('viagra-test-123', 'viagra-test-123@fake-url.com')
      ..ipAddress='147.202.45.202'
      ..url=Uri.parse('http://fake-url.com')
      ..userAgent='Spam Bot/6.6.6';

    var content='VIAGRA SPAM You check this posts everyday incase <a href="http://fake-url.com">find someone</a> needs some help?';
    comment=new Comment(content, author)
      ..type=CommentType.COMMENT;

    expect(_client.checkComment(comment), completion(isTrue));
  }

  /// Tests the [Client.submitHam] method.
  void testSubmitHam() {
    var author=new Author('Cédric Belin')
      ..ipAddress='127.0.0.1'
      ..userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71';

    var comment=new Comment('Hey, I\'m testing out the Service API!', author)
      ..type=CommentType.COMMENT;

    expect(_client.submitHam(comment), completes);
  }

  /// Tests the [Client.submitSpam] method.
  void testSubmitSpam() {
    var author=new Author('viagra-test-123', 'viagra-test-123@fake-url.com')
      ..ipAddress='147.202.45.202'
      ..url=Uri.parse('http://fake-url.com')
      ..userAgent='Spam Bot/6.6.6';

    var content='VIAGRA SPAM You check this posts everyday incase <a href="http://fake-url.com">find someone</a> needs some help?';
    var comment=new Comment(content, author)
      ..type=CommentType.COMMENT;

    expect(_client.submitSpam(comment), completes);
  }

  /// Tests the [Client.verifyKey] method.
  void testVerifyKey() {
    expect(_client.verifyKey(), completion(isTrue));
    expect(new Client('viagra-test-123', 'http://fake-url.com').verifyKey(), completion(isFalse));
    expect(new Client('', '').verifyKey(), throws);
  }
}
