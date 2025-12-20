import 'package:flutter/material.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/landing_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.45)),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.08),
              child: Column(
                children: [
                  SizedBox(height: h * 0.14),

                  // Logo
                  Image.asset('assets/icons/logo.png', width: w * 0.28),

                  const SizedBox(height: 18),

                  // App name
                  const Text(
                    'Questify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  const Text(
                    'Level up your productivity\none quest at a time',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const Spacer(),

                  // GOOGLE LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.065,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/icons/google.png',
                        height: h * 0.028,
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Terms
                  const Text(
                    'By continuing, you agree to our\nTerms of Service & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  SizedBox(height: h * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
