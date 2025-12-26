import 'package:flutter/material.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}

// Perbaikan: Gunakan PreferredSizeWidget agar AppBar tidak komplain
PreferredSizeWidget onboardingStepProgress(double progress) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(4.0),
    child: LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.white10,
      valueColor: const AlwaysStoppedAnimation<Color>(
        Colors.green,
      ), // Hijau Spotify
      minHeight: 4,
    ),
  );
}
