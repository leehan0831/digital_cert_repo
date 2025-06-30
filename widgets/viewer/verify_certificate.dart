import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class CertificateVerifier extends StatefulWidget {
  const CertificateVerifier({super.key});

  @override
  State<CertificateVerifier> createState() => _CertificateVerifierState();
}

class _CertificateVerifierState extends State<CertificateVerifier> {
  final TextEditingController _certificateIdController = TextEditingController();
  final TextEditingController _timestampController = TextEditingController();
  final TextEditingController _saltController = TextEditingController();
  final TextEditingController _receivedTokenController = TextEditingController();
  String _result = '';

  void _verify() {
    final certificateId = _certificateIdController.text.trim();
    final salt = _saltController.text.trim();
    final receivedToken = _receivedTokenController.text.trim();
    final timestamp = int.tryParse(_timestampController.text.trim()) ?? 0;

    final isValid = _VerifierLogic.verifyLink(
      certificateId: certificateId,
      timestamp: timestamp,
      salt: salt,
      receivedToken: receivedToken,
    );

    setState(() {
      _result = isValid ? '✅ Valid Link' : '❌ Invalid or Expired Link';
    });
  }

  void _generateToken() {
    final certificateId = _certificateIdController.text.trim();
    final salt = _saltController.text.trim();
    final timestamp = int.tryParse(_timestampController.text.trim()) ?? 0;

    final token = _VerifierLogic.computeToken(certificateId, timestamp, salt);

    setState(() {
      _receivedTokenController.text = token;
      _result = '🔐 Generated Token:\n$token';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Verifier'),
        backgroundColor: const Color(0xFF1E3A8A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 60, color: Color(0xFF1E3A8A)),
                    const SizedBox(height: 12),
                    const Text(
                      'Certificate Verifier',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(_certificateIdController, 'Certificate ID'),
                    _buildTextField(_timestampController, 'Timestamp (ms since epoch)', inputType: TextInputType.number),
                    _buildTextField(_saltController, 'Salt'),
                    _buildTextField(_receivedTokenController, 'Received Token'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.lock_open_rounded),
                            onPressed: _verify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            label: const Text("Verify"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.build_circle_outlined),
                          onPressed: _generateToken,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          label: const Text("Generate"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _certificateIdController.dispose();
    _timestampController.dispose();
    _saltController.dispose();
    _receivedTokenController.dispose();
    super.dispose();
  }
}

class _VerifierLogic {
  static String computeToken(String certificateId, int timestamp, String salt) {
    final data = '$certificateId-$timestamp-$salt';
    return sha256.convert(utf8.encode(data)).toString();
  }

  static bool verifyLink({
    required String certificateId,
    required int timestamp,
    required String salt,
    required String receivedToken,
    int? expiresAt,
  }) {
    final expectedToken = computeToken(certificateId, timestamp, salt);
    final now = DateTime.now().millisecondsSinceEpoch;
    final notExpired = expiresAt == null || now <= expiresAt;
    return expectedToken == receivedToken && notExpired;
  }
}
