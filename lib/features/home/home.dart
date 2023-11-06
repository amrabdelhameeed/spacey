import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spacey/core/constants/app_methods.dart';
import 'package:spacey/core/constants/app_routes.dart';
import 'package:spacey/core/localaization/app_localization.dart';
import 'package:spacey/core/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  List<String> files = [];
  List<String> list = ["xlsx", "mp4", "pdf", "other"];
  String selectedValue = "xlsx";
  @override
  void initState() {
    handler();
    super.initState();
  }

  void handler() async {
    var status = await Permission.storage.request();
    var status2 = await Permission.manageExternalStorage.request();
    if (status.isGranted && status2.isGranted) {
      final directory = await getTemporaryDirectory();
      directory.delete(recursive: true);
    } else {}
  }

  final TextEditingController _controller = TextEditingController();
  final RegExp _phoneNumberRegExp = RegExp(r'^0?\d{0,9}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setstate) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              items: list.map((String e) {
                                return DropdownMenuItem<String>(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              isExpanded: true,
                              value: selectedValue,
                              underline: SizedBox.shrink(),
                              onChanged: (String? value) {
                                setstate(() {
                                  if (value != null) {
                                    selectedValue = value;
                                  }
                                });
                              },
                            ),
                            selectedValue == "other"
                                ? TextFormField(
                                    decoration: InputDecoration(hintText: "enter your custom extention"),
                                    onFieldSubmitted: (value) {
                                      if (value != null) {
                                        selectedValue = value;
                                        setState(() {});
                                        Navigator.pop(context);
                                      }
                                    },
                                    onSaved: (newValue) {
                                      if (newValue != null) {
                                        selectedValue = newValue;
                                        setState(() {});
                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                : SizedBox(),
                            selectedValue != "other"
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Text("Search"))
                                : SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          label: Text("Choose Extenstion")),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder<List<String>>(
            future: AppMethods.loadFilesWithExtension(selectedValue),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                files = snapshot.data!;
                return Column(
                  children: [
                    // const SizedBox(
                    //   height: 40,
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$selectedValue items length : "),
                          Text(files.length.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        interactive: true,
                        thickness: 10,
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            if (index == files.length - 1) {
                              return buildListItem(files[index], true);
                            } else {
                              return buildListItem(files[index], false);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildListItem(String filePath, bool loadThumbnail) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppMethods.showOpenWithAppDialog(context, filePath);
      },
      child: Card(
        child: Row(
          children: [
            Expanded(child: Text(filePath.split('/').last.split('.').first)),
            if (!AppMethods.videoFileExtensions.contains(filePath.split('.').last))
              Thumbnail(
                dataResolver: () async {
                  return await File(filePath).readAsBytes();
                },
                errorBuilder: (p0, error) {
                  return Text(error.toString());
                },
                mimeType: AppMethods.extensionToMimeTypeMap[selectedValue]!,
                widgetSize: 100,
                decoration: WidgetDecoration(backgroundColor: Colors.transparent, wrapperBgColor: Colors.transparent, textColor: Colors.black),
              )
            else if (AppMethods.videoFileExtensions.contains(filePath.split('.').last))
              FutureBuilder<Uint8List?>(
                future: VideoThumbnail.thumbnailData(
                  video: filePath,
                  imageFormat: ImageFormat.JPEG,
                  maxWidth: 100,
                  quality: 50,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null) {
                      print(snapshot.data);
                    }
                    return snapshot.data != null ? Image.memory(snapshot.data!) : const SizedBox.shrink();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            else
              const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
