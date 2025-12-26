import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'create_account_screen.dart';

class OnboardingGenderScreen extends StatefulWidget {
  final DateTime dob;
  const OnboardingGenderScreen({super.key, required this.dob});
  @override
  State<OnboardingGenderScreen> createState() => _OnboardingGenderScreenState();
}

class _OnboardingGenderScreenState extends State<OnboardingGenderScreen> {
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: onboardingStepProgress(0.4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Apa gendermu?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              children: ["Pria", "Wanita", "Lainnya"]
                  .map(
                    (g) => ChoiceChip(
                      label: Text(g),
                      selected: selectedGender == g,
                      onSelected: (_) => setState(() => selectedGender = g),
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey[900],
                      labelStyle: TextStyle(
                        color: selectedGender == g
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: selectedGender == null
                    ? null
                    : () => Navigator.of(context).push(
                        createRoute(
                          CreateAccountScreen(
                            dob: widget.dob,
                            gender: selectedGender!,
                          ),
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
