import 'dart:io';
import 'package:flutter/material.dart';
import 'package:icuapp/iculist.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class ICUwidget extends StatelessWidget {
  const ICUwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICU APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IcuMainPage(),
    );
  }
}

class IcuMainPage extends StatefulWidget {
  const IcuMainPage({super.key});

  @override
  State<IcuMainPage> createState() => IcuMainPageState();
}

class IcuMainPageState extends State<IcuMainPage> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  final NetworkInfo networkInfo = NetworkInfo();
  bool shouldCheckCan = true;
  static String wifiSSID = '';
  static String wifiBSSID = '';
  String? ip;
  static String? wifiGateway;
  bool isLoading = false;

  @override
  void initState() {
    _checkPermissions();
    super.initState();
    print('okay');
  }

  void _checkPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
      }

      // If the permission is denied permanently, show a dialog to the user
      if (status.isDenied || status.isPermanentlyDenied) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Permission Required"),
        content: Text(
            "This app needs location access to scan for ICU devices. Please grant location permission."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings(); // Opens the app settings so the user can enable the permission
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('        ATLANTIS-UGARSOFT'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _scanForDevices,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _scanForDevices,
              child: Text(
                  isLoading ? 'Scanning...' : 'Scan for Devices ICU devices'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: accessPoints.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Set your desired border color
                      width: 2.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        10.0), // Optional: Add border radius
                  ),
                  child: ListTile(
                    title: Text(accessPoints[index].ssid),
                    subtitle: Text(accessPoints[index].bssid),
                    trailing: IconButton(
                      icon: Icon(Icons.local_hospital_outlined),
                      onPressed: () {
                        // Navigate to device settings page
                      },
                    ),
                    onTap: () async {
                      getWifiIpAddress();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ICUpage()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _scanForDevices() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = true;
      });
    });

    await _startScan(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = false;
      });
    });
  }
  /*void _scanForDevices() async {
    setState(() {
      isLoading = true;
    });
    await _startScan(context);
    setState(() {
      isLoading = false;
    });
  } */

  Future<void> _startScan(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canStartScan();
      if (can != CanStartScan.yes) {
        print('Cannot start scan, reason: $can');
        return;
      }
    }

    await WiFiScan.instance.startScan();
    _getScannedResults();
    print('StartScan');
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        accessPoints = <WiFiAccessPoint>[];
        print(accessPoints);
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

  Future<void> connectToArduinoWireless(wifiSSID, wifiBSSID) async {
    try {
      await WiFiForIoTPlugin.connect(wifiSSID, bssid: wifiBSSID);
      //getWifiIpAddress();
      //fetchData(wifiGateway!);
      print('Connected to $wifiSSID');
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

  void getWifiIpAddress() async {
    ip = await WiFiForIoTPlugin.getIP();
    wifiGateway = await networkInfo.getWifiGatewayIP();

    print(wifiGateway);
    //print(ip);

    if (wifiGateway!.isNotEmpty) {
    } else {
      print('No gateway IP');
    }
  }
}
