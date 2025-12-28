import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'landing_screen.dart';
import 'home_screen.dart';
import 'onboarding/onboarding_dob_screen.dart';
import '../storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Timer(const Duration(seconds: 3), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    // 1. Cek Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    // 2. Cek Token & Status Onboarding dari Storage
    final token = await StorageService.getToken();
    final isDone = await StorageService.isOnboardingDone();

    if (user != null && token != null) {
      if (isDone) {
        _pushTo(const HomeScreen());
      } else {
        _pushTo(const OnboardingDobScreen());
      }
    } else {
      // Jika belum login sama sekali, lempar ke Landing
      _pushTo(const LandingScreen());
    }
  }

  void _pushTo(Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                width: 120,
                errorBuilder: (context, e, s) =>
                    const Icon(Icons.music_note, size: 80, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
