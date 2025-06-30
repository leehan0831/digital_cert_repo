import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyCertificateScreen extends StatefulWidget {
  const VerifyCertificateScreen({super.key});

  @override
  _VerifyCertificateScreenState createState() => _VerifyCertificateScreenState();
}

class _VerifyCertificateScreenState extends State<VerifyCertificateScreen> {
  final TextEditingController _certificateIdController = TextEditingController();
  String? _resultMessage;
  bool _isLoading = false;

  Future<void> _verifyCertificate() async {
    final certificateId = _certificateIdController.text.trim();

    if (certificateId.isEmpty) {
      setState(() {
        _resultMessage = 'Please enter a certificate ID.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = null;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('certificates')
          .doc(certificateId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final isRevoked = data['revoked'] == true;
        final expiry = DateTime.tryParse(data['expiryDate'] ?? '') ?? DateTime.now();
        final isExpired = expiry.isBefore(DateTime.now());

        if (isRevoked) {
          _resultMessage = 'Certificate is revoked.';
        } else if (isExpired) {
          _resultMessage = 'Certificate is expired.';
        } else {
          _resultMessage = 'Certificate is valid and authentic.';
        }
      } else {
        _resultMessage = 'Certificate not found.';
      }
    } catch (e) {
      _resultMessage = 'Error verifying certificate: $e';
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _certificateIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Certificate'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Certificate ID to Verify",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _certificateIdController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Certificate ID / Hash',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.verified),
                  label: Text('Verify'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1E3A8A),
                  ),
                  onPressed: _isLoading ? null : _verifyCertificate,
                ),
                SizedBox(height: 30),
                if (_isLoading)
                  Center(child: CircularProgressIndicator(color: Colors.white))
                else if (_resultMessage != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _resultMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
