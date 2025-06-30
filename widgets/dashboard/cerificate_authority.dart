import 'package:digital_cert/widgets/certificate_authority/certificate_generation.dart';
import 'package:digital_cert/widgets/certificate_authority/certify_copy.dart';
import 'package:digital_cert/widgets/certificate_authority/request_certificate.dart';
import 'package:digital_cert/widgets/certificate_authority/secure_link_generator.dart';
import 'package:flutter/material.dart';
import 'package:digital_cert/widgets/login_screen.dart';

class CertificateAuthorityScreen extends StatelessWidget {
  const CertificateAuthorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Certificate Authority"),
        backgroundColor: Color(0xFF1E3A8A),
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
            icon: Icon(Icons.logout),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Logged out')));
            },
          ),
        ],
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
                  "Welcome, CA Officer!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Use the tools below to manage and issue certificates.",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildCard(
                        context,
                        icon: Icons.person_outline,
                        label: "Manage Client Profile",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RequestCertificateScreen(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.assignment_turned_in,
                        label: "Generate & Issue Certificates",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CertificateGenerationScreen(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.verified_user,
                        label: "Certify True Copies",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => CertifyCopyWidget()
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.share_outlined,
                        label: "Share Certificate Links",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => SecureLinkWidget(
                                    baseUrl:
                                        "https://app.digit.ink/en/view-credential/06a60dfc-9ba9-42bc-85ee-f7effc9f58c6?di_ref=shareurl",
                                  ),
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
    return Material(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: Colors.blueAccent.withOpacity(0.3),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Color(0xFF1E3A8A)),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
