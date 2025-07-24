import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'navigation.dart';

class BusinessDetailsController extends GetxController {
  var selectedDate = Rxn<DateTime>();
  var selectedState = Rxn<String>();
  final businessNameController = TextEditingController();
  final yourNameController = TextEditingController();
  final gstinController = TextEditingController();
  final businessLocationController = TextEditingController();
  final productListLocationController = TextEditingController();
  final addressLineController = TextEditingController();
  final cityController = TextEditingController();

  final List<String> indianStates = [
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
  void onInit() {
    super.onInit();
    loadBusinessData();
  }

  Future<void> loadBusinessData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      businessNameController.text = prefs.getString('businessName') ?? '';
      yourNameController.text = prefs.getString('yourName') ?? '';
      gstinController.text = prefs.getString('gstin') ?? '';
      businessLocationController.text = prefs.getString('businessLocation') ?? '';
      productListLocationController.text = prefs.getString('ProductList') ?? '';
      addressLineController.text = prefs.getString('addressLine') ?? '';
      cityController.text = prefs.getString('city') ?? '';
      selectedState.value = prefs.getString('state');
      final savedDate = prefs.getString('businessDate');
      if (savedDate != null && savedDate.isNotEmpty) {
        final parts = savedDate.split('/');
        if (parts.length == 3) {
          selectedDate.value = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        }
      }
      debugPrint('Business data loaded successfully');
    } catch (e) {
      debugPrint('Error loading business data: $e');
      Get.snackbar('Error', 'Failed to load business data: $e');
    }
  }

  Future<void> saveBusinessData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('businessName', businessNameController.text);
      await prefs.setString('yourName', yourNameController.text);
      await prefs.setString('gstin', gstinController.text);
      await prefs.setString('businessLocation', businessLocationController.text);
      await prefs.setString('ProductList', productListLocationController.text);
      await prefs.setString('addressLine', addressLineController.text);
      await prefs.setString('city', cityController.text);
      if (selectedState.value != null) {
        await prefs.setString('state', selectedState.value!);
      }
      if (selectedDate.value != null) {
        await prefs.setString(
            'businessDate', '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}');
      }
      Get.snackbar('Success', 'Business details saved successfully!');
    } catch (e) {
      debugPrint('Error saving business data: $e');
      Get.snackbar('Error', 'Failed to save business data: $e');
    }
  }
}

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusinessDetailsController());

    Widget buildTextField(String label, TextEditingController textController) {
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
        controller: textController,
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

    Widget buildCalendarDropdown(String label) {
      return Obx(() => GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(
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
                  initialSelectedDate: controller.selectedDate.value ?? DateTime.now(),
                  selectionDecoration: BoxDecoration(
                    color: const Color(0xFF6ED7B9).withOpacity(0.3),
                    border: Border.all(color: const Color(0xFF6ED7B9), width: 2),
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
                      controller.selectedDate.value = details.date;
                      Get.back();
                    }
                  },
                ),
              ),
            ),
          );
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF6ED7B9)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          ),
          child: Text(
            controller.selectedDate.value != null
                ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                : 'Date format',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        centerTitle:true,
        title: const Text(
          'Business details',
          style: TextStyle(color: Colors.black),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     debugPrint('Back button pressed');
        //     Get.offNamed('/main_navigation');
        //   },
        // ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              buildTextField('Business name', controller.businessNameController),
              const SizedBox(height: 12),
              buildTextField('Your name', controller.yourNameController),
              const SizedBox(height: 12),
              buildTextField('GSTIN', controller.gstinController),
              const SizedBox(height: 12),
              buildTextField('Business location', controller.businessLocationController),
              const SizedBox(height: 12),
              buildCalendarDropdown('Choose a date'),
              const SizedBox(height: 12),
              buildTextField('Product list', controller.productListLocationController),
              const SizedBox(height: 12),
              buildTextField('Address line', controller.addressLineController),
              const SizedBox(height: 12),
              buildTextField('City', controller.cityController),
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedState.value,
                isExpanded: true,
                menuMaxHeight: 250,
                items: controller.indianStates.map((String state) {
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
                  controller.selectedState.value = value;
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
              )),
              const SizedBox(height: 32),
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
                  onPressed: controller.saveBusinessData,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}