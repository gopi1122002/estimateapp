// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ThemeNotifier extends ValueNotifier<ThemeMode> {
//   ThemeNotifier() : super(ThemeMode.light) {
//     _loadTheme();
//   }
//
//   Future<void> _loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isDark = prefs.getBool('isDarkMode') ?? false;
//     value = isDark ? ThemeMode.dark : ThemeMode.light;
//   }
//
//   Future<void> toggleTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isDark = value == ThemeMode.dark;
//     value = isDark ? ThemeMode.light : ThemeMode.dark;
//     await prefs.setBool('isDarkMode', !isDark);
//   }
// }
//
// // ✅ Global instance
// final ThemeNotifier themeNotifier = ThemeNotifier();
