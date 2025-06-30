class PhysicalCertificateUpload {
  final String userId;
  final String documentName;
  final String filePath;
  final DateTime uploadedAt;

  PhysicalCertificateUpload({
    required this.userId,
    required this.documentName,
    required this.filePath,
    required this.uploadedAt,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'documentName': documentName,
        'filePath': filePath,
        'uploadedAt': uploadedAt.toIso8601String(),
      };

  factory PhysicalCertificateUpload.fromJson(Map<String, dynamic> json) {
    return PhysicalCertificateUpload(
      userId: json['userId'],
      documentName: json['documentName'],
      filePath: json['filePath'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}

class UploadManager {
  PhysicalCertificateUpload createUpload({
    required String userId,
    required String documentName,
    required String filePath,
  }) {
    return PhysicalCertificateUpload(
      userId: userId,
      documentName: documentName,
      filePath: filePath,
      uploadedAt: DateTime.now(),
    );
  }
}
