import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'navigation.dart';
import 'editscreenprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';
  String _dob = '';
  String _gender = '';
  String _maritalStatus = '';
  String _profession = '';
  String _email = '';
  String _phone = '';
  String _skills = '';
  String _projects = '';
  // Business details fields
  String _businessName = '';
  String _yourName = '';
  String _gstin = '';
  String _businessLocation = '';
  String _addressLine = '';
  String _city = '';
  String _state = '';
  String _businessDate = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Existing profile fields
      _username = prefs.getString('username') ?? '';
      _dob = prefs.getString('dob') ?? '';
      _gender = prefs.getString('gender') ?? '';
      _maritalStatus = prefs.getString('maritalStatus') ?? '';
      _profession = prefs.getString('profession') ?? '';
      _email = prefs.getString('email') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _skills = prefs.getString('skills') ?? '';
      _projects = prefs.getString('projects') ?? '';
      // Business details fields
      _businessName = prefs.getString('businessName') ?? '';
      _yourName = prefs.getString('yourName') ?? '';
      _gstin = prefs.getString('gstin') ?? '';
      _businessLocation = prefs.getString('businessLocation') ?? '';
      _addressLine = prefs.getString('addressLine') ?? '';
      _city = prefs.getString('city') ?? '';
      _state = prefs.getString('state') ?? '';
      _businessDate = prefs.getString('businessDate') ?? '';

      final base64Image = prefs.getString('profileImage');
      if (base64Image != null && base64Image.isNotEmpty) {
        _convertBase64ToFile(base64Image);
      }
    });
  }

  Future<void> _convertBase64ToFile(String base64Image) async {
    try {
      final bytes = base64Decode(base64Image);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/profile_image.png');
      await file.writeAsBytes(bytes);
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print('Error converting base64 to file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ).then((_) => _loadProfileData()); // Reload data after editing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[400],
              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 12),
            _buildInfoField(label: 'Username', value: _username),
            const SizedBox(height: 20),
            _buildSectionTitle('Personal Info'),
            _buildInfoField(label: 'Date of Birth', value: _dob),
            _buildInfoField(label: 'Gender', value: _gender),
            _buildInfoField(label: 'Marital Status', value: _maritalStatus),
            _buildInfoField(label: 'Profession', value: _profession),
            _buildInfoField(label: 'Email', value: _email),
            _buildInfoField(label: 'Phone', value: _phone),
            const SizedBox(height: 20),
            _buildSectionTitle('Business Info'),
            _buildInfoField(label: 'Business Name', value: _businessName),
            _buildInfoField(label: 'Your Name', value: _yourName),
            _buildInfoField(label: 'GSTIN', value: _gstin),
            _buildInfoField(label: 'Business Location', value: _businessLocation),
            _buildInfoField(label: 'Address Line', value: _addressLine),
            _buildInfoField(label: 'City', value: _city),
            _buildInfoField(label: 'State', value: _state),
            _buildInfoField(label: 'Business Date', value: _businessDate),
            const SizedBox(height: 20),
            _buildSectionTitle('Skills'),
            _buildInfoField(label: 'Skills', value: _skills),
            const SizedBox(height: 20),
            _buildSectionTitle('Projects'),
            _buildInfoField(label: 'Projects', value: _projects),
            const SizedBox(height: 40),
          ],
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