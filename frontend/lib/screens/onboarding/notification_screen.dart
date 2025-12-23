import 'package:flutter/material.dart';
import 'choose_artist_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Turn on notifications',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Get reminders and updates from Questify',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChooseArtistScreen(),
                  ),
                );
              },
              child: const Text('Allow Notifications'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChooseArtistScreen(),
                  ),
                );
              },
              child: const Text('Skip'),
            )
          ],
        ),
      ),
    );
  }
}
