import 'package:flutter/material.dart';

// ===== FilePickerService (dummy implementation) =====
class FilePickerService {
  Future<String?> pickPdfFile() async {
    await Future.delayed(Duration(seconds: 1));
    return 'example_certificate.pdf';
  }

  Future<String?> pickImageFile() async {
    await Future.delayed(Duration(seconds: 1));
    return 'certificate_image.jpg';
  }

  Future<String?> pickAnyFile() async {
    await Future.delayed(Duration(seconds: 1));
    return 'document_file.docx';
  }

  Future<bool> uploadToCloud(String fileName) async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}

// ===== UploadScreen UI =====
class UploadScreen extends StatelessWidget {
  final FilePickerService filePicker = FilePickerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Certificate"),
        backgroundColor: Color(0xFF1E3A8A),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out')),
              );
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
                  "Upload Certificate Files",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                        icon: Icons.upload_file,
                        label: "Upload PDF",
                        onTap: () async {
                          final file = await filePicker.pickPdfFile();
                          if (file != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('PDF Uploaded: $file')),
                            );
                          }
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.image,
                        label: "Upload Image",
                        onTap: () async {
                          final file = await filePicker.pickImageFile();
                          if (file != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Image Uploaded: $file')),
                            );
                          }
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.description,
                        label: "Upload Document",
                        onTap: () async {
                          final file = await filePicker.pickAnyFile();
                          if (file != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Document Uploaded: $file')),
                            );
                          }
                        },
                      ),
                      _buildCard(
                        context,
                        icon: Icons.cloud_upload,
                        label: "Upload to Cloud",
                        onTap: () async {
                          final uploaded = await filePicker.uploadToCloud("sample_file.txt");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                uploaded ? 'File uploaded to cloud!' : 'Upload failed.',
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
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
    );
  }
}
