part of akismet.tests.io;

/// Tests the features of [Client] class.
class ClientTest {

  /// The client used to query the service database.
  Client _client;

  /// A comment with content marked as ham.
  Comment _ham;

  /// A comment with content marked as spam.
  Comment _spam;

  /// Runs the unit tests using the specified Akismet API key.
  void run(String apiKey) {
    setUp(() {
      _client=new Client(apiKey, 'https://github.com/cedx/akismet.dart');

      var author=new Author('Akismet.dart')
        ..ipAddress='192.168.0.1'
        ..url=Uri.parse('https://github.com/cedx')
        ..userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71';

      _ham=new Comment('I\'m testing out the Service API.', author)
        ..referrer=Uri.parse('https://pub.dartlang.org/packages/akismet')
        ..type=CommentType.COMMENT;

      author=new Author('viagra-test-123')
        ..ipAddress='127.0.0.1'
        ..userAgent='Spam Bot/6.6.6';

      _spam=new Comment('Spam!', author)..type=CommentType.TRACKBACK;
    });

    group('Client', () {
      test('verifyKey()', testVerifyKey);
      test('checkComment()', testCheckComment);
      test('submitHam()', testSubmitHam);
      test('submitSpam()', testSubmitSpam);
    });
  }

  /// Tests the [Client.checkComment] method.
  void testCheckComment() {
    // expect(_client.checkComment(_ham), completion(isFalse));
    expect(_client.checkComment(_spam), completion(isTrue));
  }

  /// Tests the [Client.submitHam] method.
  void testSubmitHam() {
    expect(_client.submitHam(_ham), completes);
  }

  /// Tests the [Client.submitSpam] method.
  void testSubmitSpam() {
    expect(_client.submitSpam(_spam), completes);
  }

  /// Tests the [Client.verifyKey] method.
  void testVerifyKey() {
    expect(_client.verifyKey(), completion(isTrue));
    expect(new Client('viagra-test-123', 'http://fake-url.com').verifyKey(), completion(isFalse));
    expect(new Client('', '').verifyKey(), throws);
  }
}
