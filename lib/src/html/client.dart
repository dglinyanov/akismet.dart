part of akismet.html;

/// A  `dart:html` client that submit comments to [Akismet](https://akismet.com) service.
class Client extends core.Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  Client(String apiKey, Uri blog): super(apiKey, blog) {
    userAgent='Dart/0.0.0 | Akismet/${core.VERSION}';
  }

  /// The [Uri] of the remote service.
  /// Defaults to `http://127.0.0.1:8080`.
  Uri serviceUrl=Uri.parse('http://127.0.0.1:8080');

  /// Checks the specified [comment] against the service database, and returns a value indicating whether it is spam.
  Future<bool> checkComment(core.Comment comment) {
    assert(comment!=null);
    var endPoint=serviceUrl.resolve(core.EndPoints.checkComment.pattern);
    return _queryService(endPoint, comment.toJson()).then((result) => result=='true');
  }

  /// Submits the specified [comment] that was incorrectly marked as spam but should not have been.
  Future submitHam(core.Comment comment) {
    assert(comment!=null);
    var endPoint=serviceUrl.resolve(core.EndPoints.submitHam.pattern);
    return _queryService(endPoint, comment.toJson());
  }

  /// Submits the specified [comment] that was not marked as spam but should have been.
  Future submitSpam(core.Comment comment) {
    assert(comment!=null);
    var endPoint=serviceUrl.resolve(core.EndPoints.submitSpam.pattern);
    return _queryService(endPoint, comment.toJson());
  }

  /// Checks the [apiKey] against the service database, and returns a value indicating whether it is a valid API key.
  Future<bool> verifyKey() {
    var endPoint=serviceUrl.resolve(core.EndPoints.verifyKey.pattern);
    return _queryService(endPoint, {}).then((result) => result=='valid');
  }

  /// Queries the service by posting the specified [fields] to a given [endPoint], and returns the response as a [String].
  /// Throws a [HttpException] if the remote service returned an error message.
  Future<String> _queryService(Uri endPoint, Map<String, String> fields) {
    assert(endPoint!=null);
    assert(fields!=null);

    fields['blog']=blog.toString();
    fields['key']=apiKey;

    var headers={
      core.HttpHeaders.REQUESTED_WITH: 'XMLHttpRequest',
      core.HttpHeaders.USER_AGENT: userAgent
    };

    return HttpRequest.postFormData(endPoint.toString(), fields, requestHeaders: headers, responseType: 'text').then((request) {
      if(request.responseHeaders.containsKey(core.HttpHeaders.AKISMET_DEBUG_HELP))
        throw new HttpException(request.responseHeaders[core.HttpHeaders.AKISMET_DEBUG_HELP], uri: endPoint);

      return request.responseText;
    });
  }
}

/// Describes an exception that occurred during the processing of HTTP requests.
class HttpException implements Exception {

  /// Creates a new [HttpException] with the specified [message] and [uri].
  const HttpException(this.message, { this.uri });

  /// Gets a message that describes the current exception.
  final String message;

  /// Gets the requested [Uri] that caused the exception.
  final Uri uri;

  /// Returns a string representation of this object.
  @override
  String toString() => 'HttpException { message: "$message", uri: Uri($uri) }';
}
