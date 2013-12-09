part of akismet.io;

/// An HTTP server that acts as a proxy between HTML clients and [Akismet](https://akismet.com) service.
class Server {

  /// The underlying [HttpServer] instance.
  HttpServer _server;

  /// Creates a new [Server].
  /// If a [redirectUrl] is specified, the user is redirected to it when a request is unhandled.
  Server([ this.redirectUrl ]);

  /// Returns the address that the server is listening on, or `null` if the server is not started.
  InternetAddress get address => _server!=null ? _server.address : null;

  /// Returns the port that the server is listening on, or `-1` if the server is not started.
  int get port => _server!=null ? _server.port : -1;

  /// The [Uri] to redirect the user when a request is unhandled.
  /// If this property is `null`, a 404 status code is sent instead of redirecting.
  final Uri redirectUrl;

  /// Checks a [core.Comment] against the service database, and prints a value indicating whether it is spam.
  void checkComment(HttpRequestBody body) {
    var result=_processBody(body);
    result['client'].checkComment(result['comment'])
      .then((isSpam) => _sendResponse(body.request.response, isSpam ? 'true' : 'false'))
      .catchError((error) => _sendResponse(body.request.response, 'invalid', error: error.message));
  }

  /// Starts listening for HTTP requests on the specified [address] and [port].
  /// The [address] can either be a [String] or an [InternetAddress].
  ///
  /// The returned [Future] completes when the server is started.
  Future start(address, int port) {
    return HttpServer.bind(address, port)
      .then((server) {
        _server=server;

        var bodyHandler=new HttpBodyHandler();
        new Router(_server)
          ..filter(new RegExp(r'^.*$'), _processRequest)
          ..serve(core.EndPoints.checkComment, method: 'POST')
            .transform(bodyHandler)
            .listen(checkComment, onError: _errorHandler)
          ..serve(core.EndPoints.submitHam, method: 'POST')
            .transform(bodyHandler)
            .listen(submitHam, onError: _errorHandler)
          ..serve(core.EndPoints.submitSpam, method: 'POST')
            .transform(bodyHandler)
            .listen(submitSpam, onError: _errorHandler)
          ..serve(core.EndPoints.verifyKey, method: 'POST')
            .transform(bodyHandler)
            .listen(verifyKey, onError: _errorHandler)
          ..defaultStream
            .listen(_defaultHandler, onError: _errorHandler);
      })
      .catchError((error) {
        print('An error occurred while starting the server:');
        print(error);
        exit(1);
      });
  }

  /// Permanently stops this server from listening for new connections.
  /// If [force] is `true`, active connections will be closed immediately.
  ///
  /// The returned [Future] completes when the server is stopped.
  Future stop({ bool force: false }) {
    return _server.close(force: force).then((_) { _server=null; });
  }

  /// Submits a [core.Comment] that was incorrectly marked as spam but should not have been.
  void submitHam(HttpRequestBody body) {
    var result=_processBody(body);
    result['client'].submitHam(result['comment'])
      .then((_) => _sendResponse(body.request.response, 'Thanks for making the web a better place.'))
      .catchError((error) => _sendResponse(body.request.response, '', error: error.message));
  }

  /// Submits a [core.Comment] that was not marked as spam but should have been.
  void submitSpam(HttpRequestBody body) {
    var result=_processBody(body);
    result['client'].submitSpam(result['comment'])
      .then((_) => _sendResponse(body.request.response, 'Thanks for making the web a better place.'))
      .catchError((error) => _sendResponse(body.request.response, '', error: error.message));
  }

  /// Checks an API key against the service database, and prints a value indicating whether it is a valid key.
  void verifyKey(HttpRequestBody body) {
    var result=_processBody(body);
    result['client'].verifyKey()
      .then((isValid) => _sendResponse(body.request.response, isValid ? 'valid' : 'invalid'))
      .catchError((error) => _sendResponse(body.request.response, 'invalid', error: error.message));
  }

  /// Handles unmatched requests.
  void _defaultHandler(HttpRequest request) {
    // Handle CORS requests.
    if(request.method=='OPTIONS') {
      request.response
        ..statusCode=HttpStatus.NO_CONTENT
        ..close();

      return;
    }

    // Redirect the user whether specified.
    if(redirectUrl!=null) {
      request.response.redirect(redirectUrl.resolveUri(request.uri), status: HttpStatus.MOVED_PERMANENTLY);
      return;
    }

    // Send a 404 error for all other requests.
    request.response
      ..statusCode=HttpStatus.NOT_FOUND
      ..write('Not Found')
      ..close();
  }

  /// Handles request errors.
  void _errorHandler(error) {
    var now=new DateTime.now();
    print('[$now] ERROR - $error');
  }

  /// Processes the specified request [body] and returns the parsed [Client] and [Comment] in a [Map].
  Map<String, dynamic> _processBody(HttpRequestBody body) {
    var headers=body.request.headers;
    var query=body.body as Map;

    // Parse client arguments.
    var blog=Uri.parse('/');
    if(query.containsKey('blog')) {
      try { blog=Uri.parse(query['blog']); }
      catch(e) {}
    }

    var apiKey=(query.containsKey('key') ? query['key'] : headers.host.split('.').first);
    var userAgent=headers['x-user-agent'];

    var client=new Client(apiKey, blog)
      ..secureRequests=true
      ..userAgent=(userAgent.isEmpty ? headers[HttpHeaders.USER_AGENT] : userAgent).first;

    // Parse comment values.
    var comment=new core.Comment.fromJson(query);
    if(comment.author==null) comment.author=new core.Author();
    if(comment.author.ipAddress==null) comment.author.ipAddress=body.request.connectionInfo.remoteAddress.address;

    return { 'client': client, 'comment': comment };
  }

  /// Logs the [request] and adds [CORS](http://www.w3.org/TR/cors) headers to the response.
  /// Returns a [Future] that always completes with the `true` value.
  Future<bool> _processRequest(HttpRequest request) {
    // Log the request.
    var address=request.connectionInfo.remoteAddress.address;
    var now=new DateTime.now();
    var userAgent=request.headers[HttpHeaders.USER_AGENT].first;
    print('[$now] $address - ${request.method} "${request.uri}" - "$userAgent"');

    // Add CORS response headers.
    request.response
      ..headers.set('Access-Control-Allow-Headers', 'x-requested-with, x-user-agent')
      ..headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS, POST')
      ..headers.set('Access-Control-Allow-Origin', '*')
      ..headers.set('Access-Control-Expose-Headers', 'x-akismet-debug-help');

    return new Future.value(true);
  }

  /// Write the specified [result] to the specified request [response].
  /// If an [error] message is provided, it is added to the [response] headers as `x-akismet-debug-help`.
  void _sendResponse(HttpResponse response, String result, { String error }) {
    if(error!=null) response.headers.set('x-akismet-debug-help', error);
    response.write(result);
    response.close();
  }
}
