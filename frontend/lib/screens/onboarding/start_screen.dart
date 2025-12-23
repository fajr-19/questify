import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../../storage_service.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You’re all set!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await StorageService.setOnboardingDone();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('Start Listening'),
            ),

            TextButton(
              onPressed: () async {
                await StorageService.setOnboardingDone();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('Not Now'),
            )
          ],
        ),
      ),
    );
  }
}
