import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'navigation.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  final _professionController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  final _projectsController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _genderController.text = prefs.getString('gender') ?? '';
      _maritalStatusController.text = prefs.getString('maritalStatus') ?? '';
      _professionController.text = prefs.getString('profession') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _skillsController.text = prefs.getString('skills') ?? '';
      _projectsController.text = prefs.getString('projects') ?? '';

      final base64Image = prefs.getString('profileImage');
      if (base64Image != null && base64Image.isNotEmpty) {
        _convertBase64ToFile(base64Image);
      }
    });
  }

  Future<void> _convertBase64ToFile(String base64Image) async {
    final bytes = base64Decode(base64Image);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/profile_image.png');
    await file.writeAsBytes(bytes);
    setState(() {
      _imageFile = file;
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', _nameController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('gender', _genderController.text);
    await prefs.setString('maritalStatus', _maritalStatusController.text);
    await prefs.setString('profession', _professionController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('skills', _skillsController.text);
    await prefs.setString('projects', _projectsController.text);

    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      await prefs.setString('profileImage', base64Encode(bytes));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(Icons.edit, size: 16, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _buildTextField(label: 'Full Name', controller: _nameController),
            _buildTextField(label: 'Username', controller: _usernameController),

            const SizedBox(height: 20),
            _buildSectionTitle('Personal Info'),
            _buildTextField(label: 'Date of Birth', controller: _dobController),
            _buildTextField(label: 'Gender', controller: _genderController),
            _buildTextField(label: 'Marital Status', controller: _maritalStatusController),
            _buildTextField(label: 'Profession', controller: _professionController),
            _buildTextField(label: 'Email', controller: _emailController),
            _buildTextField(label: 'Phone', controller: _phoneController),

            const SizedBox(height: 20),
            _buildSectionTitle('Skills'),
            _buildTextField(label: 'Skills', controller: _skillsController),

            const SizedBox(height: 20),
            _buildSectionTitle('Projects'),
            _buildTextField(label: 'Projects', controller: _projectsController),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6ED7B9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _saveProfileData,
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF6ED7B9)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
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
