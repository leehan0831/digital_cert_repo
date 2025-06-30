class Document {
  final String documentId;
  final String title;
  final String filePath;
  final DateTime addedAt;

  Document({
    required this.documentId,
    required this.title,
    required this.filePath,
    required this.addedAt,
  });
}

class DocumentRepository {
  final List<Document> _documents = [];

  void addDocument(Document doc) {
    _documents.add(doc);
  }

  List<Document> getAllDocuments() {
    return List.unmodifiable(_documents);
  }

  void removeDocument(String documentId) {
    _documents.removeWhere((doc) => doc.documentId == documentId);
  }
}

extension DocumentJson on Document {
  Map<String, dynamic> toJson() => {
    'documentId': documentId,
    'title': title,
    'filePath': filePath,
    'addedAt': addedAt.toIso8601String(),
  };

  static Document fromJson(Map<String, dynamic> json) => Document(
    documentId: json['documentId'],
    title: json['title'],
    filePath: json['filePath'],
    addedAt: DateTime.parse(json['addedAt']),
  );
}
