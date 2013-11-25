# Installing
The normal way of installing [Akismet.dart](https://pub.dartlang.org/packages/akismet) package is to use [Pub](https://pub.dartlang.org) package manager.

## 1. Depend on it
Add this to your package's `pubspec.yaml` file:
```yaml
dependencies:
  akismet: any
```

## 2. Install it
If you're using the [Dart Editor](https://www.dartlang.org/tools/editor), choose:
```
Menu > Tools > Pub Get
```

Or if you want to install from the command line, run:
```shell
$ pub get
```
	
## 3. Import it
Now in your Dart code, you can use:
```dart
import 'package:akismet/html.dart'; // In browser applications.
import 'package:akismet/io.dart'; // In console applications.
```