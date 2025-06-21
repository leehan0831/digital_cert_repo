import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CertificateGenerationScreen()));
}

class CertificateGenerationScreen extends StatefulWidget {
  @override
  _CertificateGenerationScreenState createState() =>
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Submit certificate data to backend
      print("Certificate generated for: ${_recipientController.text}");
      // Navigate or show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Certificate Generated Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Certificate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: InputDecoration(labelText: 'Recipient Name'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter recipient name' : null,
              ),
              TextFormField(
                controller: _organizationController,
                decoration: InputDecoration(labelText: 'Organization'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter organization' : null,
              ),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(labelText: 'Purpose'),
                validator:
                    (value) => value!.isEmpty ? 'Please enter purpose' : null,
              ),
              TextFormField(
                controller: _issueDateController,
                decoration: InputDecoration(
                  labelText: 'Date Issued (YYYY-MM-DD)',
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter issue date' : null,
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date (YYYY-MM-DD)',
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter expiry date' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Generate Certificate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
