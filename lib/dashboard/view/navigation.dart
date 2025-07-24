import 'package:flutter/material.dart';
import 'businessscreen.dart';
import '../../Menu/profilescreen.dart';
import 'dashboardscreen.dart';

class MainNavigationScreen extends StatefulWidget {
  final Map<String, dynamic>? estimateDetails;

  const MainNavigationScreen({super.key, this.estimateDetails});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> _getScreens() {
    return [
      DashboardScreen(estimateDetails: widget.estimateDetails),
      const BusinessDetailsScreen(),
      const ProfileScreen(), // Reintroduced ProfileScreen to match BottomNavigationBar items
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreens()[_selectedIndex], // Line 35: Now safe with 3 screens
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF6ED7B9),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}