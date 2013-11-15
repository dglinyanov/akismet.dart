part of akismet.tests.io;

/// Tests the features of [Client] class.
class ClientTest {

  /// The test data.
  Client _client;

  /// Runs the unit tests.
  void run() {
    setUp(() {
      _client=new Client('8b8d8d8c375d', 'http://your.url.here.com');
    });

    group('Client', () {
      test('verifyKey()', testVerifyKey);
      skip_test('checkComment()', testCheckComment);
      skip_test('submitHam()', testSubmitHam);
      skip_test('submitSpam()', testSubmitSpam);
    });
  }

  /// Tests the [Client.checkComment] method.
  void testCheckComment() {
    fail('Not implemented.');
  }

  /// Tests the [Client.submitHam] method.
  void testSubmitHam() {
    fail('Not implemented.');
  }

  /// Tests the [Client.submitSpam] method.
  void testSubmitSpam() {
    fail('Not implemented.');
  }

  /// Tests the [Client.verifyKey] method.
  void testVerifyKey() {
    expect(_client.verifyKey(), completion(isTrue));
    expect(new Client('SPAM', 'http://spam.com').verifyKey(), completion(isFalse));
  }
}
