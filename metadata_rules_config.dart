class MetadataRule {
  final String fieldName;
  final String description;
  final bool Function(dynamic value) validate;

  MetadataRule({
    required this.fieldName,
    required this.description,
    required this.validate,
  });
}

class MetadataRulesConfig {
  static final List<MetadataRule> rules = [
    MetadataRule(
      fieldName: 'issuer',
      description: 'Issuer must not be empty',
      validate: (value) => value != null && value.toString().trim().isNotEmpty,
    ),
    MetadataRule(
      fieldName: 'expiryDate',
      description: 'Expiry date must be in the future',
      validate: (value) {
        if (value is DateTime) {
          return value.isAfter(DateTime.now());
        }
        return false;
      },
    ),
    MetadataRule(
      fieldName: 'certificateType',
      description: 'Certificate type must be either "X.509" or "Self-signed"',
      validate: (value) => ['X.509', 'Self-signed'].contains(value),
    ),
    MetadataRule(
      fieldName: 'signatureHash',
      description: 'Signature hash must be at least 64 characters',
      validate: (value) =>
          value != null && value.toString().length >= 64,
    ),
    MetadataRule(
      fieldName: 'country',
      description: 'Country code must be 2 uppercase letters (ISO 3166)',
      validate: (value) =>
          value != null &&
          RegExp(r'^[A-Z]{2}$').hasMatch(value.toString()),
    ),
  ];

  // Utility: Run validation against a metadata map
  static List<String> validateMetadata(Map<String, dynamic> metadata) {
    List<String> errors = [];

    for (final rule in rules) {
      final value = metadata[rule.fieldName];
      final isValid = rule.validate(value);
      if (!isValid) {
        errors.add('${rule.fieldName}: ${rule.description}');
      }
    }

    return errors;
  }
}
