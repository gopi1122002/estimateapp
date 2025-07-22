import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'invoice.dart';

class ViewEstimateScreen extends StatefulWidget {
  final List<Map<String, dynamic>> estimates;

  const ViewEstimateScreen({super.key, required this.estimates});

  @override
  State<ViewEstimateScreen> createState() => _ViewEstimateScreenState();
}

class _ViewEstimateScreenState extends State<ViewEstimateScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> estimates;

  @override
  void initState() {
    super.initState();
    estimates = List.from(widget.estimates);
    _searchController.addListener(_filterEstimates);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEstimates);
    _searchController.dispose();
    super.dispose();
  }

  void _filterEstimates() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        estimates = List.from(widget.estimates);
      } else {
        estimates = widget.estimates.where((estimate) {
          final customerName = estimate['customer']['name']?.toLowerCase() ?? '';
          final estNumber = estimate['estimateNumber']?.toString().toLowerCase() ?? '';
          return customerName.contains(query) || estNumber.contains(query);
        }).toList();
      }

      // Sort descending by estimateDate
      estimates.sort((a, b) {
        final dateA = DateFormat("dd MMM yyyy").parse(a['estimateDate']);
        final dateB = DateFormat("dd MMM yyyy").parse(b['estimateDate']);
        return dateB.compareTo(dateA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        title: const Text('View Estimates', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              cursorColor: Colors.grey, // Set cursor color to grey
              decoration: InputDecoration(
                labelText: 'Search by Customer Name or EST No.',
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: estimates.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/noestimate.png',
                      height: 350,
                      width: 350,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'No estimates found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: estimates.length,
                itemBuilder: (context, index) {
                  final estimate = estimates[index];
                  final date = estimate['estimateDate'] ?? 'N/A';
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        'Customer: ${estimate['customer']['name'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Date: $date',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvoiceScreen(estimate: estimate),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.blue),
                        child: const Text('View'),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
