import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
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
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
      ),
      home: const HomeScreen(),
    );
  }
}
