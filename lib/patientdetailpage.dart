import 'package:flutter/material.dart';
import 'package:icuapp/heartpage.dart';
import 'package:icuapp/iculist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Patientdetailpage extends StatefulWidget {
  const Patientdetailpage({super.key});

  @override
  State<Patientdetailpage> createState() => _PatientdetailpageState();
}

class _PatientdetailpageState extends State<Patientdetailpage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Any context-dependent initialization can be done here
    print(ICUpageState.icuname);
    print(ICUpageState.icuDataList);
  }

  @override
  Widget build(BuildContext context) {
    // Extract the ICU data for the specified icuname
    final icuData = ICUpageState.icuDataList
        .firstWhere((data) => data.icuName == ICUpageState.icuname);

    return Scaffold(
        appBar: AppBar(
          title: Text('ATLANTIS-UGARSOFT'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      _buildParameterBox(
                          'Blood Pressure',
                          icuData.bp.toString(),
                          FontAwesomeIcons.heartbeat), // Added icon
                      _buildDripLevelBox('Drip Level', icuData.dripLevel),
                      _buildTemperatureBox('Temperature', icuData.temperature),
                      _buildHeartRateBox(
                          'Heart Rate',
                          icuData.heartRate.toString(),
                          context,
                          FontAwesomeIcons.heart), // Added icon
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildParameterBox(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              FaIcon(icon, color: Colors.blue), // Added FontAwesome icon
              SizedBox(width: 10.0),
              Text(
                label,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildDripLevelBox(String label, int dripLevel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CustomPaint(
            size: Size(double.infinity, 30),
            painter: BatteryDripLevelPainter(dripLevel),
          ),
          SizedBox(height: 8.0),
          Text(
            '$dripLevel%',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureBox(String label, double temperature) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CustomPaint(
            size: Size(double.infinity, 50),
            painter: TemperatureLevelPainter(temperature),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildHeartRateBox(
      String label, String value, BuildContext context, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Heartgraph()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(icon, color: Colors.red), // Added FontAwesome icon
                SizedBox(width: 10.0),
                Text(
                  label,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

/*class Patientdetailpage extends StatefulWidget {
  const Patientdetailpage({super.key});

  @override
  State<Patientdetailpage> createState() => _PatientdetailpageState();
}

class _PatientdetailpageState extends State<Patientdetailpage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Any context-dependent initialization can be done here
    print(ICUpageState.icuname);
    print(ICUpageState.icuDataList);
  }

  @override
  Widget build(BuildContext context) {
    // Extract the ICU data for the specified icuname
    final icuData = ICUpageState.icuDataList
        .firstWhere((data) => data.icuName == ICUpageState.icuname);

    return Scaffold(
        appBar: AppBar(
          title: Text('ATLANTIS-UGARSOFT'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      _buildParameterBox(
                          'Blood Pressure', icuData.bp.toString()),
                      _buildDripLevelBox('Drip Level', icuData.dripLevel),
                      _buildTemperatureBox('Temperature', icuData.temperature),
                      _buildHeartRateBox(
                        'Heart Rate',
                        icuData.heartRate.toString(),
                        context,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildParameterBox(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildDripLevelBox(String label, int dripLevel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CustomPaint(
            size: Size(double.infinity, 30),
            painter: BatteryDripLevelPainter(dripLevel),
          ),
          SizedBox(height: 8.0),
          Text(
            '$dripLevel%',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureBox(String label, double temperature) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CustomPaint(
            size: Size(double.infinity, 50),
            painter: TemperatureLevelPainter(temperature),
          ),
          SizedBox(height: 8.0),
          // Text(
          // '$temperature°C',
          // style: TextStyle(fontSize: 16.0),
          // ),
        ],
      ),
    );
  }

  Widget _buildHeartRateBox(String label, String value, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the heart rate click event here
        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Heart Rate Clicked: $value'),
          ),
        );*/
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Heartgraph()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}*/

class BatteryDripLevelPainter extends CustomPainter {
  final int dripLevel;

  BatteryDripLevelPainter(this.dripLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = (size.width - 20) / 4;
    final barHeight = size.height;
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw the battery border
    final borderRect = Rect.fromLTWH(0, 0, size.width - 10, size.height);
    canvas.drawRect(borderRect, borderPaint);

    // Draw the battery cap
    final capRect = Rect.fromLTWH(
        size.width - 10, size.height * 0.3, 10, size.height * 0.4);
    canvas.drawRect(capRect, borderPaint);

    // Determine the number of bars to fill
    int barsToFill = (dripLevel / 25).ceil();

    for (int i = 0; i < 4; i++) {
      Color barColor;
      if (i < barsToFill) {
        barColor = (i == 0 && barsToFill == 1) ? Colors.red : Colors.green;
      } else {
        barColor = Colors.transparent;
      }

      final barPaint = Paint()..color = barColor;
      final barRect =
          Rect.fromLTWH(5 + i * barWidth, 0, barWidth - 5, barHeight);
      canvas.drawRect(barRect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TemperatureLevelPainter extends CustomPainter {
  final double temperature;

  TemperatureLevelPainter(this.temperature);

  @override
  void paint(Canvas canvas, Size size) {
    double fillRatio;
    Color fillColor;

    // Define the fill level and color based on temperature
    if (temperature <= 35) {
      fillRatio = 0.25; // Quarter full at 35°C and below
      fillColor = Colors.blue; // Blue for temperatures <= 35°C
    } else if (temperature <= 40) {
      fillRatio = 0.6; // Above half full between 36°C and 40°C
      fillColor = Colors.red; // Red for temperatures between 36°C and 40°C
    } else if (temperature <= 60) {
      fillRatio = 0.9; // Almost full between 41°C and 60°C
      fillColor = Colors.red; // Red for temperatures above 40°C
    } else {
      fillRatio = 1.0; // Full at temperatures above 60°C
      fillColor = Colors.red; // Red for temperatures above 60°C
    }

    // Calculate the width of the filled portion
    final fillWidth = fillRatio * size.width;

    // Create the filled rectangle
    final filledRect = Rect.fromLTWH(0, 0, fillWidth, size.height - 20);

    // Paint the filled portion
    final fillPaint = Paint()..color = fillColor;
    canvas.drawRect(filledRect, fillPaint);

    // Draw the border of the tank
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final borderRect = Rect.fromLTWH(0, 0, size.width, size.height - 20);
    canvas.drawRect(borderRect, borderPaint);

    // Draw the scale at the bottom
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 100; i += 10) {
      // Draw tick marks
      final xPosition = (i / 100) * size.width;
      final tickHeight = 10.0;
      canvas.drawLine(
        Offset(xPosition, size.height - 20),
        Offset(xPosition, size.height - 20 + tickHeight),
        borderPaint,
      );

      // Draw scale numbers
      textPainter.text = TextSpan(
        text: '$i°C',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xPosition - textPainter.width / 2, size.height - 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
