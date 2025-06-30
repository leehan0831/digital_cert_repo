import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ReviewStatus { approved, rejected }

class CertificateReview {
  final String requestId;
  final String reviewerName;
  final DateTime reviewedAt;
  final ReviewStatus status;
  final String? comment;

  CertificateReview({
    required this.requestId,
    required this.reviewerName,
    required this.reviewedAt,
    required this.status,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'reviewerName': reviewerName,
      'reviewedAt': reviewedAt.toIso8601String(),
      'status': status.name,
      'comment': comment,
    };
  }

  factory CertificateReview.fromJson(Map<String, dynamic> json) {
    return CertificateReview(
      requestId: json['requestId'],
      reviewerName: json['reviewerName'],
      reviewedAt: DateTime.parse(json['reviewedAt']),
      status: ReviewStatus.values.firstWhere((e) => e.name == json['status']),
      comment: json['comment'],
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}

class CertificateReviewManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> approve({
    required String requestId,
    required String reviewerName,
    String? comment,
  }) async {
    final review = CertificateReview(
      requestId: requestId,
      reviewerName: reviewerName,
      reviewedAt: DateTime.now(),
      status: ReviewStatus.approved,
      comment: comment,
    );

    await _firestore
        .collection('certificateReviews')
        .doc(requestId)
        .set(review.toJson());
  }

  Future<void> reject({
    required String requestId,
    required String reviewerName,
    required String comment,
  }) async {
    final review = CertificateReview(
      requestId: requestId,
      reviewerName: reviewerName,
      reviewedAt: DateTime.now(),
      status: ReviewStatus.rejected,
      comment: comment,
    );

    await _firestore
        .collection('certificateReviews')
        .doc(requestId)
        .set(review.toJson());
  }
}
