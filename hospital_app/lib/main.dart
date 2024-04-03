// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/errorwidget.dart';
import 'package:hospital_app/pages/details/detail.dart';
import 'package:hospital_app/pages/home.dart';
import 'package:hospital_app/providers/bluetoothprovider.dart';
import 'package:hospital_app/providers/cloudprovider.dart';
import 'package:hospital_app/providers/connectingprovider.dart';
import 'package:hospital_app/providers/dataprovider.dart';
import 'package:hospital_app/providers/deviceconnectedprovider.dart';
import 'package:hospital_app/providers/directoryprovider.dart';
import 'package:hospital_app/providers/filesavingprovider.dart';
import 'package:hospital_app/hospitalwidgets/healthnotificationsservice.dart';
import 'package:hospital_app/providers/passwordprovider.dart';
import 'package:hospital_app/providers/patientInfoprovider.dart';
import 'package:hospital_app/providers/readdatafromepromarduinoprovider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  /* FlutterError.onError = (FlutterErrorDetails details) {
   
    print('Global Error: ${details.exception}');
    print('Stack Trace: ${details.stack}');

    runApp(MyCustomErrorApp(details: details));
  };*/

  WidgetsFlutterBinding.ensureInitialized();
  /* SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SensorDataModel()),
      ChangeNotifierProvider(create: (context) => ConnectionProvider()),
      ChangeNotifierProvider(create: (context) => DeviceConnectionProvider()),
      ChangeNotifierProvider(create: (context) => DataProviderModel()),
      ChangeNotifierProvider(create: (context) => DirectoryProviderModel()),
      ChangeNotifierProvider(create: (context) => DataRepositoryModel()),
      ChangeNotifierProvider(create: (context) => PasswordProvider()),
      ChangeNotifierProvider(
          create: (context) => ReadDataFromAdrduinoEpromProvider()),
      ChangeNotifierProvider(create: (context) => PatientinfoProvider()),
      ChangeNotifierProvider(create: (context) => CloudFileModel()),
    ],
    child: const MyApp(),
  ));
  // const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Patient Monitor',
      theme: ThemeData(
        fontFamily: "Roboto",
        textTheme: TextTheme(
            displayLarge: TextStyle(
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w900,
        )),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/detail': (context) => DetailsPage(),
      },
      initialRoute: '/',
      //home: DetailsPage(),
    );
  }
}
