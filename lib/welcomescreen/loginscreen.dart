import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../dashboard/view/navigation.dart';
import 'forgotpassword.dart';
import 'registerscreen.dart';

class LoginController extends GetxController {
  var obscureText = true.obs;
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void navigateToForgotPassword() {
    Get.to(() => ForgotPasswordScreen());
  }

  void navigateToMainNavigation() {
    Get.offAll(() => const MainNavigationScreen());
  }

  void navigateToSignup() {
    Get.to(() => const SignupScreen());
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter email and password.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    final url = Uri.parse('https://mdqapps.tech/api/estimate/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      print("🔐 Response: ${response.body}");
      print("📡 Status: ${response.statusCode}");

      if (response.statusCode == 200 && data["error"] == false) {
        Get.snackbar("Success", "Login successfully.",
            backgroundColor: Colors.green, colorText: Colors.white);
        navigateToMainNavigation();
      } else {
        Get.snackbar("Login Failed", data["message"] ?? "Invalid credentials",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("❌ Login Error: $e");
      Get.snackbar("Error", "Something went wrong. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginScreenCustomBackground extends StatelessWidget {
  const LoginScreenCustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Column(
                        children: const [
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

                  const Text('Enter your email ID',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.emailController,
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

                  const Text('Enter your password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Obx(
                        () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.obscureText.value,
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureText.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: controller.toggleObscureText,
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
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.navigateToForgotPassword,
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6ED7B9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'Log in',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: controller.navigateToSignup,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: Color(0xFF6ED7B9),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
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
        ],
      ),
    );
  }
}
