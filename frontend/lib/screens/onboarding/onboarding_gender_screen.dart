import 'package:flutter/material.dart';
import 'create_account_screen.dart'; // Mengarah ke file pilihanmu

class OnboardingGenderScreen extends StatefulWidget {
  final DateTime dob;
  const OnboardingGenderScreen({super.key, required this.dob});

  @override
  State<OnboardingGenderScreen> createState() => _OnboardingGenderScreenState();
}

class _OnboardingGenderScreenState extends State<OnboardingGenderScreen> {
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Gender')),
      body: Column(
        children: [
          ...['Male', 'Female', 'Other'].map(
            (g) => RadioListTile<String>(
              title: Text(g),
              value: g,
              groupValue: gender,
              onChanged: (v) => setState(() => gender = v),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: gender != null
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CreateAccountScreen(dob: widget.dob, gender: gender!),
                    ),
                  )
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
