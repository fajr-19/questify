import 'dart:async';
import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'home_screen.dart';
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

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _scale = Tween(begin: 0.985, end: 1.0).animate(_controller);

    _controller.forward();

    Timer(const Duration(milliseconds: 1400), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    if (widget.toHome) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    final token = await StorageService.getToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => token != null ? const HomeScreen() : const LandingScreen(),
      ),
    );
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
            child: Image.asset('assets/icons/logo.png', width: 130),
          ),
        ),
      ),
    );
  }
}
