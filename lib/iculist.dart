import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:icuapp/mainpage.dart';
import 'package:icuapp/patientdetailpage.dart';

class ICUData {
  final String icuName;
  final int bp;
  final double temperature;
  final int dripLevel;
  final int heartRate;

  ICUData({
    required this.icuName,
    required this.bp,
    required this.temperature,
    required this.dripLevel,
    required this.heartRate,
  });

  @override
  String toString() {
    return 'ICUData(icuName: $icuName, BP: $bp, Temperature: $temperature, Drip Level: $dripLevel, Heart Rate: $heartRate)';
  }

  static List<ICUData> parseHTMLResponse(String htmlData) {
    final icuDataList = <ICUData>[];
    final regex = RegExp(
        r'ICU(\d+)\s+BP:\s*(\d+)\s+temperature:\s*([\d.]+)\s+driplevel:\s*(\d+)\s+HeartRate:\s*(\d+)');

    final matches = regex.allMatches(htmlData);

    for (final match in matches) {
      final icuName = 'ICU${match.group(1)}';
      final bp = int.parse(match.group(2)!);
      final temperature = double.parse(match.group(3)!);
      final dripLevel = int.parse(match.group(4)!);
      final heartRate = int.parse(match.group(5)!);

      icuDataList.add(ICUData(
        icuName: icuName,
        bp: bp,
        temperature: temperature,
        dripLevel: dripLevel,
        heartRate: heartRate,
      ));
    }

    return icuDataList;
  }
}

class ICUpage extends StatefulWidget {
  const ICUpage({super.key});

  @override
  State<ICUpage> createState() => ICUpageState();
}

class ICUpageState extends State<ICUpage> {
  Timer? _timer;
  static List<ICUData> icuDataList = [];
  static String icuname = '';
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();

    print(IcuMainPageState.wifiGateway);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (IcuMainPageState.wifiGateway != null) {
      // fetchData(IcuMainPageState.wifiGateway!);
      _startTimer(); // Start the timer to fetch data periodically
    } else {
      _showErrorDialog("No gateway available");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        fetchData(IcuMainPageState.wifiGateway!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATLANTIS-UGARSOFT'),
      ),
      body: Stack(
        children: [
          _buildICUList(), // List of ICUs
          if (_isLoading) // Loader
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildICUList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: icuDataList.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(icuDataList[index].icuName),
                  trailing: IconButton(
                    icon: const Icon(Icons.local_hospital_outlined),
                    onPressed: () {
                      // Navigate to device settings page
                    },
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Patientdetailpage(),
                      ),
                    );
                    setState(() {
                      icuname = icuDataList[index].icuName;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> fetchData(String wifiGateway) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await http.get(Uri.parse('http://$wifiGateway'));

      if (response.statusCode == 200) {
        final htmlResponse = response.body;

        final parsedICUDataList = ICUData.parseHTMLResponse(htmlResponse);
        setState(() {
          icuDataList = parsedICUDataList;
          _isLoading = false; // Data loaded
        });
        print(icuDataList);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Stop loading if failed
        });
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(e.toString());
      setState(() {
        _isLoading = false; // Stop loading if error
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Connection Error"),
        content: Text("Failed to connect"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
