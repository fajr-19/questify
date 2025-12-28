import 'package:flutter/material.dart';
import 'colors.dart';

/// Transisi slide antar halaman (dari kanan ke kiri)
Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut; // Diubah sedikit agar lebih smooth
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

/// Progress bar di bagian bawah AppBar untuk onboarding
PreferredSizeWidget onboardingStepProgress(double progress) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(4.0),
    child: LinearProgressIndicator(
      value: progress,
      minHeight: 4,
      backgroundColor: Colors.white.withOpacity(0.1),
      valueColor: const AlwaysStoppedAnimation<Color>(QColors.primaryPurple),
    ),
  );
}

/// Tombol kustom yang digunakan di seluruh layar onboarding
Widget buildNextBtn({
  required bool active,
  required VoidCallback onTap,
  String text = "Lanjutkan",
}) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? QColors.primaryPurple : Colors.grey.shade800,
        foregroundColor: Colors.black, // Warna splash/teks saat ditekan
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
        disabledBackgroundColor: Colors.grey.shade800.withOpacity(0.5),
      ),
      onPressed: active ? onTap : null,
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.black : Colors.white38,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
