import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/hospitalwidgets/healthinfo.dart';
import 'package:hospital_app/hospitalwidgets/heartgraph.dart';
import 'package:hospital_app/hospitalwidgets/screenrotationtesting.dart';
import 'package:hospital_app/hospitalwidgets/udpconnection.dart';
import 'package:hospital_app/providers/connectingprovider.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:udp/udp.dart';

class WirelessClass extends StatefulWidget {
  const WirelessClass({super.key});

  @override
  State<WirelessClass> createState() => WirelessClassState();
}

class WirelessClassState extends State<WirelessClass> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  final NetworkInfo networkInfo = NetworkInfo();

  bool shouldCheckCan = true;
  static String wifiSSID = '';
  static String wifiBSSID = '';
  String connectedOrNotText = '';
  String disconnectText = '';
  int wifiIndexConnected = 0;
  String wifiIndexDisconnected = '';
  String? ip;
  String? gateWay;
  static String? wifiGateway;
  late Timer fectchingDataTimer;
  static late List<String> listOfSensorValues;
  static late List<String> listOfOxygenSensorValues;
  static String? oxygenInTheBlood;

  //late UDPReceiver _udpReceiver;
  late StreamSubscription _subscription;
  String _message = '';
  // late UDPReceiver udpReceiver;
  late RawDatagramSocket _socket;
  late UDP sender;
  static double randomValues = 0.0;
  @override
  void initState() {
    super.initState();

    _startScan(context);
    listOfSensorValues = [''];
    // returnTheScreenBack();
    // sendDataUDP();
  }

  @override
  void dispose() {
    super.dispose();

    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
    //]);
    // _subscription.cancel();
    //_udpReceiver.close();
    // udpReceiver.close();
  }

  void listenForConnection(value) {
    context.read<ConnectionProvider>().checkConnection(value);
    // _connectionProvider =
    //   Provider.of<ConnectionProvider>(context, listen: false);
    //_connectionProvider.checkConnection(value);
  }

  void returnTheScreenBack() {
    // WidgetsFlutterBinding.ensureInitialized();
    print('Okay');
    setState(() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('BACK');
    //WidgetsFlutterBinding.ensureInitialized();
    // Navigator.pop(context, true);
    //  SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    // ]);

    return Scaffold(
        appBar: AppBar(
          title: const Text('AtlantisUgarSoft'),
        ),
        body: Column(
          children: [
            Expanded(
                child: SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: accessPoints.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(Icons.medical_services),
                      trailing: IconButton(
                        icon: Icon(Icons.wifi_off_rounded),
                        onPressed: disConnectFromArduinoWireless,
                        tooltip: 'Disconnect',
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      title: Text(accessPoints[index].ssid),
                      subtitle: Text(accessPoints[index].bssid),
                      onTap: () async => {
                        //  connectToDevice(_devices[index].name),
                        //  print(accessPoints[index].venueName),

                        setState(() {
                          wifiSSID = accessPoints[index].ssid;
                          wifiBSSID = accessPoints[index].bssid;
                          wifiIndexConnected = index;
                        }),
                        print(wifiIndexConnected),
                        if (await WiFiForIoTPlugin.isConnected())
                          {
                            listenForConnection('Connected'),
                            getWifiIpAddress(),
                            setState(() {
                              connectedOrNotText = 'Connected';
                              disconnectText = 'Disconnect';
                            }),
                            print('Connected'),

                            // go to healthInfo
                            loadHealthInfoGraph()
                            //requestForSensorValues(wifiGateway!, 'sensors')
                          }
                        else
                          {
                            {displayPasswordBox(context)},
                          }
                      },
                    );
                  }),
            ))
          ],
        ));
  }

  /* Future<void> requestForSensorValues(
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
        // print('Response from Arduino: ${response.body}');
        //final responseBody = response.body;
        //final document = htmlparser.parse(responseBody);

        // final OxygenVlaues = document.querySelectorAll('p');

        //listOfOxygenValues =
        //  OxygenVlaues.map((element) => element.text).toList();
        // print(OxygenVlaues);
        // final wirelessSensorValues = document.querySelectorAll('p');
        //loadHealthInfoGraph();

        final response = await http.get(Uri.parse('http://$wifiGateway'));
        // http.Request;
        final responseBody = response.body;

        // Parse HTML content
        final document = htmlparser.parse(responseBody);
        print(document);
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
  }*/

  void loadHealthInfoGraph() async {
    print(listOfSensorValues);
    print('OKAY HEALTH');
    try {
      if (listOfSensorValues[0].contains('Sensor DripLevel')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatientHealthData()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Disconnected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 20.0,
        );
      }
    } catch (e) {
      print('Invalid');
    }
  }

  void startTimer() {
    const duration = Duration(seconds: 2);
    fectchingDataTimer = Timer.periodic(duration, (Timer timer) {
      // FETCH DATA UDP OR HTTP
      fetchData(wifiGateway!);
      //fetchUDPData(wifiGateway!);
      //udpDataNew();
    });
  }

  double generateRandomValue() {
    Random random = Random();
    return random.nextDouble() * 150.0 + 10.0;
  }

  void cancelTimer() {
    fectchingDataTimer.cancel();
  }

  Future<void> _startScan(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canStartScan();

      if (can != CanStartScan.yes) {
        return;
      }
    }

    await WiFiScan.instance.startScan();

    setState(() => accessPoints = <WiFiAccessPoint>[]);
    _getScannedResults();
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults() async {
    if (await _canGetScannedResults(context)) {
      final results = await WiFiScan.instance.getScannedResults();

      setState(() => accessPoints = results);
    }
  }

  Future<void> connectToArduinoWireless() async {
    // final deviceIpAddress = _networkInfo.getWifiIP();
    // print(deviceIpAddress);

    try {
      await WiFiForIoTPlugin.connect(wifiSSID, bssid: wifiBSSID);
      getWifiIpAddress();
      // fetchData();

      print('connected to$wifiSSID');
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

  void disConnectFromArduinoWireless() {
    WiFiForIoTPlugin.disconnect();
    setState(() {
      disconnectText = '';
      connectedOrNotText = 'Disconnected';
      cancelTimer();
    });

    Fluttertoast.showToast(
      msg: "Disconnected",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 20.0,
    );
    print('Diconnected');
  }

  void displayPasswordBox(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password'),
          actions: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                connectToArduinoWireless();

                Navigator.pop(context);
              },
              child: Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  void getWifiIpAddress() async {
    ip = await WiFiForIoTPlugin.getIP();

    wifiGateway = await networkInfo.getWifiGatewayIP();

    print(wifiGateway);

    // sendData(wifiGateway!, "oxygen");
    //print(gateWay);
    // timer needed to keepfetching
    try {
      // final response = await http.get(Uri.parse('http://$wifiGateway'));
      // print('Response from Arduino: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
    if (wifiGateway!.isNotEmpty) {
      //requestForSensorValues(wifiGateway!, 'sensors');
      // CALL TIMER TO KEEP FETCHING DATA
      startTimer();
    } else {
      print('No gatewayIp');
    }
  }

  Future<void> fetchData(String wifiGateway) async {
    try {
      final response = await http.get(Uri.parse('http://$wifiGateway'));
      // http.Request;
      final responseBody = response.body;

      // Parse HTML content
      final document = htmlparser.parse(responseBody);
      // print(document);
      // Extract data from HTML

      final wirelessSensorValues = document.querySelectorAll('p');

      listOfSensorValues =
          wirelessSensorValues.map((element) => element.text).toList();
      // print(listOfSensorValues);

      //sendData(wifiGateway, 'oxygen');
      // RANDOM VALUES FOR GRAPH
      /* if (int.tryParse(listOfSensorValues[2].substring(22)) != 0) {
        setState(() {
          randomValues = generateRandomValue();
        });
      }*/
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendData(String wifiGateway, String dataToSend) async {
    try {
      final response = await http.post(
        Uri.parse('http://$wifiGateway/receiveData'),
        body: {'': dataToSend}, // Replace 'yourKey' with the actual key name
      );

      if (response.statusCode == 200) {
        //print(response.statusCode);
        print('Data sent successfully!');
        print('Response from Arduino: ${response.body}');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchUDPData(String wifiGateWay) async {
    print('UDP HERE');

    final address = InternetAddress.tryParse(wifiGateWay);
    RawDatagramSocket udpSocket = await RawDatagramSocket.bind(address, 5000);
    print(
        'UDP socket is bound to ${udpSocket.address.address}:${udpSocket.port}');
// Listen for incoming messages

    udpSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = udpSocket.receive();

        if (datagram != null) {
          String message = String.fromCharCodes(datagram.data);
          print('Received message: $message');
        }
      }
    });
// Send a message
    //udpSocket.send('Hello, UDP!'.codeUnits, InternetAddress('127.0.0.1'), 12346);

    /*var receiver = await UDP.bind(Endpoint.loopback(port: Port(8888)));

    // receiving\listening
    receiver.asStream(timeout: Duration(seconds: 20)).listen((datagram) {
      var str = String.fromCharCodes(datagram!.data);
      stdout.write(str);
      print(str);
    });*/
    /* var multicastEndpoint =
        Endpoint.multicast(InternetAddress(wifiGateWay), port: Port(54321));

    var receiver = await UDP.bind(multicastEndpoint);

    //var sender = await UDP.bind(Endpoint.any());

    receiver.asStream().listen((datagram) {
      if (datagram != null) {
        var str = String.fromCharCodes(datagram.data);

        stdout.write(str);
        print(str);
      }
    });

    // await sender.send("Foo".codeUnits, multicastEndpoint);

    await Future.delayed(Duration(seconds: 5));

    // sender.close();
    receiver.close();*/
    // FOR UDP TESTING

    //_udpReceiver = UDPReceiver(wifiGateWay, 8888);
    // UDPReceiver udpReceiver = UDPReceiver(wifiGateWay, 8888);
    //await udpReceiver.initSocket();

    // var receiver = await UDP.bind(Endpoint.any());
    //print(receiver.toString());
    // receiver.socket?.listen((datagram) {
    // Handle received data
    //  print(datagram);
    //  String message = utf8.decode(datagram.data);
    // print('Received message: $message');
    // Add your logic to handle the received data
    // });

    /*_socket = await RawDatagramSocket.bind(InternetAddress(wifiGateWay), 8888);
    // print(host + port.toString());
    _socket.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _socket.receive();
        if (datagram != null) {
          print('Received message: ${String.fromCharCodes(datagram.data)}');
        }
      }
    });*/

    // sender.close();
    // receiver.close();
  }

  void sendDataUDP() async {
    // interface on port 65000.
    var sender = await UDP.bind(Endpoint.any(port: Port(65000)));

    // send a simple string to a broadcast endpoint on port 65001.
    var dataLength = await sender.send(
        'Hello World!'.codeUnits, Endpoint.broadcast(port: Port(8888)));

    stdout.write('$dataLength bytes sent.');
  }

  void udpDataNew() async {
    print('udpnew');
    // Bind the UDP socket to any available IPv4 address and port 8888
    var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 1212);

    // Obtain the list of network interfaces
    var interfaces = await NetworkInterface.list();
    print(interfaces);

    // Find the network interface that corresponds to the device's external IP address
    var interface = interfaces.firstWhere((interface) {
      return interface.addresses.any((address) =>
          address.type == InternetAddressType.IPv4 && !address.isLoopback);
    });

    // ignore: unnecessary_null_comparison
    if (interface != null) {
      // Use the device's external IP address to receive packets on the UDP socket
      var address = interface.addresses
          .firstWhere((address) => address.type == InternetAddressType.IPv4);
      print(address);
      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          Datagram? datagram = socket.receive();
          if (datagram != null) {
            print('Received message: ${String.fromCharCodes(datagram.data)}');
          }
        }
      });
    } else {
      print('No network interface found with external IP address');
    }
  }
}
