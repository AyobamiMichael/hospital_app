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
  String dropdownValue = '';
  String radioValue = 'A';
  String slot1 = 'No value';
  String slot2 = '';
  String slot3 = '';

  String defaultdrip1 = 'No value';
  String defaultdrip2 = '';
  String defaultdrip3 = '';

  static late List<String> listOfSensorValues;
  final _dripNameController = TextEditingController();
  String dripName = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atlantis-UgarSoft'),
        ),
        body: SingleChildScrollView(
            child: Container(
          // padding: const EdgeInsets.all(20.0),
          // decoration: BoxDecoration(
          // border: Border.all(
          //  color: Colors.black,
          // width: 1.5,
          //),
          //  borderRadius: BorderRadius.circular(5.0),
          // ),
          height: 520.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Asign Drip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Radio(
                        value: 'A',
                        groupValue: radioValue,
                        onChanged: (String? value) {
                          setState(() {
                            radioValue = value!;
                          });
                        },
                      ),
                    ),
                    Text('A'),
                    SizedBox(width: 50),
                    Text('None'),
                  ],
                ),
                Row(
                  children: [
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
                    SizedBox(width: 50),
                    Text('None'),
                  ],
                ),
                Row(
                  children: [
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
                    SizedBox(width: 50),
                    Text('None'),
                  ],
                )
              ]),
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 90,
                      ),
                      DropdownButton<String>(
                        value: defaultdrip1,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                          print('DROPDOWN VALUE' + dropdownValue);
                          // SEND THE KEY TO ARDUINO
                          assignDripData(
                              WirelessClassState.wifiGateway.toString(),
                              dropdownValue);
                        },
                        items: <String>[
                          defaultdrip1,
                          defaultdrip2,
                          defaultdrip3
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await refreshDripData(
                              WirelessClassState.wifiGateway.toString(),
                              'SAVE.DATA');

                          getAndSaveDripDataFromArduinoListOfSensorsData(
                              'HELLO');
                          retriveDripData('HELLO');
                          setState(() {});
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const Text(
                'Config',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: TextFormField(
                  controller: _dripNameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
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
                    await unMountDrip(WirelessClassState.wifiGateway.toString(),
                        'UNMOUNT.$dripName');
                    print(dripName.length);
                    setState(() {
                      dripName = _dripNameController.text;
                    });
                    if (WirelessClassState.listOfSensorValues[0]
                        .contains('Sensor DripLevel')) {
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
                        msg: " Not Connected",
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
                            WirelessClassState.wifiGateway.toString(),
                            'MOUNT.$dripName');
                        print(dripName);
                        setState(() {
                          if (_dripNameController.text.length > 8) {
                            print('Invalid');
                            return;
                          } else {
                            dripName = _dripNameController.text;
                          }
                        });
                        if (WirelessClassState.listOfSensorValues[0]
                            .contains('Sensor DripLevel')) {
                          Fluttertoast.showToast(
                            msg: "Mounted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 20.0,
                          );
                          print(radioValue);
                        } else {
                          Fluttertoast.showToast(
                            msg: " Not Connected",
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
        )));
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

        //final responseBody = response.body;
        //final document = htmlparser.parse(responseBody);
        // print(document);
        //final wirelessSensorValues = document.querySelectorAll('p');

        //listOfSensorValues =
        //  wirelessSensorValues.map((element) => element.text).toList();
        // print(listOfSensorValues[0].substring(13));
        setState(() {
          //highestDripLevel = listOfSensorValues[0].substring(13);

          message = response.statusCode.toString();
        });
        // Save lowest value here
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        //Future<bool> result =
        //prefs.setString('HIGHESTDRIPLEVEL', highestDripLevel);
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
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        //Future<bool> result =
        //   prefs.setString('LOWESTDRIPLEVEL', lowestDripLevel);
        //print(result);
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> refreshDripData(String wifiGateway, String dataToSend) async {
    print('okay Data');
    try {
      final response = await http.post(
        Uri.parse('http://$wifiGateway/receiveData'),
        body: {'': dataToSend},
      );

      if (response.statusCode == 200) {
        //print(response.statusCode);
        print('Data sent successfully!');
        print('Response from Arduino: ${response.body}');

        final document = htmlparser.parse(response.body);
        // print(document);
        // Extract data from HTML

        final wirelessSensorValues = document.querySelectorAll('p');
        print(wirelessSensorValues);
        setState(() {
          // lowestDripLevel =
          //   WirelessClassState.listOfSensorValues[0].substring(13);
          message = '200';
        });
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getAndSaveDripDataFromArduinoListOfSensorsData(
      String dataToSend) async {
    print('SAVEDATA');
    setState(() {
      if (WirelessClassState.listOfSensorValues[0]
          .contains('Sensor DripLevel')) {
        slot1 = WirelessClassState.listOfSensorValues[7].substring(21);
        slot2 = WirelessClassState.listOfSensorValues[8].substring(20);
        slot3 = WirelessClassState.listOfSensorValues[9].substring(20);
      } else {
        slot1 = 'Option 1';
        slot2 = 'Option 2';
        slot3 = 'Option 3';
      }

      //dropdownValue = slot1;
    });

    //print('SLOT ONE' + slot1);
    //print('SLOT TWO' + slot2);
    //print('SLOT THREE' + slot3);

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('defaultdrip1', slot1);
    prefs.setString('defaultdrip2', slot2);
    prefs.setString('defaultdrip3', slot3);
  }

  Future<void> retriveDripData(String dataToSend) async {
    print('RETRIVEDATA');
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // defaultdrip2 = prefs.getString('defaultdrip2')!;
      //defaultdrip3 = prefs.getString('defaultdrip3')!;

      if (defaultdrip1.isEmpty || defaultdrip1.contains('S NOT CHANGE')) {
        defaultdrip1 = 'INVALID VALUE';
      } else {
        defaultdrip1 = prefs.getString('defaultdrip1')!;
      }

      if (defaultdrip2.isEmpty || defaultdrip2.contains('S NOT CHANGE')) {
        defaultdrip2 = 'INVALID VALUE';
      } else {
        defaultdrip2 = prefs.getString('defaultdrip2')!;
      }

      if (defaultdrip3.isEmpty || defaultdrip3.contains('S NOT CHANGE')) {
        defaultdrip3 = 'INVALID VALUE';
      } else {
        defaultdrip3 = prefs.getString('defaultdrip3')!;
      }

      /* if (WirelessClassState.listOfSensorValues[0]
          .contains('Sensor DripLevel')) {
        // slot1 = WirelessClassState.listOfSensorValues[7].substring(21);
        // slot2 = WirelessClassState.listOfSensorValues[8].substring(20);
        // slot3 = WirelessClassState.listOfSensorValues[9].substring(20);
      } else {
        slot1 = 'Option 1';
        slot2 = 'Option 2';
        slot3 = 'Option 3';
      }
       */
      //dropdownValue = slot1;
    });

    print('SLOT ONE' + defaultdrip1);
    print('SLOT TWO' + defaultdrip2);
    print('SLOT THREE' + defaultdrip3);
  }

  Future<void> assignDripData(String wifiGateway, String dataToSend) async {
    print('okay Data');
    // saveDripData('HELLO');
    try {
      final response = await http.post(
        Uri.parse('http://$wifiGateway/receiveData'),
        body: {'': dataToSend},
      );

      if (response.statusCode == 200) {
        //print(response.statusCode);
        print('Data sent successfully!');
        print('Response from Arduino: ${response.body}');

        final document = htmlparser.parse(response.body);
        // print(document);
        // Extract data from HTML

        final wirelessSensorValues = document.querySelectorAll('p');
        print(wirelessSensorValues);
        setState(() {
          // lowestDripLevel =
          //   WirelessClassState.listOfSensorValues[0].substring(13);
          message = '200';
        });
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
