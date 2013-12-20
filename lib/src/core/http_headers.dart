part of akismet.core;

/// A collection of HTTP headers and their values.
abstract class HttpHeaders {

  /// Header corresponding to [Akismet](https://akismet.com) debug messages.
  static const String AKISMET_DEBUG_HELP='x-akismet-debug-help';

  /// Header used to identify an AJAX request.
  static const String REQUESTED_WITH='x-requested-with';

  /// Custom header corresponding to the user agent string sent by AJAX clients.
  static const String USER_AGENT='x-user-agent';
}
