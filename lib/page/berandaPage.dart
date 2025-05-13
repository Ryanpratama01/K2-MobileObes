import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:obecity_projectsem4/wigdets/custom_button.dart';
import 'dart:math';

class BerandaUI extends StatefulWidget {
  const BerandaUI({super.key});

  @override
  State<BerandaUI> createState() => _BerandaUIState();
}

class _BerandaUIState extends State<BerandaUI>
    with SingleTickerProviderStateMixin {
  double currentWeight = 60;
  List<double> weightHistory = [65, 60, 63, 58, 66, 59, 60, 60, 61];
  String bmiCategory = "Normal";
  String inputDate = "";
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  int currentPageIndex = 0;
  late Animation<double> _slideAnimation;

  // Konstanta warna untuk konsistensi dengan login dan splash screen
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);
  @override
  void initState() {
    super.initState();

    // Initialize animations consistent with other screens
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

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
      inputDate =
          DateTime.now().day.toString() + '.' + DateTime.now().month.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor1,
            backgroundColor2,
            backgroundColor3,
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeInAnimation.value,
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Weight Input Card
              _buildGlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.scale,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Input Berat Badan Saat Ini',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('${currentWeight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                    const SizedBox(height: 8),
                    Slider(
                      value: currentWeight,
                      min: 30,
                      max: 150,
                      divisions: 240,
                      label: currentWeight.toStringAsFixed(1),
                      activeColor: primaryColor,
                      inactiveColor: secondaryColor.withOpacity(0.5),
                      onChanged: (value) =>
                          setState(() => currentWeight = value),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Simpan",
                      icon: Icons.save,
                      onPressed: calculateBMI,
                      backgroundColor: primaryColor,
                      height: 50,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Chart Card
              _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.show_chart,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Grafik Perkembangan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.3),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.3),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                getTitlesWidget: (value, meta) {
                                  return Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          minX: 0,
                          maxX: weightHistory.length.toDouble() - 1,
                          minY: (weightHistory.reduce(min) - 5).clamp(30, 150),
                          maxY: (weightHistory.reduce(max) + 5).clamp(30, 150),
                          lineBarsData: [
                            LineChartBarData(
                              spots: weightHistory
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList(),
                              isCurved: true,
                              color: Theme.of(context)
                                  .primaryColor, // Mengambil warna dari tema
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Theme.of(context).primaryColor,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.0),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Card
              _buildGlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Status Kesehatan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatusRow(
                        icon: Icons.category,
                        label: "BMI",
                        value: bmiCategory,
                        valueColor: _getBMICategoryColor(bmiCategory)),
                    _buildStatusRow(
                        icon: Icons.calendar_today,
                        label: "Tanggal Input",
                        value:
                            inputDate.isEmpty ? "Belum ada input" : inputDate),
                    _buildStatusRow(
                        icon: Icons.scale,
                        label: "Berat Badan Saat Ini",
                        value: "${currentWeight.toStringAsFixed(1)} kg"),
                    _buildStatusRow(
                        icon: Icons.history,
                        label: "Berat Badan Terakhir",
                        value: weightHistory.isEmpty
                            ? "Belum ada data"
                            : "${weightHistory.last.toStringAsFixed(1)} kg"),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFB74D)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb, color: Color(0xFFFF9800)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Jangan lupa input berat badan secara rutin untuk melihat perkembangan kesehatanmu!",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF5D4037)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for UI components
  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: child,
    );
  }

  Widget _buildStatusRow(
      {required IconData icon,
      required String label,
      required String value,
      Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Text(
            "$label : ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBMICategoryColor(String category) {
    switch (category) {
      case "Underweight":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      case "Obese":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
