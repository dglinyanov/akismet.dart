part of akismet.io;

/// A  `dart:io` client that submit comments to [Akismet](https://akismet.com) service.
class Client extends core.Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  /// The [blog] URL can be specified as a [Uri] or a [String].
  Client(String apiKey, blog): super(apiKey, blog is Uri ? blog : Uri.parse(blog)) {
    var dartVersion=Platform.version.split('.').take(3).join('.');
    userAgent='Dart/$dartVersion | Akismet/${core.VERSION}';
  }

  /// The [Encoding] used when querying the remote service.
  /// Defaults to [UTF8].
  Encoding encoding=UTF8;

  /// A value indicating whether to use secure requests when querying the service database.
  /// Defaults to `false`.
  bool secureRequests=false;

  /// Checks the specified [comment] against the service database, and returns a value indicating whether it is spam.
  Future<bool> checkComment(core.Comment comment) {
    assert(comment!=null);

    var endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: '$apiKey.rest.akismet.com',
      path: '/1.1/comment-check'
    );

    return _queryService(endPoint, comment.toJson()).then((result) => result=='true');
  }

  /// Submits the specified [comment] that was incorrectly marked as spam but should not have been.
  Future submitHam(core.Comment comment) {
    assert(comment!=null);

    var endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: '$apiKey.rest.akismet.com',
      path: '/1.1/submit-spam'
    );

    return _queryService(endPoint, comment.toJson());
  }

  /// Submits the specified [comment] that was not marked as spam but should have been.
  Future submitSpam(core.Comment comment) {
    assert(comment!=null);

    var endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: '$apiKey.rest.akismet.com',
      path: '/1.1/submit-ham'
    );

    return _queryService(endPoint, comment.toJson());
  }

  /// Checks against the service database whether [apiKey] is a valid API key.
  Future<bool> verifyKey() {
    var endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: 'rest.akismet.com',
      path: '/1.1/verify-key'
    );

    return _queryService(endPoint, { 'blog': blog.toString(), 'key': apiKey }).then((result) => result=='valid');
  }

  /// Queries the service database and returns the response as a [String].
  Future<String> _queryService(Uri endPoint, Map<String, String> fields) {
    var headers={
      HttpHeaders.CONTENT_TYPE: 'application/x-www-form-urlencoded; charset=${encoding.name}',
      HttpHeaders.USER_AGENT: userAgent
    };

    /*
    print('URL: $endPoint');
    print('Headers: $headers');
    print('Body: $fields');

    fields['is_test']='1';
    */

    return http.post(endPoint, fields: fields, headers: headers).then((response) {
      if(response.headers.containsKey('x-akismet-debug-help')) throw new HttpException(response.headers['x-akismet-debug-help'], uri: endPoint);
      /*
      print(response.request.headers);
      print(response.headers);
      print(response.reasonPhrase);
      print(response.statusCode);
      print(response.body);
      */
      return response.body;
    });
  }
}
