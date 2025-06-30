import 'package:flutter/material.dart';
import 'metadata_rule.dart';

class MetadataRuleDetailsPage extends StatefulWidget {
  final MetadataRule rule;

  const MetadataRuleDetailsPage({super.key, required this.rule});

  @override
  State<MetadataRuleDetailsPage> createState() => _MetadataRuleDetailsPageState();
}

class _MetadataRuleDetailsPageState extends State<MetadataRuleDetailsPage> {
  final TextEditingController _controller = TextEditingController();
  String? _validationResult;

  void _validateInput() {
    final rawInput = _controller.text.trim();
    final result = widget.rule.validate(_parseInput(rawInput));
    setState(() {
      _validationResult = result ? "✅ Valid" : "❌ Invalid";
    });
  }

  dynamic _parseInput(String input) {
    if (widget.rule.fieldName.toLowerCase().contains("date")) {
      try {
        return DateTime.parse(input);
      } catch (_) {
        return input;
      }
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rule.fieldName),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.rule.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter value to validate',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _validateInput(),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _validateInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
              ),
              child: const Text("Validate"),
            ),

            if (_validationResult != null) ...[
              const SizedBox(height: 16),
              Text(
                _validationResult!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _validationResult!.contains("Valid")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
