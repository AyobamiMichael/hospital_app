import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_app/hospitalwidgets/wireless.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:shared_preferences/shared_preferences.dart';

class CalibrationWidget extends StatefulWidget {
  const CalibrationWidget({super.key});

  @override
  State<CalibrationWidget> createState() => _CalibrationWidgetState();
}

class _CalibrationWidgetState extends State<CalibrationWidget> {
  String message = '';
  String lowestDripLevel = '';
  String highestDripLevel = '';

  static late List<String> listOfSensorValues;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atlantis-UgarSoft'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: 300.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Drip Calibration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        print(WirelessClassState.wifiGateway.toString());
                        await mountDrip(
                            WirelessClassState.wifiGateway.toString(), 'MOUNT');
                        if (message == '200') {
                          Fluttertoast.showToast(
                            msg: "Mounted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 20.0,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: " Not Mounted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 20.0,
                          );
                        }
                      },
                      child: const Text('Mount'))),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await unMountDrip(
                        WirelessClassState.wifiGateway.toString(), 'UNMOUNT');
                    if (message == '200') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unmounted successfully'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: " Not Unmounted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 20.0,
                      );
                    }
                  },
                  child: const Text('Unmount'),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> mountDrip(String wifiGateway, String dataToSend) async {
    print('okay mount');
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
        // print(document);
        final wirelessSensorValues = document.querySelectorAll('p');

        listOfSensorValues =
            wirelessSensorValues.map((element) => element.text).toList();
        // print(listOfSensorValues[0].substring(13));
        setState(() {
          highestDripLevel = listOfSensorValues[0].substring(13);

          message = response.statusCode.toString();
        });
        // Save lowest value here
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future<bool> result =
            prefs.setString('HIGHESTDRIPLEVEL', highestDripLevel);
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> unMountDrip(String wifiGateway, String dataToSend) async {
    print('okay unmount');
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

        //  final responseBody = response.body;
        //final document = htmlparser.parse(responseBody);
        // print(document);
        // final wirelessSensorValues = document.querySelectorAll('p');

        // listOfSensorValues =
        // wirelessSensorValues.map((element) => element.text).toList();
        // print(WirelessClassState.listOfSensorValues[0].substring(13));
        setState(() {
          lowestDripLevel =
              WirelessClassState.listOfSensorValues[0].substring(13);
          message = response.statusCode.toString();
        });
        // Save highest value
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future<bool> result =
            prefs.setString('LOWESTDRIPLEVEL', lowestDripLevel);
        print(result);
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
