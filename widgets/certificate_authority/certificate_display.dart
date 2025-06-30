import 'package:flutter/material.dart';

class ViewGeneratedCertificateScreen extends StatelessWidget {
  final String recipient;
  final String organization;
  final String purpose;
  final String issueDate;
  final String expiryDate;

  const ViewGeneratedCertificateScreen({
    super.key,
    required this.recipient,
    required this.organization,
    required this.purpose,
    required this.issueDate,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Preview'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Certificate title
                Text(
                  'Certificate of Completion',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Main content
                Text('This is to certify that'),
                Text(
                  recipient,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Text('has successfully completed'),
                Text(
                  purpose,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text('Issued by: $organization'),
                Text('Issue Date: $issueDate'),
                Text('Expiry Date: $expiryDate'),

                // Spacer before digital signature
                SizedBox(height: 40),
                Divider(thickness: 1),

                // Digital signature section
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Dr. Sofia Lim',
                        style: TextStyle(
                          fontSize: 28,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Certification Officer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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
