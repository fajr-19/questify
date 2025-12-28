import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'create_account_screen.dart';
import '../../utils/colors.dart';

class OnboardingGenderScreen extends StatefulWidget {
  final DateTime dob;
  const OnboardingGenderScreen({super.key, required this.dob});

  @override
  State<OnboardingGenderScreen> createState() => _OnboardingGenderScreenState();
}

class _OnboardingGenderScreenState extends State<OnboardingGenderScreen> {
  String? selectedGender;

  Widget _buildGenderBox(String label) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? QColors.primaryPurple.withOpacity(0.2)
              : QColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? QColors.primaryPurple : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: QColors.primaryPurple),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      appBar: AppBar(
        backgroundColor: QColors.background,
        elevation: 0,
        bottom: onboardingStepProgress(0.4),
        leading: const BackButton(color: Colors.white),
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
                    "Apa gendermu?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildGenderBox("Pria"),
                  _buildGenderBox("Wanita"),
                  _buildGenderBox("Lainnya"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
            child: buildNextBtn(
              active: selectedGender != null,
              onTap: () => Navigator.of(context).push(
                createRoute(
                  CreateAccountScreen(dob: widget.dob, gender: selectedGender!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
