import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _projectsController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showProfileSection = false;
  DateTime? _selectedDate;

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleObscureConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6ED7B9),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6ED7B9),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _goToProfileInfo() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _showProfileSection = true;
    });
  }

  Future<void> _submitProfile() async {
    if (_dobController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _maritalStatusController.text.isEmpty ||
        _professionController.text.isEmpty ||
        _skillsController.text.isEmpty ||
        _projectsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all profile fields')),
      );
      return;
    }

    // Save data to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('gender', _genderController.text);
    await prefs.setString('maritalStatus', _maritalStatusController.text);
    await prefs.setString('profession', _professionController.text);
    await prefs.setString('skills', _skillsController.text);
    await prefs.setString('projects', _projectsController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreenCustomBackground()),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text,
        bool obscureText = false,
        VoidCallback? toggleObscure,
        bool isDateField = false})
  {
    IconData icon;
    switch (label) {
      case 'Username':
        icon = Icons.account_circle_outlined;
        break;
      case 'Email ID':
        icon = Icons.email_outlined;
        break;
      case 'Mobile Number':
        icon = Icons.phone_outlined;
        break;
      case 'Password':
        icon = Icons.lock_outline;
        break;
      case 'Confirm Password':
        icon = Icons.lock_outline;
        break;
      case 'Date of Birth':
        icon = Icons.cake_outlined;
        break;
      case 'Gender':
        icon = Icons.transgender_outlined;
        break;
      case 'Marital Status':
        icon = Icons.favorite_border;
        break;
      case 'Profession':
        icon = Icons.work_outline;
        break;
      case 'Skills':
        icon = Icons.build_outlined;
        break;
      case 'Projects':
        icon = Icons.folder_open_outlined;
        break;
      default:
        icon = Icons.text_fields;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscureText,
          cursorColor: Colors.teal,
          readOnly: isDateField,
          onTap: isDateField ? () => _selectDate(context) : null,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF6ED7B9)),
            suffixIcon: toggleObscure != null
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleObscure,
            )
                : null,
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
      ],
    );
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
              const SizedBox(height: 80),
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

              if (!_showProfileSection) ...[
                _buildTextField('Username', _usernameController),
                _buildTextField('Email ID', _emailController),
                _buildTextField('Mobile Number', _phoneController, type: TextInputType.phone),
                _buildTextField('Password', _passwordController, obscureText: _obscurePassword, toggleObscure: _toggleObscurePassword),
                _buildTextField('Confirm Password', _confirmPasswordController, obscureText: _obscureConfirmPassword, toggleObscure: _toggleObscureConfirmPassword),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _goToProfileInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6ED7B9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ] else ...[
                const Center(
                  child: Text(
                    'Add Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField('Date of Birth', _dobController, isDateField: true),
                _buildTextField('Gender', _genderController),
                _buildTextField('Marital Status', _maritalStatusController),
                _buildTextField('Profession', _professionController),
                _buildTextField('Skills', _skillsController),
                _buildTextField('Projects', _projectsController),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6ED7B9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}