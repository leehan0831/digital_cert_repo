import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FilePickerWidget> {
  String? _uploadMessage;

  Future<void> _pickAndUpload(List<String> extensions, String label) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/${DateTime.now().millisecondsSinceEpoch}_${file.name}');

      try {
        final uploadTask = await storageRef.putData(file.bytes!);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        setState(() {
          _uploadMessage = '$label uploaded successfully!\nURL: $downloadUrl';
        });
      } catch (e) {
        setState(() {
          _uploadMessage = 'Failed to upload $label ❌';
        });
      }
    } else {
      setState(() {
        _uploadMessage = 'No file selected.';
      });
    }
  }

  Widget _buildUploadButton(String label, List<String> extensions) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => _pickAndUpload(extensions, label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildUploadButton('Upload PDF', ['pdf']),
            _buildUploadButton('Upload Image', ['jpg', 'jpeg', 'png']),
            _buildUploadButton('Upload Document', ['doc', 'docx', 'txt']),
            _buildUploadButton('Upload Any File', ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'txt']),
          ],
        ),
        const SizedBox(height: 20),
        if (_uploadMessage != null)
          Text(
            _uploadMessage!,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
      ],
    );
  }
}
