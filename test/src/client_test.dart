part of akismet.tests.core;

/// Tests the features of [Client] class.
class ClientTest {

  /// The client used to query the service database.
  Client _client;

  /// A comment with content marked as ham.
  Comment _ham;

  /// A comment with content marked as spam.
  Comment _spam;

  /// Creates a new [ClientTest] testing the specified [Client].
  ClientTest(this._client) {
    var author=new Author('Akismet.dart')
      ..ipAddress='192.168.0.1'
      ..url=Uri.parse('http://dev.belin.io/akismet.dart')
      ..userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71';

    _ham=new Comment('I\'m testing out the Service API.', author)
      ..referrer=Uri.parse('https://pub.dartlang.org/packages/akismet')
      ..type=CommentType.COMMENT;

    author=new Author('viagra-test-123')
      ..ipAddress='127.0.0.1'
      ..userAgent='Spam Bot/6.6.6';

    _spam=new Comment('Spam!', author)..type=CommentType.TRACKBACK;
  }

  /// Runs the unit tests.
  void run() {
    group('Client', () {
      test('verifyKey()', testVerifyKey);
      test('submitHam()', testSubmitHam);
      test('submitSpam()', testSubmitSpam);
      test('checkComment()', testCheckComment);
    });
  }

  /// Tests the [Client.checkComment] method.
  void testCheckComment() {
    expect(_client.checkComment(_ham), completion(isFalse));
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

    const constructor=const Symbol('');
    var instanceMirror=reflect(_client);
    var classMirror=instanceMirror.type;

    Uri serviceUrl;
    try { serviceUrl=instanceMirror.getField(#serviceUrl).reflectee; }
    on NoSuchMethodError { serviceUrl=null; }

    var client=classMirror.newInstance(constructor, [ 'viagra-test-123', Uri.parse('http://fake-url.com') ]).reflectee;
    if(serviceUrl!=null) client.serviceUrl=serviceUrl;
    expect(client.verifyKey(), completion(isFalse));

    client=classMirror.newInstance(constructor, [ '', Uri.parse('mailto:viagra-test-123@fake-url.com') ]).reflectee;
    if(serviceUrl!=null) client.serviceUrl=serviceUrl;
    expect(client.verifyKey(), completion(isFalse));
  }
}
