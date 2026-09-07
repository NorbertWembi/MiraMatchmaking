import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

final String baseUrl = 'http://10.0.2.2:5050/api/reports';

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _reportController = TextEditingController();
  final List<bool> _circleFilled = [false, false, false, false]; // 4 circles
  final List<String> _labels = [
    'Spam',
    'Harassment',
    'Inappropriate Content',
    'Other'
  ];

  void _submitReport() async {
    final reportText = _reportController.text.trim();
    final selectedReasons = <String>[];

    for (int i = 0; i < _labels.length; i++) {
      if (_circleFilled[i]) selectedReasons.add(_labels[i]);
    }

    if (reportText.isEmpty && selectedReasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reason or enter a report.')),
      );
      return;
    }

    try {
      final reporterId = "64f0f6a1234567890abcdef1";
      final reportedId = "64f0f6a1234567890abcdef2";

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reporterId': reporterId,
          'reportedId': reportedId,
          'reason': selectedReasons.join(', '),
          'description': reportText,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully.')),
        );
        Navigator.pop(context); // go back
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  Widget _buildCircleButton(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _circleFilled[index] = !_circleFilled[index];
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _circleFilled[index] ? Colors.black : Colors.transparent,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _labels[index],
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report / Block')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Block button
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User has been blocked.')),
                );
              },
              label: const Text('Block'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.block),
            ),
            const SizedBox(height: 20),

            // Report button (navigates to same page for demo)
            ElevatedButton.icon(
              onPressed: () {},
              label: const Text('Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.report),
            ),
            const SizedBox(height: 20),

            // Report description box
            TextField(
              controller: _reportController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Describe if other...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent , width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4 labeled circle buttons
            Column(
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildCircleButton(index),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Submit report
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('Submit Report', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
