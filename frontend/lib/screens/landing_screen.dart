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
          Container(color: Colors.black.withOpacity(0.28)),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                children: [
                  SizedBox(height: h * 0.12),

                  // Title
                  Text(
                    'Questify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  // Google button
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.065,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/icons/google.png',
                        height: h * 0.028,
                      ),
                      label: const Text('Continue with Google'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  // Phone & Email buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _smallButton(Icons.phone, 'Phone', h),
                      SizedBox(width: w * 0.08),
                      _smallButton(Icons.email, 'Email', h),
                    ],
                  ),

                  SizedBox(height: h * 0.03),

                  // Terms text
                  Text(
                    'I agree to the Terms of Service\nQuestify User Terms and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: h * 0.014,
                    ),
                  ),

                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(IconData icon, String label, double h) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(h * 0.015),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black, size: h * 0.028),
        ),
        SizedBox(height: h * 0.008),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
