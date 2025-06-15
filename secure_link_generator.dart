import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class SecureLinkGenerator {
  final String baseUrl;

  SecureLinkGenerator({required this.baseUrl});

  /// Generates a secure link using certificate ID, with optional expiry time.
  String generateLink(String certificateId, {DateTime? expiresAt}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSalt = _generateRandomString(12);

    // Combine ID + timestamp + randomSalt
    final data = '$certificateId-$timestamp-$randomSalt';

    final token = sha256.convert(utf8.encode(data)).toString();

    final expiryParam = expiresAt != null
        ? '&exp=${expiresAt.millisecondsSinceEpoch}'
        : '';

    return '$baseUrl/view?cert=$certificateId&token=$token$expiryParam';
  }

  String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
