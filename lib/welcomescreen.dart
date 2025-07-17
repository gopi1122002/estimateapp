import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'registerscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌳 Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/tree.png', // Your combined image
              fit: BoxFit.cover,
            ),
          ),

          // 🌿 Foreground content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // 🌟 Title
                const Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 6),

                const Text(
                  'ESTIMATE GENERATOR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 150),

                // 📝 Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: const Text(
                    'Quickly create accurate estimates with just a few taps. '
                        'Simplify your workflow and save time with our user-friendly interface.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),

                const Spacer(),

                // 🔐 Sign In Button

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreenCustomBackground(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 180),

                // 🆕 Create Account Text
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 54),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
