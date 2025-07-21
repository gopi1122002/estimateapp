import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dashboardscreen.dart';
import 'navigation.dart'; // Assuming this is mainnavigation.dart

class NewEstimateScreen extends StatefulWidget {
  const NewEstimateScreen({super.key});

  @override
  State<NewEstimateScreen> createState() => _NewEstimateScreenState();
}

class _NewEstimateScreenState extends State<NewEstimateScreen> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _estimateDateController =
  TextEditingController(text: " ");
  final TextEditingController _expiryDateController =
  TextEditingController(text: " ");
  final TextEditingController _estimateNumberController =
  TextEditingController(text: " ");
  String _currency = "INR";
  final TextEditingController _notesController = TextEditingController(
      text: "Looking forward for your business.");
  final List<String> _currencies = ["INR", "USD", "EUR", "GBP", "JPY", "CNY", "AUD", "CAD", "CHF", "SGD"];
  final List<String> countryList = [
    "India", "United States", "Germany", "United Kingdom",
    "Japan", "China", "Australia", "Canada", "Switzerland", "Singapore"
  ];

  // Local variables to store customer and item details
  Map<String, dynamic>? _customerDetails;
  List<Map<String, dynamic>> _itemDetails = [];

  @override
  void dispose() {
    _customerController.dispose();
    _estimateDateController.dispose();
    _expiryDateController.dispose();
    _estimateNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate;
    try {
      initialDate = DateFormat("dd MMM yyyy").parse(controller.text);
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat("dd MMM yyyy").format(picked);
      });
    }
  }

  void _showCustomerModal() {
    final customerNameController = TextEditingController();
    final gstinController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final zipController = TextEditingController();
    final countryController = TextEditingController();
    String? placeOfSupplyValue;
    String? stateValue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        void clearAllFields() {
          customerNameController.clear();
          gstinController.clear();
          addressController.clear();
          cityController.clear();
          zipController.clear();
          countryController.clear();
          placeOfSupplyValue = null;
          stateValue = null;
        }

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: clearAllFields,
                        child: const Text("Clear",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                      const Text("Customer Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  TextField(
                    controller: customerNameController,
                    decoration: InputDecoration(
                      labelText: "Customer Name",
                      hintText: "Customer Name",
                      labelStyle: const TextStyle(color: Colors.black),
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey)),
                    ),
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: gstinController,
                          decoration: InputDecoration(
                            labelText: "GSTIN",
                            hintText: "GSTIN",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                          ),
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: DropdownButtonFormField<String>(
                          value: placeOfSupplyValue,
                          decoration: InputDecoration(
                            labelText: "Place of Supply",
                            hintText: "Choose state",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                          ),
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          items: <String>['Tamil Nadu', 'Kerala', 'Andhra Pradesh']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            placeOfSupplyValue = newValue;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Address line",
                      hintText: "Address line",
                      labelStyle: const TextStyle(color: Colors.black),
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey)),
                    ),
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.grey,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: cityController,
                          decoration: InputDecoration(
                            labelText: "City",
                            hintText: "City",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                          ),
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: DropdownButtonFormField<String>(
                          value: stateValue,
                          decoration: InputDecoration(
                            labelText: "State",
                            hintText: "Choose state",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey)),
                          ),
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          items: <String>['Tamil Nadu', 'Kerala', 'Andhra Pradesh']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            stateValue = newValue;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: DropdownButtonFormField<String>(
                          value: countryController.text.isEmpty ? null : countryController.text,
                          items: countryList.map((String country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                          onChanged: (value) {
                            countryController.text = value!;
                          },
                          decoration: const InputDecoration(
                            labelText: "Country",
                            hintText: "Select Country",
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6ED7B9),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      if (customerNameController.text.isNotEmpty) {
                        setState(() {
                          _customerDetails = {
                            'name': customerNameController.text,
                            'gstin': gstinController.text,
                            'placeOfSupply': placeOfSupplyValue,
                            'address': addressController.text,
                            'city': cityController.text,
                            'state': stateValue,
                            'country': countryController.text,
                          };
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter customer name')),
                        );
                      }
                    },
                    child: const Text("Done",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showItemModal() {
    final itemNameController = TextEditingController();
    final hsnController = TextEditingController();
    final priceController = TextEditingController();
    final itemsController = TextEditingController(); // No initial value
    final gstController = TextEditingController();
    final cessController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        void clearAllFields() {
          itemNameController.clear();
          hsnController.clear();
          priceController.clear();
          itemsController.clear();
          gstController.clear();
          cessController.clear();
        }

        void updateItems(double change) {
          double currentValue = double.tryParse(itemsController.text) ?? 0.0;
          double newValue = currentValue + change;
          if (newValue >= 0) {
            itemsController.text = newValue.toStringAsFixed(0); // Whole numbers
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: clearAllFields,
                      child: const Text(
                        "Clear",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "Item Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(
                    labelText: "Item Name",
                    hintText: "What are you selling?",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.grey,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: hsnController,
                  decoration: InputDecoration(
                    labelText: "HSN",
                    hintText: "HSN",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.grey,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          labelText: "Price",
                          hintText: "INR 0.00",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          prefixText: "INR ",
                        ),
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_rounded),
                            color: Colors.black,
                            onPressed: () => updateItems(-1.0),
                          ),
                          Expanded(
                            child: TextField(
                              controller: itemsController,
                              decoration: InputDecoration(
                                labelText: "Items",
                                hintText: "_",
                                labelStyle: const TextStyle(color: Colors.black),
                                hintStyle: const TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey)),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                              ),
                              keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                              readOnly: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                              cursorColor: Colors.grey,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_rounded),
                            color: Colors.black,
                            onPressed: () => updateItems(1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: gstController,
                        decoration: InputDecoration(
                          labelText: "GST",
                          hintText: "GST",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: cessController,
                        decoration: InputDecoration(
                          labelText: "Cess",
                          hintText: "Cess",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6ED7B9),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (itemNameController.text.isNotEmpty) {
                      setState(() {
                        _itemDetails.add({
                          'name': itemNameController.text,
                          'hsn': hsnController.text,
                          'price': priceController.text,
                          'items': itemsController.text,
                          'gst': gstController.text,
                          'cess': cessController.text,
                        });
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter item name')),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        title: const Text('New Estimate',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showCustomerModal,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6ED7B9).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_sharp, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Add Customer Details',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ),
            ),
            if (_customerDetails != null) ...[
              const SizedBox(height: 16),
              Text('Customer: ${_customerDetails!['name']}',
                  style: const TextStyle(fontSize: 16)),
              Text('GSTIN: ${_customerDetails!['gstin']}',
                  style: const TextStyle(fontSize: 16)),
              Text('Place of Supply: ${_customerDetails!['placeOfSupply']}',
                  style: const TextStyle(fontSize: 16)),
              Text('Address: ${_customerDetails!['address']}',
                  style: const TextStyle(fontSize: 16)),
              Text('City: ${_customerDetails!['city']}',
                  style: const TextStyle(fontSize: 16)),
              Text('State: ${_customerDetails!['state']}',
                  style: const TextStyle(fontSize: 16)),
              Text('Country: ${_customerDetails!['country']}',
                  style: const TextStyle(fontSize: 16)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estimate Date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _estimateDateController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Select a date",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: Color(0xFF6ED7B9)),
                            onPressed: () =>
                                _selectDate(context, _estimateDateController),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expiry Date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _expiryDateController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Select a date",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: Color(0xFF6ED7B9)),
                            onPressed: () =>
                                _selectDate(context, _expiryDateController),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estimate Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _estimateNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter estimate number",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Currency',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _currency,
                        items: _currencies.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _currency = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Select currency",
                          labelStyle: const TextStyle(color: Colors.black),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                        style: const TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showItemModal,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6ED7B9).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_sharp, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Add Item Details',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ),
            ),
            if (_itemDetails.isNotEmpty) ...[
              const SizedBox(height: 16),
              for (var item in _itemDetails)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item: ${item['name']}', style: const TextStyle(fontSize: 16)),
                    Text('HSN: ${item['hsn']}', style: const TextStyle(fontSize: 16)),
                    Text('Price: ${item['price']}', style: const TextStyle(fontSize: 16)),
                    Text('Items: ${item['items']}', style: const TextStyle(fontSize: 16)),
                    Text('GST: ${item['gst']}', style: const TextStyle(fontSize: 16)),
                    Text('Cess: ${item['cess']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                  ],
                ),
            ],
            const SizedBox(height: 16),
            const Text('Notes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Add notes here",
                labelStyle: const TextStyle(color: Colors.black),
                hintStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.grey,
            ),
            const SizedBox(height: 8),
            const Text('Terms & Conditions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Terms & Conditions...',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_customerDetails == null || _itemDetails.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add customer and item details')),
                    );
                    return;
                  }
                  // Store all details in a single map
                  final estimateDetails = {
                    'customer': _customerDetails,
                    'estimateDate': _estimateDateController.text,
                    'expiryDate': _expiryDateController.text,
                    'estimateNumber': _estimateNumberController.text,
                    'currency': _currency,
                    'notes': _notesController.text,
                    'items': _itemDetails,
                  };

                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/generate.png', // Use your actual image path
                              height: 180,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Estimate generated successfully',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  // Navigate back to MainNavigationScreen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainNavigationScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6ED7B9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6ED7B9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Generate Estimate',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}