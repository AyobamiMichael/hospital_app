import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewHeartGraph3 extends StatelessWidget {
  const NewHeartGraph3({Key? key}) : super(key: key);

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
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _generateECGData();
      });
    });
  }

  // Simulating ECG data for PQRST wave
  void _generateECGData() {
    final DateTime currentTime = DateTime.now();
    final double simulatedECGValue = _simulatePQRSTWave();

    // Add new data point to the chart
    _chartData.add(SensorData(currentTime, simulatedECGValue));
    if (_chartData.length > 100) {
      // Keep the chart data manageable
      _chartData.removeAt(0);
    }
  }

  // Function to simulate PQRST waveform
  double _simulatePQRSTWave() {
    final int time = DateTime.now().millisecondsSinceEpoch % 2000;

    // Define the PQRST waveform (values approximated for demo)
    if (time < 100) {
      return 0.05; // P-wave
    } else if (time < 120) {
      return 0.1; // PR segment
    } else if (time < 150) {
      return 1.2; // QRS complex (R-wave)
    } else if (time < 180) {
      return -0.5; // S-wave
    } else if (time < 250) {
      return 0.3; // T-wave
    } else {
      return 0; // Baseline
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
              minimum: -1,
              maximum: 2,
              interval: 0.5,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            series: <SplineSeries<SensorData, DateTime>>[
              SplineSeries<SensorData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (SensorData data, _) => data.time,
                yValueMapper: (SensorData data, _) => data.pulse,
                color: Colors.greenAccent,
                width: 2,
              )
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