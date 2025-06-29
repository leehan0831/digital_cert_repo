import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:printing/printing.dart';
import '../utils/certificate_pdf_generator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CertificateGenerationScreen extends StatefulWidget {
  @override
  _CertificateGenerationScreenState createState() =>
      _CertificateGenerationScreenState();
}

class _CertificateGenerationScreenState
    extends State<CertificateGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _organizationController = TextEditingController();
  final _purposeController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_auth.currentUser == null) await _signInWithGoogle();

      final certData = {
        'recipient': _recipientController.text,
        'organization': _organizationController.text,
        'purpose': _purposeController.text,
        'issue_date': _issueDateController.text,
        'expiry_date': _expiryDateController.text,
        'issued_by': _auth.currentUser?.email,
        'timestamp': Timestamp.now(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection('certificates')
          .add(certData);

      final pdfBytes = await generateCertificatePDF(
        recipient: _recipientController.text,
        organization: _organizationController.text,
        purpose: _purposeController.text,
        issueDate: _issueDateController.text,
        expiryDate: _expiryDateController.text,
      );

      final storageRef = FirebaseStorage.instance.ref().child(
        'certificates/${docRef.id}.pdf',
      );
      await storageRef.putData(pdfBytes);

      await Printing.sharePdf(bytes: pdfBytes, filename: 'certificate.pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Certificate Created, Uploaded & Shared")),
      );

      _formKey.currentState!.reset();
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
                    (value) => value!.isEmpty ? 'Enter recipient name' : null,
              ),
              TextFormField(
                controller: _organizationController,
                decoration: InputDecoration(labelText: 'Organization'),
                validator:
                    (value) => value!.isEmpty ? 'Enter organization' : null,
              ),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(labelText: 'Purpose'),
                validator: (value) => value!.isEmpty ? 'Enter purpose' : null,
              ),
              TextFormField(
                controller: _issueDateController,
                decoration: InputDecoration(
                  labelText: 'Date Issued (YYYY-MM-DD)',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter issue date' : null,
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date (YYYY-MM-DD)',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter expiry date' : null,
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
