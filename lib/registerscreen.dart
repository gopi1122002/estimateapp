import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _createAccount() {
    // Navigate to actual signup logic or screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => NextScreen()));
    print("Create account tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Banner or Illustration
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Image.asset(
              //     'assets/images/signup_banner.png', // Replace with your background image
              //     height: 180,
              //     fit: BoxFit.contain,
              //   ),
              // ),
              const SizedBox(height: 140),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'TO CONTINUE',
                      style: TextStyle(
                        fontSize: 21,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text('Enter first name'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: 'Enter first name',
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFB2EFE5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Enter your email ID'),
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: 'Enter your email ID',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFB2EFE5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Enter your password'),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureText,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFB2EFE5)), // Filled lock icon
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleObscureText,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6ED7B9), // Mint green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Create an account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
