import 'package:flutter/material.dart';

class SampleCertificate {
  final String title;
  final String issuer;
  final String fileName;

  SampleCertificate({
    required this.title,
    required this.issuer,
    required this.fileName,
  });
}

class ReceivedCertificateWidget extends StatelessWidget {
  final List<SampleCertificate> certificates;

  const ReceivedCertificateWidget({
    super.key,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Let parent scroll if needed
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.description, color: Color(0xFF1E3A8A)),
            title: Text(cert.title),
            subtitle: Text('Issued by: ${cert.issuer}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(cert.title),
                  content: Text("Simulating open for file: ${cert.fileName}"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
