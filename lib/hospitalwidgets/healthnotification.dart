import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/hospitalwidgets/healthnotificationsservice.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/timezone.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:audioplayers/audioplayers.dart';

class HealthNotification extends StatefulWidget {
  const HealthNotification({super.key});

  @override
  State<HealthNotification> createState() => _NotificationState();
}

class _NotificationState extends State<HealthNotification> {
  //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //  FlutterLocalNotificationsPlugin();

  bool enableNotifications = false;
  bool enablePatientDirectNotifications = false;
  bool isGridViewVisible = false;
  bool isToggleOn = false;
  final String toggleKey = 'toggleState';
  final List<List<dynamic>> csvData = [];
  final String csvFileName = 'patientname.csv';
  String patientName = '';

  @override
  void initState() {
    super.initState();
    //  getNotificationsProvider();
    HealthNotificationsService().initialiseAllNotifications();
    //loadToggleState();
    //loadCsvcsvData();
  }

//  void getNotificationsProvider() async {}
  Future<void> retrievePatientNameAndSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    patientName = prefs.getString('patientname') ?? 'No name';
    // print(storedPassword);
    print({'patientNameStored:$patientName'});
    if (patientName.isNotEmpty) {
      final timestamp = DateTime.now();
      final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

      setState(() {
        csvData.add([patientName, formattedTime]);
      });
      savecsvData();
    }
  }

  Future<void> loadCsvcsvData() async {
    final file = File(await getFilePath());
    if (await file.exists()) {
      final csvString = await file.readAsString();
      final csvList = const CsvToListConverter().convert(csvString);
      setState(() {
        csvData.addAll(csvList);
      });
    }
  }

  Future<void> savecsvData() async {
    final file = File(await getFilePath());
    final csvString = const ListToCsvConverter().convert(csvData);
    await file.writeAsString(csvString);
  }

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$csvFileName';
  }

  void loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggleOn = prefs.getBool(toggleKey) ?? false;
    });
  }

  void saveToggleState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(toggleKey, value);
  }

  void toggleNotification(bool value) {
    setState(() {
      enableNotifications = value;
      //  print(value);
      if (enableNotifications) {
        // Notification to check patient enabled
        HealthNotificationsService().startNotificationTimer();
      } else {
        // Disable notifications
        HealthNotificationsService().cancelNotificationTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Toggle switches at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Notifications'),
                Switch(
                  value: enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      enableNotifications = value;
                      toggleNotification(enableNotifications);
                      print(value);
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Patient Direct Notifications'),
                Switch(
                  value: enablePatientDirectNotifications,
                  onChanged: (value) {
                    setState(() {
                      enablePatientDirectNotifications = value;
                      // saveToggleState(enableNotifications);
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // retrievePatientNameAndSave();
              },
              child: const Text('Done'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isGridViewVisible = !isGridViewVisible;
                });
              },
              child: Text('Load Report'),
            ),
            // GridView
            Visibility(
              visible: isGridViewVisible,
              child: Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount:
                      csvData.length, // Adjust the number of items as needed
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Center(
                        child: Text(csvData[index][0].toString()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
