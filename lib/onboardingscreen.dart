import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginscreen.dart';
import 'select_language.dart';// <-- Ensure this path is correct

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "image": "assets/images/onboardingscreen1.png",
      "title": "Effortless estimate builder pro",
      "subtitle":
      "Effortless estimate builder pro makes creating accurate estimates quick and simple with user-friendly templates.",
    },
    {
      "image": "assets/images/onboardingscreen2.png",
      "title": "Instant quote & estimate creator",
      "subtitle":
      "Instant quote & estimate creator delivers fast, precise quotes with automated features for on-the-go professionals.",
    },
    {
      "image": "assets/images/onboardingscreen3.png",
      "title": "Precision estimate generator suite",
      "subtitle":
      "Precision estimate generator suite offers advanced tools for creating detailed, accurate project estimates effortlessly.",
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _skip() {
    _controller.jumpToPage(_onboardingData.length - 1);
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboarded', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SelectLanguageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF6ED7B9),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data["title"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 95),
                      Image.asset(
                        data["image"],
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        data["subtitle"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (index == _onboardingData.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            onPressed: _completeOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6ed7b9),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Get Started",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            if (_currentPage != _onboardingData.length - 1)
              Positioned(
                right: 16,
                top: 40,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text("Skip", style: TextStyle(color: Colors.grey)),
                ),
              ),
            if (_currentPage != _onboardingData.length - 1)
              Positioned(
                bottom: 60,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _onboardingData.length,
                            (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: _currentPage == index ? 12 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? Colors.grey[800] : Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6ed7b9),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
                        elevation: 2,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
