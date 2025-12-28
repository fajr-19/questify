import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import '../home_screen.dart';
import '../../utils/colors.dart';

class LoadingTransitionScreen extends StatefulWidget {
  const LoadingTransitionScreen({super.key});

  @override
  State<LoadingTransitionScreen> createState() =>
      _LoadingTransitionScreenState();
}

class _LoadingTransitionScreenState extends State<LoadingTransitionScreen> {
  String loadingText = "Pilihan yang bagus!";
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => opacity = 0.0);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        loadingText = "Mencari musik buat kamu...";
        opacity = 1.0;
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(
        context,
      ).pushAndRemoveUntil(createRoute(const HomeScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: QColors.primaryPurple),
            const SizedBox(height: 40),
            AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 500),
              child: Text(
                loadingText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
