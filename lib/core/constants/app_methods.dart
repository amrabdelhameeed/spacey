import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AppMethods {
  AppMethods._(); // Private constructor
  static Future<List<String>> loadFilesWithExtension(String targetExtension) async {
    List<Directory?> directories = [
      await getExternalStorageDirectory(),
      await getApplicationDocumentsDirectory(),
      await getApplicationSupportDirectory(),
    ];

    List<String> filePaths = [];

    for (var directory in directories) {
      if (directory != null) {
        filePaths.addAll(_scanDirectory(directory, targetExtension));
      }
    }

    return filePaths;
  }

  static List<String> _scanDirectory(Directory directory, String targetExtension) {
    List<String> filePaths = [];
    try {
      for (var entity in directory.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith(targetExtension)) {
          filePaths.add(entity.path);
        }
      }
    } on PlatformException catch (e) {
      print("PlatformException : ${e.toString()}");
    } on FileSystemException catch (e) {
      print("FileSystemException : ${e.toString()}");
    }
    return filePaths;
  }
}
