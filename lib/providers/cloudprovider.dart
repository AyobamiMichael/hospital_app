import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CloudFileModel with ChangeNotifier {
  List<List<dynamic>> csvTable = [];
  // List<FileSystemEntity> listOffilesToUpLoad = [];
  // List<String> listOfFilesUploaded = [];

  Future<List<List<dynamic>>> loadDataFromCsv(String filePath) async {
    // CHECK LIST OF FILES INSIDE THE UPLOADED FILES FOLDER

    // print('path$filePath');

    final file = File(filePath);

    if (await file.exists()) {
      final csvData = await file.readAsString();
      csvTable = const CsvToListConverter().convert(csvData);
//      print(csvTable[4][0]);
      //  print(csvTable);
      // SEND DATA TO FIREBASE FROM HERE
      // RENAME FILE HERE
      saveDataToFireStore(filePath);
      //print(filePath.substring(0, 100));
      notifyListeners();
      return csvTable;
    } else {
      return [];
    }
  }

  // Firebase db
  void saveDataToFireStore(String path) {
    //print(csvTable[4][0]);
    // print(csvTable);
    // print(path.substring(84, 90));
    //print(path.substring(84, 90));
    // print(path);

    for (int i = 1; i < csvTable.length; i++) {
      // recordedTimeList.add(csvTable[i][0] / 1000000000000);
      // recordedHeartBeatList.add(csvTable[i][1]);
      // recordedBreathingRateList.add(int.parse(csvTable[i][2]));
      try {
        FirebaseFirestore.instance.collection('data').add({
          'health info': [
            (csvTable[i][0] / 1000000000000),
            csvTable[i][1],
            csvTable[i][2]
          ]
        });
        print('Done');

        Fluttertoast.showToast(
          msg: "File successfully uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (error) {
        print('error sending data to Firestore: $error');
      }
    }

    final originalFile = File(path);
    final newPath = path.replaceFirst(RegExp(r'(\.csv)$'), '_up.csv');
    originalFile.renameSync(newPath);
    print('File renamed to $newPath');
  }
}
