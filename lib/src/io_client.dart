part of akismet.io;

/// A  `dart:io` client that submit comments to [Akismet](https://akismet.com) service.
class Client extends core.Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  Client(String apiKey, Uri blog): super(apiKey, blog) {
    var dartVersion=Platform.version.split('.').take(3).join('.');
    userAgent='Dart/$dartVersion | Akismet/${core.VERSION}';
  }

  /// A value indicating whether to use secure requests when querying the service database.
  /// Defaults to `false`.
  bool secureRequests=false;

  /// Checks the specified [comment] against the service database, and returns a value indicating whether it is spam.
  Future<bool> checkComment(core.Comment comment) {
    assert(comment!=null);
    var endPoint=new Uri(scheme: secureRequests ? 'https' : 'http', host: '$apiKey.rest.akismet.com', path: core.EndPoints.checkComment.toString());
    return _queryService(endPoint, comment.toJson()).then((result) => result=='true');
  }

  /// Submits the specified [comment] that was incorrectly marked as spam but should not have been.
  Future submitHam(core.Comment comment) {
    assert(comment!=null);
    var endPoint=new Uri(scheme: secureRequests ? 'https' : 'http', host: '$apiKey.rest.akismet.com', path: core.EndPoints.submitHam.toString());
    return _queryService(endPoint, comment.toJson());
  }

  /// Submits the specified [comment] that was not marked as spam but should have been.
  Future submitSpam(core.Comment comment) {
    assert(comment!=null);
    var endPoint=new Uri(scheme: secureRequests ? 'https' : 'http', host: '$apiKey.rest.akismet.com', path: core.EndPoints.submitSpam.toString());
    return _queryService(endPoint, comment.toJson());
  }

  /// Checks the [apiKey] against the service database, and returns a value indicating whether it is a valid API key.
  Future<bool> verifyKey() {
    var endPoint=new Uri(scheme: secureRequests ? 'https' : 'http', host: 'rest.akismet.com', path: core.EndPoints.verifyKey.toString());
    return _queryService(endPoint, { 'key': apiKey }).then((result) => result=='valid');
  }

  /// Queries the service by posting the specified [fields] to a given [endPoint], and returns the response as a [String].
  /// Throws a [HttpException] if the remote service returned an error message.
  Future<String> _queryService(Uri endPoint, Map<String, String> fields) {
    assert(endPoint!=null);
    assert(fields!=null);

    fields['blog']=blog.toString();

    var headers={
      HttpHeaders.CONTENT_TYPE: 'application/x-www-form-urlencoded',
      HttpHeaders.USER_AGENT: userAgent
    };

    return http.post(endPoint, fields: fields, headers: headers).then((response) {
      if(response.headers.containsKey('x-akismet-debug-help'))
        throw new HttpException(response.headers['x-akismet-debug-help'], uri: endPoint);

      return response.body;
    });
  }
}
