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
  String bpMonitorSys = '';
  String bpMonitorDia = '';
  String bpMonitorHr = '';

  @override
  void initState() {
    super.initState();

    fetchData(WirelessClassState.wifiGateway.toString());
    WirelessClassState.listOfSensorValues = [];
    if (WirelessClassState.listOfSensorValues.isNotEmpty) {
      bpMonitorSys = WirelessClassState.listOfSensorValues[7].substring(22);
      bpMonitorDia = WirelessClassState.listOfSensorValues[7].substring(22);
      print(bpMonitorSys);
    } else {
      bpMonitorSys = '0';
      bpMonitorDia = '0';
    }
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
          Center(child: LCDNumberDisplay(number: int.parse(bpMonitorSys))),
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
          Center(child: LCDNumberDisplay(number: int.parse(bpMonitorDia))),
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
          Center(child: LCDNumberDisplay(number: int.parse(bpMonitorDia))),
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
      // print(document);
      // Extract data from HTML

      final wirelessSensorValues = document.querySelectorAll('p');

      listOfValues =
          wirelessSensorValues.map((element) => element.text).toList();
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
          color: Colors.black,
        ),
      ),
    );
  }
}
