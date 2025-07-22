import 'package:flutter/material.dart';

import '../dashboard/view/navigation.dart';
import 'forgotpassword.dart';

class LoginScreenCustomBackground extends StatefulWidget {
  const LoginScreenCustomBackground({super.key});

  @override
  State<LoginScreenCustomBackground> createState() => _LoginScreenCustomBackgroundState();
}

class _LoginScreenCustomBackgroundState extends State<LoginScreenCustomBackground> {
  bool _obscureText = true;
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top-left large faded circle
          // Positioned(
          //   top: -120,
          //   right: 20,
          //   left: -200,
          //   child: Container(
          //     width: 380,
          //     height: 500,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: const Color(0xFFB2EFE5).withOpacity(0.3),
          //     ),
          //   ),
          // ),

          // Top-left circle outline
          // Positioned(
          //   top: -320,
          //   left: -40,
          //   right: 70,
          //   child: Container(
          //     width: 460,
          //     height: 850,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         color: const Color(0xFFB2EFE5).withOpacity(0.9),
          //         width: 1.2,
          //       ),
          //     ),
          //   ),
          // ),

          // Top-right faded circle
          // Positioned(
          //   top: -60,
          //   right: -70,
          //   child: Container(
          //     width: 200,
          //     height: 200,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: const Color(0xFFB2EFE5).withOpacity(0.2),
          //     ),
          //   ),
          // ),

          // // Top-right circle outline
          // Positioned(
          //   top: -50,
          //   right: -60,
          //   child: Container(
          //     width: 200,
          //     height: 200,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         color: const Color(0xFFB2EFE5).withOpacity(0.5),
          //         width: 1.5,
          //       ),
          //     ),
          //   ),
          // ),

          // // Small mid-left faded circle
          // Positioned(
          //   top: 100,
          //   left: 60,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: const Color(0xFFB2EFE5).withOpacity(0.3),
          //     ),
          //   ),
          // ),

          // Small mid-left circle outline
          // Positioned(
          //   top: 105,
          //   left: 65,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         color: const Color(0xFFB2EFE5).withOpacity(0.5),
          //         width: 1.2,
          //       ),
          //     ),
          //   ),
          // ),

          /// 🌿 Foreground Login UI

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏷️ Header
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          Text(
                            'LOG IN',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'TO CONTINUE',
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  /// 📧 Email Field
                  const Text('Enter your email ID',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: 'Enter your email ID',
                      prefixIcon: const Icon(Icons.email, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),


                  const SizedBox(height: 24),

                  /// 🔒 Password Field
                  const Text('Enter your password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: _obscureText,
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.teal), // Filled lock icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: _toggleObscureText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),


                  /// 🔗 Forgot Password
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  /// ✅ Log In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6ed7b9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
