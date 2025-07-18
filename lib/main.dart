import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboardingscreen.dart';
import 'loginscreen.dart';
import 'navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;

    if (isOnboarded) {
      return const OnboardingScreen(); // Login screen
    } else {
      return const LoginScreenCustomBackground(); // First time only
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
