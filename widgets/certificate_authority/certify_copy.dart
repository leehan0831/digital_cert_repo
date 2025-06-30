import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class CertifyCopyWidget extends StatefulWidget {
  const CertifyCopyWidget({super.key});

  @override
  State<CertifyCopyWidget> createState() => _CertifyCopyWidgetState();
}

class _CertifyCopyWidgetState extends State<CertifyCopyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _certificateIdController = TextEditingController();
  final _certifiedByController = TextEditingController();
  final _reasonController = TextEditingController();

  String? _resultMessage;

  Future<void> _handleCertify() async {
    if (_formKey.currentState!.validate()) {
      final certificateId = _certificateIdController.text.trim();
      final certifiedBy = _certifiedByController.text.trim();
      final reason = _reasonController.text.trim();
      final certifiedAt = DateTime.now();

      final signature = _generateSignature(
        certificateId,
        certifiedBy,
        reason,
        certifiedAt,
      );

      final data = {
        'certificateId': certificateId,
        'certifiedBy': certifiedBy,
        'reason': reason,
        'certifiedAt': certifiedAt.toIso8601String(),
        'digitalSignature': signature,
      };

      try {
        await FirebaseFirestore.instance
            .collection('certified_copies')
            .doc(certificateId)
            .set(data);

        setState(() {
          _resultMessage = 'Certified copy saved ✅\nSignature: $signature';
        });
      } catch (e) {
        setState(() {
          _resultMessage = 'Error saving to Firestore ❌';
        });
      }
    }
  }

  String _generateSignature(String certificateId, String certifiedBy, String reason, DateTime date) {
    final raw = '$certificateId|$certifiedBy|$reason|${date.toIso8601String()}';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  @override
  void dispose() {
    _certificateIdController.dispose();
    _certifiedByController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certify True Copy'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(_certificateIdController, 'Certificate ID'),
                    const SizedBox(height: 12),
                    _buildInputField(_certifiedByController, 'Certified By'),
                    const SizedBox(height: 12),
                    _buildInputField(_reasonController, 'Reason for Certification'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.verified),
                      label: const Text('Generate Certified Copy'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onPressed: _handleCertify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_resultMessage != null)
                Text(
                  _resultMessage!,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E3A8A)),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }
}
