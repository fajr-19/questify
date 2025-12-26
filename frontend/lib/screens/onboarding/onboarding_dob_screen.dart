import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'onboarding_gender_screen.dart';

class OnboardingDobScreen extends StatefulWidget {
  const OnboardingDobScreen({super.key});
  @override
  State<OnboardingDobScreen> createState() => _OnboardingDobScreenState();
}

class _OnboardingDobScreenState extends State<OnboardingDobScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: onboardingStepProgress(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kapan hari lahirmu?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2005),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Perbaikan typo: spaceBetween
                  children: [
                    Text(
                      selectedDate == null
                          ? "Pilih tanggal lahir"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.white54),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: selectedDate == null
                    ? null
                    : () => Navigator.of(context).push(
                        createRoute(OnboardingGenderScreen(dob: selectedDate!)),
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
