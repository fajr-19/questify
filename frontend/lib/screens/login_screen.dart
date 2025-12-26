import 'package:flutter/material.dart';
import '../api_service.dart';
import 'home_screen.dart';
import 'onboarding/onboarding_dob_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  Future<void> _handleGoogleLogin() async {
    setState(() => loading = true);
    final result = await ApiService.loginWithGoogle();

    if (!mounted) return;
    setState(() => loading = false);

    if (result != null) {
      bool isNewUser = result['isNewUser'] ?? false;
      if (isNewUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingDobScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login gagal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Questify',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: loading ? null : _handleGoogleLogin,
              icon: const Icon(Icons.login),
              label: Text(loading ? 'Loading...' : 'Continue with Google'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(250, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
