import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestCertificateScreen extends StatefulWidget {
  const RequestCertificateScreen({super.key});

  @override
  _RequestCertificateScreenState createState() => _RequestCertificateScreenState();
}

class _RequestCertificateScreenState extends State<RequestCertificateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  bool _isSubmitting = false;

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    final requestData = {
      'name': _nameController.text,
      'organization': _organizationController.text,
      'purpose': _purposeController.text,
      'status': 'pending',
      'requestedBy': user?.uid,
      'requestedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('certificate_requests').add(requestData);

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Certificate request submitted')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request Certificate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmitting
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Your Name'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Please enter your name' : null,
                    ),
                    TextFormField(
                      controller: _organizationController,
                      decoration: InputDecoration(labelText: 'Organization'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter organization' : null,
                    ),
                    TextFormField(
                      controller: _purposeController,
                      decoration: InputDecoration(labelText: 'Purpose of Certificate'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter purpose' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitRequest,
                      child: Text('Submit Request'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
