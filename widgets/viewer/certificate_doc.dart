import 'package:flutter/material.dart';

class CertificateFoldersList extends StatelessWidget {
  const CertificateFoldersList({super.key});

  final List<Map<String, String>> sampleFolders = const [
    {'id': 'folder1', 'name': 'Academic Certificates'},
    {'id': 'folder2', 'name': 'Training Programs'},
    {'id': 'folder3', 'name': 'Professional Licenses'},
    {'id': 'folder4', 'name': 'Event Participation'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Folders'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        itemCount: sampleFolders.length,
        itemBuilder: (context, index) {
          final folder = sampleFolders[index];
          return ListTile(
            leading: Icon(Icons.folder, color: Colors.blue[800]),
            title: Text(folder['name']!),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FolderDetailScreen(
                    folderId: folder['id']!,
                    folderName: folder['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FolderDetailScreen extends StatelessWidget {
  final String folderId;
  final String folderName;

  const FolderDetailScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Center(
        child: Text(
          'Contents of "$folderName"',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
