import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'choose_artist_screen.dart';

class NotificationScreen extends StatelessWidget {
  // Data yang dibawa dari layar sebelumnya
  final DateTime dob;
  final String gender;
  final String name;

  const NotificationScreen({
    super.key,
    required this.dob,
    required this.gender,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Kita beri progress sedikit lebih maju dari Create Account (misal 0.7)
        bottom: onboardingStepProgress(0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_active_outlined,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 32),
            const Text(
              "Nyalakan Notifikasi?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Dapatkan info terbaru tentang artis favorit dan podcast yang kamu ikuti.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Spacer(),
            // Tombol "Turn on notifications"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // OPER DATA ke ChooseArtistScreen
                  Navigator.of(context).push(
                    createRoute(
                      ChooseArtistScreen(dob: dob, gender: gender, name: name),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Turn on notifications",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol "Not now" (Tetap harus oper data)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    ChooseArtistScreen(dob: dob, gender: gender, name: name),
                  ),
                );
              },
              child: const Text(
                "Not now",
                style: TextStyle(
                  color: Colors.white,
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
