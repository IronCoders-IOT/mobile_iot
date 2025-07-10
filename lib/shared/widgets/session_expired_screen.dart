import 'package:flutter/material.dart';

/// A full-screen widget to display when the user's session has expired.
/// Shows a message and a button to log in again.
class SessionExpiredScreen extends StatelessWidget {
  final VoidCallback onLoginAgain;

  const SessionExpiredScreen({
    Key? key,
    required this.onLoginAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.redAccent),
              const SizedBox(height: 24),
              Text(
                'Session expired',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please log in again to continue.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black54,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onLoginAgain,
                  child: const Text('Log in again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 