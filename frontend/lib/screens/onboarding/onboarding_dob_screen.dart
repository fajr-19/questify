import 'package:flutter/material.dart';
import 'onboarding_gender_screen.dart';

class OnboardingDobScreen extends StatefulWidget {
  const OnboardingDobScreen({super.key});

  @override
  State<OnboardingDobScreen> createState() => _OnboardingDobScreenState();
}

class _OnboardingDobScreenState extends State<OnboardingDobScreen> {
  DateTime? dob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kapan hari lahirmu?')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ListTile(
              title: Text(
                dob == null
                    ? 'Pilih Tanggal Lahir'
                    : "${dob!.toLocal()}".split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => dob = picked);
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: dob != null
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OnboardingGenderScreen(dob: dob!),
                      ),
                    )
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
