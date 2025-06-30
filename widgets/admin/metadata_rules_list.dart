import 'package:flutter/material.dart';
import 'metadata_rules_config.dart';
import 'metadata_rule.dart';

class MetadataRulesListPage extends StatelessWidget {
  const MetadataRulesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rules = MetadataRulesConfig.rules;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Metadata Rules"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        itemCount: rules.length,
        itemBuilder: (context, index) {
          final rule = rules[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(rule.fieldName),
              subtitle: Text(rule.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MetadataRuleDetailsPage(rule: rule),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
