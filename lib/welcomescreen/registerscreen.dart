import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginscreen.dart';

class SignupController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final professionController = TextEditingController();
  final skillsController = TextEditingController();
  final projectsController = TextEditingController();

  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var showProfileSection = false.obs;
  var selectedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    resetForm(); // Reset form when controller is initialized
  }

  void resetForm() {
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    dobController.clear();
    genderController.clear();
    maritalStatusController.clear();
    professionController.clear();
    skillsController.clear();
    projectsController.clear();
    showProfileSection.value = false;
    selectedDate.value = null;
  }

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
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
                foregroundColor: Color(0xFF6ED7B9),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void goToProfileInfo() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    showProfileSection.value = true;
  }

  Future<void> registerUser() async {
    const String baseUrl = 'https://mdqapps.tech';
    const String url = '$baseUrl/api/estimate/register';

    final Map<String, dynamic> requestBody = {
      'name': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'mobile number': phoneController.text.trim(),
      'password': passwordController.text.trim(),
      'con_password': confirmPasswordController.text.trim(),
      'dob': dobController.text.trim(),
      'gender': genderController.text.trim(),
      'maritalStatus': maritalStatusController.text.trim(),
      'professional': professionController.text.trim(),
      'skill': skillsController.text.trim(),
      'project': projectsController.text.trim(),
    };

    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("@@@@@@@@@@@@@@@@@@@@@@looking for response code@@@@@@@@@@@@@@@@@@@@");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', usernameController.text.trim());
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('phone', phoneController.text.trim());
        await prefs.setString('dob', dobController.text.trim());
        await prefs.setString('gender', genderController.text.trim());
        await prefs.setString('maritalStatus', maritalStatusController.text.trim());
        await prefs.setString('profession', professionController.text.trim());
        await prefs.setString('skills', skillsController.text.trim());
        await prefs.setString('projects', projectsController.text.trim());

        Get.snackbar('Success', 'Registration successful!');
        resetForm(); // Clear form after successful registration
        Get.off(() => const LoginScreenCustomBackground());
      } else {
        Get.snackbar('Error', 'Registration failed: ${response.body}');
      }
    } catch (error) {
      Get.snackbar('Error', 'Error: $error');
    }
  }

  Future<void> submitProfile() async {
    if (dobController.text.isEmpty ||
        genderController.text.isEmpty ||
        maritalStatusController.text.isEmpty ||
        professionController.text.isEmpty ||
        skillsController.text.isEmpty ||
        projectsController.text.isEmpty) {
      Get.snackbar('Error', 'Please complete all profile fields');
      return;
    }

    await registerUser();
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    Widget buildTextField(String label, TextEditingController textController,
        {TextInputType type = TextInputType.text,
          bool obscureText = false,
          VoidCallback? toggleObscure,
          bool isDateField = false}) {
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
            controller: textController,
            keyboardType: type,
            obscureText: obscureText,
            readOnly: isDateField,
            onTap: isDateField ? () => controller.selectDate(context) : null,
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(icon, color: Color(0xFF6ED7B9)),
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
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
              Obx(
                    () => controller.showProfileSection.value
                    ? Column(
                  children: [
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
                    buildTextField('Date of Birth', controller.dobController, isDateField: true),
                    buildTextField('Gender', controller.genderController),
                    buildTextField('Marital Status', controller.maritalStatusController),
                    buildTextField('Profession', controller.professionController),
                    buildTextField('Skills', controller.skillsController),
                    buildTextField('Projects', controller.projectsController),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.submitProfile,
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
                  ],
                )
                    : Column(
                  children: [
                    buildTextField('Username', controller.usernameController),
                    buildTextField('Email ID', controller.emailController),
                    buildTextField('Mobile Number', controller.phoneController, type: TextInputType.phone),
                    Obx(
                          () => buildTextField(
                        'Password',
                        controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        toggleObscure: controller.toggleObscurePassword,
                      ),
                    ),
                    Obx(
                          () => buildTextField(
                        'Confirm Password',
                        controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        toggleObscure: controller.toggleObscureConfirmPassword,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.goToProfileInfo,
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Have an account? "),
                        TextButton(
                          onPressed: () {
                            Get.off(() => const LoginScreenCustomBackground());
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFF6ED7B9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}