typedef Validator = bool Function(dynamic value);

class MetadataRule {
  final String fieldName;
  final String description;
  final Validator validate;
  final String? example; // Optional example for documentation/tooling

  const MetadataRule({
    required this.fieldName,
    required this.description,
    required this.validate,
    this.example,
  });
}

class MetadataRulesConfig {
  static final List<MetadataRule> rules = [
    MetadataRule(
      fieldName: 'issuer',
      description: 'Issuer must not be empty.',
      example: 'Example CA Authority',
      validate: (value) => value != null && value.toString().trim().isNotEmpty,
    ),
    MetadataRule(
      fieldName: 'expiryDate',
      description: 'Expiry date must be in the future.',
      example: 'DateTime object like DateTime(2025, 12, 31)',
      validate: (value) => value is DateTime && value.isAfter(DateTime.now()),
    ),
    MetadataRule(
      fieldName: 'certificateType',
      description: 'Certificate type must be either "X.509" or "Self-signed".',
      example: '"X.509"',
      validate:
          (value) => value != null && ['X.509', 'Self-signed'].contains(value),
    ),
    MetadataRule(
      fieldName: 'signatureHash',
      description: 'Signature hash must be at least 64 characters.',
      example: '"a3f5... (64+ characters)"',
      validate:
          (value) => value != null && value.toString().trim().length >= 64,
    ),
    MetadataRule(
      fieldName: 'country',
      description: 'Country code must be 2 uppercase letters (ISO 3166).',
      example: '"MY", "US", "GB"',
      validate:
          (value) =>
              value != null &&
              RegExp(r'^[A-Z]{2}$').hasMatch(value.toString().trim()),
    ),
  ];

  /// Validate metadata and return a list of error messages
  static List<String> validateMetadata(Map<String, dynamic> metadata) {
    final List<String> errors = [];

    for (final rule in rules) {
      final value = metadata[rule.fieldName];
      final isValid = rule.validate(value);
      if (!isValid) {
        errors.add(
          '${rule.fieldName}: ${rule.description} (received: "$value")',
        );
      }
    }

    return errors;
  }

  /// Utility: Get rule by field name
  static MetadataRule? getRuleByField(String fieldName) {
    return rules.firstWhere(
      (rule) => rule.fieldName == fieldName,
      orElse: () => null,
    );
  }
}
