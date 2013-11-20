# Changelog
This file contains highlights of what changes on each version of the [Akismet.dart](https://pub.dartlang.org/packages/akismet) package.  
This file is normally updated whenever a new version is pushed to [Pub](https://pub.dartlang.org).

#### Version 0.2.0
* Added new client implementation based on [dart:html](https://api.dartlang.org/dart_html.html).
* Added server implementation used to proxy client requests to [Akismet](https://akismet.com) service.
* Breaking change: `Uri` in constructors can no longer be specified as `String`.
* Breaking change: removed `Client.encoding` property.

#### Version 0.1.1
* Added `EndPoints` class providing the URLs of the [Akismet](https://akismet.com) service end points.
* Fixed issue [#1](https://github.com/cedx/akismet.dart/issues/1).

#### Version 0.1.0
* Initial release: client implementation based on [dart:io](https://api.dartlang.org/dart_io.html).