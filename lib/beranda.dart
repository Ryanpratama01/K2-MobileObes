import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';


class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  double currentWeight = 60;
  List<double> weightHistory = [65, 60, 63, 58, 66, 59, 60, 60, 61];
  String bmiCategory = "Normal";
  String inputDate = "";

  void calculateBMI() {
    double height = 1.7; // assumed height in meters
    double bmi = currentWeight / pow(height, 2);
    String category;

    if (bmi < 18.5) {
      category = "Underweight";
    } else if (bmi < 25) {
      category = "Normal";
    } else if (bmi < 30) {
      category = "Overweight";
    } else {
      category = "Obese";
    }

    setState(() {
      bmiCategory = category;
      weightHistory.add(currentWeight);
      inputDate = DateTime.now().day.toString() + '.' + DateTime.now().month.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Beranda'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Input Berat Badan Saat Ini'),
                  SizedBox(height: 8),
                  Text('${currentWeight.toStringAsFixed(1)} kg', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Slider(
                    value: currentWeight,
                    min: 30,
                    max: 150,
                    divisions: 240,
                    label: currentWeight.toStringAsFixed(1),
                    onChanged: (value) => setState(() => currentWeight = value),
                  ),
                  ElevatedButton.icon(
                    onPressed: calculateBMI,
                    icon: Icon(Icons.save),
                    label: Text("Simpan"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grafik Perkembangan"),
                  SizedBox(height: 150, child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weightHistory.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                          isCurved: false,
                          color: Colors.green,
                          dotData: FlDotData(show: true),
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("BMI : $bmiCategory"),
                      Text("Tanggal Input : $inputDate"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Berat Badan : ${currentWeight.toStringAsFixed(1)}"),
                      Text("Berat Badan Akhir : ${weightHistory.last.toStringAsFixed(1)}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(child: Text("Jangan lupa input BB untuk lihat perkembanganmu")),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: 'Rekomendasi'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'IMT'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}