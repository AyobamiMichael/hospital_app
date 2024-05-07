import 'dart:async';
import 'package:flutter/material.dart';

class BloodPressureAlertBox extends StatefulWidget {
  const BloodPressureAlertBox({super.key});

  @override
  BloodPressureAlertBoxState createState() => BloodPressureAlertBoxState();
}

class BloodPressureAlertBoxState extends State<BloodPressureAlertBox> {
  static const hola = '';
  @override
  void initState() {
    super.initState();
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dialog Box"),
          content: Text("Do you want to start or cancel?"),
          actions: <Widget>[
            TextButton(
              child: Text("Start"),
              onPressed: () {
                // Handle Start button click
                Navigator.of(context).pop();
                // Add your logic for the Start action here
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                // Handle Cancel button click
                Navigator.of(context).pop();
                // Add your logic for the Cancel action here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dialog Box Example"),
      ),
      body: Center(
        child: Text("This is the Home Page"),
      ),
    );
  }
}
