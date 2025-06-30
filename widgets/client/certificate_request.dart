import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateRequest {
  final String requestId;
  final String requesterId;
  final String requesterName;
  final String reason;
  final DateTime requestedAt;

  CertificateRequest({
    required this.requestId,
    required this.requesterId,
    required this.requesterName,
    required this.reason,
    required this.requestedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'reason': reason,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  static CertificateRequest fromJson(Map<String, dynamic> json) {
    return CertificateRequest(
      requestId: json['requestId'],
      requesterId: json['requesterId'],
      requesterName: json['requesterName'],
      reason: json['reason'],
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }
}

class CertificateRequestGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateRequestId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomCode = _generateRandomString(6);
    return 'REQ-$timestamp-$randomCode';
  }

  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> sendRequest({
    required String requesterId,
    required String requesterName,
    required String certificateType,
    required String reason,
  }) async {
    final requestId = _generateRequestId();
    final now = DateTime.now();

    final request = CertificateRequest(
      requestId: requestId,
      requesterId: requesterId,
      requesterName: requesterName,
      reason: reason,
      requestedAt: now,
    );

    await _firestore
        .collection('certificateRequests')
        .doc(requestId)
        .set(request.toJson());
  }
}
