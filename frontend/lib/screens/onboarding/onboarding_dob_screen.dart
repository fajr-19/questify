import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'onboarding_gender_screen.dart';
import '../../utils/colors.dart';

class OnboardingDobScreen extends StatefulWidget {
  const OnboardingDobScreen({super.key});

  @override
  State<OnboardingDobScreen> createState() => _OnboardingDobScreenState();
}

class _OnboardingDobScreenState extends State<OnboardingDobScreen> {
  // Default date (User minimal 13-20 tahun biasanya)
  DateTime selectedDate = DateTime(2005, 1, 1);

  void _showPicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: QColors.primaryPurple,
              onPrimary: Colors.black, // Teks pada tombol/lingkaran terpilih
              surface: QColors.surface,
              onSurface: Colors.white, // Teks tanggal
            ),
            dialogBackgroundColor: QColors.background,
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      appBar: AppBar(
        backgroundColor: QColors.background,
        elevation: 0,
        // Progress awal 20%
        bottom: onboardingStepProgress(0.2),
        // Kita tidak pakai BackButton di sini karena ini layar pertama setelah login
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
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
                  const SizedBox(height: 10),
                  const Text(
                    "Data ini akan membantu kami memberikan konten yang sesuai untukmu.",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _showPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: QColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: QColors.primaryPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
            child: buildNextBtn(
              active: true,
              onTap: () {
                Navigator.of(
                  context,
                ).push(createRoute(OnboardingGenderScreen(dob: selectedDate)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
