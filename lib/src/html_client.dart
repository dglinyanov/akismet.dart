part of akismet.html;

/// A  `dart:html` client that submit comments to [Akismet](https://akismet.com) service.
class Client extends core.Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  /// The remote service queried by this client is located at the specified [serviceUrl], which defaults to `http://127.0.0.1:3000`.
  Client(String apiKey, blog, { this.serviceUrl }): super(apiKey, blog) {
    if(serviceUrl==null) serviceUrl=Uri.parse('http://127.0.0.1:3000');
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
    assert(fields!=null);
    fields['blog']=blog.toString();
    fields['key']=apiKey;

    var headers={
      HttpHeaders.CONTENT_TYPE: 'application/x-www-form-urlencoded; charset=${encoding.name}',
      //HttpHeaders.X_REQUESTED_WITH: 'XMLHttpRequest',
      HttpHeaders.USER_AGENT: userAgent
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

/// Provides common HTTP headers as defined in [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616.html).
abstract class HttpHeaders {

  /// Value of the [Content-Type](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17) HTTP header.
  static const String CONTENT_TYPE='content-type';

  /// Value of the [User-Agent](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43) HTTP header.
  /// Browsers don't allow to modify the user agent string. So this constant specifies the custom value `X-User-Agent`.
  static const String USER_AGENT='x-user-agent';

  /// Value of the [X-Requested-With](http://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Common_non-standard_request_headers) HTTP header.
  static const String X_REQUESTED_WITH='x-requested-with';
}
