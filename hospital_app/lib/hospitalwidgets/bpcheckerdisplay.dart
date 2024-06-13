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
  @override
  void initState() {
    super.initState();

    fetchData(WirelessClassState.wifiGateway.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atlantis-UgarSoft'),
      ),
      body: Center(child: LCDNumberDisplay(number: 12345)),
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
