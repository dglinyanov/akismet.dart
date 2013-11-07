part of akismet;

/**
 * Represents a comment submitted by an [Author].
 */
class Comment {

  /**
   * Creates a new [Comment].
   */
  Comment();

  /// The comment's author.
  Author author;

  /// The comment's content.
  String content;

  /// The permanent location of the entry the comment is submitted to.
  Uri permalink;

  /// The URL of the webpage that linked to the entry being requested.
  Uri referrer;

  /// The comment's type.
  String type;
}

/**
 * Canonical values defining the type of a [Comment].
 */
abstract class CommentType {

  /// Specifies a standard comment.
  static const String COMMENT='comment';

  /// Specifies a [pingback](https://en.wikipedia.org/wiki/Pingback) comment.
  static const String PINGBACK='pingback';

  /// Specifies a [trackback](https://en.wikipedia.org/wiki/Trackback) comment.
  static const String TRACKBACK='trackback';
}
