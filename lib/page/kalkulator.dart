import 'package:flutter/material.dart';

void main() {
  runApp(IMTPage());
}

class IMTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Kalkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
      ),
      home: BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage>
    with SingleTickerProviderStateMixin {
  // Color Constants
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String gender = 'Laki-laki';
  String alcoholUse = 'Tidak';
  String familyObesity = 'Tidak';
  String physicalActivity = 'Tidak';
  String painComplaint = 'Tidak';
  String instantNoodles = 'Tidak';

  int currentPageIndex = 3; // IMT page is the 4th index

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
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

  @override
  void dispose() {
    _animationController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  // Glass card widget
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title Card
                  _buildGlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calculate,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Kalkulator BMI',
                          style: TextStyle(
                            fontSize: 20,
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
                  ),

                  // Input Data Card
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Masukkan Data Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Tinggi Badan (cm)', heightController),
                        _buildDropdown(
                          'Jenis Kelamin',
                          ['Laki-laki', 'Perempuan'],
                          gender,
                          (val) => setState(() => gender = val!),
                        ),
                        _buildTextField('Berat Badan (kg)', weightController),
                        _buildDropdown(
                          'Sering Mengkonsumsi Alkohol?',
                          ['Ya', 'Tidak'],
                          alcoholUse,
                          (val) => setState(() => alcoholUse = val!),
                        ),
                        _buildDropdown(
                          'Riwayat Keluarga Obesitas?',
                          ['Ya', 'Tidak'],
                          familyObesity,
                          (val) => setState(() => familyObesity = val!),
                        ),
                        _buildDropdown(
                          'Sering Aktivitas Fisik?',
                          ['Ya', 'Tidak'],
                          physicalActivity,
                          (val) => setState(() => physicalActivity = val!),
                        ),
                        _buildDropdown(
                          'Apakah Sering Nyeri?',
                          ['Ya', 'Tidak'],
                          painComplaint,
                          (val) => setState(() => painComplaint = val!),
                        ),
                        _buildDropdown(
                          'Sering Mengkonsumsi Makanan Berkalori Tinggi?',
                          ['Ya', 'Tidak'],
                          instantNoodles,
                          (val) => setState(() => instantNoodles = val!),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _calculateBMI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Hitung BMI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Informational Tip Card
                  _buildGlassCard(
                    child: Container(
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
                              "Masukkan data dengan akurat untuk mendapatkan perhitungan BMI yang tepat!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5D4037),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height != null && weight != null) {
      final bmi = weight / ((height / 100) * (height / 100));

      // Determine BMI Category
      String bmiCategory;
      if (bmi < 18.5) {
        bmiCategory = "Underweight";
      } else if (bmi < 25) {
        bmiCategory = "Normal";
      } else if (bmi < 30) {
        bmiCategory = "Overweight";
      } else {
        bmiCategory = "Obese";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Hasil BMI',
            style: TextStyle(color: primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BMI Anda: ${bmi.toStringAsFixed(2)}'),
              Text('Kategori: $bmiCategory'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tutup',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Masukkan tinggi dan berat badan yang valid'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }
}
