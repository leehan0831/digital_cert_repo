import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

class SecureLinkWidget extends StatefulWidget {
  final String baseUrl;

  const SecureLinkWidget({super.key, required this.baseUrl});

  @override
  State<SecureLinkWidget> createState() => _SecureLinkWidgetState();
}

class _SecureLinkWidgetState extends State<SecureLinkWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _certIdController = TextEditingController();
  DateTime? _expiryDate;
  String? _generatedLink;

  void _generateLink() {
    if (_formKey.currentState!.validate()) {
      final certId = _certIdController.text.trim();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final salt = _generateRandomString(12);
      final data = '$certId-$timestamp-$salt';
      final token = sha256.convert(utf8.encode(data)).toString();
      final expParam = _expiryDate != null ? '&exp=${_expiryDate!.millisecondsSinceEpoch}' : '';

      final link = '${widget.baseUrl}/view?cert=$certId&token=$token&ts=$timestamp&salt=$salt$expParam';

      setState(() {
        _generatedLink = link;
      });
    }
  }

  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  void _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Secure Link'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _certIdController,
                decoration: const InputDecoration(
                  labelText: 'Certificate ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter certificate ID' : null,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _expiryDate == null
                        ? 'No Expiry Date Selected'
                        : 'Expiry: ${_expiryDate!.toLocal().toIso8601String().split('T').first}',
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickExpiryDate,
                  icon: const Icon(Icons.date_range),
                  label: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text('Generate Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
              ),
              onPressed: _generateLink,
            ),
            const SizedBox(height: 20),
            if (_generatedLink != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Secure Link:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(_generatedLink!),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedLink!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
