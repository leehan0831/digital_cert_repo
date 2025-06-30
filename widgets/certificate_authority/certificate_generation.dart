import 'package:flutter/material.dart';
import 'package:digital_cert/widgets/certificate_authority/certificate_display.dart';

class CertificateGenerationScreen extends StatefulWidget {
  const CertificateGenerationScreen({super.key});

  @override
  State<CertificateGenerationScreen> createState() =>
      _CertificateGenerationScreenState();
}

class _CertificateGenerationScreenState
    extends State<CertificateGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split("T").first;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ViewGeneratedCertificateScreen(
            recipient: _recipientController.text.trim(),
            organization: _organizationController.text.trim(),
            purpose: _purposeController.text.trim(),
            issueDate: _issueDateController.text.trim(),
            expiryDate: _expiryDateController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Generate Certificate'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_recipientController, 'Recipient Name'),
              _buildTextField(_organizationController, 'Organization'),
              _buildTextField(_purposeController, 'Purpose'),
              _buildDateField(context, _issueDateController, 'Issue Date'),
              _buildDateField(context, _expiryDateController, 'Expiry Date'),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.verified),
                label: const Text("Generate Certificate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
        value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(context, controller),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
        value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
