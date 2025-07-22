import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'navigation.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  DateTime? _selectedDate;
  String? _selectedState;
  final _businessNameController = TextEditingController();
  final _yourNameController = TextEditingController();
  final _gstinController = TextEditingController();
  final _businessLocationController = TextEditingController();
  final _ProductlistLocationController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();

  final List<String> _indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal', 'Andaman and Nicobar Islands',
    'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu', 'Delhi',
    'Jammu and Kashmir', 'Ladakh', 'Lakshadweep', 'Puducherry'
  ];

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
  }

  Future<void> _loadBusinessData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _businessNameController.text = prefs.getString('businessName') ?? '';
        _yourNameController.text = prefs.getString('yourName') ?? '';
        _gstinController.text = prefs.getString('gstin') ?? '';
        _businessLocationController.text = prefs.getString('businessLocation') ?? '';
        _ProductlistLocationController.text =prefs.getString('productlist') ?? '';
        _addressLineController.text = prefs.getString('addressLine') ?? '';
        _cityController.text = prefs.getString('city') ?? '';
        _selectedState = prefs.getString('state') ?? null;
        final savedDate = prefs.getString('businessDate');
        if (savedDate != null && savedDate.isNotEmpty) {
          final parts = savedDate.split('/');
          if (parts.length == 3) {
            _selectedDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        }
      });
      debugPrint('Business data loaded successfully');
    } catch (e) {
      debugPrint('Error loading business data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load business data: $e')),
      );
    }
  }

  Future<void> _saveBusinessData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('businessName', _businessNameController.text);
      await prefs.setString('yourName', _yourNameController.text);
      await prefs.setString('gstin', _gstinController.text);
      await prefs.setString('businessLocation', _businessLocationController.text);
      await prefs.setString('ProductList', _ProductlistLocationController.text);
      await prefs.setString('addressLine', _addressLineController.text);
      await prefs.setString('city', _cityController.text);
      if (_selectedState != null) {
        await prefs.setString('state', _selectedState!);
      }
      if (_selectedDate != null) {
        await prefs.setString('businessDate', '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business details saved successfully!')),
      );
    } catch (e) {
      debugPrint('Error saving business data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save business data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        title: const Text(
          'Business details',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const  MainNavigationScreen()),
            );
          },
        ),
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildTextField('Business name', _businessNameController),
              const SizedBox(height: 12),
              _buildTextField('Your name', _yourNameController),
              const SizedBox(height: 12),
              _buildTextField('GSTIN', _gstinController),
              const SizedBox(height: 12),
              _buildTextField('Business location', _businessLocationController),
              const SizedBox(height: 12),
              _buildCalendarDropdown('Choose a date'),
              const SizedBox(height: 12),
              _buildTextField('Product list', _ProductlistLocationController),
              const SizedBox(height: 12),
              _buildTextField('Address line', _addressLineController),
              const SizedBox(height: 12),
              _buildTextField('City', _cityController),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedState,
                isExpanded: true,
                menuMaxHeight: 250,
                items: _indianStates.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(
                      state,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedState = value!;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Choose state',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.location_on, color: Color(0xFF6ED7B9)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF6ED7B9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6ED7B9)),
              ),
              const SizedBox(height: 32), // Before the button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6ED7B9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveBusinessData,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    IconData icon;
    switch (label) {
      case 'Business name':
        icon = Icons.business;
        break;
      case 'Your name':
        icon = Icons.person;
        break;
      case 'GSTIN':
        icon = Icons.receipt;
        break;
      case 'Business location':
        icon = Icons.location_city;
        break;
      case 'Product list':
        icon = Icons.list_sharp;
        break;
      case 'Address line':
        icon = Icons.home;
        break;
      case 'City':
        icon = Icons.location_on;
        break;
      default:
        icon = Icons.text_fields;
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: const Color(0xFF6ED7B9)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6ED7B9)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCalendarDropdown(String label) {
    return GestureDetector(
      onTap: _showCalendarDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF6ED7B9)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'Date format',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 280,
          height: 320, // Consistent with EditProfileScreen
          padding: const EdgeInsets.all(8),
          child: SfCalendar(
            view: CalendarView.month,
            minDate: DateTime(1900),
            maxDate: DateTime.now(),
            initialSelectedDate: _selectedDate ?? DateTime.now(),
            selectionDecoration: BoxDecoration(
              color: const Color(0xFF6ED7B9).withOpacity(0.3),
              border: Border.all(color: const Color(0xFF6ED7B9), width: 2),
              // shape: BoxShape.circle,
            ),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.none,
              showTrailingAndLeadingDates: true,
            ),
            showNavigationArrow: true,
            headerStyle: const CalendarHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6ED7B9),
              ),
            ),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                setState(() {
                  _selectedDate = details.date!;
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }
}