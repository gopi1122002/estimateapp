import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcomescreen/welcomescreen.dart';
import 'dashboard/view/dashboardscreen.dart';
import 'onboardingscreen/onboardingscreen.dart';
import 'welcomescreen/loginscreen.dart';
import 'welcomescreen/registerscreen.dart';
import 'dashboard/view/navigation.dart';
import 'dashboard/view/businessscreen.dart';
import 'Menu/profilescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;

    if (isOnboarded) {
      return const WelcomeScreen();
    } else {
      return const OnboardingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => FutureBuilder<Widget>(
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
        ),
        GetPage(name: '/login', page: () => const LoginScreenCustomBackground()),
        GetPage(name: '/signup', page: () => const SignupScreen()), // ✅ Corrected
        GetPage(name: '/main_navigation', page: () => const MainNavigationScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/business', page: () => const BusinessDetailsScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF6ED7B9),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
