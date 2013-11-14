part of akismet.core;

/// Represents the author of a [Comment].
class Author {

  /// Creates a new [Author] with the specified [name] and [email] address.
  Author([ this.name, this.email ]);

  /// Creates a new [Author] from the specified [map] in JSON format.
  Author.fromJson(Map<String, String> map) {
    assert(map!=null);

    if(map['comment_author']!=null) name=map['comment_author'];
    if(map['comment_author_email']!=null) email=map['comment_author_email'];
    if(map['comment_author_url']!=null) url=Uri.parse(map['comment_author_url']);
    if(map['user_agent']!=null) userAgent=map['user_agent'];
    if(map['user_ip']!=null) ipAddress=map['user_ip'];
  }

  /// The author's mail address.
  String email;

  /// The author's IP address.
  String ipAddress;

  /// The author's name.
  String name;

  /// The URL of the author's website.
  Uri url;

  /// The author's user agent, that is the string identifying the Web browser used to submit comments.
  String userAgent;

  /// Converts this object to a [Map] in JSON format.
  Map<String, String> toJson() {
    var map={};

    if(name!=null) map['comment_author']=name;
    if(email!=null) map['comment_author_email']=email;
    if(url!=null) map['comment_author_url']=url.toString();
    if(userAgent!=null) map['user_agent']=userAgent;
    if(ipAddress!=null) map['user_ip']=ipAddress;

    return map;
  }

  /// Returns a string representation of this object.
  @override
  String toString() => 'Author ${toJson()}';
}