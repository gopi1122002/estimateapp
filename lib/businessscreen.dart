import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  DateTime? _selectedDate;
  String? _selectedState;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Business details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextField('Business name')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Your name')),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField('GSTIN')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Business location')),
                ],
              ),
              const SizedBox(height: 20),
              _buildCalendarDropdown('Choose a date'),
              const SizedBox(height: 20),
              _buildTextField('Address line'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField('City')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
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
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                  onPressed: () {},
                  child: const Text(
                    'Next',
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

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF6ED7B9)),
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'Tap to select a date',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SizedBox(
          width: 300,
          height: 400,
          child: SfCalendar(
            view: CalendarView.month,
            initialSelectedDate: _selectedDate ?? DateTime.now(),
            onTap: (CalendarTapDetails details) {
              if (details.date != null) {
                setState(() {
                  _selectedDate = details.date!;
                });
                Navigator.of(context).pop();
              }
            },
            monthViewSettings: MonthViewSettings(
              showTrailingAndLeadingDates: true,
              showAgenda: false,
              monthCellStyle: MonthCellStyle(
                todayBackgroundColor: const Color(0xFFFFF3E0),
                backgroundColor: const Color(0xFFF6F9F7),
                trailingDatesBackgroundColor: Colors.grey.shade200,
                leadingDatesBackgroundColor: Colors.grey.shade200,
                textStyle: const TextStyle(color: Colors.black),
                trailingDatesTextStyle: TextStyle(color: Colors.grey.shade400),
                leadingDatesTextStyle: TextStyle(color: Colors.grey.shade400),
              ),
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
          ),
        ),
      ),
    );
  }
}
