import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/hospitalwidgets/wireless.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final _audioPlayer = AudioPlayer();

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

    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        getDataFromArduino();
      });
      // _playBeepSound();
    });
  }

  void getDataFromArduino() {
    // Assuming `WirelessClassState.listOfSensorValues[2]` contains sensor data
    heartBeat2 = WirelessClassState.listOfSensorValues[10].substring(20);
    double? pulse = double.tryParse(heartBeat2);
    print('PULSE: $pulse');
    if (pulse != null) {
      // Add new data point to the chart
      // if (pulse > 0.5) {
      _chartData.add(SensorData(DateTime.now(), pulse));
      _playBeepSound();

      if (_chartData.length > 30) {
        _chartData.removeAt(0);
      }
      //}
      // else if (pulse < 0.5) {
      //_chartData.add(SensorData(DateTime.now(), 0.0));
      //_playLowSignal();
      //}
    }
  }

  Future<void> _playBeepSound() async {
    String audiopath = 'audio/medicalmonitor.mp3';
    await _audioPlayer.play(AssetSource(audiopath));

    print("Audio Player result");
  }

  Future<void> _playLowSignal() async {
    String audiopath = 'audio/lowmonitorsound.mp3';
    await _audioPlayer.play(AssetSource(audiopath));
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
              minimum: -2,
              maximum: 2,
              interval: 0.5,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            series: <SplineSeries<SensorData, DateTime>>[
              SplineSeries<SensorData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (SensorData data, _) => data.time,
                yValueMapper: (SensorData data, _) => data.pulse,
                color: Colors.red,
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
