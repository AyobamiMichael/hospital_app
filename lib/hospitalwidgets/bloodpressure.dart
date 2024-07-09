import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hospital_app/hospitalwidgets/bloodpressurealert.dart';
import 'package:hospital_app/hospitalwidgets/bpcheckerdisplay.dart';
import 'package:hospital_app/hospitalwidgets/wireless.dart';
import 'package:hospital_app/providers/deviceconnectedprovider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:html/parser.dart' as htmlparser;

class BloodPressure extends StatefulWidget {
  const BloodPressure({super.key});

  @override
  State<BloodPressure> createState() => _BloodPressureState();
}

double portraitWidth = 0.0;
double portraitHeight = 0.0;

class _BloodPressureState extends State<BloodPressure> {
  final _formKey = GlobalKey<FormState>();
  final _bpController1 = TextEditingController();
  final _bpController2 = TextEditingController();
  static late List<String> listOfOxygenSensorValues;
  String oxygenInTheBlood = '';
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    // connectToArduinoWireless();
    // request for the oxygen level here
    //getOxygenInTheBlood(WirelessClassState.wifiGateway.toString(), 'oxygen');
    //requestForOxygenSensorValues(
    //  WirelessClassState.wifiGateway.toString(), 'sensors');
    // print(WirelessClassState.wifiGateway);
    // print(WirelessClassState.oxygenInTheBlood!);
    //print(WirelessClassState.wifiBSSID);
    // print(WirelessClassState.wifiSSID);
    // WirelessClassState().sendData(WirelessClassState.wifiGateway!, 'oxygen');

    showOxygenIntheBlood();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      showDialogBox();
      print('TIMER STARTED');
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      print('TIMER STOPPED');
    }
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Blood Pressure Check", textAlign: TextAlign.center),
          content: Text("Check Patient's Blood Pressure"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: Colors.blue),
              child: Text("Start"),
              onPressed: () {
                //Navigator.of(context).pop();
                stopTimer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BpCheckerDisplay()),
                );
              },
            ),
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    portraitWidth = MediaQuery.of(context).size.width;
    portraitHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atlantis-UgarSoft'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Device connected to:${context.watch<DeviceConnectionProvider>().deviceName}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 15),
            Text(
              'Oxygen in the blood: $oxygenInTheBlood',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text('Patient Info'),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // Adjust horizontal alignment
              child: Container(
                width: 120, // Adjust the width as needed
                child: TextFormField(
                  controller: _bpController1,
                  decoration: InputDecoration(
                    labelText: 'High',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 2,
                    child: CustomPaint(painter: LinePainter()))),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight, // Adjust horizontal alignment
              child: Container(
                width: 120, // Adjust the width as needed
                child: TextFormField(
                  controller: _bpController2,
                  decoration: InputDecoration(
                    labelText: 'Low',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey[300],
              indent: 20,
              endIndent: 20,
            ),
            const Text(
              'BP Correction Factor',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft, // Adjust horizontal alignment
              child: Container(
                width: 120, // Adjust the width as needed
                child: TextFormField(
                  controller: _bpController1,
                  decoration: InputDecoration(
                    labelText: 'High',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 2,
                    child: CustomPaint(painter: LinePainter()))),
            Align(
              alignment: Alignment.centerRight, // Adjust horizontal alignment
              child: Container(
                width: 120, // Adjust the width as needed
                child: TextFormField(
                  controller: _bpController2,
                  decoration: InputDecoration(
                    labelText: 'Low',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String bp1 = _bpController1.text;
      String bp2 = _bpController2.text;
      // sendDataToArduino(name, deviceId);
    }
  }

  void showOxygenIntheBlood() {
    try {
      if (WirelessClassState.listOfSensorValues.isNotEmpty) {
        setState(() {
          oxygenInTheBlood =
              WirelessClassState.listOfSensorValues[5].substring(20);
        });
        // print(WirelessClassState.listOfSensorValues[6]);
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> getOxygenInTheBlood(
      String wifiGateway, String dataToSend) async {
    print('okay go get oxygen');
    try {
      final response = await http.post(
        Uri.parse('http://$wifiGateway/receiveData'),
        body: {'': dataToSend},
      );

      if (response.statusCode == 200) {
        //print(response.statusCode);
        print('Data sent successfully!');
        print('Response from Arduino: ${response.body}');
        // Disconnect from the Wifi
        // disConnectFromArduinoWireless();

        final responseBody = response.body;
        final document = htmlparser.parse(responseBody);
        print(document);
        // final wirelessSensorValues = document.querySelectorAll('p');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestForOxygenSensorValues(
      String wifiGateway, String dataToSend) async {
    print('okay get sensor values');
    try {
      final response = await http.post(
        Uri.parse('http://$wifiGateway/receiveData'),
        body: {'': dataToSend},
      );

      if (response.statusCode == 200) {
        //print(response.statusCode);
        print('Data sent successfully!');

        final response = await http.get(Uri.parse('http://$wifiGateway'));
        // http.Request;
        final responseBody = response.body;

        // Parse HTML content
        final document = htmlparser.parse(responseBody);
        // print(document);
        // Extract data from HTML

        final oxygenSensorValues = document.querySelectorAll('p');

        listOfOxygenSensorValues =
            oxygenSensorValues.map((element) => element.text).toList();
        print(listOfOxygenSensorValues);
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectToArduinoWireless() async {
    try {
      await WiFiForIoTPlugin.connect(WirelessClassState.wifiSSID,
          bssid: WirelessClassState.wifiBSSID);
      String wifiSSID = WirelessClassState.wifiSSID;
      print('connected to$wifiSSID');
    } catch (e) {
      print("Failed to connect: $e");
    }
    print(WirelessClassState.wifiGateway!);
    //getOxygenInTheBlood(WirelessClassState.wifiGateway!, 'oxygen');
  }

  void disConnectFromArduinoWireless() {
    WiFiForIoTPlugin.disconnect();
    print('Diconnected');
  }

  Future<void> requestForSensorValues(
      String wifiGateway, String dataToSend) async {
    try {
      final response = await http.post(
        Uri.parse('http://$wifiGateway/receiveData'),
        body: {'': dataToSend},
      );

      if (response.statusCode == 200) {
        //print(response.statusCode);
        print('Data sent successfully!');
        print('Response from Arduino: ${response.body}');
        final responseBody = response.body;
        final document = htmlparser.parse(responseBody);
        print(document);
        // final wirelessSensorValues = document.querySelectorAll('p');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}

class LinePainter extends CustomPainter {
  final Paint _paintLine = Paint()
    ..color = Colors.black
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, size) {
    // print(size.height);
    canvas.drawLine(Offset(100, size.width / 6),
        Offset(portraitWidth / 2, size.height - 40), _paintLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
