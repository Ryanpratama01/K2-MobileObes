import 'package:flutter/material.dart';
import 'dart:ui';
import 'wigdets/custom_button.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFCDEDC1),
                  Color(0xFFA5D6A7),
                ],
              ),
            ),
          ),
          
          // Decorative elements
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.2),
                    const Color(0xFF81C784).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF007C79).withOpacity(0.2),
                    const Color(0xFF009688).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          
          // Health icons
          Positioned(
            top: 80,
            right: 40,
            child: Transform.rotate(
              angle: -0.2,
              child: const Icon(
                Icons.apple,
                color: Color(0xFFE57373),
                size: 28,
                shadows: [Shadow(color: Colors.black12, blurRadius: 5)],
              ),
            ),
          ),
          
          Positioned(
            bottom: 120,
            left: 30,
            child: Transform.rotate(
              angle: 0.1,
              child: const Icon(
                Icons.favorite,
                color: Color(0xFFE57373),
                size: 28,
                shadows: [Shadow(color: Colors.black12, blurRadius: 5)],
              ),
            ),
          ),
          
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
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
              child: Column(
                children: [
                  // Logo with circle background
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
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
                  
                  // Title with gradient
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Pantau berat badan & kesehatanmu sekarang!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Login Card with blur effect
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
                                  color: Color(0xFF2E7D32),
                                  size: 28,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2E7D32),
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
                            
                            // Username field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                                hintText: "Masukkan username anda",
                                prefixIcon: const Icon(Icons.person, color: Color(0xFF2E7D32)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFAED581)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFAED581)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(height: 18),
                            
                            // Email field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                                hintText: "Masukkan email anda",
                                prefixIcon: const Icon(Icons.email, color: Color(0xFF2E7D32)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFAED581)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFAED581)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(height: 18),
                            
                            // Password field
                            TextFormField(
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                                hintText: "Masukkan password anda",
                                prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFAED581)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFAED581)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E7D32),
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
                            
                            // Login button using CustomButton
                            CustomButton(
                              text: "Masuk",
                              icon: Icons.login_rounded,
                              onPressed: () {},
                              backgroundColor: const Color(0xFF2E7D32),
                              height: 56,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Or divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    "Atau",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Register link
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.person_add,
                                      color: Color(0xFF2E7D32),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Daftar Akun Baru",
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
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
                  
                  const SizedBox(height: 20),
                  
                  // Health tip at bottom
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tips_and_updates,
                          color: Color(0xFF2E7D32),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Langkah awal menuju hidup sehat",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2E7D32),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}