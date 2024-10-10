import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/hospitalwidgets/wireless.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewHeartGraph2 extends StatelessWidget {
  const NewHeartGraph2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atlantis-UgarSoft')),
      body: const HeartGraph2(),
    );
  }
}

class HeartGraph2 extends StatefulWidget {
  const HeartGraph2({Key? key}) : super(key: key);

  @override
  State<HeartGraph2> createState() => _HeartGraph2State();
}

class _HeartGraph2State extends State<HeartGraph2> {
  final List<SensorData> _chartData = <SensorData>[];
  Timer? _timer;
  String heartBeat2 = '';

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        getDataFromArduino();
      });
    });
  }

  void getDataFromArduino() {
    // Assuming `WirelessClassState.listOfSensorValues[2]` contains sensor data
    heartBeat2 = WirelessClassState.listOfSensorValues[10].substring(20);
    double? pulse = double.tryParse(heartBeat2);
    if (pulse != null) {
      // Add new data point to the chart
      _chartData.add(SensorData(DateTime.now(), pulse));
      if (_chartData.length > 30) {
        _chartData.removeAt(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          child: SfCartesianChart(
            backgroundColor: Colors.black,
            primaryXAxis:
                DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 120,
              interval: 10,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            series: <SplineSeries<SensorData, DateTime>>[
              SplineSeries<SensorData, DateTime>(
                  dataSource: _chartData,
                  xValueMapper: (SensorData data, _) => data.time,
                  yValueMapper: (SensorData data, _) => data.pulse,
                  color: Colors.red,
                  width: 2,
                  cardinalSplineTension: 0.0)
            ],
          ),
        ),
      ),
    );
  }
}

class SensorData {
  final DateTime time;
  final double pulse;

  SensorData(this.time, this.pulse);
}
