import 'package:flutter/material.dart';
import 'welcomescreen.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  String? _selectedCode;

  final List<Map<String, String>> _languages = const [
    {"name": "English", "flag": "🇺🇸", "code": "en"},
    {"name": "Tamil", "flag": "🇮🇳", "code": "hi"},
    {"name": "Arabic", "flag": "🇸🇦", "code": "ar"},
    {"name": "Spanish", "flag": "🇪🇸", "code": "es"},
    {"name": "French", "flag": "🇫🇷", "code": "fr"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// 🌿 Decorative top image
            Center(
              child: Image.asset(
                'assets/images/full_language_screen.png',
                width: 500,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Select your language",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "Select your preferred language to use the app easily",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = _selectedCode == lang['code'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF6ed7b9)
                              : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        leading: Text(
                          lang['flag']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(
                          lang['name']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Radio<String>(
                          value: lang['code']!,
                          groupValue: _selectedCode,
                          activeColor: const Color(0xFF6ed7b9),
                          onChanged: (value) {
                            setState(() => _selectedCode = value);
                          },
                        ),
                        onTap: () {
                          setState(() => _selectedCode = lang['code']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6ed7b9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_selectedCode == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a language before continuing."),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    // Simply navigate to WelcomeScreen without setting locale
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    );
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
