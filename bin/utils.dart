import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:pubspec_parse/pubspec_parse.dart';

class Utils {
  const Utils._();

  static String getCurrentVersion() {
    return Pubspec.parse(File("pubspec.yaml").readAsStringSync()).version.toString();
  }

  static Future<List<String>> getPlatforms(String p) async {
    var completer = Completer();
    var results = <String>[];
    Directory(p).list(
      recursive: false, 
      followLinks: false
    ).where((event) => event is Directory).listen((event) { 
      String folder = path.basename(event.path);
      if(_platforms.contains(folder)) {
        results.add(folder);
      }
    }).onDone(() { 
      completer.complete();
    });

    return completer.future.then((value) => results);
  }

  static const List<String> _platforms = ["web", "ios", "android", "macos", "windows", "linux"];
}