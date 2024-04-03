import 'package:flutter/material.dart';
import 'package:hospital_app/providers/cloudprovider.dart';
//import 'package:hospital_app/providers/dataprovider.dart';
import 'package:hospital_app/providers/directoryprovider.dart';
import 'package:hospital_app/providers/filesavingprovider.dart';
//import 'package:hospital_app/hospitalwidgets/recordedgraph.dart';
import 'package:provider/provider.dart';
//import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PatientDataListToCloudScreen extends StatefulWidget {
  const PatientDataListToCloudScreen({super.key});

  @override
  State<PatientDataListToCloudScreen> createState() =>
      _PatientDataListToCloudScreenState();
}

class _PatientDataListToCloudScreenState
    extends State<PatientDataListToCloudScreen> {
  // Step 1: Create a list of boolean values to track item selection.
  List<bool> selectedItems = [];
  List<String> fileData = [];
  late DirectoryProviderModel _directoryProviderModel;
  late DataRepositoryModel _dataRepositoryModel;
  late CloudFileModel _cloudFileModel;
  List<String> listOfFileNames = [];
  bool selectedItem = false;
  int lengthForGeneratedCheckBox = 0;

  @override
  void initState() {
    super.initState();
    context.read<DirectoryProviderModel>().getDir();

    _directoryProviderModel = DirectoryProviderModel();
    _dataRepositoryModel = DataRepositoryModel();
    _cloudFileModel = CloudFileModel();
  }

  @override
  void dispose() {
    super.dispose();
    // _dataRepositoryModel.dispose();
    //_directoryProviderModel.dispose();
    //_cloudFileModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atlantis-UgarSoft'),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: context
                    .watch<DirectoryProviderModel>()
                    .listOfFilesNames2
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      // Add a border to the ListTile
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.grey, // Border color based on selection
                        width: 5.0,
                      ),
                    ),
                    leading: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 60,
                    ),
                    // Step 2: Add a Checkbox to select items for deletion
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.cloud_upload),
                          onPressed: () {
                            // FILES GOES TO THE FIREBASE FROM HERE
                            _directoryProviderModel =
                                Provider.of<DirectoryProviderModel>(context,
                                    listen: false);

                            _directoryProviderModel.listOfFilesNames2[index]
                                    .endsWith('_up.csv')
                                ? Fluttertoast.showToast(
                                    msg: "File already uploaded",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.orange,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  )
                                : _cloudFileModel.loadDataFromCsv(
                                    _directoryProviderModel
                                        .listOfFilesNames2[index]);
                          },
                        ),
                        // Step 3: Add a Share button for Email
                        /* IconButton(
                          icon: Icon(Icons.email),
                          onPressed: () {
                            // Get the file or data you want to share
                            String filePath = context
                                .read<DirectoryProviderModel>()
                                .listOfFilesNames2[index];

                            // Share via Email
                            Share.shareFiles([filePath],
                                subject: 'Subject of the Email',
                                text: 'Body of the Email');
                          },
                        ),*/
                        /* Checkbox(
                          value: selectedItems[index],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedItems[index] = value ?? false;

                              print(selectedItems);
                            });
                          },
                        )*/
                      ],
                    ),
                    title: Text(context
                        .watch<DirectoryProviderModel>()
                        .listOfFilesNames2[index]
                        .substring(69, 74)),
                    subtitle: Text(
                        "${context.watch<DirectoryProviderModel>().listOfFilesNames2[index].substring(74, 84)} ${context.watch<DirectoryProviderModel>().listOfFilesNames2[index].substring(84, 86)}${':'}${context.watch<DirectoryProviderModel>().listOfFilesNames2[index].substring(86, 90)} "),
                    onTap: () {
                      // Use providerOf for better content from the provider
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
