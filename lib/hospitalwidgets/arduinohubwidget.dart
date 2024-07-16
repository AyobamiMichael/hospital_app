import 'package:flutter/material.dart';

class ArduinoHubPage extends StatefulWidget {
  const ArduinoHubPage({super.key});

  @override
  State<ArduinoHubPage> createState() => _ArduinoHubPageState();
}

class _ArduinoHubPageState extends State<ArduinoHubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Atlantis-UgarSoft'),
    ));
  }
}
