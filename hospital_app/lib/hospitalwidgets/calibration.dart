// IT'S ALL HISTORY, LET NOTHING WORRY YOU.

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
  String dropdownValue = 'Option 1';
  String radioValue = 'A';

  static late List<String> listOfSensorValues;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atlantis-UgarSoft'),
        ),
        body: Container(
          // padding: const EdgeInsets.all(20.0),
          // decoration: BoxDecoration(
          // border: Border.all(
          //  color: Colors.black,
          // width: 1.5,
          //),
          //  borderRadius: BorderRadius.circular(5.0),
          // ),
          height: 315.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Radio(
                  value: 'A',
                  groupValue: radioValue,
                  onChanged: (String? value) {
                    setState(() {
                      radioValue = value!;
                    });
                  },
                ),
                Text('A'),
                Radio(
                  value: 'B',
                  groupValue: radioValue,
                  onChanged: (String? value) {
                    setState(() {
                      radioValue = value!;
                    });
                  },
                ),
                Text('B'),
                Radio(
                  value: 'C',
                  groupValue: radioValue,
                  onChanged: (String? value) {
                    setState(() {
                      radioValue = value!;
                    });
                  },
                ),
                Text('C'),
              ]),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Option 1', 'Option 2', 'Option 3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const Text(
                'Drip Calibration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await unMountDrip(
                        WirelessClassState.wifiGateway.toString(), 'UNMOUNT');

                    if (message == '200') {
                      Fluttertoast.showToast(
                        msg: "Unmounted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 20.0,
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
              ),
              const SizedBox(height: 20),
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
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),

              /*
              const SizedBox(height: 5),
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
              const SizedBox(height: 10),
              
              ),
              const Divider(
                color: Colors.black,
                thickness: 1.5,
                height: 20,
                indent: 10,
                endIndent: 10,
              ),
              const Text(
                'Drip Calibration B',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
             
              const SizedBox(height: 15),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await unMountDrip(
                        WirelessClassState.wifiGateway.toString(), 'UNMOUNT');

                    if (message == '200') {
                      Fluttertoast.showToast(
                        msg: "Unmounted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 20.0,
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
              ),
              const Divider(
                color: Colors.black,
                thickness: 1.5,
                height: 20,
                indent: 10,
                endIndent: 10,
              ),
              const Text(
                'Drip Calibration C',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 15),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await unMountDrip(
                        WirelessClassState.wifiGateway.toString(), 'UNMOUNT');

                    if (message == '200') {
                      Fluttertoast.showToast(
                        msg: "Unmounted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 20.0,
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
              )*/
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
          message = '200';
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
