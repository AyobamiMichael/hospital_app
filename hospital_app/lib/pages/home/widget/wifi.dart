import 'package:flutter/material.dart';
import 'package:hospital_app/hospitalwidgets/healthinfo.dart';
import 'package:hospital_app/hospitalwidgets/wireless.dart';
import 'package:geolocator/geolocator.dart';

class Wifi extends StatelessWidget {
  //const Wifi({super.key});
  final bool isConnected;
  final VoidCallback onTap;

  Wifi({required this.isConnected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Row(
            children: [
              Text(
                "WIFI",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              IconButton(
                  onPressed: () async {
                    bool isLocationEnabled =
                        await Geolocator.isLocationServiceEnabled();
                    if (!isLocationEnabled) {
                      _showSettingsDialog(context);
                    } else {
                      // List the wireless device
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WirelessClass()),
                      );
                    }
                  },
                  //onPressed: isConnected ? null : onTap,
                  icon: const Icon(
                    Icons.wifi,
                    size: 35,
                    color: Colors.blue,
                  ))
            ],
          ),
        ),
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("AtlantisUgarSoft"),
      content: const Text("Device not available"),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please enable location'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              child: Text('OPEN SETTINGS'),
            ),
          ],
        );
      },
    );
  }

// @override
// Widget build(BuildContext context) {
// return ElevatedButton(
//child: Text('Wifi'),
//onPressed: isConnected ? onTap : null,
//);
}
