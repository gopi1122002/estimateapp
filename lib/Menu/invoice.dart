import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  final Map<String, dynamic> estimate;

  const InvoiceScreen({super.key, required this.estimate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        title: const Text('Invoice', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Invoice Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Customer: ${estimate['customer']['name'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Mobile: ${estimate['customer']['mobile'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Email: ${estimate['customer']['email'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('GSTIN: ${estimate['customer']['gstin'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Place of Supply: ${estimate['customer']['placeOfSupply'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Address: ${estimate['customer']['address'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('City: ${estimate['customer']['city'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('State: ${estimate['customer']['state'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Country: ${estimate['customer']['country'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Estimate Date: ${estimate['estimateDate'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Expiry Date: ${estimate['expiryDate'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Estimate Number: ${estimate['estimateNumber'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                Text('Currency: ${estimate['currency'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...((estimate['items'] as List?)?.map((item) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item: ${item['name'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                    Text('HSN: ${item['hsn'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                    Text('Price: ${item['price'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                    Text('Items: ${item['items'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                    Text('GST: ${item['gst'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                    Text('Cess: ${item['cess'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                  ],
                )) ?? []),
                const SizedBox(height: 16),
                Text('Notes: ${estimate['notes'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Generated on: ${DateTime.now().toLocal().toString().split('.')[0]} IST', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}