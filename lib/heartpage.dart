import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icuapp/iculist.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Heartgraph extends StatelessWidget {
  const Heartgraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atlantis-UgarSoft')),
      body: const HeartGraph(),
    );
  }
}

class HeartGraph extends StatefulWidget {
  const HeartGraph({super.key});

  @override
  State<HeartGraph> createState() => _HeartGraphState();
}

class _HeartGraphState extends State<HeartGraph> {
  final List<SensorData> _chartData = <SensorData>[];
  Timer? _timer;
  String heartBeat2 = '';
  List<Map<String, dynamic>> icuDevicesData = [];
  List<Map<String, dynamic>> filteredICUdataList = [];

  @override
  void initState() {
    super.initState();
    _startTimer();
    loadIcuDataList();
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
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        // Ensure the widget is still in the widget tree
        setState(() {
          loadIcuDataList();
        });
      }
    });
  }

  Future<void> loadIcuDataList() async {
    if (!mounted) return; // Early exit if the widget is not mounted

    setState(() {
      icuDevicesData = ICUpageState.icuDataList.map((icuData) {
        return {
          'name': icuData.icuName,
          'BP': icuData.bp,
          'Temperature': icuData.temperature,
          'Drip Level': icuData.dripLevel.toString(),
          'Heart Rate': icuData.heartRate.toString()
        };
      }).toList();
    });

    filteredICUdataList = icuDevicesData.where((icudata) {
      return icudata['name'] == ICUpageState.icuname;
    }).toList();

    if (filteredICUdataList.isNotEmpty) {
      double? pulse = double.tryParse(filteredICUdataList[0]['Heart Rate']);
      if (pulse != null) {
        setState(() {
          _chartData.add(SensorData(DateTime.now(), pulse));
          if (_chartData.length > 30) {
            _chartData.removeAt(0);
          }
        });
      }
    }

    print(filteredICUdataList[0]['Heart Rate']);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: SfCartesianChart(
            backgroundColor: Colors.black,
            primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 120,
              interval: 10,
              majorGridLines: MajorGridLines(width: 0),
            ),
            series: <SplineSeries<SensorData, DateTime>>[
              SplineSeries<SensorData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (SensorData data, _) => data.time,
                yValueMapper: (SensorData data, _) => data.pulse,
                color: Colors.red,
                width: 2,
              ),
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
