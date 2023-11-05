import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AppMethods {
  AppMethods._(); // Private constructor
  static Future<List<String>> loadFilesWithExtension(String targetExtension) async {
    List<Directory?> directories = [
      Directory('/storage/emulated/0/'),
      // await getExternalStorageDirectory(),
      // await getApplicationDocumentsDirectory(),
      // await getApplicationSupportDirectory(),
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

  static List<String> videoFileExtensions = [
    'mp4',
    'avi',
    'mkv',
    'mov',
    'wmv',
    'flv',
    'webm',
    '3gp',
    'mpeg',
    'mpg',
    'm4v',
    'ogv',
    'ts',
    'vob',
    'mts',
    'm2ts',
    'divx',
    'asf',
    'dat',
    'm2v',
    'qt',
    'mod',
    'tod',
    'vro',
  ];

  static final extensionToMimeTypeMap = {
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'txt': 'text/plain',
    'html': 'text/html',
    'xml': 'application/xml',
    'json': 'application/json',
    // Add more extensions and their corresponding MIME types as needed
  };

// Define a function to get the MIME type based on a file's extension
  String getMimeTypeFromExtension(String extension) {
    // Get the corresponding MIME type from the map
    final mimeType = extensionToMimeTypeMap[extension.toLowerCase()];

    // If the MIME type is not found, default to a generic value (e.g., 'application/octet-stream')
    return mimeType ?? 'application/octet-stream';
  }
}
