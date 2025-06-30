import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Dashboard imports
import 'package:digital_cert/widgets/dashboard/admin_dashboard.dart';
import 'package:digital_cert/widgets/dashboard/cerificate_authority.dart';
import 'package:digital_cert/widgets/dashboard/client_dashboard.dart';
import 'package:digital_cert/widgets/dashboard/recipient_dashboard.dart';
import 'package:digital_cert/widgets/dashboard/viewer_dashboard.dart';

import 'login_screen.dart';

class RoleNavigator {
  static Future<void> redirectUserBasedOnRole(BuildContext context, User user) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snapshot.exists || !snapshot.data().toString().contains('role')) {
        _showError(context, "No role found for this user. Please contact the administrator.");
        return;
      }

      final String role = snapshot.get('role').toString().toLowerCase();
      late Widget destination;

      switch (role) {
        case 'admin':
        case 'system administrator':
          destination = const AdminDashboardScreen();
          break;
        case 'certificate authority':
          destination = const CertificateAuthorityScreen();
          break;
        case 'client':
          destination = const ClientDashboard();
          break;
        case 'recipient':
          destination = const RecipientDashboard();
          break;
        case 'viewer':
          destination = const ViewerDashboard();
          break;
        default:
          _showError(context, "Unknown role: $role");
          return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    } catch (e) {
      _showError(context, "Error retrieving role: $e");
    }
  }

  static void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Access Denied"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
