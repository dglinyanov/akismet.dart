part of akismet.core;

/**
 * Represents the author of a [Comment].
 */
class Author {

  /**
   * Creates a new [Author] with the specified name and mail address.
   */
  Author([ this.name, this.email ]);

  /**
   * Creates a new [Author] from the specified [map] in JSON format.
   */
  Author.fromJson(Map<String, dynamic> map) {
    assert(map!=null);

    if(map['email']!=null) email=map['email'].toString();
    if(map['ipAddress']!=null) ipAddress=map['ipAddress'].toString();
    if(map['name']!=null) name=map['name'].toString();
    if(map['url']!=null) url=Uri.parse(map['url'].toString());
    if(map['userAgent']!=null) userAgent=map['userAgent'].toString();
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

  /**
   * Converts this object to a [Map] in JSON format.
   */
  Map<String, dynamic> toJson() {
    var map={};

    if(email!=null) map['email']=email;
    if(ipAddress!=null) map['ipAddress']=ipAddress;
    if(name!=null) map['name']=name;
    if(url!=null) map['url']=url.toString();
    if(userAgent!=null) map['userAgent']=userAgent;

    return map;
  }

  /**
   * Returns a string representation of this object.
   */
  @override
  String toString() => 'Author ${toJson()}';
}