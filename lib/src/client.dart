part of akismet.core;

/// Provides the base class for clients that submit comments to [Akismet](https://akismet.com) service.
abstract class Client {

  /// Creates a new [Client] with the specified Akismet API key and blog URL.
  Client(this.apiKey, this.blog);

  /// The Akismet API key.
  String apiKey;

  /// The front page or home URL of the instance making requests.
  Uri blog;

  /// The [Encoding] used when querying the service database.
  /// Defaults to [UTF8].
  Encoding encoding=UTF8;

  /// A value indicating whether to use secure requests when querying the service database.
  /// Defaults to `false`.
  bool secureRequests=false;

  /// The user agent string to use when making requests.
  /// If possible, the user agent string should always have the following format: `Application Name/Version | Plugin Name/Version`.
  String userAgent;

  /// Checks against the service database whether the specified [Comment] is spam.
  Future<bool> checkComment(Comment comment) {
    assert(comment!=null);

    Uri endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: '$apiKey.rest.akismet.com',
      path: '/1.1/comment-check'
    );

    return queryService(endPoint, _getQueryFields(comment)).then((result) => result=='true');
  }

  /// Query the service database and returns the response as a [String].
  Future<String> queryService(Uri endPoint, Map<String, String> queryFields);

  /// Submits the specified [comment] that was incorrectly marked as spam but should have not been.
  Future submitHam(Comment comment) {
    assert(comment!=null);

    Uri endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: '$apiKey.rest.akismet.com',
      path: '/1.1/submit-spam'
    );

    return queryService(endPoint, _getQueryFields(comment));
  }

  /// Submits the specified [comment] that was not marked as spam but should have been.
  Future submitSpam(Comment comment) {
    assert(comment!=null);

    Uri endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: '$apiKey.rest.akismet.com',
      path: '/1.1/submit-ham'
    );

    return queryService(endPoint, _getQueryFields(comment));
  }

  /// Checks against the service database whether [apiKey] is a valid API key.
  Future<bool> verifyKey() {
    Uri endPoint=new Uri(
      scheme: secureRequests ? 'https' : 'http',
      host: 'rest.akismet.com',
      path: '/1.1/verify-key'
    );

    return queryService(endPoint, { 'blog': blog, 'key': apiKey }).then((result) => result=='valid');
  }

  /// Gets a [Map] of the fields corresponding to the specified [Comment].
  /// TODO: Better description.
  Map<String, String> _getQueryFields(Comment comment) {
    Map fields={ 'blog': blog };
    if(comment.content!=null) fields['comment_content']=comment.content;
    if(comment.permalink!=null) fields['permalink']=comment.permalink.toString();
    if(comment.referrer!=null) fields['referrer']=comment.referrer.toString();
    if(comment.type!=null) fields['comment_type']=comment.type;

    if(comment.author!=null) {
      Author author=comment.author;
      if(author.email!=null) fields['comment_author_email']=author.email;
      if(author.ipAddress!=null) fields['user_ip']=author.ipAddress;
      if(author.name!=null) fields['comment_author']=author.name;
      if(author.url!=null) fields['comment_author_url']=author.url.toString();
      if(author.userAgent!=null) fields['user_agent']=author.userAgent;
    }

    return fields;
  }
}
