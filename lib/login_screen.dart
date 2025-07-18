import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obecity_projectsem4/beranda.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:obecity_projectsem4/utils/request-url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wigdets/custom_button.dart'; // Tetap menggunakan 'wigdets' sesuai aslinya
import 'dart:math' as math;
import 'register.dart';
import 'forget_pw.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  // final _formKey = GlobalKey<FormState>();

  // Controller untuk form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // redirectWhenTokenExist();
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

  void redirectWhenTokenExist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") != "") {
      Get.offAll(BerandaPage());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginProcess(email, password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse("$baseUrl/login");
    var body = {'email': email, 'password': password};
    var response = await http
        .post(url, body: body, headers: {'Accept': 'application/json'});
    var resBody = jsonDecode(response.body); //parsing json
    prefs.setString("token", resBody['access_token']);
    prefs.setString("nama", resBody['user']['Nama']);
    prefs.setString("email", resBody['user']['email']);
    prefs.setString("role", resBody['user']['Role']);

    // print(resBody);
  }

  // Konstanta warna untuk konsistensi
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  // Metode untuk validasi form
  void _validateAndSubmit() async {
    if (true) {
      // Implementasi login
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("$baseUrl/login");
      var body = {
        'email': _emailController.text,
        'password': _passwordController.text
      };
      var response = await http.post(url, body: body);
      var resBody = jsonDecode(response.body); //parsing json
      prefs.setString("token", resBody['access_token']);
      prefs.setString("nama", resBody['user']['Nama']);
      prefs.setString("email", resBody['user']['email']);
      prefs.setString("role", resBody['user']['Role']);

      print(response.body);
      if (response.statusCode == 200) {
        Get.offAll(BerandaPage());
      } else {
        Get.showSnackbar(GetSnackBar(
          duration: Duration(seconds: 1),
          title: "Error",
          message: response.body,
        ));
      }

      // // Di sini bisa ditambahkan kode untuk mengirim data ke API login
    }
  }

  // Metode untuk membuat input field dengan style yang konsisten
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
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
            : null,
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
          SingleChildScrollView(
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
                // key: _formKey,
                child: Column(
                  children: [
                    // Logo dengan circle background
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.from(
                                    alpha: 1,
                                    red: 0.18,
                                    green: 0.49,
                                    blue: 0.196)
                                .withOpacity(0.3),
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
                        "Pantau berat badan & kesehatanmu sekarang!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Login Card dengan efek blur
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
                                    Icons.login_rounded,
                                    color: primaryColor,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 24,
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

                              const SizedBox(height: 25),

                              // Username field dengan validasi
                              // _buildInputField(
                              //   label: "Username",
                              //   hint: "Masukkan username anda",
                              //   icon: Icons.person,
                              //   controller: _usernameController,
                              //   validator: (value) {
                              //     if (value == null ||
                              //         value.isEmpty ||
                              //         value.length < 3) {
                              //       return 'Username minimal 3 karakter';
                              //     }
                              //     return null;
                              //   },
                              // ),

                              // const SizedBox(height: 18),

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
                                // validator: (value) {
                                //   if (value == null ||
                                //       value.isEmpty ||
                                //       value.length < 8 ||
                                //       !RegExp(r'\d').hasMatch(value)) {
                                //     return 'Password harus 8 karakter dan mengandung angka';
                                //   }
                                //   return null;
                                // },
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ResetPasswordPage()),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: primaryColor,
                                  ),
                                  child: const Text(
                                    "Lupa password?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Login button menggunakan CustomButton
                              CustomButton(
                                text: "Masuk",
                                icon: Icons.login_rounded,
                                onPressed: _validateAndSubmit,
                                backgroundColor: primaryColor,
                                height: 56,
                              ),

                              const SizedBox(height: 20),

                              // Tambahan register option
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Belum punya akun?",
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage()),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryColor,
                                    ),
                                    child: const Text.rich(TextSpan(
                                      text: "Daftar sekarang",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
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
        ],
      ),
    );
  }
}
