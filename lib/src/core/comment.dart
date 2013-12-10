part of akismet.core;

/// Represents a comment submitted by an [Author].
class Comment {

  /// Creates a new [Comment] with the specified [content] and [author].
  Comment([ this.content, this.author ]);

  /// Creates a new [Comment] from the specified [map] in JSON format.
  Comment.fromJson(Map<String, String> map) {
    assert(map!=null);

    if(map.keys.any((key) => key.startsWith('comment_author') || key.startsWith('user'))) author=new Author.fromJson(map);
    if(map['comment_content']!=null) content=map['comment_content'];
    if(map['comment_type']!=null) type=map['comment_type'];
    if(map['permalink']!=null) permalink=Uri.parse(map['permalink']);
    if(map['referrer']!=null) referrer=Uri.parse(map['referrer']);
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
  /// This string value specifies a [CommentType] constant or a made up value like "registration".
  String type;

  /// Converts this object to a [Map] in JSON format.
  Map<String, String> toJson() {
    var map={};

    if(author!=null) map.addAll(author.toJson());
    if(content!=null) map['comment_content']=content;
    if(type!=null) map['comment_type']=type;
    if(permalink!=null) map['permalink']=permalink.toString();
    if(referrer!=null) map['referrer']=referrer.toString();

    return map;
  }

  /// Returns a string representation of this object.
  @override
  String toString() => 'Comment ${toJson()}';
}

/// Specifies the type of a [Comment].
abstract class CommentType {

  /// A standard comment.
  static const String COMMENT='comment';

  /// A [pingback](https://en.wikipedia.org/wiki/Pingback) comment.
  static const String PINGBACK='pingback';

  /// A [trackback](https://en.wikipedia.org/wiki/Trackback) comment.
  static const String TRACKBACK='trackback';
}
