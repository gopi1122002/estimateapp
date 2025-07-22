import 'package:flutter/material.dart';
import 'package:newproject/welcomescreen/welcomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/view/dashboardscreen.dart' show DashboardScreen;
import 'onboardingscreen/onboardingscreen.dart';
import 'welcomescreen/loginscreen.dart';
// Assuming this contains DashboardScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;

    // Note: Your original code has a logic error: isOnboarded=true shows OnboardingScreen.
    // Assuming you meant to show LoginScreenCustomBackground when onboarded.
    if (isOnboarded) {
      return const WelcomeScreen();
    } else {
      return const OnboardingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Use the home route for FutureBuilder
      routes: {
        '/': (context) => FutureBuilder<Widget>(
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
        '/login': (context) => const LoginScreenCustomBackground(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}