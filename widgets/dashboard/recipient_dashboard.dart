import 'package:digital_cert/widgets/admin/upload_screen.dart';
import 'package:digital_cert/widgets/recipient/verification_screen.dart';
import 'package:digital_cert/widgets/recipient/document_management.dart';
import 'package:digital_cert/widgets/recipient/view_received_certificates.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_cert/widgets/login_screen.dart';

final sampleCerts = [
  SampleCertificate(
    title: "Flutter Developer Certificate",
    issuer: "Tech University",
    fileName: "flutter_cert.pdf",
  ),
  SampleCertificate(
    title: "UI/UX Completion",
    issuer: "Design Institute",
    fileName: "uiux_cert.pdf",
  ),
  SampleCertificate(
    title: "Cybersecurity Training",
    issuer: "CyberSafe Org",
    fileName: "cyber_cert.pdf",
  ),
];

class RecipientDashboard extends StatelessWidget {
  const RecipientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipient Dashboard"),
        backgroundColor: const Color(0xFF1E3A8A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
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
                const Text(
                  "Welcome, Recipient!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildCard(
                        context,
                        icon: Icons.inbox_outlined,
                        label: "View Received Certificates",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReceivedCertificateWidget(certificates: sampleCerts),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.upload_file_outlined,
                        label: "Upload Physical Certificate",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UploadScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.verified_outlined,
                        label: "Verify Authenticity",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerificationScreen(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.folder_copy_outlined,
                        label: "Manage Repository",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => DocumentRepositoryScreen()
                            ),
                          );
                        },
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

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF1E3A8A)),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
