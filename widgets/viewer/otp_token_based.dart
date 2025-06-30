import 'package:flutter/material.dart';

class OTPAccessScreen extends StatefulWidget {
  final String expectedToken;
  final DateTime expiresAt;
  final void Function() onVerified;

  const OTPAccessScreen({
    super.key,
    required this.expectedToken,
    required this.expiresAt,
    required this.onVerified,
  });

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
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isVerified
                ? [Colors.green.shade400, Colors.green.shade200]
                : [Color(0xFF1E3A8A), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: _isVerified ? _buildSuccessCard() : _buildInputForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.lock_open_outlined, size: 80, color: Colors.white),
        SizedBox(height: 20),
        Text(
          "Secure Certificate Access",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Enter your access token to view the certificate.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: TextField(
            controller: _tokenController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _verifyToken(),
            decoration: InputDecoration(
              hintText: "Enter Access Token",
              prefixIcon: Icon(Icons.vpn_key),
              errorText: _errorMessage,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyToken,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1E3A8A),
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text("Verify", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildSuccessCard() {
    return Column(
      children: [
        Icon(Icons.verified_user, size: 80, color: Colors.white),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 50, color: Colors.green),
              SizedBox(height: 12),
              Text(
                "Access Granted!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Your certificate is now visible.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }
}
