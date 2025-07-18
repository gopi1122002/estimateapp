import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'loginscreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final int otpLength = 4;
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  bool _isOtpInvalid = false;
  Timer? _timer;
  int _secondsRemaining = 15;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _resendCode() {
    _startTimer();
    _clearOTPFields();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Resent")),
    );
  }

  void _verifyOTP() {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 4) {
      setState(() => _isOtpInvalid = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 4-digit OTP')),
      );
      return;
    }

    if (otp != "1234") { // Replace with your actual OTP validation logic
      setState(() => _isOtpInvalid = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
      return;
    }

    // OTP is valid
    setState(() => _isOtpInvalid = false);
    _clearOTPFields();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenCustomBackground()),
    );
  }


  void _clearOTPFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Focus(
        onKey: (node, event) {
          // Only handle backspace on key down
          if (event.logicalKey.keyLabel == 'Backspace' &&
              event is RawKeyDownEvent &&
              _otpControllers[index].text.isEmpty &&
              index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.teal.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isOtpInvalid ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isOtpInvalid ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isOtpInvalid ? Colors.red : Colors.teal,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            setState(() => _isOtpInvalid = false); // Clear red border
            if (value.isNotEmpty && index < _focusNodes.length - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              Image.asset(
                'assets/images/otpscreen.png',
                height: 260,
                width: 260,
              ),
              const SizedBox(height: 32),
              const Text(
                "OTP verification",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "A 4 digit code has been sent\nto your email",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.red, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "0:${_secondsRemaining.toString().padLeft(2, '0')} sec",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _secondsRemaining == 0 ? _resendCode : null,
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: _secondsRemaining == 0
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 62),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6ED7B9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
