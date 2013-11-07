part of akismet;

/**
 * Represents the author of a [Comment].
 */
class Author {

  /**
   * Creates a new [Author].
   */
  Author();

  /// The author's user agent, that is the string identifying the Web browser used to submit comments.
  String agent;

  /// The author's mail address.
  String email;

  /// The author's IP address.
  String ip;

  /// The author's name.
  String name;

  /// The URL of the author's website.
  Uri url;
}