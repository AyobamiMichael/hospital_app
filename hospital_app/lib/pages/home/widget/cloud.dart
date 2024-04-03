import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hospital_app/hospitalwidgets/datalisttocloud.dart';
import 'package:hospital_app/providers/filesavingprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class Cloud extends StatefulWidget {
  const Cloud({super.key});

  @override
  State<Cloud> createState() => CloudState();
}

class CloudState extends State<Cloud> {
  String _filePath = '';
  String fileFormat = 'Invalid file format';
  late DataRepositoryModel _dataRepositoryModel;
  late Timer dataTimer;
  List<List<dynamic>> csvTable = [];

  @override
  void initState() {
    super.initState();
    _dataRepositoryModel = DataRepositoryModel();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PatientDataListToCloudScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue, backgroundColor: Colors.white

          // You can customize other properties like padding, shape, etc. here
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .center, // Aligns children vertically at the center

        children: [
          const Icon(
            Icons.cloud_upload,
            size: 75,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            "Cloud",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
