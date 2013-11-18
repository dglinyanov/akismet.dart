part of akismet.core;

/// Provides the [UrlPattern]s corresponding to the service end points.
abstract class EndPoints {

  /// URL of the [comment check](https://akismet.com/development/api/#comment-check) end point.
  static final UrlPattern checkComment=new UrlPattern('/1.1/comment-check');

  /// URL of the [submit ham](https://akismet.com/development/api/#verify-key) end point.
  static final UrlPattern submitHam=new UrlPattern('/1.1/submit-ham');

  /// URL of the [submit spam](https://akismet.com/development/api/#verify-key) end point.
  static final UrlPattern submitSpam=new UrlPattern('/1.1/submit-spam');

  /// URL of the [key verification](https://akismet.com/development/api/#verify-key) end point.
  static final UrlPattern verifyKey=new UrlPattern('/1.1/verify-key');
}
