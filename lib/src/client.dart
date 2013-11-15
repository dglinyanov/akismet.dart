part of akismet.core;

/// Provides the base class for clients that submit comments to [Akismet](https://akismet.com) service.
abstract class Client {

  /// Creates a new [Client] with the specified Akismet [apiKey] and [blog] URL.
  Client(this.apiKey, this.blog) {
    assert(apiKey!=null);
    assert(blog!=null);
  }

  /// The Akismet API key.
  final String apiKey;

  /// The front page or home URL of the instance making requests.
  final Uri blog;

  /// The user agent string to use when making requests.
  /// If possible, the user agent string should always have the following format: `Application Name/Version | Plugin Name/Version`.
  String userAgent;

  /// Checks the specified [comment] against the service database, and returns a value indicating whether it is spam.
  Future<bool> checkComment(Comment comment);

  /// Submits the specified [comment] that was incorrectly marked as spam but should not have been.
  Future submitHam(Comment comment);

  /// Submits the specified [comment] that was not marked as spam but should have been.
  Future submitSpam(Comment comment);

  /// Returns a string representation of this object.
  @override
  String toString() => 'Client { apiKey: "$apiKey", blog: Uri($blog), userAgent: "$userAgent" }';

  /// Checks against the service database whether [apiKey] is a valid API key.
  Future<bool> verifyKey();
}
