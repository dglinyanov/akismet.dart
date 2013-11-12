part of akismet.core;

/**
 * Represents a comment submitted by an [Author].
 */
class Comment {

  /**
   * Creates a new [Comment] with the specified content and [Author].
   */
  Comment([ this.content, this.author ]);

  /**
   * Creates a new [Comment] from the specified [map] in JSON format.
   */
  Comment.fromJson(Map<String, dynamic> map) {
    assert(map!=null);

    if(map['author'] is Map) author=new Author.fromJson(map['author']);
    if(map['content']!=null) content=map['content'].toString();
    if(map['permalink']!=null) permalink=Uri.parse(map['permalink'].toString());
    if(map['referrer']!=null) referrer=Uri.parse(map['referrer'].toString());
    if(map['type']!=null) type=map['type'].toString();
  }

  /// The comment's author.
  Author author;

  /// The comment's content.
  String content;

  /// The permanent location of the entry the comment is submitted to.
  Uri permalink;

  /// The URL of the webpage that linked to the entry being requested.
  Uri referrer;

  /// The comment's type.
  /// This string value specifies a [CommentType] canonical value or a made up value like "registration".
  String type;

  /**
   * Converts this object to a [Map] in JSON format.
   */
  Map<String, dynamic> toJson() {
    var map={};

    if(author!=null) map['author']=author;
    if(content!=null) map['content']=content;
    if(permalink!=null) map['permalink']=permalink.toString();
    if(referrer!=null) map['referrer']=referrer.toString();
    if(type!=null) map['type']=type;

    return map;
  }

  /**
   * Returns a string representation of this object.
   */
  @override
  String toString() => 'Comment ${toJson()}';
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
