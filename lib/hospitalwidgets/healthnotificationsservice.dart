import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class HealthNotificationsService {
  bool isReminderEnabled = false;
  String patientName = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String setTime = '';
  late Timer notificationTimer;

  Future<void> initialiseAllNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIos = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, payload) async {});
    // Android settings
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
    );
  }

  Future displayNotificationsDetails(
      {int id = 0, String? title, String? body, String? payload}) async {
    // notifyListeners();
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> retrievePatientNameAndSetTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    patientName = prefs.getString('patientname') ?? 'No name';
    // print(storedPassword);
    print({'patientNameStored:$patientName'});
    //notifyListeners();
  }

  // For background notifications when the App is not ative
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }

    //notifyListeners();
  }

  void startNotificationTimer() {
    const oneHour = Duration(minutes: 1);
    notificationTimer = Timer.periodic(oneHour, (Timer timer) {
      displayNotificationsDetails(title: 'Emergency', body: 'Patient1');
    });

    /* notificationTimer = Timer(oneHour, () {
      displayNotificationsDetails(title: 'Emergency', body: 'Patient1');
    });*/
    print('Timer Started');
  }

  void cancelNotificationTimer() {
    if (notificationTimer.isActive) {
      notificationTimer.cancel();
      print('Timer Canceled');
    } else {
      print('timer not active');
    }
  }
}
