import 'dart:async';
import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'home_screen.dart';
import 'onboarding/onboarding_dob_screen.dart'; // Import layar pertama onboarding
import '../storage_service.dart';

class SplashScreen extends StatefulWidget {
  final bool toHome;
  const SplashScreen({super.key, this.toHome = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Animasi (Fade dan Scale halus)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scale = Tween(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Timer sedikit lebih lama agar animasi terlihat jelas sebelum pindah
    Timer(const Duration(milliseconds: 2000), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    // 1. Jika diarahkan paksa ke Home (misalnya setelah login/onboarding sukses)
    if (widget.toHome) {
      _pushTo(const HomeScreen());
      return;
    }

    // 2. Ambil status dari Storage
    final token = await StorageService.getToken();
    final isDone = await StorageService.isOnboardingDone();

    // 3. Logika Navigasi:
    // - Jika tidak ada token -> Landing (Login)
    // - Jika ada token tapi belum onboarding -> OnboardingDobScreen
    // - Jika ada token dan sudah onboarding -> HomeScreen
    if (token == null) {
      _pushTo(const LandingScreen());
    } else {
      if (isDone) {
        _pushTo(const HomeScreen());
      } else {
        _pushTo(const OnboardingDobScreen());
      }
    }
  }

  // Fungsi pembantu agar kode lebih rapi
  void _pushTo(Widget page) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }
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
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'assets/icons/logo.png',
              width: 140,
              // Fallback jika asset belum terdaftar
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
