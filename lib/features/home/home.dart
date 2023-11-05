import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spacey/core/constants/app_methods.dart';
import 'package:spacey/core/localaization/app_localization.dart';
import 'package:spacey/core/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    handler();
    super.initState();
  }

  void handler() async {
    // final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    // print(appDocumentsDirectory.parent.path);
    // final appDocumentsDirectory2 = await getExternalStorageDirectory();
    // print(appDocumentsDirectory2 != null ? appDocumentsDirectory2.path : "");
    // await Permission.storage.request();
    var status = await Permission.storage.request();
    var status2 = await Permission.manageExternalStorage.request();
    if (status.isGranted && status2.isGranted) {
      final directory = await getTemporaryDirectory();
      directory.delete(recursive: true);
      // Permission granted, proceed with creating the folder and file
      // ...
    } else {
      // Permission denied, handle accordingly
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder<List<String>>(
          future: AppMethods.loadFilesWithExtension(Random().nextBool() ? "mp4" : "pdf"),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(snapshot.data!.length.toString()),
                  ),
                  Expanded(
                      child: Scrollbar(
                          interactive: true,
                          thickness: 10,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  showOpenWithAppDialog(context, snapshot.data![index]);
                                },
                                child: Card(
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(snapshot.data![index])),
                                      Expanded(
                                        child: !AppMethods.videoFileExtensions.contains(snapshot.data![index].split('.').last)
                                            ? Thumbnail(
                                                dataResolver: () async {
                                                  // print("object")
                                                  return await File(snapshot.data![index]).readAsBytes();
                                                },
                                                mimeType: "application/pdf",
                                                widgetSize: 50,
                                              )
                                            : FutureBuilder<Uint8List?>(
                                                future: VideoThumbnail.thumbnailData(
                                                  video: snapshot.data![index],
                                                  imageFormat: ImageFormat.JPEG,
                                                  maxWidth: 100, // Adjust the thumbnail size as needed
                                                  quality: 50, // Adjust the image quality as needed
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                    if (snapshot.data != null) {
                                                      print(snapshot.data);
                                                    }
                                                    return snapshot.data != null ? Image.memory(snapshot.data!) : SizedBox.shrink();
                                                  } else {
                                                    return CircularProgressIndicator();
                                                  }
                                                },
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )))
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // void showOpenWithAppDialog(BuildContext context, String filePath) async {
  //   try {
  //     if (await canLaunch(filePath)) {
  //       await launch(filePath);
  //     } else {
  //       // Handle if the file cannot be opened
  //     }
  //   } catch (e) {
  //     print('Error opening file: $e');
  //     // Handle the error
  //   }
  // }
  Future<void> showOpenWithAppDialog(BuildContext context, String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        print('File opened with success.');
      } else {
        print('File open failed: ${result.message}');
      }
    } catch (e) {
      print('Error opening file: $e');
    }
  }
}
