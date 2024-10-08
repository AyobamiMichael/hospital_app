import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hospital_app/hospitalwidgets/wireless.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;

class BpCheckerDisplay extends StatefulWidget {
  const BpCheckerDisplay({super.key});

  @override
  State<BpCheckerDisplay> createState() => _BpCheckerDisplayState();
}

class _BpCheckerDisplayState extends State<BpCheckerDisplay> {
  static late List<String> listOfValues;
  double bpMonitorSys = 0.0;
  double bpMonitorDia = 0.0;
  String bpMonitorHr = '';
  String testingValue = '';
  String bpMonitorDiaStringValue = '';

  late Timer fectchingDataTimer;

  @override
  void initState() {
    super.initState();

    //startTimer();
    fetchData(WirelessClassState.wifiGateway.toString());
  }

  void startTimer() {
    const duration = Duration(seconds: 2);
    // Example
    //fetchData(WirelessClassState.wifiGateway.toString());
    fectchingDataTimer = Timer.periodic(duration, (Timer timer) {
      WirelessClassState.listOfSensorValues = [];
      if (WirelessClassState.listOfSensorValues.isNotEmpty) {
        // bpMonitorSys = WirelessClassState.listOfSensorValues[7].substring(22);
        //bpMonitorDia = WirelessClassState.listOfSensorValues[7].substring(22);
        //testingValue = WirelessClassState.listOfSensorValues[3].substring(21);
        //print(testingValue);
      } else {
        // bpMonitorSys = '0';
        //bpMonitorDia = '0';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    fectchingDataTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atlantis-UgarSoft'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'SYS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(child: LCDNumberDisplay(number: bpMonitorSys.toInt())),
          Divider(
            height: 5,
            thickness: 2,
            color: Colors.grey[300],
            indent: 20,
            endIndent: 20,
          ),
          const Text(
            'DIA',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(child: LCDNumberDisplay(number: bpMonitorDia.toInt())),
          Divider(
            height: 5,
            thickness: 2,
            color: Colors.grey[300],
            indent: 20,
            endIndent: 20,
          ),
          const Text(
            'DIA',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(child: LCDNumberDisplay(number: 500)),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Future<void> fetchData(String wifiGateway) async {
    try {
      final response = await http.get(Uri.parse('http://$wifiGateway/'));
      // http.Request;
      final responseBody = response.body;

      // Parse HTML content
      final document = htmlparser.parse(responseBody);
      //print(document);
      // Extract data from HTML

      final wirelessSensorValues = document.querySelectorAll('p');

      listOfValues =
          wirelessSensorValues.map((element) => element.text).toList();
      print(listOfValues);
      if (listOfValues.isNotEmpty) {
        testingValue = listOfValues[8].substring(22);
        //listOfValues[3].substring(20);
        bpMonitorDiaStringValue = listOfValues[7].substring(22);

        double? nubValue = double.tryParse(testingValue);
        double? bpMonitorV1 = double.tryParse(bpMonitorDiaStringValue);
        //print(nubValue!);
        setState(() {
          bpMonitorSys = nubValue!;
          bpMonitorDia = bpMonitorV1!;
        });
      } else {
        bpMonitorSys = 0.0;
        bpMonitorDia = 0.0;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class LCDNumberDisplay extends StatelessWidget {
  final int number;

  LCDNumberDisplay({required this.number});

  @override
  Widget build(BuildContext context) {
    String numberStr = number.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          numberStr.split('').map((digit) => LCDDigit(digit: digit)).toList(),
    );
  }
}

class LCDDigit extends StatelessWidget {
  final String digit;

  LCDDigit({required this.digit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        digit,
        style: TextStyle(
          fontFamily:
              'Technology', // Ensure you have a digital font or use a built-in style
          fontSize: 48.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
