import 'package:flutter/material.dart';

class OTPAccessScreen extends StatefulWidget {
  final String expectedToken; 
  final DateTime expiresAt;  
  final void Function() onVerified; 

  OTPAccessScreen({
    Key? key,
    required this.expectedToken,
    required this.expiresAt,
    required this.onVerified,
  }) : super(key: key);

  @override
  _OTPAccessScreenState createState() => _OTPAccessScreenState();
}

class _OTPAccessScreenState extends State<OTPAccessScreen> {
  final TextEditingController _tokenController = TextEditingController();
  String? _errorMessage;
  bool _isVerified = false;
  bool _isLoading = false; 

  void _verifyToken() {
    final input = _tokenController.text.trim();

    if (DateTime.now().isAfter(widget.expiresAt)) {
      setState(() {
        _errorMessage = "This token has expired.";
        _isVerified = false;
        _isLoading = false; 
      });
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (input == widget.expectedToken) {
          _isVerified = true;
          _errorMessage = null;
          widget.onVerified(); 
        } else {
          _errorMessage = "Invalid token. Please try again.";
          _isVerified = false;
        }
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isVerified) {
      return Scaffold(
        appBar: AppBar(title: Text("Certificate Viewer")),
        body: Center(
          child: Text(
            "🎉 Access Granted!\nHere’s your certificate.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Secure Certificate Access")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Enter your access token to view the certificate.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: "Access Token",
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyToken, 
              child: _isLoading 
                  ? CircularProgressIndicator()
                  : Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}