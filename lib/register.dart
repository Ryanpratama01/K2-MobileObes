import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:obecity_projectsem4/utils/request-url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obecity_projectsem4/beranda.dart';
import 'package:obecity_projectsem4/wigdets/custom_button.dart'; // Tetap menggunakan 'wigdets' sesuai aslinya
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  // Controller untuk form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Tampilkan date picker untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  // Konstanta warna untuk konsistensi
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  // Metode untuk validasi form dan registrasi
  void _validateAndRegister() async {
    if (_formKey.currentState!.validate()) {
      // Implementasi registrasi
      var url = Uri.parse("$baseUrl/register");
      var body = {
        'nama': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'tanggal_lahir': _selectedDate != null 
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!) 
            : '',
        'role': 'user', // Default role
      };
      
      try {
        var response = await http.post(url, body: body);
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registrasi berhasil, lanjutkan dengan login otomatis
          var loginUrl = Uri.parse("$baseUrl/login");
          var loginBody = {
            'email': _emailController.text,
            'password': _passwordController.text
          };
          
          var loginResponse = await http.post(loginUrl, body: loginBody);
          
          if (loginResponse.statusCode == 200) {
            var resBody = jsonDecode(loginResponse.body);
            
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("token", resBody['access_token']);
            prefs.setString("nama", resBody['user']['Nama']);
            prefs.setString("email", resBody['user']['email']);
            prefs.setString("role", resBody['user']['Role']);
            
            Get.offAll(() => BerandaPage());
          } else {
            // Login gagal setelah registrasi berhasil
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 3),
              title: "Registrasi Berhasil",
              message: "Silahkan login dengan akun baru Anda",
              backgroundColor: primaryColor,
            ));
            
            // Navigasi ke halaman login
            Get.back(); // Kembali ke halaman login
          }
        } else {
          // Registrasi gagal
          var errorMessage = "Registrasi gagal";
          try {
            var errorBody = jsonDecode(response.body);
            errorMessage = errorBody['message'] ?? errorMessage;
          } catch (e) {
            // Gagal parse error message
          }
          
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 3),
            title: "Error",
            message: errorMessage,
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Error",
          message: "Terjadi kesalahan koneksi",
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // Metode untuk membuat input field dengan style yang konsisten
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isDate = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor),
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : (isDate ? const Icon(Icons.calendar_today, color: primaryColor) : null),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background dengan gradient
          Container(
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
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo dengan circle background
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(46, 125, 50, 0.3),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'assets/LogoObes.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title dengan gradient
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF007C79),
                            Color(0xFF004D40),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          "ObesCheck",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Buat akun dan pantau kesehatanmu!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Card dengan efek blur
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.person_add_rounded,
                                      color: primaryColor,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Registrasi",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                // Username field dengan validasi
                                _buildInputField(
                                  label: "Nama Lengkap",
                                  hint: "Masukkan nama lengkap anda",
                                  icon: Icons.person,
                                  controller: _usernameController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 3) {
                                      return 'Nama minimal 3 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Tanggal Lahir field
                                _buildInputField(
                                  label: "Tanggal Lahir",
                                  hint: "Pilih tanggal lahir anda",
                                  icon: Icons.cake,
                                  controller: _birthDateController,
                                  isDate: true,
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pilih tanggal lahir anda';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Email field dengan validasi
                                _buildInputField(
                                  label: "Email",
                                  hint: "Masukkan email anda",
                                  icon: Icons.email,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Masukkan email yang valid';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Password field dengan validasi
                                _buildInputField(
                                  label: "Password",
                                  hint: "Masukkan password anda",
                                  icon: Icons.lock,
                                  controller: _passwordController,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 8) {
                                      return 'Password minimal 8 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 25),

                                // Register button menggunakan CustomButton
                                CustomButton(
                                  text: "Daftar",
                                  icon: Icons.app_registration_rounded,
                                  onPressed: _validateAndRegister,
                                  backgroundColor: primaryColor,
                                  height: 56,
                                ),

                                const SizedBox(height: 20),

                                // Opsi login
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Sudah punya akun?",
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigasi kembali ke halaman login
                                        Get.back();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      child: const Text(
                                        "Login Sekarang",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}