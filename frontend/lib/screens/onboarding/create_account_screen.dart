import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'choose_artist_screen.dart';

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
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: onboardingStepProgress(0.6),
      ),
      body: Padding(
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
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: nameController.text.isEmpty
                    ? null
                    : () {
                        // Kirim semua data ke Artist Screen
                        Navigator.of(context).push(
                          createRoute(
                            ChooseArtistScreen(
                              dob: widget.dob,
                              gender: widget.gender,
                              name: nameController.text,
                            ),
                          ),
                        );
                      },
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
