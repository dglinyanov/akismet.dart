/// `dart:io` implementation of the package.
/// Import this library in console applications.
library akismet.io;

import 'core.dart' as core;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// TODO ? export 'core.dart' show Author, Comment;

/// A  `dart:io` client that submit comments to [Akismet](https://akismet.com) service.
class Client extends core.Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  Client(String apiKey, Uri blog): super(apiKey, blog) {
    var dartVersion=Platform.version.split('.').take(3).join('.');
    userAgent='Dart/$dartVersion | Akismet.dart/${core.VERSION}';
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

  /// Submits the specified [comment] that was incorrectly marked as spam but should have not been.
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

    return _queryService(endPoint, { 'blog': blog, 'key': apiKey }).then((result) => result=='valid');
  }

  /// Queries the service database and returns the response as a [String].
  Future<String> _queryService(Uri endPoint, Map<String, String> queryFields) {
    var headers={
      HttpHeaders.CONTENT_TYPE: 'application/x-www-form-urlencoded; charset=${encoding.name}',
      HttpHeaders.USER_AGENT: userAgent
    };

    http.post(endPoint, fields: queryFields, headers: headers).then((response) => response.body);
  }
}
