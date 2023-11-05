import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spacey/core/constants/app_methods.dart';
import 'package:spacey/core/localaization/app_localization.dart';
import 'package:spacey/core/widgets/custom_snackbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    requestStoragePermissions();
    super.initState();
  }

  Future<void> requestStoragePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage, // External storage
      Permission.manageExternalStorage, // Internal storage (Android)
    ].request();

    // Check if permissions are granted
    if (await Permission.storage.isGranted && await Permission.manageExternalStorage.isGranted) {
      CustomSnackBar.show(context: context, text: "granted");
      // Permissions granted, you can proceed
      // Load files, etc.
    } else {
      CustomSnackBar.show(context: context, text: "denied");
      // Permissions not granted, handle accordingly
      // You can show a message or ask the user to grant permissions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder<List<String>>(
          future: AppMethods.loadFilesWithExtension("pdf"),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Text(snapshot.data![index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
