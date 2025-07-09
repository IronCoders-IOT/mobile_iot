/// A splash screen widget that checks authentication and navigates accordingly.
///
/// This file defines the [SplashScreen] widget, which displays a loading indicator
/// while checking for an authentication token and redirects the user to the
/// appropriate screen (dashboard or login).
import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';

/// Splash screen that checks authentication status and redirects the user.
///
/// Shows a loading indicator while verifying the presence of a token, then navigates
/// to the dashboard if authenticated or to the login screen otherwise.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    if (!mounted) return;
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
} 