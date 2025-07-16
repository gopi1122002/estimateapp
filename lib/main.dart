import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'package:newproject/onboardingscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the system top (status bar) color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6ED7B9), // Mint green
      statusBarIconBrightness: Brightness.dark, // Black icons
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}




