import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _dobController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  final _professionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _projectsController = TextEditingController();
  File? _imageFile;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _dobController.text = prefs.getString('dob') ?? '';
        _maritalStatusController.text = prefs.getString('maritalStatus') ?? '';
        _professionController.text = prefs.getString('profession') ?? '';
        _skillsController.text = prefs.getString('skills') ?? '';
        _projectsController.text = prefs.getString('projects') ?? '';

        final base64Image = prefs.getString('profileImage');
        if (base64Image != null && base64Image.isNotEmpty) {
          _convertBase64ToFile(base64Image);
        }
      });
      debugPrint('Profile data loaded successfully');
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data: $e')),
      );
    }
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
      debugPrint('Profile image loaded from base64');
    } catch (e) {
      debugPrint('Error converting base64 to file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile image: $e')),
      );
    }
  }

  Future<void> _saveProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dob', _dobController.text);
      await prefs.setString('maritalStatus', _maritalStatusController.text);
      await prefs.setString('profession', _professionController.text);
      await prefs.setString('skills', _skillsController.text);
      await prefs.setString('projects', _projectsController.text);

      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        await prefs.setString('profileImage', base64Encode(bytes));
        debugPrint('Profile image saved as base64');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error saving profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageOption(
                icon: Icons.camera_alt,
                label: "Camera",
                source: ImageSource.camera,
              ),
              _buildImageOption(
                icon: Icons.photo,
                label: "Gallery",
                source: ImageSource.gallery,
              ),
            ],
          ),
        ),
      );

      if (source == null) {
        debugPrint('No image source selected');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image source selected')),
        );
        return;
      }

      // Request appropriate permissions
      PermissionStatus permissionStatus;
      if (source == ImageSource.camera) {
        permissionStatus = await Permission.camera.request();
      } else {
        // For Android 13+ (API 33), use READ_MEDIA_IMAGES; for older versions, fallback to storage
        permissionStatus = await (Platform.isAndroid && (int.tryParse(Platform.version.split('.').first) ?? 30) >= 33
            ? Permission.photos.request()
            : Permission.storage.request());
      }

      if (permissionStatus.isGranted) {
        final pickedFile = await ImagePicker().pickImage(
          source: source,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 85,
        );
        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
          debugPrint('Image picked successfully: ${pickedFile.path}');
        } else {
          debugPrint('No image picked');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
      } else if (permissionStatus.isPermanentlyDenied) {
        debugPrint('Permission permanently denied for ${source == ImageSource.camera ? 'camera' : 'photos/storage'}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Permission permanently denied. Please enable ${source == ImageSource.camera ? 'camera' : 'photos'} access in settings.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      } else {
        debugPrint('Permission denied for ${source == ImageSource.camera ? 'camera' : 'photos/storage'}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission denied for ${source == ImageSource.camera ? 'camera' : 'photos'}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _pickImage,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal[100],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 280,
          height: 320,
          padding: const EdgeInsets.all(8),
          child: SfCalendar(
            view: CalendarView.month,
            minDate: DateTime(1900),
            maxDate: DateTime.now(),
            initialSelectedDate: _selectedDate ?? DateTime.now(),
            selectionDecoration: BoxDecoration(
              color: const Color(0xFF6ED7B9).withOpacity(0.3),
              border: Border.all(color: const Color(0xFF6ED7B9), width: 2),
              shape: BoxShape.circle,
            ),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.none,
            ),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                Navigator.pop(context, details.date);
              }
            },
          ),
        ),
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9), // Updated to match BusinessDetailsScreen
        elevation: 0,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
            const SizedBox(height: 20),
            _buildSectionTitle('Personal Info'),
            _buildTextField(label: 'Date of Birth', controller: _dobController, isDateField: true),
            _buildTextField(label: 'Marital Status', controller: _maritalStatusController),
            _buildTextField(label: 'Profession', controller: _professionController),
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

  Widget _buildTextField({required String label, required TextEditingController controller, bool isDateField = false}) {
    IconData icon;
    switch (label) {
      case 'Date of Birth':
        icon = Icons.cake_outlined;
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: isDateField,
        onTap: isDateField ? () => _selectDate(context) : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: const Color(0xFF6ED7B9)),
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