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

      // Jika user baru -> ke DOB, Jika user lama -> ke Home
      Widget nextStep = isNewUser
          ? const OnboardingDobScreen()
          : const HomeScreen();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => nextStep),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Gagal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Questify',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Confirm your account to continue',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 60),
            if (loading)
              const CircularProgressIndicator(color: Colors.white)
            else
              ElevatedButton(
                onPressed: _handleGoogleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  minimumSize: const Size(250, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Confirm & Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
