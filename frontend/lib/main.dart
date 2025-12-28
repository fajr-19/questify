import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/colors.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase Berhasil Terhubung!");
  } catch (e) {
    debugPrint("❌ Firebase Gagal Terhubung: $e");
  }
  runApp(const QuestifyApp());
}

class QuestifyApp extends StatelessWidget {
  const QuestifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: QColors.background,
        primaryColor: QColors.primaryPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: QColors.background,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      // Splash Screen adalah titik masuk pertama
      home: const SplashScreen(),
    );
  }
}
