import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'choose_artist_screen.dart';
import '../../utils/colors.dart';

class CreateAccountScreen extends StatefulWidget {
  final DateTime dob;
  final String gender;
  const CreateAccountScreen({
    super.key,
    required this.dob,
    required this.gender,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      appBar: AppBar(
        backgroundColor: QColors.background,
        elevation: 0,
        bottom: onboardingStepProgress(0.6),
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
                    "Siapa namamu?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCtrl,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    cursorColor: QColors.primaryPurple,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: QColors.surface,
                      hintText: "Nama Lengkap",
                      hintStyle: const TextStyle(color: Colors.white24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: QColors.primaryPurple,
                        ),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: "Dengan melanjutkan, kamu setuju dengan ",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      children: [
                        TextSpan(
                          text: "Terms of Use",
                          style: const TextStyle(
                            color: QColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " dan "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: const TextStyle(
                            color: QColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " Questify."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
            child: buildNextBtn(
              active: nameCtrl.text.trim().length >= 2,
              onTap: () => Navigator.of(context).push(
                createRoute(
                  ChooseArtistScreen(
                    dob: widget.dob,
                    gender: widget.gender,
                    name: nameCtrl.text.trim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
