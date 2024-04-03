import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryProviderModel with ChangeNotifier {
  List<FileSystemEntity> listOffiles2 = [];
  List<String> listOfFilesNames2 = [];
  List<FileSystemEntity> listOffilesToUpLoad = [];
  List<String> listOfFilesUploaded = [];
  int _duration = 0;
  int get duration => _duration;
  Future<void> getDir() async {
    final directory = await getExternalStorageDirectory();
    final dir = directory?.path;
    String filesDirectory = '$dir/';
    //String filesDirectory = '$dir/';
    final myDir = Directory(filesDirectory);

    listOffiles2 = myDir.listSync(recursive: true, followLinks: false);
    listOfFilesNames2 = listOffiles2.map((file) => file.path).toList();

    // print(listOfFilesNames2);
    notifyListeners();
  }

  void getDuration(int duration) {
    _duration = duration;

    notifyListeners();
  }

  void deleteFiles(int value) {
    if (value >= 0 && value < listOffiles2.length) {
      FileSystemEntity file = listOffiles2[value];
      file.deleteSync();
      listOffiles2.removeAt(value);
      print('Deleted file: ${file.path}');

      Fluttertoast.showToast(
        msg: "Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Not Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Invalid index: $value');
    }
    notifyListeners();
  }

  Future<void> getDirOfFilesToUpload() async {
    final directory = await getExternalStorageDirectory();
    final dir = directory?.path;
    String filesDirectory = '$dir/uploadDirectory';
    final myDir = Directory(filesDirectory);

    listOffilesToUpLoad = myDir.listSync(recursive: true, followLinks: false);
    listOfFilesUploaded = listOffilesToUpLoad.map((file) => file.path).toList();

    //print(listOfFilesUploaded);
    notifyListeners();
  }
}
