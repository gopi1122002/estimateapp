import 'package:flutter/material.dart';
import 'select_language.dart'; // <-- new screen
import 'package:flutter/services.dart';

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
      "subtitle": "Effortless estimate builder pro makes creating accurate estimates quick and simple with user-friendly templates.",
    },
    {
      "image": "assets/images/onboardingscreen2.png",
      "title": "Instant quote & estimate creator",
      "subtitle": "Instant quote & estimate creator delivers fast, precise quotes with automated features for on-the-go professionals.",
    },
    {
      "image": "assets/images/onboardingscreen3.png",
      "title": "Precision estimate generator suite",
      "subtitle": "Precision estimate generator suite offers advanced tools for creating detailed, accurate project estimates effortlessly.",
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

  void _goToLanguageScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SelectLanguageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF6ED7B9), // Mint green
          statusBarIconBrightness: Brightness.dark,
      ),
    child:Scaffold(
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
                    // Title at the top
                    Text(
                      data["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 95),

                    //  Image in the middle
                    Image.asset(
                      data["image"],
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),

                    //  Subtitle below the image
                    Text(
                      data["subtitle"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    //  Only on last page: "Get Started" button
                    if (index == _onboardingData.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed: _goToLanguageScreen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFF6ed7b9),// Mint
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

          // Skip button (hide on last screen)
          if (_currentPage != _onboardingData.length - 1)
            Positioned(
              right: 16,
              top: 40,
              child: TextButton(
                onPressed: _skip,
                child: const Text("Skip", style: TextStyle(color: Colors.grey)),
              ),
            ),

          // Bottom dots and Next button (hide on last screen)
          if (_currentPage != _onboardingData.length - 1)
            Positioned(
              bottom: 60,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Keeps the row tight around its children
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
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color(0xFF6ed7b9),// Mint green
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      elevation: 2,
                    ),
                    child: const Icon(
                      Icons.chevron_right, // right chevron
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
