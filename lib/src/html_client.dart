part of akismet.html;

/// A  `dart:html` client that submit comments to [Akismet](https://akismet.com) service.
class Client extends core.Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  /// The remote service queried by this client is located at the specified [serviceUrl], which defaults to `http://127.0.0.1:3000`.
  /// The [blog] and [serviceUrl] URLs can be specified as a [Uri] or a [String].
  Client(String apiKey, blog, { serviceUrl: 'http://127.0.0.1:3000' }): super(apiKey, blog is Uri ? blog : Uri.parse(blog)) {
    assert(serviceUrl!=null);
    this.serviceUrl=(serviceUrl is Uri ? serviceUrl : Uri.parse(serviceUrl));
    this.userAgent='Dart/0.0.0 | Akismet/${core.VERSION}';
  }

  /// The [Encoding] used when querying the remote service.
  /// Defaults to [UTF8].
  Encoding encoding=UTF8;

  /// The [Uri] of the remote service.
  Uri serviceUrl;

  /// Checks the specified [comment] against the service database, and returns a value indicating whether it is spam.
  Future<bool> checkComment(core.Comment comment) {
    assert(comment!=null);
    var endPoint=Uri.parse('${serviceUrl}${core.EndPoints.checkComment}');
    print(endPoint);
    endPoint=serviceUrl.resolve(core.EndPoints.checkComment.toString());
    print(endPoint);
    return _queryService(endPoint, comment.toJson()).then((result) => result=='true');
  }

  /// Submits the specified [comment] that was incorrectly marked as spam but should not have been.
  Future submitHam(core.Comment comment) {
    assert(comment!=null);
    var endPoint=Uri.parse('${serviceUrl}${core.EndPoints.submitHam}');
    print(endPoint);
    endPoint=serviceUrl.resolve(core.EndPoints.submitHam.toString());
    print(endPoint);
    return _queryService(endPoint, comment.toJson());
  }

  /// Submits the specified [comment] that was not marked as spam but should have been.
  Future submitSpam(core.Comment comment) {
    assert(comment!=null);
    var endPoint=Uri.parse('${serviceUrl}${core.EndPoints.submitSpam}');
    print(endPoint);
    endPoint=serviceUrl.resolve(core.EndPoints.submitSpam.toString());
    print(endPoint);
    return _queryService(endPoint, comment.toJson());
  }

  /// Checks the [apiKey] against the service database, and returns a value indicating whether it is a valid API key.
  Future<bool> verifyKey() {
    var endPoint=Uri.parse('${serviceUrl}${core.EndPoints.verifyKey}');
    print(endPoint);
    endPoint=serviceUrl.resolve(core.EndPoints.verifyKey.toString());
    print(endPoint);
    return _queryService(endPoint, {}).then((result) => result=='valid');
  }

  /// Queries the service by posting the specified [fields] to a given [endPoint], and returns the response as a [String].
  /// Throws a [HttpException] if the remote service returned an error message.
  Future<String> _queryService(Uri endPoint, Map<String, String> fields) {
    fields['blog']=blog.toString();
    fields['key']=apiKey;

    var headers={
      'Content-Type': 'application/x-www-form-urlencoded; charset=${encoding.name}',
      'X-User-Agent': userAgent
    };

    return HttpRequest.postFormData(endPoint.toString(), fields, requestHeaders: headers).then((request) {
      print(request.response);
      print(request.responseHeaders);
      print(request.responseText);
      print(request.responseType);
      print(request.status);
      print(request.statusText);

      if(request.responseHeaders.containsKey('x-akismet-debug-help'))
        throw new HttpException(request.responseHeaders['x-akismet-debug-help'], uri: endPoint);

      return request.responseText;

    })
    .catchError((error) {
      print(error);
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
