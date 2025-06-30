import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:digital_cert/widgets/navigation.dart';
import 'package:digital_cert/widgets/registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signInWithGoogle() async {
    final enteredEmail = _emailController.text.trim();

    if (enteredEmail.isEmpty) {
      _showSnackBar('Please enter your email before continuing.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      await _googleSignIn.signOut(); // 🔁 Force account picker

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        _showSnackBar("Google Sign-In failed.");
        return;
      }

      if (user.email!.toLowerCase() != enteredEmail.toLowerCase()) {
        _showSnackBar("Entered email does not match Google account.");
        return;
      }

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName ?? '',
          'role': 'recipient',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await RoleNavigator.redirectUserBasedOnRole(context, user);
    } catch (e) {
      _showSnackBar('Google sign-in failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _continueWithEmailRoleRouting() async {
    final enteredEmail = _emailController.text.trim();

    if (enteredEmail.isEmpty) {
      _showSnackBar('Please enter your email.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: enteredEmail)
          .get();

      if (query.docs.isEmpty) {
        _showSnackBar('No user found with that email.');
        return;
      }

      final doc = query.docs.first;
      final role = doc['role'] ?? '';
      final mockUser = FirebaseAuth.instance.currentUser;

      if (mockUser == null) {
        _showSnackBar('User not authenticated. Please use Google Sign-In for full access.');
        return;
      }

      await RoleNavigator.redirectUserBasedOnRole(context, mockUser);
    } catch (e) {
      _showSnackBar('Error during role lookup: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildLogo(),
                    const SizedBox(height: 50),
                    _buildLoginCard(),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: const [
        Icon(Icons.security, size: 80, color: Colors.white),
        SizedBox(height: 20),
        Text("Digital Certificate", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        Text("Repository", style: TextStyle(fontSize: 20, color: Colors.white70)),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text("Sign in to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 32),

          _buildTextField(_emailController, "Enter your email", Icons.email_outlined),
          const SizedBox(height: 12),
          const Text("Use your email for verification. You'll sign in using Google or continue manually.",
              style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            icon: const Icon(Icons.login, color: Colors.white),
            label: const Text("Sign in with Google"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _signInWithGoogle,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.email_outlined, color: Color(0xFF1E3A8A)),
            label: const Text("Continue with Email", style: TextStyle(color: Color(0xFF1E3A8A))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
            ),
            onPressed: _continueWithEmailRoleRouting,
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?", style: TextStyle(fontSize: 14, color: Colors.grey)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipientRegistration())),
                child: const Text(" Register now",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
