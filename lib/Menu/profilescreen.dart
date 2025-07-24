import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../dashboard/view/navigation.dart';
import '../dashboard/view/editscreenprofile.dart';

class ProfileController extends GetxController {
  var username = ''.obs;
  var dob = ''.obs;
  var gender = ''.obs;
  var maritalStatus = ''.obs;
  var profession = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var skills = ''.obs;
  var projects = ''.obs;

  // Business details
  var businessName = ''.obs;
  var yourName = ''.obs;
  var gstin = ''.obs;
  var businessLocation = ''.obs;
  var addressLine = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var businessDate = ''.obs;

  var imageFile = Rxn<File>();
  var isLoading = true.obs;

  Future<void> loadProfileData() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();

    username.value = prefs.getString('username') ?? '';
    dob.value = prefs.getString('dob') ?? '';
    gender.value = prefs.getString('gender') ?? '';
    maritalStatus.value = prefs.getString('maritalStatus') ?? '';
    profession.value = prefs.getString('profession') ?? '';
    email.value = prefs.getString('email') ?? '';
    phone.value = prefs.getString('phone') ?? '';
    skills.value = prefs.getString('skills') ?? '';
    projects.value = prefs.getString('projects') ?? '';

    businessName.value = prefs.getString('businessName') ?? '';
    yourName.value = prefs.getString('yourName') ?? '';
    gstin.value = prefs.getString('gstin') ?? '';
    businessLocation.value = prefs.getString('businessLocation') ?? '';
    addressLine.value = prefs.getString('addressLine') ?? '';
    city.value = prefs.getString('city') ?? '';
    state.value = prefs.getString('state') ?? '';
    businessDate.value = prefs.getString('businessDate') ?? '';

    final base64Image = prefs.getString('profileImage');
    if (base64Image != null && base64Image.isNotEmpty) {
      await _convertBase64ToFile(base64Image);
    }

    isLoading.value = false;
  }

  Future<void> _convertBase64ToFile(String base64Image) async {
    try {
      final bytes = base64Decode(base64Image);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/profile_image.png');
      await file.writeAsBytes(bytes);
      imageFile.value = file;
    } catch (e) {
      print('Error converting base64 to file: $e');
    }
  }

  Future<void> updateProfile() async {
    const String baseUrl = 'https://mdqapps.tech';
    const String url = '$baseUrl/api/estimate/update_profile';

    final Map<String, dynamic> requestBody = {
      'name': username.value,
      'dob': dob.value,
      'gender': gender.value,
      'maritalStatus': maritalStatus.value,
      'profession': profession.value,
      'email': email.value,
      'phone': phone.value,
      'skills': skills.value,
      'projects': projects.value,
      'businessName': businessName.value,
      'yourName': yourName.value,
      'gstin': gstin.value,
      'businessLocation': businessLocation.value,
      'addressLine': addressLine.value,
      'city': city.value,
      'state': state.value,
      'businessDate': businessDate.value,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token if required, e.g., 'Authorization': 'Bearer ${prefs.getString('token')}'
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        Get.snackbar('Error', 'Failed to update profile: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error updating profile: $e');
    }
  }

  void navigateToMainNavigation() {
    Get.off(() => const MainNavigationScreen());
  }

  void navigateToEditProfile() {
    Get.to(() => const EditProfileScreen())?.then((_) async {
      await loadProfileData();
      await updateProfile(); // Call API to update profile after editing
    });
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.loadProfileData(); // Load data on initialization

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: controller.navigateToEditProfile,
          ),
        ],
      ),

      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: controller.loadProfileData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: controller.imageFile.value != null
                      ? FileImage(controller.imageFile.value!)
                      : null,
                  child: controller.imageFile.value == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 12),
                _buildInfoField(label: 'Username', value: controller.username.value),
                const SizedBox(height: 20),
                _buildSectionTitle('Personal Info'),
                _buildInfoField(label: 'Date of Birth', value: controller.dob.value),
                _buildInfoField(label: 'Gender', value: controller.gender.value),
                _buildInfoField(label: 'Marital Status', value: controller.maritalStatus.value),
                _buildInfoField(label: 'Profession', value: controller.profession.value),
                _buildInfoField(label: 'Email', value: controller.email.value),
                _buildInfoField(label: 'Phone', value: controller.phone.value),
                const SizedBox(height: 20),
                _buildSectionTitle('Business Info'),
                _buildInfoField(label: 'Business Name', value: controller.businessName.value),
                _buildInfoField(label: 'Your Name', value: controller.yourName.value),
                _buildInfoField(label: 'GSTIN', value: controller.gstin.value),
                _buildInfoField(label: 'Business Location', value: controller.businessLocation.value),
                _buildInfoField(label: 'Address Line', value: controller.addressLine.value),
                _buildInfoField(label: 'City', value: controller.city.value),
                _buildInfoField(label: 'State', value: controller.state.value),
                _buildInfoField(label: 'Business Date', value: controller.businessDate.value),
                const SizedBox(height: 20),
                _buildSectionTitle('Skills'),
                _buildInfoField(label: 'Skills', value: controller.skills.value),
                const SizedBox(height: 20),
                _buildSectionTitle('Projects'),
                _buildInfoField(label: 'Projects', value: controller.projects.value),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            maxLines: null,
          ),
          const Divider(color: Color(0xFFDCDCDC)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}