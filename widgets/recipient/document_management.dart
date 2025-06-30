import 'package:flutter/material.dart';
import 'document_repository.dart';

class DocumentRepositoryScreen extends StatelessWidget {
  final DocumentRepository repository = DocumentRepository();

  DocumentRepositoryScreen({super.key}); // Or use singleton

  @override
  Widget build(BuildContext context) {
    final documents = repository.getAllDocuments();

    return Scaffold(
      appBar: AppBar(
        title: Text("Document Repository"),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return ListTile(
            title: Text(doc.title),
            subtitle: Text("Added on: ${doc.addedAt.toLocal()}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                repository.removeDocument(doc.documentId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted ${doc.title}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
