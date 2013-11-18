# Akismet.dart
Prevent comment spam using [Akismet](https://akismet.com) service, in [Dart](https://www.dartlang.org).
	
## Features
* [Key verification](https://akismet.com/development/api/#verify-key): checks an Akismet API key and gets a value indicating whether it is valid.
* [Comment check](https://akismet.com/development/api/#comment-check): checks a comment and gets a value indicating whether it is spam.
* [Submit spam](https://akismet.com/development/api/#submit-spam): submits a comment that was incorrectly marked as spam but should not have been.
* [Submit ham](https://akismet.com/development/api/#submit-ham): submits a comment that was not marked as spam but should have been.

## Documentation
* [API Reference](http://cedx.github.io/akismet.dart/api)

## Installing via [Pub](https://pub.dartlang.org)

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

	dependencies:
		akismet: any

### 2. Install it
If you're using the [Dart Editor](https://www.dartlang.org/tools/editor), choose:

	Menu > Tools > Pub Get

Or if you want to install from the command line, run:

	$ pub get
	
### 3. Import it
Now in your Dart code, you can use:

	import 'package:akismet/io.dart';

## Usage

### Key Verification
    var client=new Client('123YourAPIKey', 'http://your.blog.url');    
    client.verifyKey().then((isValid) {
	  print(isValid ? 'Your API key is valid.' : 'Your API key is invalid.');
    });
	
### Comment Check
    var client=new Client('123YourAPIKey', 'http://your.blog.url');
    var comment=new Comment('A comment.', new Author('An author.'));
     
    client.checkComment(comment).then((isSpam) {
	  print(isSpam ? 'The comment is marked as spam.' : 'The comment is marked as ham.');
    });
	
### Submit Spam/Ham
    var client=new Client('123YourAPIKey', 'http://your.blog.url');
    var comment=new Comment('A comment.', new Author('An author.'));
    
    client.submitSpam(comment).then((_) {
	  print('Spam submitted.');
    });
    
    client.submitHam(comment).then((_) {
	  print('Ham submitted.');
    });

## License
[Akismet.dart](https://pub.dartlang.org/packages/akismet) is distributed under the MIT License.

