import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CAListScreen extends StatelessWidget {
  const CAListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificate Authorities"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('certificate_authorities')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No Certificate Authorities found."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final ca = docs[index];
              return ListTile(
                leading: const Icon(Icons.verified_user, color: Color(0xFF1E3A8A)),
                title: Text(ca['name'] ?? 'Unnamed CA'),
                subtitle: Text("${ca['organization']} • ${ca['email']}"),
              );
            },
          );
        },
      ),
    );
  }
}
